// lib/screens/questionnaire_details_screen.dart
import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:personal_trainer/modules/questions/pages/page.dart';
import 'package:provider/provider.dart';

import '../../../domain/core/services/questionnaire_service.dart';
import '../../../domain/domain/entities/FitnessQuestionnaire.dart';
import '../../presentation/auth_controller.dart';



class QuestionnaireDetailsScreen extends StatefulWidget {
  const QuestionnaireDetailsScreen({Key? key}) : super(key: key);

  @override
  State<QuestionnaireDetailsScreen> createState() => _QuestionnaireDetailsScreenState();
}

class _QuestionnaireDetailsScreenState extends State<QuestionnaireDetailsScreen> {
  FitnessQuestionnaire? _questionnaire;
  bool _isLoading = false;
  final authController = Get.find<AuthController>();
  final _service = QuestionnaireService();
  String? _userId;

  Future<void> _loadUserId() async {
    if (_userId != null) return;
    _userId = await authController.getUserIdd();
    setState(() {});
  }
  Future<void> _fetchQuestionnaire() async {
    if (_userId == null) return;

    setState(() => _isLoading = true);

    try {
      _questionnaire = await _service.getQuestionnaireByUserId(_userId!);
    } catch (e) {
      print('Error al cargar el cuestionario: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserId().then((_) => _fetchQuestionnaire());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del Cuestionario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<String>(
              future: authController.getUserIdd(),
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
              child: const Text('Editar datos'),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_questionnaire != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection('Datos Personales', {
                        'Nombre de usuario': _questionnaire!.username,
                        'Género': _questionnaire!.gender,
                        'Fecha de nacimiento': _questionnaire!.birthDate,
                        'Altura': _questionnaire!.height,
                        'Peso': _questionnaire!.weight,
                      }),
                      _buildSection('Objetivos', {
                        'Objetivos de fitness': _questionnaire!.fitnessGoals.join(', '),
                        'Plazo': _questionnaire!.timelineGoal,
                        'Motivaciones': _questionnaire!.motivations.join(', '),
                      }),
                      _buildSection('Salud', {
                        'Condiciones médicas': _questionnaire!.medicalConditions.join(', '),
                        'Medicamentos': _questionnaire!.medications.join(', '),
                        'Alergias': _questionnaire!.allergies.join(', '),
                        'Nivel de energía': _questionnaire!.energyLevel,
                        'Calidad de sueño': _questionnaire!.sleepQuality,
                      }),
                      _buildSection('Hábitos', {
                        'Nivel de actividad': _questionnaire!.activityLevel,
                        'Restricciones dietéticas': _questionnaire!.dietaryRestrictions.join(', '),
                        'Hábitos alimenticios': _questionnaire!.eatingHabits,
                        'Consumo de alcohol': _questionnaire!.alcoholConsumption,
                        'Estado de fumador': _questionnaire!.smokingStatus,
                      }),
                      _buildSection('Entrenamiento', {
                        'Actividades preferidas': _questionnaire!.preferredActivities.join(', '),
                        'Horas semanales': _questionnaire!.weeklyTrainingHours.toString(),
                        'Nivel de compromiso': _questionnaire!.commitmentLevel,
                      }),
                    ],
                  ),
                ),
              )
            else
              const Center(child: Text('No se encontraron datos')),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Map<String, String> data) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ...data.entries.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${e.key}: ', style: const TextStyle(fontWeight: FontWeight.w500)),
                  Expanded(child: Text(e.value)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }


}