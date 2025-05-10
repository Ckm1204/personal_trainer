// lib/modules/exercise/widgets/exercise_storage_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_trainer/modules/exercise/widgets/saved_exercise_plan.dart';

import '../../../domain/core/storage/storage_manager.dart';

class ExerciseStorageService {
  Box<SavedExercisePlan>? _box;

  Future<void> init() async {
    _box = Hive.box<SavedExercisePlan>(StorageManager.exerciseBoxName);
  }

  Future<void> saveExercisePlan(Map<String, List<String>> exercises) async {
    final plan = SavedExercisePlan(
      exercises: exercises,
      savedAt: DateTime.now(),
    );
    await _box?.put('current_plan', plan);
  }

  SavedExercisePlan? getSavedPlan() {
    return _box?.get('current_plan');
  }

  Future<void> clearSavedPlan() async {
    await _box?.delete('current_plan');
  }
}