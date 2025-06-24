import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/features/features/auth/services/auth_service.dart';
import 'package:task_manager/features/features/auth/view/login_page.dart';
import 'package:task_manager/features/features/tasks/view/calendar_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      final authService = AuthService();

      return StreamBuilder<User?>(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            if (user != null) {
              return const CalendarPage();
            }
            return const LoginPage();
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
    } catch (e) {
      // Se houver erro com Firebase, mostra a tela de login
      print('Erro no AuthWrapper: $e');
      return const LoginPage();
    }
  }
} 