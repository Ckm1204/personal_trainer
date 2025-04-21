import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import '../../domain/entities/user.dart';

class RemoteDataSource {
  final Account _account;

  RemoteDataSource(Client client) : _account = Account(client);

  Future<User> register(String email, String password) async {
    try {
      final appwrite_models.User user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      print('[✅] Registro exitoso con ID: ${user.$id}');

      // Crear sesión automáticamente después del registro
      await _account.createEmailPasswordSession(
          email: email, password: password);
      print('[🔐] Sesión creada correctamente tras registro');

      return User(id: user.$id, email: user.email);
    } on AppwriteException catch (e) {
      print('[❌] AppwriteException: ${e.message}');
      rethrow;
    } catch (e) {
      print('[❌] Error inesperado en registro: $e');
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _account.createEmailPasswordSession(
          email: email, password: password);
      print('[✅] Sesión iniciada exitosamente');
    } on AppwriteException catch (e) {
      print('[❌] AppwriteException: ${e.message}');
      rethrow;
    } catch (e) {
      print('[❌] Error inesperado en login: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      print('[🚪] Sesión cerrada exitosamente');
    } catch (e) {
      print('[❌] Error al cerrar sesión: $e');
    }
  }
}
