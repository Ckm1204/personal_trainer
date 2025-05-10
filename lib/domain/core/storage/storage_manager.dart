// lib/core/storage/storage_manager.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_trainer/modules/exercise/widgets/saved_exercise_plan.dart';

class StorageManager {
  static final StorageManager _instance = StorageManager._internal();

  factory StorageManager() {
    return _instance;
  }

  StorageManager._internal();

  // Box names
  static const String exerciseBoxName = 'saved_exercises';
  static const String nutritionBoxName = 'saved_nutrition';
  static const String habitsBoxName = 'saved_habits';

  // Type IDs for Hive adapters
  static const int exercisePlanTypeId = 1;
  static const int nutritionPlanTypeId = 2;
  static const int habitsTypeId = 3;

  Future<void> initializeStorage() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(exercisePlanTypeId)) {
      Hive.registerAdapter(SavedExercisePlanAdapter());
    }
    // Add other adapters here when needed
    // if (!Hive.isAdapterRegistered(nutritionPlanTypeId)) {
    //   Hive.registerAdapter(SavedNutritionPlanAdapter());
    // }
    // if (!Hive.isAdapterRegistered(habitsTypeId)) {
    //   Hive.registerAdapter(SavedhabitsAdapter());
    // }

    // Open boxes
    await Future.wait([
      Hive.openBox<SavedExercisePlan>(exerciseBoxName),
      // Add other boxes here when needed
      // Hive.openBox<SavedNutritionPlan>(nutritionBoxName),
      // Hive.openBox<Savedhabits>(habitsBoxName),
    ]);
  }

  Future<void> closeStorage() async {
    await Hive.close();
  }
}