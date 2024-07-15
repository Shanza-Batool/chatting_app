import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../services/auth_provider.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return  Consumer<AuthProvider>(
      builder: (context, authProvider,child){
        if(authProvider.isSignedIn){
          return const HomeScreen();
        }else{
          return const LoginScreen();
        }
      },
    );
  }
}