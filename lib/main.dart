import 'package:dufil/config/routes/app_routes.dart';
import 'package:dufil/data/providers/auth_provider.dart' as auth_provider;
import 'package:dufil/data/providers/task_provider.dart';
import 'package:dufil/data/repos/auth_repo.dart';
import 'package:dufil/data/repos/task_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => auth_provider.AuthProvider(AuthRepository()),
    ),
    ChangeNotifierProvider(
      create: (_) => TaskProvider(
        TaskRepository(userId: FirebaseAuth.instance.currentUser?.uid ?? ''),
      ),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.login,
      routes: AppRoutes.getRoutes(),
    );
  }
}
