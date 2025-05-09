// lib/modules/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import 'register_page.dart';
import 'package:personal_trainer/domain/core/services/auth_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final authService = Get.find<AuthService>();

    // Validación de sesión activa
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await authService.checkAuthStatus();
      if (authService.isAuthenticated.value) {
        authService.signIn();
      }
    });

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: controller.emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              controller.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: () async {
                    await controller.login();
                    if (controller.isLogged.value) {
                      authService.signIn();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 40,
                    ),
                  ),
                  child: const Text(
                    'Iniciar Sesión',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.to(() => const RegisterPage()),
                child: const Text('¿No tienes cuenta? Regístrate'),
              )
            ],
          )),
        ),
      ),
    );
  }
}