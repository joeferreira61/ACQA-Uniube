import 'package:flutter/material.dart';
// import 'package:task_master_app/features/auth/services/auth_service.dart';
import 'package:gerenciador_tarefas/features/auth/view/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _authService = AuthService();

  @override
  void dispose() {
// ... existing code ...
                  onPressed: () {
                    // Lógica de login desativada para teste
                    print("Botão de login pressionado!");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Login desativado para teste de UI.'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                  child: const Text('Entrar', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
// ... existing code ...
} 