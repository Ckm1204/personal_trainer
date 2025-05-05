// lib/models/fitness_questionnaire.dart
import 'dart:convert';
import 'package:appwrite/appwrite.dart';


class FitnessQuestionnaire {

  final String userId;
  final List<String> fitnessGoals;
  final String timelineGoal;
  final List<String> motivations;
  final List<String> previousAttempts;
  final String commitmentLevel;
  final List<String> preferredActivities;
  final List<String> medicalConditions;
  final List<String> medications;
  final List<String> allergies;
  final String energyLevel;
  final String sleepQuality;
  final String activityLevel;
  final List<String> dietaryRestrictions;
  final String eatingHabits;
  final String alcoholConsumption;
  final String smokingStatus;
  final List<String> trainingPreferences;
  final int weeklyTrainingHours;
  final Map<String, String> otherAnswers;

  FitnessQuestionnaire(
      {
    required this.userId,
    required this.fitnessGoals,
    required this.timelineGoal,
    required this.motivations,
    required this.previousAttempts,
    required this.commitmentLevel,
    required this.preferredActivities,
    required this.medicalConditions,
    required this.medications,
    required this.allergies,
    required this.energyLevel,
    required this.sleepQuality,
    required this.activityLevel,
    required this.dietaryRestrictions,
    required this.eatingHabits,
    required this.alcoholConsumption,
    required this.smokingStatus,
    required this.trainingPreferences,
    required this.weeklyTrainingHours,
    required this.otherAnswers,
  }
  );

  Map<String, dynamic> toJson() {
    return {
      'id': ID.unique(), // Use $id instead of id
      'userId': userId,
      'dataFitness': jsonEncode({
        'fitnessGoals': fitnessGoals,
        'timelineGoal': timelineGoal,
        'motivations': motivations,
        'previousAttempts': previousAttempts,
        'commitmentLevel': commitmentLevel,
        'preferredActivities': preferredActivities,
        'medicalConditions': medicalConditions,
        'medications': medications,
        'allergies': allergies,
        'energyLevel': energyLevel,
        'sleepQuality': sleepQuality,
        'activityLevel': activityLevel,
        'dietaryRestrictions': dietaryRestrictions,
        'eatingHabits': eatingHabits,
        'alcoholConsumption': alcoholConsumption,
        'smokingStatus': smokingStatus,
        'trainingPreferences': trainingPreferences,
        'weeklyTrainingHours': weeklyTrainingHours,
        'otherAnswers': otherAnswers,
      })
    };
  }
}