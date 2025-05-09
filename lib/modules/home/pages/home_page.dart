import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_trainer/modules/diet/pages/weekly_diet_page.dart';
import 'package:personal_trainer/modules/exercise/pages/weekly_excercise_page.dart';
import 'package:personal_trainer/modules/profile/widgets/profile_widget.dart';
import '../../presentation/auth_controller.dart';
import '../../questions/pages/questionnaire_details_page.dart';
import '../../questions/pages/questionnaire_page.dart';
import '../widget/home_widget.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final currentIndex = 0.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrenador Personal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => controller.logout(),
          )
        ],
      ),
      body: Obx(() => IndexedStack(
        index: currentIndex.value,
        children: const [
          // Aqui van las pantallas de la app
          WeeklyDietScreen(),
          WeeklyExerciseScreen(),
          //HomeContent(),
          ProfileWidget(),
          QuestionnaireDetailsScreen(),
        ],
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: currentIndex.value,
        onTap: (index) => currentIndex.value = index,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: 'Dieta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_outlined),
            label: 'Ejercicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progreso',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      )),
    );
  }
}