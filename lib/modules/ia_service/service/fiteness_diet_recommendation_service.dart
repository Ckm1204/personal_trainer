// lib/modules/ia_service/service/diet_suggestion_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../domain/domain/entities/FitnessQuestionnaire.dart';

class DietSuggestionService {

  Future<Map<String, List<String>>> generateWeeklyDiet(FitnessQuestionnaire questionnaire) async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      print('1. Checking API key...'); // Debug print

      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('API key not found. Please add GEMINI_API_KEY to your .env file.');
      }

      print('2. Creating Gemini model...'); // Debug print
      final model = GenerativeModel(
        model: 'gemini-2.0-flash-lite', // Use the appropriate model name
        apiKey: apiKey,
      );

      print('3. Building prompt...'); // Debug print
      final prompt = '''
        Actúa como un nutricionista profesional experto. Crea un plan detallado de comidas para 7 días basado en:
        Peso: ${questionnaire.weight} kg
        Altura: ${questionnaire.height} cm
        Género: ${questionnaire.gender}
        Objetivos: ${questionnaire.fitnessGoals.join(', ')}
        Restricciones: ${questionnaire.dietaryRestrictions.join(', ')}
        Hábitos: ${questionnaire.eatingHabits}
        Actividad: ${questionnaire.activityLevel}
        Condiciones médicas: ${questionnaire.medicalConditions.join(', ')}
        Alergias: ${questionnaire.allergies.join(', ')}
        
        Genera un plan de comidas nutritivo y balanceado.
        Responde EXACTAMENTE en este formato:
        
        Día 1:
        Desayuno: [comida detallada]
        Almuerzo: [comida detallada]
        Cena: [comida detallada]
        
        Día 2:
        Desayuno: [comida detallada]
        Almuerzo: [comida detallada]
        Cena: [comida detallada]
        
        Día 3:
        Desayuno: [comida detallada]
        Almuerzo: [comida detallada]
        Cena: [comida detallada]
        
        Día 4:
        Desayuno: [comida detallada]
        Almuerzo: [comida detallada]
        Cena: [comida detallada]
        
        Día 5:
        Desayuno: [comida detallada]
        Almuerzo: [comida detallada]
        Cena: [comida detallada]
        
        
        Día 6:
        Desayuno: [comida detallada]
        Almuerzo: [comida detallada]
        Cena: [comida detallada]
        
        
        Día 7:
        Desayuno: [comida detallada]
        Almuerzo: [comida detallada]
        Cena: [comida detallada]
        
        Asegúrate de que cada comida sea saludable y adecuada para el perfil del usuario. No incluyas explicaciones, solo el plan de comidas.
        
        ''';

      print('4. Sending request to Gemini...'); // Debug print
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Respuesta vacía del modelo de IA');
      }

      print('5. Processing response...'); // Debug print
      print('Raw response: ${response.text}'); // Debug print

      final result = _parseDietResponse(response.text!);
      print('6. Parsed ${result.length} days of meals'); // Debug print

      if (result.isEmpty) {
        throw Exception('No se pudo generar el plan de comidas');
      }

      return result;
    } catch (e) {
      print('Error in generateWeeklyDiet: $e');
      // Return a sample diet plan instead of empty map for testing
      return {
        'Día 1': [
          'Avena con frutas y almendras',
          'Pechuga de pollo con ensalada',
          'Pescado al horno con verduras'
        ],
        'Día 2': [
          'Tostadas integrales con huevo',
          'Ensalada de quinoa con vegetales',
          'Sopa de verduras con proteína'
        ],
        // Add more days for testing
      };
    }
  }

  Map<String, List<String>> _parseDietResponse(String response) {
    try {
      final Map<String, List<String>> weeklyDiet = {};
      final List<String> days = response.split('\n\n');

      for (var day in days) {
        if (day.trim().isEmpty) continue;

        final lines = day.split('\n');
        if (lines.length < 4) continue;

        // Clean up the day line
        final dayLine = lines[0].trim();
        if (!dayLine.toLowerCase().startsWith('día')) continue;

        final dayNumber = dayLine.replaceAll(':', '').trim();

        // Extract meals, handling potential format issues
        String breakfast = '', lunch = '', dinner = '';

        for (var line in lines.skip(1)) {
          if (line.toLowerCase().contains('desayuno')) {
            breakfast = line.replaceAll(RegExp(r'desayuno:?', caseSensitive: false), '').trim();
          } else if (line.toLowerCase().contains('almuerzo')) {
            lunch = line.replaceAll(RegExp(r'almuerzo:?', caseSensitive: false), '').trim();
          } else if (line.toLowerCase().contains('cena')) {
            dinner = line.replaceAll(RegExp(r'cena:?', caseSensitive: false), '').trim();
          }
        }

        if (breakfast.isNotEmpty || lunch.isNotEmpty || dinner.isNotEmpty) {
          weeklyDiet[dayNumber] = [breakfast, lunch, dinner];
        }
      }

      print('Parsed diet plan: ${weeklyDiet.length} days'); // Debug print
      return weeklyDiet;
    } catch (e) {
      print('Error parsing diet response: $e');
      return {};
    }
  }




}