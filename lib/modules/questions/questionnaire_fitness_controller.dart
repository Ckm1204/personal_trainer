// lib/modules/questions/controllers/questionnaire_fitness_controller.dart
import 'dart:async';

import 'package:get/get.dart';
import 'package:appwrite/appwrite.dart';
import 'package:personal_trainer/modules/presentation/auth_controller.dart';
import '../../../util/constants/appwrite_constants.dart';
import '../../../domain/domain/entities/FitnessQuestionnaire.dart';
import '../../domain/data/datasources/provider/app_write_provider.dart';

class QuestionnaireFitnessController extends GetxController {
  final fitnessGoals = <String>[].obs;
  final timelineGoal = ''.obs;
  final motivations = <String>[].obs;
  final previousAttempts = <String>[].obs;
  final commitmentLevel = ''.obs;
  final preferredActivities = <String>[].obs;
  final medicalConditions = <String>[].obs;
  final medications = <String>[].obs;
  final allergies = <String>[].obs;
  final energyLevel = ''.obs;
  final sleepQuality = ''.obs;
  final activityLevel = ''.obs;
  final dietaryRestrictions = <String>[].obs;
  final eatingHabits = ''.obs;
  final alcoholConsumption = ''.obs;
  final smokingStatus = ''.obs;
  final trainingPreferences = <String>[].obs;
  final weeklyTrainingHours = 0.obs;
  final otherAnswers = <String, String>{}.obs;
  final isLoading = false.obs;

  final AppWriteProvider appWriteProvider;
  final AuthController authController = Get.find<AuthController>();
  late final Databases databases;

  QuestionnaireFitnessController(this.appWriteProvider) {
    databases = Databases(appWriteProvider.client);


  }

 Future<void> submitQuestionnaire() async {
   try {
     isLoading.value = true;

     final userId = await authController.getUserIdd().timeout(
       const Duration(seconds: 10),
       onTimeout: () => throw TimeoutException('Connection timed out'),
     );

     if (userId.isEmpty) {
       throw Exception('User ID not found');
     }

     // Check if user already has a questionnaire
     try {
       final existingDoc = await databases.listDocuments(
         databaseId: AppwriteConstants.databaseId,
         collectionId: AppwriteConstants.collectionDataUsersId,
         queries: [
           Query.equal('userId', userId),
         ],
       );

       final questionnaire = FitnessQuestionnaire(
         userId: userId,
         fitnessGoals: fitnessGoals,
         timelineGoal: timelineGoal.value,
         motivations: motivations,
         previousAttempts: previousAttempts,
         commitmentLevel: commitmentLevel.value,
         preferredActivities: preferredActivities,
         medicalConditions: medicalConditions,
         medications: medications,
         allergies: allergies,
         energyLevel: energyLevel.value,
         sleepQuality: sleepQuality.value,
         activityLevel: activityLevel.value,
         dietaryRestrictions: dietaryRestrictions,
         eatingHabits: eatingHabits.value,
         alcoholConsumption: alcoholConsumption.value,
         smokingStatus: smokingStatus.value,
         trainingPreferences: trainingPreferences,
         weeklyTrainingHours: weeklyTrainingHours.value,
         otherAnswers: otherAnswers,
       );

       if (existingDoc.documents.isNotEmpty) {
         // Update existing document
         final docId = existingDoc.documents.first.$id;
         await databases.updateDocument(
           databaseId: AppwriteConstants.databaseId,
           collectionId: AppwriteConstants.collectionDataUsersId,
           documentId: docId,
           data: questionnaire.toJson(),
         );
         Get.snackbar('Éxito', 'Cuestionario actualizado correctamente');
       } else {
         // Create new document
         await databases.createDocument(
           databaseId: AppwriteConstants.databaseId,
           collectionId: AppwriteConstants.collectionDataUsersId,
           documentId: ID.unique(),
           data: questionnaire.toJson(),
         );
         Get.snackbar('Éxito', 'Cuestionario guardado correctamente');
       }
     } catch (e) {
       print('Error checking/updating questionnaire: $e');
       Get.snackbar(
         'Error',
         'Error al procesar el cuestionario: ${e.toString()}',
         duration: const Duration(seconds: 5)
       );
     }
   } catch (e) {
     print('Error submitting questionnaire: $e');
     Get.snackbar(
       'Error',
       'No se pudo guardar el cuestionario: ${e.toString()}',
       duration: const Duration(seconds: 5)
     );
   } finally {
     isLoading.value = false;
   }
 }


}