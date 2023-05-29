
import 'package:note_management_system_v2/models/category.dart';

abstract class CategoryState {}

class InitialCategoryState extends CategoryState {}

class LoadingCategoryState extends CategoryState {}

class FailureCategoryState extends CategoryState {
  String message;

  FailureCategoryState(this.message);
}

class SuccessGetAllCategoryState extends CategoryState {
  final List<Category>? listCategories;

  SuccessGetAllCategoryState(this.listCategories);
}

class SuccessDeleteCategoryState extends CategoryState {

}

class ErrorDeleteCategoryState extends CategoryState {
  String message;

  ErrorDeleteCategoryState(this.message);
}

class SuccessSubmitCategoryState extends CategoryState {
  Category category;

  SuccessSubmitCategoryState(this.category);
}

class ErrorSubmitCategoryState extends CategoryState {
  String message;

  ErrorSubmitCategoryState(this.message);
}

class SuccessUpdateCategoryState extends CategoryState {
  Category category;

  SuccessUpdateCategoryState(this.category);
}

class ErrorUpdateCategoryState extends CategoryState {
  String message;

  ErrorUpdateCategoryState(this.message);
}
