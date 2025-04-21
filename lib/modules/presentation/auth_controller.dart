import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_trainer/utils/domain/usecases/login_usecase.dart';
import 'package:personal_trainer/utils/domain/usecases/register_usecase.dart';

import '../home/pages/home_page.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isLogin = true.obs;

  final _registerUseCase = Get.find<RegisterUseCase>();
  final _loginUseCase = Get.find<LoginUseCase>();

  void toggleForm() => isLogin.value = !isLogin.value;

  Future<void> submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Completa todos los campos');
      return;
    }

    try {
      isLoading.value = true;

      if (isLogin.value) {
        print('Intentando login con $email');
        await _loginUseCase(email, password);
      } else {
        print('Intentando registro con $email');
        final result = await _registerUseCase(email, password);
        print('Registro exitoso: ${result.email}');
      }

      Get.offAll(() => const HomePage());
    } catch (e) {
      print('Error al registrar o iniciar sesión: $e');
      Get.snackbar('Error', 'Error inesperado',
          messageText: Text(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

}
