import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/Localization/language_constant.dart';
import 'package:note_management_system_v2/component/snack_bar.dart';

import 'package:note_management_system_v2/cubits/status_cubit/status_cubit.dart';
import 'package:note_management_system_v2/cubits/status_cubit/status_state.dart';
import 'package:note_management_system_v2/models/account.dart';
import 'package:note_management_system_v2/models/status.dart';

import 'package:note_management_system_v2/repository/status_repository.dart';

class StatusScreen extends StatefulWidget {
  final Account user;
  const StatusScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  late final StatusCubit statusCubit;
  final _keyForm = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool isDuplicate = false;

  @override
  void initState() {
    super.initState();
    statusCubit = StatusCubit(StatusRepository(email: widget.user.email!));
    statusCubit.getAllStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: statusCubit,
        child: BlocConsumer<StatusCubit, StatusState>(
          listener: (_, state) {
            if (state is SuccessSubmitStatusState) {
              Navigator.of(context).pop();
              _nameController.clear();
              showSnackBar(context,
                  translation(context).addSucc + '${state.status.name}');
              statusCubit.getAllStatus();
              // statusCubit.addNewStatus(state.status);
            } else if (state is ErrorSubmitStatusState) {
              isDuplicate = true;
              _keyForm.currentState!.validate();
            } else if (state is SuccessDeleteStatusState) {
              showSnackBar(context, translation(context).delSucc);
              // statusCubit.getAllStatus();
            } else if (state is ErrorDeleteStatusState) {
              showSnackBar(context, state.message);
            } else if (state is SuccessUpdateStatusState) {
              Navigator.of(context).pop();
              showSnackBar(context, translation(context).upSucc);
              statusCubit.getAllStatus();
            } else if (state is ErrorUpdateStatusState) {
              Navigator.of(context).pop();
              showSnackBar(context, state.message);
            }
          },
          buildWhen: (previous, current) {
            if (current is ErrorSubmitStatusState ||
                current is SuccessDeleteStatusState ||
                current is ErrorDeleteStatusState ||
                current is ErrorUpdateStatusState) return false;
            return true;
          },
          // child: BlocBuilder<StatusCubit, StatusState>(
          builder: (context, state) {
            debugPrint(state.toString());
            if (state is InitialStatusState || state is LoadingStatusState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is SuccessGetAllStatusState) {
              final listStatus = state.listStatus;
              return ListView.builder(
                itemCount: listStatus!.length,
                itemBuilder: (context, index) => Card(
                  color: Colors.white,
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
                  child: Dismissible(
                    key: Key(listStatus[index].name!),
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
                        return _deleteStatus(context, listStatus[index].name!);
                      } else if (directory == DismissDirection.endToStart) {
                        await _showDialog(context, listStatus[index]);
                        return false;
                      }
                    },
                    child: ListTile(
                      title: Text(listStatus[index].name!),
                      subtitle: Text(listStatus[index].createdAt!),
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
      content: Text(translation(context).delQues + '$name?'),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(translation(context).noChoice)),
        ElevatedButton(
            onPressed: () {
              statusCubit.deleteStatus(context, name);
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

  Future<void> _showDialog(BuildContext context, Status? status) async {
    if (status != null) {
      _nameController.text = status.name!;
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
                      final value = Status(
                        name: _nameController.text,
                      );

                      (status == null)
                          ? statusCubit.createStatus(context, value)
                          : statusCubit.updateStatus(
                              context, status.name!, value);
                    }
                  },
                  child: Text((status == null)
                      ? translation(context).createNew
                      : translation(context).update)),
            ],
          ),
        );
      }),
    );
  }
}
