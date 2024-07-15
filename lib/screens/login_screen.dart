import 'package:chatting_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/custom_textbutton.dart';
import '../components/custom_textfield.dart';
import '../services/auth_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.signIn(
          _emailController.text, _passwordController.text);
      print('login successfull');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextfield(
                labelText: 'Email',
                obscureText: false,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(
              height: 30,
            ),
            CustomTextfield(
              labelText: 'Password',
              obscureText: true,
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(
              height: 50,
            ),
            CustomTextbutton(
                width: MediaQuery.of(context).size.width / 1.5,
                text: 'Login',
                height: 55,
                backgroundColor: const Color(0xff3876fd),
                foregroundColor: Colors.white,
                onPressed: () {
                  handleLogin();
                }),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text('OR'),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()));
                    },
                    child: const Text(
                      'Create Account',
                      style: TextStyle(color: Color(0xff3876fd), fontSize: 16),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
