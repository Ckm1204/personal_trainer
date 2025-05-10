import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../domain/core/services/questionnaire_service.dart';
import '../../ia_service/service/fitness_exercise_service.dart';
import '../../presentation/auth_controller.dart';
import '../widgets/exercise_storage_service.dart';

class WeeklyExerciseScreen extends StatefulWidget {
  const WeeklyExerciseScreen({super.key});

  @override
  State<WeeklyExerciseScreen> createState() => _WeeklyExerciseScreenState();
}

class _WeeklyExerciseScreenState extends State<WeeklyExerciseScreen> {
  final ExerciseSuggestionService _exerciseService = ExerciseSuggestionService();
  final QuestionnaireService _questionnaireService = QuestionnaireService();
  final ExerciseStorageService _storageService = ExerciseStorageService();
  final AuthController _authController = Get.find<AuthController>();

  Map<String, List<String>> weeklyExercises = {};
  bool _isLoading = true;
  String? _userId;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialPlan();
    });
  }

  Future<void> _loadInitialPlan() async {
    final savedPlan = _storageService.getSavedPlan();
    if (savedPlan != null) {
      setState(() {
        weeklyExercises = savedPlan.exercises;
        _isLoading = false;
      });
    } else {
      await _loadExercises();
    }
  }

  Future<void> _loadUserId() async {
    try {
      _userId = await _authController.getUserIdd();
    } catch (e) {
      _errorMessage = 'Error al cargar el ID de usuario';
    }
  }

  Future<void> _loadExercises() async {
    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      await _loadUserId();
      if (_userId == null) {
        setState(() {
          _errorMessage = 'No se pudo obtener el ID de usuario';
          _isLoading = false;
        });
        return;
      }

      final questionnaire = await _questionnaireService.getQuestionnaireCompleteByUserId(_userId!);
      if (questionnaire == null) {
        setState(() {
          _errorMessage = 'Por favor completa el cuestionario primero';
          _isLoading = false;
        });
        return;
      }

      final exercises = await _exerciseService.generateWeeklyExercises(questionnaire);
      if (mounted) {
        setState(() {
          weeklyExercises = exercises;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar el plan de ejercicios: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _savePlan() async {
    try {
      await _storageService.saveExercisePlan(weeklyExercises);
      Get.snackbar(
        'Éxito',
        'Plan guardado correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo guardar el plan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Semanal de Ejercicios'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildContent(),
          ),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadExercises,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }
    if (weeklyExercises.isEmpty) {
      return const Center(
        child: Text('No hay un plan de ejercicios disponible'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: weeklyExercises.length,
      itemBuilder: (context, index) {
        final day = 'Día ${index + 1}';
        final exercises = weeklyExercises[day] ?? [];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Text(
              day,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: exercises
                .map((exercise) => _buildExerciseTile(exercise))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: _savePlan,
            icon: const Icon(Icons.favorite),
            label: const Text('Guardar Plan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _loadExercises,
            icon: const Icon(Icons.refresh),
            label: const Text('Generar Nuevo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseTile(String exercise) {
    return ListTile(
      leading: const Icon(Icons.fitness_center),
      title: Text(exercise),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}