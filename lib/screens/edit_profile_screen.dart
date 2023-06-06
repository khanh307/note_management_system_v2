import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/Localization/language_constant.dart';
import 'package:note_management_system_v2/cubits/edit_profile_cubit.dart/edit_cubit.dart';
import 'package:note_management_system_v2/cubits/edit_profile_cubit.dart/edit_state.dart';
import 'package:note_management_system_v2/models/account.dart';
import 'package:note_management_system_v2/utils/snackbar/snack_bar.dart';

class EditProfileScreen extends StatefulWidget {
  final Account user;
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final _formKeyEdit = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.text = widget.user.email!;
    _firstNameController.text = widget.user.fristname!;
    _lastNameController.text = widget.user.lastname!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<EditProfileCubit>(
        create: (context) => EditProfileCubit(),
        child: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            if (state is EditProfileLoading) {
              const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is EditProfileSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showSnackBar(context, translation(context).changePassSucc);
              });
            } else if (state is EditProfileFaileure) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showSnackBar(context, 'Change information failed');
              });
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: _formKeyEdit,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              enabled: false,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: const Icon(Icons.email),
                                border: const OutlineInputBorder(),
                                filled: true,
                                disabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[500]!),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: _firstNameController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z\s]')),
                              ],
                              decoration: InputDecoration(
                                labelText: translation(context).fName,
                                prefixIcon: const Icon(Icons.person),
                                border: const OutlineInputBorder(),
                              ),
                              // validator: ValidateEnglish.validateFirstnameEdit,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return translation(context).noInputField;
                                }

                                if (value.trim().length < 2 ||
                                    value.trim().length > 32) {
                                  return translation(context).min2max32;
                                }

                                if (value.endsWith(' ')) {
                                  return translation(context).noSpace;
                                }

                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: _lastNameController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z\s]')),
                              ],
                              decoration: InputDecoration(
                                labelText: translation(context).lName,
                                prefixIcon: const Icon(Icons.person),
                                border: const OutlineInputBorder(),
                              ),
                              // validator: ValidateEnglish.validateLastnameEdit,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return translation(context).noInputField;
                                }

                                if (value.length < 2 || value.length > 32) {
                                  return translation(context).min2max32;
                                }

                                if (value.endsWith(' ')) {
                                  return translation(context).noSpace;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKeyEdit.currentState!.validate()) {
                                  final email = _emailController.text;

                                  final firstName = _firstNameController.text;
                                  final lastName = _lastNameController.text;

                                  context
                                      .read<EditProfileCubit>()
                                      .updateProfile(
                                          email: email,
                                          nemail: email,
                                          firstname: firstName,
                                          lastname: lastName);
                                }
                              },
                              child: Text(translation(context).update),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
