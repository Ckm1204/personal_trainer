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

  final String birthDate;
  final String gender;
  final String height;
  final String username;
  final String weight;



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

    required this.birthDate,
    required this.gender,
    required this.height,
    required this.weight,
    required this.username,
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

      }),
      'dataUser':jsonEncode({
        'birthDate':birthDate,
        'gender':gender,
        'height':height,
        'username':username,
        'weight':weight,
      })
    };
  }

  factory FitnessQuestionnaire.fromJson(Map<String, dynamic> json) {
    final dataFitness = jsonDecode(json['dataFitness']);
    final dataUser = jsonDecode(json['dataUser']);

    return FitnessQuestionnaire(
      userId: json['userId'],
      fitnessGoals: List<String>.from(dataFitness['fitnessGoals']),
      timelineGoal: dataFitness['timelineGoal'],
      motivations: List<String>.from(dataFitness['motivations']),
      previousAttempts: List<String>.from(dataFitness['previousAttempts']),
      commitmentLevel: dataFitness['commitmentLevel'],
      preferredActivities: List<String>.from(dataFitness['preferredActivities']),
      medicalConditions: List<String>.from(dataFitness['medicalConditions']),
      medications: List<String>.from(dataFitness['medications']),
      allergies: List<String>.from(dataFitness['allergies']),
      energyLevel: dataFitness['energyLevel'],
      sleepQuality: dataFitness['sleepQuality'],
      activityLevel: dataFitness['activityLevel'],
      dietaryRestrictions: List<String>.from(dataFitness['dietaryRestrictions']),
      eatingHabits: dataFitness['eatingHabits'],
      alcoholConsumption: dataFitness['alcoholConsumption'],
      smokingStatus: dataFitness['smokingStatus'],
      trainingPreferences: List<String>.from(dataFitness['trainingPreferences']),
      weeklyTrainingHours: dataFitness['weeklyTrainingHours'],
      otherAnswers: Map<String, String>.from(dataFitness['otherAnswers']),
      birthDate: dataUser['birthDate'],
      gender: dataUser['gender'],
      height: dataUser['height'],
      username: dataUser['username'],
      weight: dataUser['weight'],
    );
  }


}