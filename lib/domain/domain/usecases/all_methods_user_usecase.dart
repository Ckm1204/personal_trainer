
import '../../repositories/auth_repository.dart';
import '../entities/user.dart';

class AllMethodsUser {

  final AuthRepository repository;

  AllMethodsUser(this.repository);


  Future<void> logout(){
    return repository.logout();
  }

  Future<bool> isLoggedIn(){
    return repository.isLoggedIn();
  }

  Future<User> getUser(){
    return repository.getUser();
  }

  Future<String> getUserId(){
    return repository.getUserId();
  }

}