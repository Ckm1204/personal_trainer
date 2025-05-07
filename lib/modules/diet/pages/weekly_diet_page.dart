// lib/modules/diet/pages/weekly_diet_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_trainer/modules/ia_service/service/fiteness_diet_recommendation_service.dart';
import '../../../../domain/core/services/questionnaire_service.dart';
import '../../presentation/auth_controller.dart';


class WeeklyDietScreen extends StatefulWidget {
  const WeeklyDietScreen({super.key});

  @override
  State<WeeklyDietScreen> createState() => _WeeklyDietScreenState();
}

class _WeeklyDietScreenState extends State<WeeklyDietScreen> {
  final DietSuggestionService _dietService = DietSuggestionService();
  final QuestionnaireService _questionnaireService = QuestionnaireService();
  final AuthController _authController = Get.find<AuthController>();

  Map<String, List<String>> weeklyDiet = {};
  bool _isLoading = true;
  String? _userId;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDiet();
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

  // lib/modules/ia_service/weekly_diet_page.dart
  // Update the _loadDiet method:

  Future<void> _loadDiet() async {
    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      await _loadUserId();
      print('1. User ID after loading: $_userId'); // Debug print

      if (_userId == null) {
        setState(() {
          _errorMessage = 'No se pudo obtener el ID de usuario';
          _isLoading = false;
        });
        return;
      }

      final questionnaire = await _questionnaireService.getQuestionnaireCompleteByUserId(_userId!);
      print('2. Questionnaire loaded: ${questionnaire != null}'); // Debug print

      if (questionnaire == null) {
        setState(() {
          _errorMessage = 'Por favor completa el cuestionario primero';
          _isLoading = false;
        });
        return;
      }

      print('3. Generating diet plan...'); // Debug print
      final diet = await _dietService.generateWeeklyDiet(questionnaire);
      print('4. Diet plan generated: ${diet.length} days'); // Debug print

      if (mounted) {
        setState(() {
          weeklyDiet = diet;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error in _loadDiet: $e'); // Detailed error
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar el plan de comidas: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Semanal de Comidas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadDiet,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : weeklyDiet.isEmpty
                  ? const Center(
                      child: Text('No hay un plan de comidas disponible'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: weeklyDiet.length,
                      itemBuilder: (context, index) {
                        final day = 'Día ${index + 1}';
                        final meals = weeklyDiet[day] ?? [];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ExpansionTile(
                            title: Text(day,
                              style: const TextStyle(fontWeight: FontWeight.bold)
                            ),
                            children: [
                              _buildMealTile('Desayuno', meals.isNotEmpty ? meals[0] : ''),
                              _buildMealTile('Almuerzo', meals.length > 1 ? meals[1] : ''),
                              _buildMealTile('Cena', meals.length > 2 ? meals[2] : ''),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }

  Widget _buildMealTile(String title, String meal) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(meal),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}