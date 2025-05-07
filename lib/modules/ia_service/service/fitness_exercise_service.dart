import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../domain/domain/entities/FitnessQuestionnaire.dart';

class ExerciseSuggestionService {
  Future<Map<String, List<String>>> generateWeeklyExercises(FitnessQuestionnaire questionnaire) async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      print('1. Checking API key...');

      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('API key not found. Please add GEMINI_API_KEY to your .env file.');
      }

      print('2. Creating Gemini model...');
      final model = GenerativeModel(
        model: 'gemini-2.0-flash-lite',
        apiKey: apiKey,
      );

      print('3. Building prompt...');
      final prompt = '''
      Actúa como un entrenador personal profesional. Crea una rutina de ejercicios detallada para 7 días basada en:
      Peso: ${questionnaire.weight} kg
      Altura: ${questionnaire.height} cm
      Género: ${questionnaire.gender}
      Objetivos: ${questionnaire.fitnessGoals.join(', ')}
      Nivel de actividad: ${questionnaire.activityLevel}
      Condiciones médicas: ${questionnaire.medicalConditions.join(', ')}
      
      IMPORTANTE: Responde SOLO con el siguiente formato exacto, sin texto adicional:
      
      Día 1:
      Ejercicio 1: [nombre del ejercicio] - [series x repeticiones o tiempo]
      Ejercicio 2: [nombre del ejercicio] - [series x repeticiones o tiempo]
      Ejercicio 3: [nombre del ejercicio] - [series x repeticiones o tiempo]
      
      Día 2:
      [Continuar mismo formato]
      ''';

      print('4. Sending request to Gemini...');
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Respuesta vacía del modelo de IA');
      }

      print('5. Processing response...');
      print('Raw response: ${response.text}');

      final result = _parseExerciseResponse(response.text!);
      print('6. Parsed ${result.length} days of exercises');

      if (result.isEmpty) {
        throw Exception('No se pudo generar la rutina de ejercicios');
      }

      return result;
    } catch (e) {
      print('Error in generateWeeklyExercises: $e');
      return _getDefaultExercisePlan();
    }
  }

Map<String, List<String>> _parseExerciseResponse(String response) {
  try {
    final Map<String, List<String>> weeklyExercises = {};
    final List<String> days = response.split('\n\n');

    for (var day in days) {
      if (day.trim().isEmpty) continue;

      final lines = day.split('\n');
      if (lines.isEmpty) continue;

      // Get the day line
      final dayLine = lines[0].trim();
      if (!dayLine.toLowerCase().startsWith('día')) continue;

      final dayNumber = dayLine.replaceAll(':', '').trim();

      // Get exercises, skipping the day header
      final exercises = lines.skip(1)
          .where((line) => line.trim().isNotEmpty &&
              !line.startsWith('*') &&
              !line.startsWith('-') &&
              !line.startsWith('**'))
          .map((line) {
            // Clean up the exercise line
            final cleanLine = line
                .replaceAll(RegExp(r'ejercicio \d+:?', caseSensitive: false), '')
                .trim();
            return cleanLine;
          })
          .where((exercise) => exercise.isNotEmpty)
          .toList();

      if (exercises.isNotEmpty) {
        weeklyExercises[dayNumber] = exercises;
      }
    }

    print('Parsed exercises: ${weeklyExercises.length} days');

    // Validate we have at least some exercises
    if (weeklyExercises.isEmpty) {
      throw Exception('No valid exercises found in response');
    }

    return weeklyExercises;
  } catch (e) {
    print('Error in _parseExerciseResponse: $e');
    return {};
  }
}

  Map<String, List<String>> _getDefaultExercisePlan() {
    return {
      'Día 1': [
        'Sentadillas - 3 series x 12 repeticiones',
        'Flexiones de pecho - 3 series x 10 repeticiones',
        'Plancha - 3 series x 30 segundos'
      ],
      'Día 2': [
        'Caminata rápida - 30 minutos',
        'Peso muerto - 3 series x 10 repeticiones',
        'Abdominales - 3 series x 15 repeticiones'
      ]

    };
  }
}