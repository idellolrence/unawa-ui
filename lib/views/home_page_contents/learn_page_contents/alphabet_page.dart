import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../utils/constants.dart';
import '../../../utils/unawa_card.dart';
import '../../home_page_options/home_page.dart';
import '../test_page.dart';
import 'phrases_page_contents/completion_page.dart';

class AlphabetPage extends StatefulWidget {
  const AlphabetPage({super.key});

  @override
  _AlphabetPageState createState() => _AlphabetPageState();
}

class _AlphabetPageState extends State<AlphabetPage> {
  int currentIndex = 0;
  List<String> imageUrls = [];

  // Firebase Storage base URL
  final String baseUrl =
      'https://firebasestorage.googleapis.com/v0/b/unawa-43922.appspot.com/o/alphabet%2F';
  final String token =
      '310b22bc-873b-49cf-94a8-bd48a26294c7'; // Replace this with your actual token

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
  }

  // Function to generate all image URLs from card_a.png to card_z.png
  void fetchImageUrls() {
    for (int i = 0; i < 26; i++) {
      String filename = 'card_${String.fromCharCode(97 + i)}.png';
      String imageUrl = '$baseUrl$filename?alt=media&token=$token';
      imageUrls.add(imageUrl);
    }
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
          'Alphabet',
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
            return Center(
                child: CircularProgressIndicator()); // Loading indicator
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                      vertical: constraints.maxHeight * 0.05),
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
