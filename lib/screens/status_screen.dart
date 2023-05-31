import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/cubits/signin_cubit/signin_cubit.dart';
import 'package:note_management_system_v2/cubits/status_cubit/status_cubit.dart';
import 'package:note_management_system_v2/cubits/status_cubit/status_state.dart';
import 'package:note_management_system_v2/models/status.dart';
import 'package:note_management_system_v2/models/user.dart';
import 'package:note_management_system_v2/repository/status_repository.dart';

class StatusScreen extends StatefulWidget {
  final User user;
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
    // TODO: implement initState
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
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Successfully insert ${state.status.name}')));
              statusCubit.getAllStatus();
              // statusCubit.addNewStatus(state.status);
            } else if (state is ErrorSubmitStatusState) {
              isDuplicate = true;
              _keyForm.currentState!.validate();
            } else if (state is SuccessDeleteStatusState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Successfully delete status')));
              // statusCubit.getAllStatus();
            } else if (state is ErrorDeleteStatusState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is SuccessUpdateStatusState) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Successfully update a category!')));
              statusCubit.getAllStatus();
            } else if (state is ErrorUpdateStatusState) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
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
                        return _deleteStatus(listStatus[index].name!);
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

  Future<bool> _deleteStatus(String name) async {
    final AlertDialog dialog = AlertDialog(
      title: const Text('Delete'),
      content: Text('* You want to delete this $name? Yes/No?'),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('No')),
        ElevatedButton(
            onPressed: () {
              statusCubit.deleteStatus(name);
              Navigator.pop(context, true);
            },
            child: const Text('Yes')),
      ],
    );

    return await showDialog(
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter name',
                  ),
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '* Please enter a name';
                    }

                    if (value.length < 4) {
                      return '* Please enter a minimum of 4 characters';
                    }

                    if (isDuplicate) {
                      return '* Please enter a different name, this name already exists';
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
                          ? statusCubit.createStatus(value)
                          : statusCubit.updateStatus(status.name!, value);
                    }
                  },
                  child: Text((status == null) ? 'Create New' : 'Update')),
            ],
          ),
        );
      }),
    );
  }
}
