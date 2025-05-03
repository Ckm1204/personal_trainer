import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentation/auth_controller.dart';
import '../../presentation/pages/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              controller.logout();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '¡Bienvenido!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            FutureBuilder<String>(
              future: controller.getUserIdd(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return Text(
                  'ID: ${snapshot.data ?? "No disponible"}',
                  style: const TextStyle(fontSize: 16),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}