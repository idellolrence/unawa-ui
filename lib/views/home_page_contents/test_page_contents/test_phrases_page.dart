import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../../main.dart';
import '../../../utils/constants.dart';
import '../../../utils/unawa_card.dart';
import '../../home_page_options/home_page.dart';
import '../test_page.dart';
import 'test_completion_page.dart';

class TestPhrasesPage extends StatefulWidget {
  const TestPhrasesPage({super.key});

  @override
  _TestPhrasesPageState createState() => _TestPhrasesPageState();
}

class _TestPhrasesPageState extends State<TestPhrasesPage> {
  int currentIndex = 0;
  List<String> imageUrls = [];
  List<List<String>> choices = [];
  List<String> correctAnswers = [];
  int correctAnswerCount = 0; // Counter for correct answers

  // Firebase Storage base URL
  final String baseUrl =
      'https://firebasestorage.googleapis.com/v0/b/unawa-43922.appspot.com/o/phrases%2F';
  final String token =
      '60675598-8e4d-4911-a931-be3e8a5cd3eb'; // Replace with your actual token

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
    generateChoices(); // Generate choices for the quiz
  }

  // Function to generate all image URLs for phrases
  void fetchImageUrls() {
    List<String> filenames = [
      'card_kumusta.png',
      'card_mahal_kita.png',
      'card_okay.png',
      'card_salamat.png',
    ];

    imageUrls = filenames
        .map((filename) => '$baseUrl$filename?alt=media&token=$token')
        .toList();
    setState(() {}); // Update the UI after adding URLs
  }

  // Function to generate choices and correct answers
  void generateChoices() {
    List<List<String>> tempChoices = [
      [
        'Kumusta',
        'Magandang Araw',
        'Salamat',
        'Mahal Kita'
      ], // Choices for first image
      [
        'Salamat',
        'Mahal Kita',
        'Paalam',
        'Walang Anuman'
      ], // Choices for second image
      ['Okay', 'Hindi Okay', 'Sige', 'Bakit'], // Choices for third image
      ['Salamat', 'Kumusta', 'Tama', 'Mali'], // Choices for fourth image
    ];

    correctAnswers = [
      'Kumusta',
      'Mahal Kita',
      'Okay',
      'Salamat'
    ]; // Correct answers corresponding to each question

    for (var choiceSet in tempChoices) {
      choiceSet.shuffle(Random());
      choices.add(choiceSet);
    }
  }

  void _onChoiceSelected(String selectedAnswer) {
    // Check if the selected answer is correct
    if (selectedAnswer == correctAnswers[currentIndex]) {
      // Handle correct answer
      correctAnswerCount++; // Increment the correct answer count
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Correct!'),
          duration: const Duration(seconds: 1),
        ),
      );

      // Move to the next question
      if (currentIndex < imageUrls.length - 1) {
        setState(() {
          currentIndex++;
        });
      } else {
        _showCompletionPage();
      }
    } else {
      // Handle incorrect answer
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Incorrect! Please try again.'),
        duration: const Duration(seconds: 1),
      ));
      // Do not move to the next question
    }
  }

  void _showCompletionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestCompletionPage(
          onRelearn: _relearn,
          onTest: _test,
          onHome: _goHome,
          correctAnswers: correctAnswerCount, // Pass the correct answers count
          totalQuestions:
              imageUrls.length, // Pass the total number of questions
        ),
      ),
    );
  }

  void _relearn() {
    setState(() {
      currentIndex = 0; // Reset index
      correctAnswerCount = 0; // Reset correct answer count
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
          'Phrases Test',
          style: TextStyle(
            color: AppTheme.textColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.black : AppTheme.mainColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (imageUrls.isEmpty || choices.isEmpty) {
            return Center(
                child: CircularProgressIndicator()); // Loading indicator
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display the image card
                SizedBox(
                  height: constraints.maxHeight *
                      0.5, // Increased height for the card
                  width: constraints.maxWidth *
                      0.8, // Increased width for the card
                  child: UnawaCard(
                    imagePath: imageUrls[currentIndex],
                    onSwipeRight: () {}, // Implement if necessary
                    onSwipeLeft: () {}, // Implement if necessary
                  ),
                ),
                const SizedBox(height: 20),

                // Display the choices in a 2x2 grid layout
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                    mainAxisSpacing: 20, // Vertical spacing between buttons
                    crossAxisSpacing: 20, // Horizontal spacing between buttons
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: choices[currentIndex].length,
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      onPressed: () =>
                          _onChoiceSelected(choices[currentIndex][index]),
                      child: Text(choices[currentIndex][index]),
                    );
                  },
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
