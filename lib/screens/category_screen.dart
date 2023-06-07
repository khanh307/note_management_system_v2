import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/Localization/language_constant.dart';
import 'package:note_management_system_v2/component/snack_bar.dart';
import 'package:note_management_system_v2/cubits/category_cubit/category_cubit.dart';
import 'package:note_management_system_v2/cubits/category_cubit/category_state.dart';
import 'package:note_management_system_v2/models/account.dart';
import 'package:note_management_system_v2/models/category.dart';
import 'package:note_management_system_v2/repository/category_repository.dart';

class CategoryScreen extends StatefulWidget {
  final Account user;
  const CategoryScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late final CategoryCubit categoryCubit;
  final _keyForm = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool isDuplicate = false;

  @override
  void initState() {
    super.initState();
    categoryCubit =
        CategoryCubit(CategoryRepository(email: widget.user.email!));
    categoryCubit.getAllCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: categoryCubit,
        child: BlocConsumer<CategoryCubit, CategoryState>(
          listener: (_, state) {
            if (state is SuccessSubmitCategoryState) {
              Navigator.of(context).pop();
              _nameController.clear();
              showSnackBar(context,
                  translation(context).addSucc + ' ${state.category.name}');
              categoryCubit.getAllCategory();
              // statusCubit.addNewStatus(state.status);
            } else if (state is ErrorSubmitCategoryState) {
              isDuplicate = true;
              _keyForm.currentState!.validate();
            } else if (state is SuccessDeleteCategoryState) {
              showSnackBar(context, translation(context).delSucc);
              // categoryCubit.getAllCategory();
            } else if (state is ErrorDeleteCategoryState) {
              showSnackBar(context, state.message);
            } else if (state is SuccessUpdateCategoryState) {
              Navigator.of(context).pop();
              showSnackBar(context, translation(context).update);
              categoryCubit.getAllCategory();
            } else if (state is ErrorUpdateCategoryState) {
              Navigator.of(context).pop();
              showSnackBar(context, state.message);
            }
          },
          buildWhen: (previous, current) {
            if (current is ErrorSubmitCategoryState ||
                current is SuccessDeleteCategoryState ||
                current is ErrorDeleteCategoryState ||
                current is ErrorUpdateCategoryState) return false;
            return true;
          },
          // child: BlocBuilder<StatusCubit, StatusState>(
          builder: (context, state) {
            debugPrint(state.toString());
            if (state is InitialCategoryState ||
                state is LoadingCategoryState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is SuccessGetAllCategoryState) {
              final listCategory = state.listCategories;
              return ListView.builder(
                itemCount: listCategory!.length,
                itemBuilder: (context, index) => Card(
                  color: Colors.white,
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
                  child: Dismissible(
                    key: Key(listCategory[index].name!),
                    background: Container(
                      color: Colors.redAccent,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.greenAccent,
                      child: const Icon(
                        Icons.update,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: (directory) async {
                      if (directory == DismissDirection.startToEnd) {
                        return await _deleteStatus(
                            context, listCategory[index].name!);
                      } else if (directory == DismissDirection.endToStart) {
                        await _showDialog(context, listCategory[index]);
                        return false;
                      }
                    },
                    child: ListTile(
                      title: Text(listCategory[index].name!),
                      subtitle: Text(listCategory[index].createdAt!),
                    ),
                  ),
                ),
              );
            }

            return Text(state.toString());
          },
          // ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showDialog(context, null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool> _deleteStatus(context, String name) async {
    final AlertDialog dialog = AlertDialog(
      title: Text(translation(context).del),
      content: Text(translation(context).delQues + ' $name?'),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(translation(context).noChoice)),
        ElevatedButton(
            onPressed: () async {
              categoryCubit.deleteCategory(context, name);
              Navigator.pop(context, true);
            },
            child: Text(translation(context).yesChoice)),
      ],
    );

    return await showDialog(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (context) => dialog);
  }

  Future<void> _showDialog(BuildContext context, Category? category) async {
    if (category != null) {
      _nameController.text = category.name!;
    }

    return showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(builder: (context, setState) {
        return Container(
          padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 90),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Form(
                key: _keyForm,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: translation(context).enterName,
                  ),
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return translation(context).noInputField;
                    }

                    if (value.length < 4) {
                      return translation(context).min4;
                    }

                    if (isDuplicate) {
                      return translation(context).existName;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_keyForm.currentState!.validate()) {
                      final value = Category(
                        name: _nameController.text,
                      );

                      (category == null)
                          ? categoryCubit.createCategory(context, value)
                          : categoryCubit.updateCategory(category.name!, value);
                    }
                  },
                  child: Text((category == null)
                      ? translation(context).createNew
                      : translation(context).update)),
            ],
          ),
        );
      }),
    );
  }
}
