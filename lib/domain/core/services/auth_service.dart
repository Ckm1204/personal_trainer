import 'package:get/get.dart';
import 'package:appwrite/appwrite.dart';
import 'package:personal_trainer/domain/data/datasources/provider/app_write_provider.dart';
import 'package:personal_trainer/modules/home/pages/home_page.dart';
import 'package:personal_trainer/modules/presentation/pages/login_page.dart';

import '../../domain/entities/user.dart';

class AuthService extends GetxService {
  final _appWriteProvider = Get.find<AppWriteProvider>();
  late final Account _account;
  final isAuthenticated = false.obs;
  final Rx<User?> _currentUser = Rx<User?>(null);
  User? get currentUser => _currentUser.value;


  AuthService() {
    _account = Account(_appWriteProvider.client);
  }

  Future<AuthService> init() async {
    await checkAuthStatus();
    return this;
  }

  Future<void> checkAuthStatus() async {
    try {
      final session = await _account.getSession(
        sessionId: 'current',
      );
      isAuthenticated.value = session.$id.isNotEmpty;
    } catch (e) {
      isAuthenticated.value = false;
      print('No active session: $e');
    }
  }

  void signIn() {
    isAuthenticated.value = true;
    Get.offAll(() => const HomePage());
  }

  Future<void> signOut() async {
    try {
      await _account.deleteSession(
        sessionId: 'current',
      );
    } catch (e) {
      print('Error deleting session: $e');
    } finally {
      isAuthenticated.value = false;
      Get.offAll(() => const LoginPage());
    }
  }





}