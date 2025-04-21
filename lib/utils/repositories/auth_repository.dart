
import '../domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> register(String email, String password);
  Future<void> login(String email, String password);
  Future<void> logout();
}