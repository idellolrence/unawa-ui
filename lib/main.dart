import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_up/firebase_options.dart';
import 'utils/constants.dart'; // Import your app_theme.dart
import 'splashscreen_page.dart'; // Import the splash screen page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class ThemeProvider with ChangeNotifier {
  String _currentThemeString = 'Light'; // Default theme selection

  String get currentThemeString => _currentThemeString;

  void setTheme(String theme) {
    _currentThemeString = theme;
    notifyListeners();
  }

  ThemeData get currentTheme {
    // Create the theme with Poppins font
    final textTheme = GoogleFonts.poppinsTextTheme();

    switch (_currentThemeString) {
      case 'Dark':
        return AppTheme.darkTheme.copyWith(textTheme: textTheme);
      case 'Light':
        return AppTheme.lightTheme.copyWith(textTheme: textTheme);
      default:
        return WidgetsBinding.instance.window.platformBrightness == Brightness.dark
            ? AppTheme.darkTheme.copyWith(textTheme: textTheme)
            : AppTheme.lightTheme.copyWith(textTheme: textTheme);
    }
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
            home: const SplashScreenPage(), // Set the splash screen as the home
          );
        },
      ),
    );
  }
}



/*
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sign_up/firebase_options.dart';
import 'package:sign_up/authentication/auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
*/