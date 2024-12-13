import 'package:firebase_auth/firebase_auth.dart';

// Classe de exceção personalizada para tratamento de erros de autenticação
class AutenticacaoException implements Exception {
  final String message;
  AutenticacaoException(this.message);

  @override
  String toString() {
    return message;
  }
}

class AutenticacaoService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> login({required String email, required String senha}) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      throw AutenticacaoException(_getErrorMessage(e)); // Lança exceção personalizada
    } catch (e) {
      throw AutenticacaoException('Erro desconhecido. Por favor, tente novamente.'); // Lança exceção personalizada
    }
  }

  Future<UserCredential?> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
    required String telefone,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      throw AutenticacaoException(_getErrorMessage(e)); // Lança exceção personalizada
    } catch (e) {
      throw AutenticacaoException('Erro desconhecido. Por favor, tente novamente.'); // Lança exceção personalizada
    }
  }

  Future<void> resetarSenha(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AutenticacaoException(_getErrorMessage(e)); // Lança exceção personalizada
    } catch (e) {
      throw AutenticacaoException('Erro desconhecido. Por favor, tente novamente.'); // Lança exceção personalizada
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'Este e-mail já está sendo utilizado.';
      case 'weak-password':
        return 'A senha é muito fraca.';
      case 'operation-not-allowed':
        return 'Operação não permitida.';
      default:
        return 'Erro desconhecido.';
    }
  }
}
