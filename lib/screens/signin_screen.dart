import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/cubits/signin_cubit/signin_cubit.dart';
import 'package:note_management_system_v2/cubits/signin_cubit/signin_state.dart';
import 'package:note_management_system_v2/home.dart';
import 'package:note_management_system_v2/screens/signup_screen.dart';
import 'package:note_management_system_v2/utils/password_uils.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<SignInCubit>(
        create: (_) => SignInCubit(),
        child: const SignInHome(),
      ),
    );
  }
}

class SignInHome extends StatefulWidget {
  const SignInHome({super.key});

  @override
  State<SignInHome> createState() => _SignInHomeState();
}

class _SignInHomeState extends State<SignInHome> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: BlocBuilder<SignInCubit, SignInState>(builder: (context, state) {
      if (state is SignInSuccessState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(user: state.user,)),
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
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Sign In',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 30,
                      letterSpacing: 0.8),
                ),
                const SizedBox(
                  height: 30,
                ),
                Image.asset(
                  'assets/images/logo_small.png',
                  height: 120,
                ),
                const SizedBox(
                  height: 30,
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
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  )),
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

                      final encryptPasswords = hashPassword(password);

                      context.read<SignInCubit>().login(email, encryptPasswords);
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
                      const Text(
                        'You have not account?',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SignUpPage()),
                                (route) => false);
                          },
                          child: const Text('SignUp')),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
