import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/cubits/change_password/change_password_cubit.dart';
import 'package:note_management_system_v2/cubits/change_password/change_password_state.dart';
import 'package:note_management_system_v2/models/account.dart';
import 'package:note_management_system_v2/utils/password_uils.dart';
import 'package:note_management_system_v2/utils/snackbar/snack_bar.dart';
import 'package:note_management_system_v2/utils/validate/validate_english.dart';

class ChangePasswordScreen extends StatefulWidget {
  final Account user;
  const ChangePasswordScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formkeyChange = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _obscureTextNew = true;

  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleNewPassword() {
    setState(() {
      _obscureTextNew = !_obscureTextNew;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.text = widget.user.email!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ChangePasswordCubit>(
        create: (context) => ChangePasswordCubit(),
        child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
          listener: (context, state) {
            if (state is ChangePasswordLoading) {
              const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ChangePasswordSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showSnackBar(context, 'Successfully changed information');
              });
            } else if (state is ChangePasswordFaliure) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showSnackBar(context, 'Password change failed');
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
                        key: _formkeyChange,
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
                              height: 20,
                            ),
                            TextFormField(
                              controller: _currentPasswordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: 'Enter your current password',
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: GestureDetector(
                                  onTap: _togglePassword,
                                  child: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: _obscureText
                                        ? Colors.grey
                                        : Colors.blue,
                                  ),
                                ),
                                border: const OutlineInputBorder(),
                              ),
                              validator:
                                  ValidateEnglish.validateCurrentPassword,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r"\s")),
                              ],
                              controller: _newPasswordController,
                              obscureText: _obscureTextNew,
                              decoration: InputDecoration(
                                labelText: 'Enter your new password',
                                prefixIcon: const Icon(Icons.lock),
                                border: const OutlineInputBorder(),
                                suffixIcon: GestureDetector(
                                  onTap: _toggleNewPassword,
                                  child: Icon(
                                    _obscureTextNew
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: _obscureTextNew
                                        ? Colors.grey
                                        : Colors.blue,
                                  ),
                                ),
                              ),
                              validator: ValidateEnglish.validateNewPassword,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 15)),
                              onPressed: () {
                                if (_formkeyChange.currentState!.validate()) {
                                  final email = _emailController.text;
                                  final currentPassword =
                                      _currentPasswordController.text;
                                  final newPassword =
                                      _newPasswordController.text;

                                  final encryptPasswords =
                                      hashPassword(newPassword);

                                  if (widget.user.password ==
                                      hashPassword(currentPassword)) {
                                    context
                                        .read<ChangePasswordCubit>()
                                        .changePassword(
                                            email: email,
                                            password: hashPassword(currentPassword),
                                            newPassword: encryptPasswords);
                                  } else {
                                    showSnackBar(
                                        context, 'Password change failed');
                                  }
                                }
                              },
                              child: const Text('Change Password'),
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
