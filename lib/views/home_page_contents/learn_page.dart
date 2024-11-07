import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../utils/constants.dart';
import 'learn_page_contents/alphabet_page.dart';
import 'learn_page_contents/phrases_page.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.currentThemeString == 'Dark';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learn',
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
                image: 'assets/Buttons Images/Learn/letters_button.png',
                title: 'Alphabet',
                description: 'Learn the alphabet in sign language',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AlphabetPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildLearnOption(
                context,
                image: 'assets/Buttons Images/Learn/phrases_button.png',
                title: 'Phrases',
                description: 'Learn common phrases in sign language',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PhrasesPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: isDarkMode ? AppTheme.cardColor : AppTheme.lightBackgroundColor,
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
