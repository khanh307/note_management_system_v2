import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:note_management_system_v2/Localization/language_constant.dart';
import 'package:note_management_system_v2/component/my_dropdown_button.dart';
import 'package:note_management_system_v2/component/snack_bar.dart';
import 'package:note_management_system_v2/cubits/note_cubit/note_cubit.dart';
import 'package:note_management_system_v2/cubits/note_cubit/note_state.dart';
import 'package:note_management_system_v2/models/account.dart';
import 'package:note_management_system_v2/models/category.dart';
import 'package:note_management_system_v2/models/note.dart';
import 'package:note_management_system_v2/models/priority.dart';
import 'package:note_management_system_v2/models/status.dart';

import 'package:note_management_system_v2/repository/category_repository.dart';
import 'package:note_management_system_v2/repository/note_repository.dart';
import 'package:note_management_system_v2/repository/priority_repository.dart';
import 'package:note_management_system_v2/repository/status_repository.dart';
import 'package:note_management_system_v2/validator/note_validator.dart';

class NoteScreen extends StatefulWidget {
  final Account user;

  const NoteScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? dropdownCategoryValue;
  String? dropdownPriorityValue;
  String? dropdownStatusValue;
  late final NoteCubit noteCubit;
  final _keyForm = GlobalKey<FormState>();
  bool isDuplicate = false;
  List<Category> _categories = [];
  List<PriorityModel> _priorities = [];
  List<Status> _status = [];
  DateTime? _dateTime;

  Future<void> getAllData() async {
    _categories =
        (await CategoryRepository(email: widget.user.email!).getAllCategory())!;
    _priorities = (await PriorityRepository(email: widget.user.email!)
        .getAllPriorities())!;
    _status =
        (await StatusRepository(email: widget.user.email!).getAllProfile())!;
  }

