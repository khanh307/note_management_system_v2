import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/component/snack_bar.dart';
import 'package:note_management_system_v2/cubits/priority_cubit/priority_cubit.dart';
import 'package:note_management_system_v2/cubits/priority_cubit/priority_state.dart';
import 'package:note_management_system_v2/models/priority.dart';
import 'package:note_management_system_v2/models/user.dart';
import 'package:note_management_system_v2/repository/priority_repository.dart';

class PriorityScreen extends StatefulWidget {
  final User user;

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
              showSnackBar(context, 'Successfully insert ${state.priority.name}');
              priorityCubit.getAllPriorities();
            } else if (state is ErrorSubmitStateState) {
              isDuplicate = true;
              _keyForm.currentState!.validate();
            } else if (state is SuccessDeletePriorityState) {
              showSnackBar(context, 'Successfully delete priority');

              priorityCubit.getAllPriorities();
            } else if (state is ErrorDeletePriorityState) {
              showSnackBar(context, state.message);
            } else if (state is SuccessUpdatePriorityState) {
              Navigator.of(context).pop();
              showSnackBar(context, 'Successfully update a priority!');
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
                        await _deletePriority(listPriority[index].name!);
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

  Future<void> _deletePriority(String name) async {
    final AlertDialog dialog = AlertDialog(
      title: const Text('Delete'),
      content: Text('* You want to delete this $name? Yes/No?'),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No')),
        ElevatedButton(
            onPressed: () async {
              priorityCubit.deletePriority(name);
              Navigator.pop(context);
            },
            child: const Text('Yes')),
      ],
    );

    showDialog(
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
                      return '* Please enter a minimum of 5 characters';
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
                      final value = PriorityModel(
                        name: _nameController.text,
                      );

                      (priority == null)
                          ? priorityCubit.createPriority(value)
                          : priorityCubit.updatePriority(priority.name!, value);
                    }
                  },
                  child: Text((priority == null) ? 'Create New' : 'Update')),
            ],
          ),
        );
      }),
    );
  }
}
