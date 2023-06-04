import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/cubits/edit_profile_cubit.dart/edit_cubit.dart';
import 'package:note_management_system_v2/cubits/edit_profile_cubit.dart/edit_state.dart';
import 'package:note_management_system_v2/models/account.dart';
import 'package:note_management_system_v2/utils/snackbar/snack_bar.dart';
import 'package:note_management_system_v2/utils/validate/validate_english.dart';

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
                showSnackBar(context, 'Successfully changed information');
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
                              decoration: const InputDecoration(
                                labelText: 'Enter your Firstname',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                              validator: ValidateEnglish.validateFirstnameEdit,
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
                              decoration: const InputDecoration(
                                labelText: 'Enter your Lastname',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                              validator: ValidateEnglish.validateLastnameEdit,
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
                              child: const Text('Update Profile'),
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
