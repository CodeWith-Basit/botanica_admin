import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/admin_login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  // Ensure Flutter engine bindings are initialized before calling native Firebase plugins
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase with the configured project options
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization notice: $e');
  }

  runApp(const BotanicaAdminApp());
}

class BotanicaAdminApp extends StatelessWidget {
  const BotanicaAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Botanica Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Automatically check authentication state:
      // If signed in -> DashboardScreen, otherwise -> AdminLoginScreen
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return const DashboardScreen();
          }
          return const AdminLoginScreen();
        },
      ),
    );
  }
}
