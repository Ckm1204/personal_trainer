import '../data/datasources/remote_data_source.dart';
import '../domain/entities/user.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> register(String email, String password) {
    return remoteDataSource.register(email, password);
  }

  @override
  Future<void> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  Future<bool> isLoggedIn() {
    return remoteDataSource.isLoggedIn();
  }

  @override
  Future<User> getUser() {
    return remoteDataSource.getCurrentUser();
  }

  @override
  Future<String> getUserId() {
    return remoteDataSource.getUserId();
  }


}