  @override
  void initState() {
    super.initState();
    noteCubit = NoteCubit(NoteRepository(email: widget.user.email!));
    getAllData();
    noteCubit.getAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    Widget itemCard(IconData icon, note, title) => Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            children: [
              Icon(icon),
              Text('$title: '),
              Text(note),
            ],
          ),
        );

    return Scaffold(
      body: BlocProvider.value(
        value: noteCubit,
        child: BlocConsumer<NoteCubit, NoteState>(
          listener: (_, state) {
            if (state is SuccessSubmitNoteState) {
              Navigator.of(context).pop();
              _nameController.clear();
              showSnackBar(context, translation(context).addSucc + '${state.note.name}');
              noteCubit.getAllNotes();
              // statusCubit.addNewStatus(state.status);
            } else if (state is ErrorSubmitNoteState) {
              isDuplicate = true;
              _keyForm.currentState!.validate();
            } else if (state is SuccessDeleteNoteState) {
              showSnackBar(context, translation(context).delSucc);
              // noteCubit.getAllNotes();
            } else if (state is ErrorDeleteNoteState) {
              showSnackBar(context, state.message);
            } else if (state is SuccessUpdateNoteState) {
              Navigator.of(context).pop();
              showSnackBar(context, translation(context).upSucc);
              noteCubit.getAllNotes();
            } else if (state is ErrorUpdateNoteState) {
              Navigator.of(context).pop();
              showSnackBar(context, state.message);
            }
          },
          buildWhen: (previous, current) {
            if (current is ErrorSubmitNoteState ||
                current is SuccessDeleteNoteState ||
                current is ErrorDeleteNoteState ||
                current is ErrorUpdateNoteState) return false;
            return true;
          },
          builder: (context, state) {
            if (state is InitialNoteState || state is LoadingNoteState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is SuccessGetAllNoteState) {
              final listNotes = state.listNote;
              return ListView.builder(
                itemCount: listNotes!.length,
                itemBuilder: (context, index) => Card(
                  color: Colors.white,
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
                  child: Dismissible(
                    key: Key(listNotes[index].name!),
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
                        return _deleteNote(context, listNotes[index]);
                      } else if (directory == DismissDirection.endToStart) {
                        await _showDialog(context, listNotes[index]);
                        return false;
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                listNotes[index].name!,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          itemCard(Icons.category, listNotes[index].category,
                              translation(context).category),
                          itemCard(
                              Icons.priority_high,
                              listNotes[index].priority,
                              translation(context).prio),
                          itemCard(Icons.priority_high, listNotes[index].status,
                              translation(context).status),
                          itemCard(Icons.date_range, listNotes[index].planDate,
                              translation(context).plandate),
                          itemCard(
                              Icons.calendar_month_sharp,
                              listNotes[index].createdAt,
                              translation(context).createdAt),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return Text(state.toString());
          },
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

  Future<bool> _deleteNote(context, Note note) async {
    if (_checkNoteDone(note)) {
      final AlertDialog dialog = AlertDialog(
        title: Text(translation(context).del),
        content: Text(translation(context).delQues + '${note.name}?'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(translation(context).noChoice)),
          ElevatedButton(
              onPressed: () async {
                noteCubit.deleteNote(note.name!);
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
    } else {
      showSnackBar(context, note.name! + translation(context).no6Month);
      return false;
    }
  }

  Future<void> _showDialog(BuildContext context, Note? note) async {
    if (note != null) {
      _nameController.text = note.name!;
      _dateTime = DateFormat('dd/MM/yyyy').parse(note.planDate!);
      _dateController.text = note.planDate!;
      dropdownCategoryValue = note.category!;
      dropdownStatusValue = note.status!;
      dropdownPriorityValue = note.priority!;
    } else {
      _nameController.text = '';
      _dateController.text = '';
      _dateTime = null;
      dropdownStatusValue = null;
      dropdownPriorityValue = null;
      dropdownCategoryValue = null;
    }

    return showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(builder: (context, setState) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 90),
            child: Form(
              key: _keyForm,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
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
                  const SizedBox(
                    height: 20,
                  ),
                  MyDropdownButton(
                      hint: translation(context).category,
                      dropdownValue: dropdownCategoryValue,
                      dropdownItems: _categories!.map((e) {
                        return e.name;
                      }).toList(),
                      onChange: (value) {
                        setState(() {
                          dropdownCategoryValue = value;
                        });
                      },
                      validator: (value) =>
                          NoteValidator.categoryValidate(context, value)),
                  const SizedBox(
                    height: 20,
                  ),
                  MyDropdownButton(
                      hint: translation(context).pickpriority,
                      dropdownValue: dropdownPriorityValue,
                      dropdownItems: _priorities!.map((e) {
                        return e.name;
                      }).toList(),
                      onChange: (value) {
                        setState(() {
                          dropdownPriorityValue = value;
                        });
                      },
                      validator: (value) =>
                          NoteValidator.priorityValidate(context, value)),
                  const SizedBox(
                    height: 20,
                  ),
                  MyDropdownButton(
                      hint: translation(context).pickStatus,
                      dropdownValue: dropdownStatusValue,
                      dropdownItems: _status!.map((e) {
                        return e.name;
                      }).toList(),
                      onChange: (value) {
                        setState(() {
                          dropdownStatusValue = value;
                        });
                      },
                      validator: (value) =>
                          NoteValidator.statusValidate(context, value)),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) =>
                        NoteValidator.planDateValidate(context, value),
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: translation(context).pickdate),
                    readOnly: true,
                    controller: _dateController,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate:
                            (_dateTime != null) ? _dateTime! : DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(3000),
                      ).then((value) {
                        setState(() {
                          _dateTime = value!;
                          _dateController.text = _formatDate(value);
                        });
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_keyForm.currentState!.validate()) {
                          final value = Note(
                            name: _nameController.text,
                            user: widget.user.email,
                            planDate: _formatDate(_dateTime!),
                            status: dropdownStatusValue,
                            priority: dropdownPriorityValue,
                            category: dropdownCategoryValue,
                          );

                          (note == null)
                              ? noteCubit.createNote(value)
                              : noteCubit.updateNote(note.name!, value);
                        }
                      },
                      child: Text((note == null)
                          ? translation(context).createNew
                          : translation(context).update)),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  bool _checkNoteDone(Note note) {
    if (note.status.toString().toLowerCase() == 'done') {
      DateTime dateDone = DateFormat('dd/MM/yyyy').parse(note.planDate!);
      DateTime endDate =
          DateTime(dateDone.year, dateDone.month + 6, dateDone.day);
      if (DateTime.now().difference(endDate).inDays < 0) {
        return false;
      }
    } else {
      return true;
    }
    return true;
  }
}
