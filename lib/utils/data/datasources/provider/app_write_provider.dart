import 'package:appwrite/appwrite.dart';

class AppWriteProvider {
  // AppWrite provider implementation
  Client client = Client();
  AppWriteProvider() {
    client
        .setEndpoint('https://cloud.appwrite.io/v1') // Your Appwrite endpoint
        .setProject('67f46dc9003a5cdc675f');
  }
}