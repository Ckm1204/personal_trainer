
import '../domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> register(String email, String password);
  Future<void> login(String email, String password);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<User> getUser();
  Future<String> getUserId();

}