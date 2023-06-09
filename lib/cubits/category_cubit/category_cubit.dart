import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/Localization/language_constant.dart';
import 'package:note_management_system_v2/cubits/category_cubit/category_state.dart';
import 'package:note_management_system_v2/models/category.dart';
import 'package:note_management_system_v2/repository/category_repository.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryCubit(this._categoryRepository) : super(InitialCategoryState());

  Future<void> getAllCategory() async {
    emit(LoadingCategoryState());
    try {
      var result = await _categoryRepository.getAllCategory();
      emit(SuccessGetAllCategoryState(result));
    } catch (e) {
      emit(FailureCategoryState(e.toString()));
    }
  }

  //Ghi
  Future<void> createCategory(context, Category category) async {
    try {
      var result = await _categoryRepository.createCategory(category);
      if (result.status == 1) {
        emit(SuccessSubmitCategoryState(category));
      } else if (result.status == -1 && result.error == 2) {
        emit(ErrorSubmitCategoryState(translation(context).existName));
      }
    } catch (e) {
      emit(FailureCategoryState(e.toString()));
    }
  }

  Future<void> updateCategory(String name, Category category) async {
    try {
      var result = await _categoryRepository.updateCategory(name, category);
      if (result.status == 1) {
        emit(SuccessUpdateCategoryState(category));
      } else if (result.status == -1) {
        emit(ErrorUpdateCategoryState('* Lỗi'));
      }
    } catch (e) {
      emit(FailureCategoryState(e.toString()));
    }
  }

  // Xóa
  Future<void> deleteCategory(context, String name) async {
    try {
      var result = await _categoryRepository.deleteCategory(name);
      if (result.status == 1) {
        emit(SuccessDeleteCategoryState());
      } else if (result.status == -1 && result.error == 2) {
        emit(ErrorDeleteCategoryState(
            '$name' + translation(context).existinNote));
      }
    } catch (e) {
      emit(FailureCategoryState(e.toString()));
    }
  }
}
