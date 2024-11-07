import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../utils/constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.currentThemeString == 'Dark';

    // Screen dimensions for dynamic sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adjusted values for a much larger logo scaling
    final double fontSize = screenWidth * 0.04 > 18 ? 18 : screenWidth * 0.04;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.lightBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.05,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/Logos, Logo Marks, and Launcher Icon/logo_blue.png',
                  width: 400,
                ),
              ),
              const SizedBox(height: 14), // Decreased space below the logo
              Text(
                'About Unawa',
                style: TextStyle(
                  fontSize: fontSize + 4,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: fontSize,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    height: 1.5,
                  ),
                  children: const [
                    TextSpan(
                      text:
                          'Unawa is a Filipino Sign Language (FSL) learning app ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          'designed to make language learning fun and engaging through gamification. ',
                    ),
                    TextSpan(
                      text:
                          'Whether you’re a beginner or just looking to sharpen your skills, ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          'Unawa provides interactive tools that guide you step-by-step:',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBulletPoint(
                    'Graphical card sets to help you familiarize yourself with essential signs.',
                    fontSize,
                    isDarkMode,
                  ),
                  _buildBulletPoint(
                    'A unique camera feature to test your knowledge in real-world practice.',
                    fontSize,
                    isDarkMode,
                  ),
                  _buildBulletPoint(
                    'Machine learning technology that recognizes your sign gestures and provides real-time feedback.',
                    fontSize,
                    isDarkMode,
                  ),
                  _buildBulletPoint(
                    'Achievement tracking to celebrate milestones and monitor your progress.',
                    fontSize,
                    isDarkMode,
                  ),
                  _buildBulletPoint(
                    'Flexible learning pace, so you can grow your confidence gradually.',
                    fontSize,
                    isDarkMode,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Features',
                style: TextStyle(
                  fontSize: fontSize + 2,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(3),
                },
                border: TableBorder.all(
                  color: isDarkMode ? Colors.white54 : Colors.grey,
                  width: 1,
                ),
                children: [
                  _buildTableRow(
                    'Learning Mode',
                    'Step-by-step interactive card sets for beginners.',
                    fontSize,
                    isDarkMode,
                  ),
                  _buildTableRow(
                    'Practical Tests',
                    'Camera feature for real-time sign recognition and feedback.',
                    fontSize,
                    isDarkMode,
                  ),
                  _buildTableRow(
                    'Machine Learning',
                    'Integrated technology for accurate gesture recognition.',
                    fontSize,
                    isDarkMode,
                  ),
                  _buildTableRow(
                    'Achievement Tracking',
                    'Track your progress and celebrate milestones.',
                    fontSize,
                    isDarkMode,
                  ),
                  _buildTableRow(
                    'Customizable Pace',
                    'Progress at your own speed to build confidence.',
                    fontSize,
                    isDarkMode,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text, double fontSize, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• ",
            style: TextStyle(
              fontSize: fontSize,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: isDarkMode ? Colors.white70 : Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(
      String title, String description, double fontSize, bool isDarkMode) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            description,
            style: TextStyle(
              fontSize: fontSize,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}
