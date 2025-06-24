import 'package:flutter/material.dart';
import 'package:task_manager/features/features/auth/services/auth_service.dart';
import 'package:task_manager/features/features/auth/view/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icon
                const Icon(Icons.check_circle_outline, size: 80, color: Color(0xFF6200EE)),
                const SizedBox(height: 24),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),

                // Sign In Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6200EE),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final userCredential = await _authService.signInWithEmailAndPassword(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );

                    if (userCredential == null) {
                      // Exibir erro
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Falha no login. Verifique seu e-mail e senha.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    // Se o login for bem-sucedido, o AuthWrapper cuidará da navegação.
                  },
                  child: const Text('Entrar', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const SizedBox(height: 16),

                // Register Link
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    'Não é cadastrado? Cadastre-se',
                    style: TextStyle(color: Color(0xFF6200EE)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 