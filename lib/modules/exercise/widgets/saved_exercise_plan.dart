// lib/modules/exercise/widgets/saved_exercise_plan.dart
import 'package:hive/hive.dart';

part 'saved_exercise_plan.g.dart';

@HiveType(typeId: 1)
class SavedExercisePlan extends HiveObject {
  @HiveField(0)
  final Map<String, List<String>> exercises;

  @HiveField(1)
  final DateTime savedAt;

  SavedExercisePlan({
    required this.exercises,
    required this.savedAt,
  });
}