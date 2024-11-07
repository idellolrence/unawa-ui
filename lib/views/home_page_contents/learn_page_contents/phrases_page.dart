import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../utils/constants.dart';
import '../../../utils/unawa_card.dart';
import '../../home_page_options/home_page.dart';
import '../test_page.dart';
import 'phrases_page_contents/completion_page.dart';

class PhrasesPage extends StatefulWidget {
  const PhrasesPage({super.key});

  @override
  _PhrasesPageState createState() => _PhrasesPageState();
}

class _PhrasesPageState extends State<PhrasesPage> {
  int currentIndex = 0;
  List<String> imageUrls = [];
  
  // Firebase Storage base URL
  final String baseUrl = 'https://firebasestorage.googleapis.com/v0/b/unawa-43922.appspot.com/o/phrases%2F';
  final String token = '60675598-8e4d-4911-a931-be3e8a5cd3eb'; // Replace with your actual token

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
  }

  // Function to generate all image URLs for phrases (add as many phrases as needed)
  void fetchImageUrls() {
    List<String> filenames = [
      'card_kumusta.png',
      'card_mahal_kita.png',
      'card_okay.png',
      'card_salamat.png',
    ];

    imageUrls = filenames.map((filename) => '$baseUrl$filename?alt=media&token=$token').toList();
    setState(() {}); // Update the UI after adding URLs
  }

  void _onSwipeRight() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      }
    });
  }

  void _onSwipeLeft() {
    setState(() {
      if (currentIndex < imageUrls.length - 1) {
        currentIndex++;
      } else {
        _showCompletionPage();
      }
    });
  }

  void _showCompletionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompletionPage(
          onRelearn: _relearn,
          onTest: _test,
          onHome: _goHome,
        ),
      ),
    );
  }

  void _relearn() {
    setState(() {
      currentIndex = 0; // Reset index
    });
    Navigator.pop(context);
  }

  void _test() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TestPage()),
    );
  }

  void _goHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.currentThemeString == 'Dark';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Phrases',
          style: TextStyle(
            color: AppTheme.textColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.black : AppTheme.mainColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double cardHeight = constraints.maxHeight * 0.5;
          double cardWidth = constraints.maxWidth * 0.6;

          if (imageUrls.isEmpty) {
            return Center(child: CircularProgressIndicator()); // Loading indicator
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.05),
                  height: cardHeight,
                  width: cardWidth,
                  child: Stack(
                    alignment: Alignment.center,
                    children: imageUrls.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String imagePath = entry.value;
                      return Positioned.fill(
                        child: Visibility(
                          visible: idx == currentIndex,
                          child: UnawaCard(
                            imagePath: imagePath,
                            onSwipeRight: _onSwipeRight,
                            onSwipeLeft: _onSwipeLeft,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: (currentIndex + 1) / imageUrls.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 10),
                Text(
                  '${currentIndex + 1}/${imageUrls.length}',
                  style: TextStyle(
                    fontSize: 20,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
