import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/custom_textbutton.dart';
import '../components/custom_textfield.dart';
import '../services/firebase_services.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  File? _image;
  final AuthService _authService = AuthService();

  Future<void> _pickImage() async {
    File? image = await _authService.pickImage();
    setState(() {
      _image = image;
    });
  }

  Future<void> _signUp() async {
    try {
      User? user = await _authService.signUp(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _image,
      );
      if (user != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: _pickImage,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(),
                  ),
                  child: _image == null
                      ? const Center(
                          child: Icon(
                            Icons.camera,
                            size: 50,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextfield(
                labelText: 'Email',
                obscureText: false,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextfield(
                labelText: 'Name',
                obscureText: false,
                controller: _nameController,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(
                height: 50,
              ),
              CustomTextfield(
                labelText: 'Password',
                obscureText: true,
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextbutton(
                width: MediaQuery.of(context).size.width / 1.5,
                text: 'Sign Up',
                height: 55,
                backgroundColor: const Color(0xff3876fd),
                foregroundColor: Colors.white,
                onPressed: _signUp,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(color: Color(0xff3876fd), fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
