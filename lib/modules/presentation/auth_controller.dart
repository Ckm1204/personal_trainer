import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_trainer/modules/presentation/pages/login_page.dart';
import 'package:personal_trainer/domain/domain/usecases/login_usecase.dart';
import 'package:personal_trainer/domain/domain/usecases/register_usecase.dart';

import '../../domain/domain/usecases/all_methods_user_usecase.dart';
import '../home/pages/home_page.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final isLogged = false.obs;

  final userId = RxString('');
  final isLoading = false.obs;

  final _registerUseCase = Get.find<RegisterUseCase>();
  final _loginUseCase = Get.find<LoginUseCase>();
  final _allMethodsUser = Get.find<AllMethodsUser>();



  void setUserId(String id) {
    userId.value = id;
  }

  String getUserId() {
    return userId.value;
  }


  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Completa todos los campos');
      return;
    }

    try {
      isLoading.value = true;
      await _loginUseCase(email, password);
      Get.offAll(() => const HomePage());
    } catch (e) {
      print('Error al iniciar sesión: $e');
      Get.snackbar('Error', 'Error al iniciar sesión',
          messageText: Text(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final username = usernameController.text.trim();

    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      Get.snackbar('Error', 'Completa todos los campos');
      return;
    }

    try {
      isLoading.value = true;
      await _registerUseCase(email, password);
      Get.back();
    } catch (e) {
      print('Error al registrar: $e');
      Get.snackbar('Error', 'Error al registrar',
          messageText: Text(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _allMethodsUser.logout();
      Get.offAll(() => const LoginPage());
    } catch (e) {
      print('Error al cerrar sesión: $e');
      Get.snackbar('Error', 'Error al cerrar sesión',
          messageText: Text(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> getUserIdd() async {
    try {
      final userid = await _allMethodsUser.getUserId();
      return userid;
    } catch (e) {
      print('Error al obtener el ID del usuario: $e');
      return '';
    }
  }


}
