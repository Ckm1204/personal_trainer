// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:personal_trainer/domain/data/datasources/provider/app_write_provider.dart';
import 'package:personal_trainer/domain/data/datasources/remote_data_source.dart';
import 'package:personal_trainer/domain/domain/usecases/all_methods_user_usecase.dart';
import 'package:personal_trainer/domain/repositories/auth_repository_impl.dart';
import 'package:personal_trainer/domain/domain/usecases/login_usecase.dart';
import 'package:personal_trainer/domain/domain/usecases/register_usecase.dart';
import 'package:personal_trainer/modules/presentation/auth_controller.dart';

import 'domain/core/services/auth_service.dart';
import 'domain/core/storage/storage_manager.dart';
import 'modules/exercise/widgets/exercise_storage_service.dart';
import 'modules/home/pages/home_page.dart';
import 'modules/presentation/pages/login_page.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa los servicios
  final appWriteProvider = AppWriteProvider();
  Get.put(appWriteProvider);

  final remoteDataSource = RemoteDataSource(appWriteProvider.client);
  final authRepository = AuthRepositoryImpl(remoteDataSource);

  Get.put(RegisterUseCase(authRepository));
  Get.put(AllMethodsUser(authRepository));
  Get.put(LoginUseCase(authRepository));
  Get.put(AuthController());



  // Inicializa y espera el AuthService
  await Get.putAsync(() => AuthService().init());
  // Inicial el ExerciseStorageService
  await StorageManager().initializeStorage();

  // Initialize your services
  final exerciseStorageService = ExerciseStorageService();
  await exerciseStorageService.init();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Personal Trainer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends GetWidget<AuthService> {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isAuthenticated.value
      ? const HomePage()
      : const LoginPage()
    );
  }
}