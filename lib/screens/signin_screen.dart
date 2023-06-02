import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_sign_in/google_sign_in.dart';

import 'package:note_management_system_v2/cubits/signin_cubit/signin_cubit.dart';
import 'package:note_management_system_v2/cubits/signin_cubit/signin_state.dart';

import 'package:note_management_system_v2/home.dart';
import 'package:note_management_system_v2/models/account.dart';

import 'package:note_management_system_v2/screens/signup_screen.dart';
import 'package:note_management_system_v2/utils/password_uils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInHome extends StatefulWidget {
  const SignInHome({super.key});

  @override
  State<SignInHome> createState() => _SignInHomeState();
}

class _SignInHomeState extends State<SignInHome> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isGoogleSignIn = false;

  bool _obscureText = true;

  bool _isCheckRemember = false;

  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    setState(() {
      _isCheckRemember = sharedPref.getBool('remember') ?? false;
      if (_isCheckRemember) {
        _emailController.text = sharedPref.getString('email') ?? '';
        _passwordController.text = sharedPref.getString('password') ?? '';
      }
    });
  }

  Future<void> _saveRemember(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _isCheckRemember = value;
      pref.setBool('remember', value);
      if (!value) {
        pref.remove('email');
        pref.remove('password');
      } else {
        pref.setString('email', _emailController.text);
        pref.setString('password', _passwordController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: BlocProvider<SignInCubit>(
        create: (_) => SignInCubit(),
        child: BlocConsumer<SignInCubit, SignInState>(
          listener: (context, state) {
            if (state is SignInSuccessState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            account: state.account,
                            isGoogleSignIn: isGoogleSignIn,
                          )),
                  (route) => false,
                );
              });
            } else if (state is SignInErrorState) {
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
                    const SizedBox(height: 20),
                    const Text(
                      'Sign In',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 30,
                          letterSpacing: 0.8),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Image.asset(
                      'assets/images/logo_small.png',
                      height: 120,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'SignIn Your Account',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Form(
                          key: _formKey,
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
                                height: 20,
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                  labelText: 'Password',
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
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _isCheckRemember,
                            onChanged: (value) {
                              setState(() {
                                _isCheckRemember = value ?? false;
                              });
                              _saveRemember(_isCheckRemember);
                            },
                          ),
                          const Text('Remember me')
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final email = _emailController.text;
                            final password = _passwordController.text;

                            final encryptPasswords = hashPassword(password);

                            context.read<SignInCubit>().login(
                                  Account(
                                      email: email, password: encryptPasswords),
                                );
                          }
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Does not have account?',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const SignUpHome()),
                                    (route) => false);
                              },
                              child: const Text('SignUp')),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          GoogleSignIn().signIn().then((value) {
                            if (value != null) {
                              isGoogleSignIn = true;

                              String firstname = '';
                              String lastname = '';
                              String photoUrl = '';

                              if (value.displayName != null) {
                                List<String> nameArray =
                                    value.displayName!.split(" ");
                                if (nameArray.isNotEmpty) {
                                  firstname = nameArray.first;
                                  if (nameArray.length > 1) {
                                    lastname = nameArray.sublist(1).join(" ");
                                  }
                                }
                              }

                              photoUrl = value.photoUrl ?? '';

                              Account account = Account(
                                email: value.email,
                                password: hashPassword(" "),
                                fristname: firstname,
                                lastname: lastname,
                                photoUrl: photoUrl,
                              );

                              context.read<SignInCubit>().signInGooGle(account);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/google_logo.png',
                              height: 40,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text('Sign In with Google'),
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
