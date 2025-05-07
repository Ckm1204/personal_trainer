// lib/services/questionnaire_service.dart
import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../util/constants/appwrite_constants.dart';
import '../../data/datasources/provider/app_write_provider.dart';
import '../../domain/entities/FitnessQuestionnaire.dart';

// lib/services/questionnaire_service.dart
class QuestionnaireService {
  final AppWriteProvider appWriteProvider;

  QuestionnaireService() : appWriteProvider = Get.find<AppWriteProvider>();

  Future<FitnessQuestionnaire?> getQuestionnaireCompleteByUserId(String userId) async {
    try {
      final databases = Databases(appWriteProvider.client);
      final response = await databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionDataUsersId,
        queries: [Query.equal('userId', userId)],
      );

      if (response.documents.isEmpty) return null;
      return FitnessQuestionnaire.fromJson(response.documents.first.data);
    } catch (e) {
      print('Error fetching questionnaire: $e');
      return null;
    }
  }


}