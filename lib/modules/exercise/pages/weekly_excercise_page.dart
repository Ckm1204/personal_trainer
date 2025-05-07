import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/core/services/questionnaire_service.dart';
import '../../ia_service/service/fitness_exercise_service.dart';
import '../../presentation/auth_controller.dart';

class WeeklyExerciseScreen extends StatefulWidget {
  const WeeklyExerciseScreen({super.key});

  @override
  State<WeeklyExerciseScreen> createState() => _WeeklyExerciseScreenState();
}

class _WeeklyExerciseScreenState extends State<WeeklyExerciseScreen> {
  final ExerciseSuggestionService _exerciseService = ExerciseSuggestionService();
  final QuestionnaireService _questionnaireService = QuestionnaireService();
  final AuthController _authController = Get.find<AuthController>();

  Map<String, List<String>> weeklyExercises = {};
  bool _isLoading = true;
  String? _userId;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExercises();
    });
  }

  Future<void> _loadUserId() async {
    try {
      _userId = await _authController.getUserIdd();
      print('User ID loaded: $_userId');
    } catch (e) {
      print('Error loading user ID: $e');
      _errorMessage = 'Error al cargar el ID de usuario';
    }
  }

  Future<void> _loadExercises() async {
    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      await _loadUserId();
      print('1. User ID after loading: $_userId');

      if (_userId == null) {
        setState(() {
          _errorMessage = 'No se pudo obtener el ID de usuario';
          _isLoading = false;
        });
        return;
      }

      final questionnaire = await _questionnaireService.getQuestionnaireCompleteByUserId(_userId!);
      print('2. Questionnaire loaded: ${questionnaire != null}');

      if (questionnaire == null) {
        setState(() {
          _errorMessage = 'Por favor completa el cuestionario primero';
          _isLoading = false;
        });
        return;
      }

      print('3. Generating exercise plan...');
      final exercises = await _exerciseService.generateWeeklyExercises(questionnaire);
      print('4. Exercise plan generated: ${exercises.length} days');

      if (mounted) {
        setState(() {
          weeklyExercises = exercises;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error in _loadExercises: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar el plan de ejercicios: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Semanal de Ejercicios'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
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
                )
              : weeklyExercises.isEmpty
                  ? const Center(
                      child: Text('No hay un plan de ejercicios disponible'),
                    )
                  : ListView.builder(
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