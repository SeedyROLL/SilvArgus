import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/app_state.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await DatabaseService().database;
  await NotificationService().init();

  // Check onboarding status
  final prefs = await SharedPreferences.getInstance();
  final bool hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: SilvArgusApp(hasSeenOnboarding: hasSeenOnboarding),
    ),
  );
}

class SilvArgusApp extends StatelessWidget {
  final bool hasSeenOnboarding;
  const SilvArgusApp({super.key, required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SilvArgus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          primary: const Color(0xFF2E7D32), // UI Primary: Deep Green
          secondary: const Color(0xFF81C784), // Secondary: Light Green
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F8E9), // Agro-Modern Base Background
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: const Color(0xFF2E7D32),
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: hasSeenOnboarding ? const HomeScreen() : const OnboardingScreen(),
    );
  }
}

