import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_up/views/home_page_contents/test_page_contents/test_phrases_page.dart';

import '../../main.dart';
import '../../utils/constants.dart';
import '../home_page_options/home_page.dart';
import 'test_page_contents/test_all_page.dart';
import 'test_page_contents/test_alphabet_page.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current theme from the provider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.currentThemeString == 'Dark';

    return WillPopScope(
      onWillPop: () async {
        // Navigate back to HomePage when the back button is pressed
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
          (route) => false,
        );
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Test',
            style: TextStyle(
              color: AppTheme.textColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: isDarkMode ? Colors.black : AppTheme.mainColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildLearnOption(
                  context,
                  image: 'assets/Buttons Images/Test/test_letters_button.png',
                  title: 'Test Alphabet',
                  description:
                      'Test your knowledge of the alphabet in sign language',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TestAlphabetPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildLearnOption(
                  context,
                  image: 'assets/Buttons Images/Test/test_phrases_button.png',
                  title: 'Test Phrases',
                  description: 'Test common phrases in sign language',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TestPhrasesPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildLearnOption(
                  context,
                  image: 'assets/Buttons Images/Test/test_all_button.png',
                  title: 'Test All',
                  description: 'Test all signs in sign language',
                  onTap: () {
                    // Navigate to the page for "Test All"
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const TestAllPage(), // Adjust if needed
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        backgroundColor:
            isDarkMode ? AppTheme.cardColor : AppTheme.lightBackgroundColor,
      ),
    );
  }

  Widget _buildLearnOption(
    BuildContext context, {
    required String image,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.currentThemeString == 'Dark';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: AppTheme.cardDecoration.copyWith(
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.asset(
                image,
                width: double.infinity,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
