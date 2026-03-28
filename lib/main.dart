import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/database/database_instance.dart';
import 'package:to_do_list/pages/home_page.dart';
import 'package:to_do_list/pages/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isOnboardingShown = prefs.getBool('isOnboardingShown') ?? false;
  runApp(MyApp(isOnboardingShown: isOnboardingShown));
}

class MyApp extends StatefulWidget {
  final bool isOnboardingShown;
  const MyApp({super.key, required this.isOnboardingShown});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1E2F),
        cardColor: const Color(0xFF2A2A3D),
      ),
      themeMode: _themeMode,
      home: widget.isOnboardingShown
          ? MyHomePage(
              title: 'ToDo',
              onThemeToggle: _toggleTheme,
            )
          : OnboardingPage(onThemeToggle: _toggleTheme),
    );
  }
}