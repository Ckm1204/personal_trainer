// lib/modules/questions/views/questionnaire_fitness_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/data/datasources/provider/app_write_provider.dart';
import '../../home/pages/home_page.dart';
import '../questionnaire_fitness_controller.dart';
import '../widgets/questionnaire_fitness_widget.dart';


class QuestionnaireFitnessPage extends StatelessWidget {
  const QuestionnaireFitnessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuestionnaireFitnessController(AppWriteProvider()));
    final showQuestions = false.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuestionario Fitness'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(() => !showQuestions.value
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Información Personal',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) => controller.username.value = value,
              decoration: const InputDecoration(
                labelText: 'Nombre de usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Fecha de nacimiento'),
              subtitle: Text(
                controller.birthDate.value.toString().split(' ')[0],
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  controller.birthDate.value = date;
                }
              },
            ),
            const SizedBox(height: 16),
            const Text('Género:', style: TextStyle(fontSize: 16)),
            RadioListTile(
              title: const Text('Masculino'),
              value: 'Masculino',
              groupValue: controller.gender.value,
              onChanged: (value) => controller.gender.value = value!,
            ),
            RadioListTile(
              title: const Text('Femenino'),
              value: 'Femenino',
              groupValue: controller.gender.value,
              onChanged: (value) => controller.gender.value = value!,
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) => controller.height.value = value,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Altura (metros)',
                hintText: 'Ejemplo: 1.75',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) => controller.weight.value = value,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Peso (kg)',
                hintText: 'Ejemplo: 70.5',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () => showQuestions.value = true,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Siguiente'),
              ),
            ),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuestionWidgets.buildMultipleChoice(
              'Objetivos de fitness:',
              ['Perder peso', 'Ganar músculo', 'Mejorar condición física', 'Preparación para evento', 'Otro'],
              controller.fitnessGoals,
              allowMultiple: true,
              onOtherSelected: (value) => controller.otherAnswers['fitnessGoals'] = value,
            ),
            QuestionWidgets.buildSingleChoice(
              'Plazo para lograr objetivos:',
              ['3 meses', '6 meses', '12 meses', 'Más de 12 meses'],
              controller.timelineGoal,
            ),
            QuestionWidgets.buildMultipleChoice(
              '¿Qué te motiva a hacer este cambio?',
              ['Salud', 'Apariencia física', 'Rendimiento deportivo', 'Bienestar general', 'Otro'],
              controller.motivations,
              allowMultiple: true,
              onOtherSelected: (value) => controller.otherAnswers['motivations'] = value,
            ),
            QuestionWidgets.buildMultipleChoice(
              '¿Qué has intentado antes?',
              ['Dietas', 'Ejercicio en casa', 'Gimnasio', 'Deportes', 'Entrenador personal', 'Otro'],
              controller.previousAttempts,
              allowMultiple: true,
              onOtherSelected: (value) => controller.otherAnswers['previousAttempts'] = value,
            ),
            QuestionWidgets.buildSingleChoice(
              'Nivel de compromiso:',
              ['Muy comprometido', 'Moderadamente comprometido', 'Poco comprometido'],
              controller.commitmentLevel,
            ),
            QuestionWidgets.buildMultipleChoice(
              'Actividades físicas preferidas:',
              ['Pesas', 'Cardio', 'Deportes de equipo', 'Yoga', 'Artes marciales', 'Otro'],
              controller.preferredActivities,
              allowMultiple: true,
              onOtherSelected: (value) => controller.otherAnswers['preferredActivities'] = value,
            ),
            QuestionWidgets.buildMultipleChoice(
              'Condiciones médicas:',
              ['Ninguna', 'Problemas cardíacos', 'Diabetes', 'Problemas articulares', 'Otro'],
              controller.medicalConditions,
              allowMultiple: true,
              onOtherSelected: (value) => controller.otherAnswers['medicalConditions'] = value,
            ),
            QuestionWidgets.buildMultipleChoice(
              'Medicamentos:',
              ['Ninguno', 'Antihipertensivos', 'Antiinflamatorios', 'Otro'],
              controller.medications,
              allowMultiple: true,
              onOtherSelected: (value) => controller.otherAnswers['medications'] = value,
            ),
            QuestionWidgets.buildMultipleChoice(
              'Alergias o intolerancias:',
              ['Ninguna', 'Lácteos', 'Gluten', 'Frutos secos', 'Otro'],
              controller.allergies,
              allowMultiple: true,
              onOtherSelected: (value) => controller.otherAnswers['allergies'] = value,
            ),
            QuestionWidgets.buildSingleChoice(
              'Nivel de energía diario:',
              ['Alto', 'Medio', 'Bajo', 'Variable'],
              controller.energyLevel,
            ),
            QuestionWidgets.buildSingleChoice(
              'Calidad del sueño:',
              ['Excelente', 'Buena', 'Regular', 'Mala'],
              controller.sleepQuality,
            ),
            QuestionWidgets.buildSingleChoice(
              'Nivel de actividad actual:',
              ['Sedentario', 'Ligeramente activo', 'Moderadamente activo', 'Muy activo'],
              controller.activityLevel,
            ),
            QuestionWidgets.buildMultipleChoice(
              'Restricciones dietéticas:',
              ['Ninguna', 'Vegetariano', 'Vegano', 'Sin gluten', 'Sin lactosa', 'Otro'],
              controller.dietaryRestrictions,
              allowMultiple: true,
              onOtherSelected: (value) => controller.otherAnswers['dietaryRestrictions'] = value,
            ),
            QuestionWidgets.buildSingleChoice(
              'Hábitos alimenticios:',
              ['Muy saludables', 'Moderadamente saludables', 'Necesitan mejora'],
              controller.eatingHabits,
            ),
            QuestionWidgets.buildSingleChoice(
              'Consumo de alcohol:',
              ['Nunca', 'Ocasional', 'Regular', 'Frecuente'],
              controller.alcoholConsumption,
            ),
            QuestionWidgets.buildSingleChoice(
              '¿Fumas?',
              ['No', 'Ocasionalmente', 'Regularmente'],
              controller.smokingStatus,
            ),
            QuestionWidgets.buildMultipleChoice(
              'Preferencias de entrenamiento:',
              ['Pesas', 'Cardio', 'HIIT', 'Yoga', 'Deportes', 'Otro'],
              controller.trainingPreferences,
              allowMultiple: true,
              onOtherSelected: (value) => controller.otherAnswers['trainingPreferences'] = value,
            ),
            QuestionWidgets.buildSingleChoice(
              'Horas semanales disponibles para entrenar:',
              ['2-3 horas', '4-6 horas', '7-9 horas', 'Más de 10 horas'],
              controller.weeklyTrainingHours.toString().obs,
            ),

            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  controller.submitQuestionnaire();
                  Get.offAll(() => const HomePage());
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Enviar cuestionario'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        )
        ),
      ),
      ),
    );
  }
}