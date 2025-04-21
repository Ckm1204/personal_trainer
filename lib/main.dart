// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_trainer/utils/data/datasources/provider/app_write_provider.dart';
import 'package:personal_trainer/utils/data/datasources/remote_data_source.dart';
import 'package:personal_trainer/utils/repositories/auth_repository_impl.dart';
import 'package:personal_trainer/utils/domain/usecases/login_usecase.dart';
import 'package:personal_trainer/utils/domain/usecases/register_usecase.dart';

import 'modules/presentation/auth_controller.dart';
import 'modules/presentation/pages/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Add this line
  final appWriteProvider = AppWriteProvider();
  final remoteDataSource = RemoteDataSource(appWriteProvider.client);
  final authRepository = AuthRepositoryImpl(remoteDataSource);

  Get.put(RegisterUseCase(authRepository));
  Get.put(LoginUseCase(authRepository));
  Get.put(AuthController());

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
      home: const LoginPage(),
    );
  }
}
