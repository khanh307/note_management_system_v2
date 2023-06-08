import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/Localization/language_constant.dart';
import 'package:note_management_system_v2/component/snack_bar.dart';
import 'package:note_management_system_v2/cubits/priority_cubit/priority_cubit.dart';
import 'package:note_management_system_v2/cubits/priority_cubit/priority_state.dart';
import 'package:note_management_system_v2/models/account.dart';
import 'package:note_management_system_v2/models/priority.dart';

import 'package:note_management_system_v2/repository/priority_repository.dart';

class PriorityScreen extends StatefulWidget {
  final Account user;

  const PriorityScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<PriorityScreen> createState() => _PriorityScreenState();
}

class _PriorityScreenState extends State<PriorityScreen> {
  late final PriorityCubit priorityCubit;
  final _keyForm = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool isDuplicate = false;

  @override
  void initState() {
    super.initState();
    priorityCubit =
        PriorityCubit(PriorityRepository(email: widget.user.email!));
    priorityCubit.getAllPriorities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: priorityCubit,
        child: BlocConsumer<PriorityCubit, PriorityState>(
          listener: (_, state) {
            if (state is SuccessSubmitPriorityState) {
              _nameController.clear();
              Navigator.of(context).pop();
              showSnackBar(context,
                  translation(context).addSucc + '${state.priority.name}');
              priorityCubit.getAllPriorities();
            } else if (state is ErrorSubmitStateState) {
              isDuplicate = true;
              _keyForm.currentState!.validate();
            } else if (state is SuccessDeletePriorityState) {
              showSnackBar(context, translation(context).delSucc);

              priorityCubit.getAllPriorities();
            } else if (state is ErrorDeletePriorityState) {
              showSnackBar(context, state.message);
            } else if (state is SuccessUpdatePriorityState) {
              Navigator.of(context).pop();
              showSnackBar(context, translation(context).upSucc);
              priorityCubit.getAllPriorities();
            } else if (state is ErrorUpdatePriorityState) {
              Navigator.of(context).pop();
              showSnackBar(context, state.message);
            }
          },
          buildWhen: (previous, current) {
            if (current is ErrorSubmitStateState ||
                current is SuccessDeletePriorityState ||
                current is ErrorDeletePriorityState ||
                current is ErrorUpdatePriorityState) return false;
            return true;
          },
          // child: BlocBuilder<StatusCubit, StatusState>(
          builder: (context, state) {
            debugPrint(state.toString());
            if (state is InitialPriorityState ||
                state is LoadingPriorityState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is SuccessGetAllPriorityState) {
              final listPriority = state.listPriority;
              return ListView.builder(
                itemCount: listPriority!.length,
                itemBuilder: (context, index) => Card(
                  color: Colors.white,
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
                  child: Dismissible(
                    key: Key(listPriority[index].name!),
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
                        await _deletePriority(
                            context, listPriority[index].name!);
                        return false;
                      } else if (directory == DismissDirection.endToStart) {
                        await _showDialog(context, listPriority[index]);
                        return false;
                      }
                    },
                    child: ListTile(
                      title: Text(listPriority[index].name!),
                      subtitle: Text(listPriority[index].createdAt!),
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

  Future<void> _deletePriority(context, String name) async {
    final AlertDialog dialog = AlertDialog(
      title: Text(translation(context).del),
      content: Text(translation(context).delQues + '$name?'),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(translation(context).noChoice)),
        ElevatedButton(
            onPressed: () async {
              priorityCubit.deletePriority(context, name);
              Navigator.pop(context);
            },
            child: Text(translation(context).yesChoice)),
      ],
    );

    showDialog(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (context) => dialog);
  }

  Future<void> _showDialog(
      BuildContext context, PriorityModel? priority) async {
    if (priority != null) {
      _nameController.text = priority.name!;
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
                      final value = PriorityModel(
                        name: _nameController.text,
                      );

                      (priority == null)
                          ? priorityCubit.createPriority(context, value)
                          : priorityCubit.updatePriority(
                              context, priority.name!, value);
                    }
                  },
                  child: Text((priority == null)
                      ? translation(context).createNew
                      : translation(context).update)),
            ],
          ),
        );
      }),
    );
  }
}
