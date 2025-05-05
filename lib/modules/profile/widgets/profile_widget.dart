


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../presentation/auth_controller.dart';
import '../../questions/pages/questionnaire_page.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Center(
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.to(() => const QuestionnaireFitnessPage()),
            child: const Text('Editar Cuestionario Fitness'),
          ),
        ],
      ),
    );
  }
}