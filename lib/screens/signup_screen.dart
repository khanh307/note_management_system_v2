import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/Localization/language_constant.dart';
import 'package:note_management_system_v2/cubits/signup_cubit/signup_cubit.dart';
import 'package:note_management_system_v2/cubits/signup_cubit/signup_state.dart';
import 'package:note_management_system_v2/models/account.dart';
import 'package:note_management_system_v2/models/user.dart';
import 'package:note_management_system_v2/screens/signin_screen.dart';
import 'package:note_management_system_v2/utils/password_uils.dart';

class SignUpHome extends StatefulWidget {
  const SignUpHome({Key? key}) : super(key: key);

  @override
  State<SignUpHome> createState() => _SignUpHomeState();
}

class _SignUpHomeState extends State<SignUpHome> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  bool _obscureText = true;

  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context).register),
      ),
      body: BlocProvider<SignUpCubit>(
        create: (_) => SignUpCubit(),
        child: BlocConsumer<SignUpCubit, SignUpSate>(
          listener: (context, state) {
            if (state is SignUpSuccessState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInHome()),
                  (route) => false,
                );
              });
            } else if (state is SignUpErrorState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                  ),
                );
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
                      height: 20,
                    ),
                    Text(
                      translation(context).register,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 30,
                          letterSpacing: 0.8),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      'assets/images/logo_small.png',
                      height: 120,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      translation(context).regisQuote,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Form(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: translation(context).passHint,
                                prefixIcon: const Icon(Icons.lock),
                                border: const OutlineInputBorder(),
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
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                labelText: translation(context).fName,
                                prefixIcon: const Icon(Icons.person),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                labelText: translation(context).lName,
                                prefixIcon: const Icon(Icons.person),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          final firstName = _firstNameController.text;
                          final lastName = _lastNameController.text;

                          final encryptPasswords = hashPassword(password);

                          context.read<SignUpCubit>().addAccount(Account(
                              email: email,
                              password: encryptPasswords,
                              fristname: firstName,
                              lastname: lastName));
                        },
                        child: Text(
                          translation(context).register,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            translation(context).hadAcc,
                            style: TextStyle(fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SignInHome()),
                              );
                            },
                            child: Text(translation(context).login),
                          ),
                        ],
                      ),
                    )
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
