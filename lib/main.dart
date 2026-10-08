import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'screens/admin_login_screen.dart';
import 'screens/dashboard_screen.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32), // Emerald forest green
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFF388E3C),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF1B5E20),
        ),
        scaffoldBackgroundColor: const Color(0xFFF9FBF9),
      ),
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
