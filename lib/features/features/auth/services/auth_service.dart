import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Stream para verificar o estado de autenticação do usuário
  Stream<User?> get authStateChanges {
    try {
      return _firebaseAuth.authStateChanges();
    } catch (e) {
      print('Erro ao obter authStateChanges: $e');
      // Retorna um stream que emite null (usuário não logado)
      return Stream.value(null);
    }
  }

  // Método para fazer login com email e senha
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Aqui você pode tratar erros específicos, como senha incorreta ou usuário não encontrado
      print(e.message);
      return null;
    } catch (e) {
      print('Erro geral no login: $e');
      return null;
    }
  }

  // Método para criar um novo usuário com email e senha
  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Tratar erros como email já em uso
      print(e.message);
      return null;
    } catch (e) {
      print('Erro geral no cadastro: $e');
      return null;
    }
  }

  // Método para fazer logout
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Erro no logout: $e');
    }
  }
} 