import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../../../main.dart';
import '../../../utils/constants.dart';
import '../../home_page_options/home_page.dart';
import '../test_page.dart';
import 'test_completion_page.dart';

class TestAllPage extends StatefulWidget {
  const TestAllPage({super.key});

  @override
  _TestAllPageState createState() => _TestAllPageState();
}

class _TestAllPageState extends State<TestAllPage> {
  int currentIndex = 0;
  int correctAnswers = 0; // Track correct answers
  List<QuizQuestion> quizQuestions = [];

  @override
  void initState() {
    super.initState();
    fetchQuizQuestions();
  }

  // Function to fetch quiz questions for alphabets and phrases
  void fetchQuizQuestions() {
    final String baseAlphabetUrl =
        'https://firebasestorage.googleapis.com/v0/b/unawa-43922.appspot.com/o/alphabet%2F';
    final String alphabetToken = '77f11ae4-cfe8-4726-810f-1f8780db2e77';

    final String basePhraseUrl =
        'https://firebasestorage.googleapis.com/v0/b/unawa-43922.appspot.com/o/phrases%2F';
    final String phraseToken = '60675598-8e4d-4911-a931-be3e8a5cd3eb';

    // Generate questions for alphabets
    for (int i = 0; i < 26; i++) {
      String letter = String.fromCharCode(65 + i); // A-Z
      String filename = 'card_${String.fromCharCode(97 + i)}.png';
      String imageUrl =
          '$baseAlphabetUrl$filename?alt=media&token=$alphabetToken';

      List<String> choices = [
        letter,
        String.fromCharCode(65 + ((i + 1) % 26)),
        String.fromCharCode(65 + ((i + 2) % 26)),
        String.fromCharCode(65 + ((i + 3) % 26))
      ]..shuffle(); // Shuffle to randomize positions

      quizQuestions.add(
        QuizQuestion(
          imageUrl: imageUrl,
          question: 'Which letter is this?',
          choices: choices,
          correctAnswer: letter,
        ),
      );
    }

    // Generate questions for phrases
    List<String> phraseFilenames = [
      'card_kumusta.png',
      'card_mahal_kita.png',
      'card_okay.png',
      'card_salamat.png',
    ];

    List<List<String>> phraseChoices = [
      ['Kumusta', 'Magandang Araw', 'Salamat', 'Mahal Kita'],
      ['Salamat', 'Mahal Kita', 'Paalam', 'Walang Anuman'],
      ['Okay', 'Hindi Okay', 'Sige', 'Bakit'],
      ['Salamat', 'Kumusta', 'Tama', 'Mali'],
    ];

    List<String> correctPhraseAnswers = [
      'Kumusta',
      'Salamat',
      'Okay',
      'Salamat'
    ];

    for (int i = 0; i < phraseFilenames.length; i++) {
      String imageUrl =
          '$basePhraseUrl${phraseFilenames[i]}?alt=media&token=$phraseToken';

      phraseChoices[i].shuffle(Random()); // Shuffle choices for phrases

      quizQuestions.add(
        QuizQuestion(
          imageUrl: imageUrl,
          question: 'What does this phrase mean?',
          choices: phraseChoices[i],
          correctAnswer: correctPhraseAnswers[i],
        ),
      );
    }

    // Shuffle all questions to randomize order
    quizQuestions.shuffle();

    setState(() {}); // Update the UI after adding questions
  }

  void _showCompletionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestCompletionPage(
          onRelearn: _relearn,
          onTest: _test,
          onHome: _goHome,
          correctAnswers: correctAnswers, // Pass correct answers
          totalQuestions: quizQuestions.length, // Pass total questions
        ),
      ),
    );
  }

  void _relearn() {
    setState(() {
      currentIndex = 0; // Reset index
      correctAnswers = 0; // Reset score
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

  void _checkAnswer(String selectedAnswer) {
    final isCorrect =
        quizQuestions[currentIndex].correctAnswer == selectedAnswer;
    if (isCorrect) {
      correctAnswers++; // Increment correct answers
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Correct!' : 'Incorrect, try again!'),
        duration: const Duration(seconds: 1),
      ),
    );

    if (isCorrect) {
      setState(() {
        if (currentIndex < quizQuestions.length - 1) {
          currentIndex++;
        } else {
          _showCompletionPage();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.currentThemeString == 'Dark';

    if (quizQuestions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final quizQuestion = quizQuestions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz All'),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.black : AppTheme.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Image.network(
                quizQuestion.imageUrl,
                key: ValueKey<int>(currentIndex),
                height:
                    MediaQuery.of(context).size.height * 0.3, // Dynamic height
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              quizQuestion.question,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width *
                    0.06, // Responsive font size
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Display choices in a responsive 2x2 grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 4, // Spacing between buttons
                mainAxisSpacing: 4, // Spacing between buttons
                children: quizQuestion.choices.map((choice) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal:
                              15), // Adjusted padding for similar button size
                      minimumSize: const Size(120,
                          50), // Set minimum size for buttons (width, height)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5), // Consistent border radius
                      ),
                    ),
                    onPressed: () => _checkAnswer(choice),
                    child: Text(
                      choice,
                      style: const TextStyle(
                          fontSize:
                              16), // Keep the font size consistent (adjust if needed)
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: (currentIndex + 1) / quizQuestions.length,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 10),
            Text(
              '${currentIndex + 1}/${quizQuestions.length}',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width *
                    0.05, // Responsive font size
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizQuestion {
  final String imageUrl;
  final String question;
  final List<String> choices;
  final String correctAnswer;

  QuizQuestion({
    required this.imageUrl,
    required this.question,
    required this.choices,
    required this.correctAnswer,
  });
}


/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:unawa_home_page/utils/constants.dart';
import 'package:unawa_home_page/views/home_page_contents/test_page.dart';
import 'package:unawa_home_page/views/home_page_options/home_page.dart';
import 'package:unawa_home_page/main.dart';
import 'package:unawa_home_page/views/home_page_contents/test_page_contents/test_completion_page.dart';

class TestAllPage extends StatefulWidget {
  const TestAllPage({super.key});

  @override
  _TestAllPageState createState() => _TestAllPageState();
}

class _TestAllPageState extends State<TestAllPage> {
  int currentIndex = 0;
  int correctAnswers = 0; // Track correct answers
  List<QuizQuestion> quizQuestions = [];

  @override
  void initState() {
    super.initState();
    fetchQuizQuestions();
  }

  // Function to fetch quiz questions for alphabets and phrases
  void fetchQuizQuestions() {
    final String baseAlphabetUrl = 'https://firebasestorage.googleapis.com/v0/b/unawa-43922.appspot.com/o/alphabet%2F';
    final String alphabetToken = '77f11ae4-cfe8-4726-810f-1f8780db2e77';

    final String basePhraseUrl = 'https://firebasestorage.googleapis.com/v0/b/unawa-43922.appspot.com/o/phrases%2F';
    final String phraseToken = '60675598-8e4d-4911-a931-be3e8a5cd3eb';

    // Generate questions for alphabets
    for (int i = 0; i < 26; i++) {
      String letter = String.fromCharCode(65 + i); // A-Z
      String filename = 'card_${String.fromCharCode(97 + i)}.png';
      String imageUrl = '$baseAlphabetUrl$filename?alt=media&token=$alphabetToken';

      List<String> choices = [
        letter,
        String.fromCharCode(65 + ((i + 1) % 26)),
        String.fromCharCode(65 + ((i + 2) % 26)),
        String.fromCharCode(65 + ((i + 3) % 26))
      ]..shuffle(); // Shuffle to randomize positions

      quizQuestions.add(
        QuizQuestion(
          imageUrl: imageUrl,
          question: 'Which letter is this?',
          choices: choices,
          correctAnswer: letter,
        ),
      );
    }

    // Generate questions for phrases
    List<String> phraseFilenames = [
      'card_kumusta.png',
      'card_mahal_kita.png',
      'card_okay.png',
      'card_salamat.png',
    ];

    List<List<String>> phraseChoices = [
      ['Kumusta', 'Magandang Araw', 'Salamat', 'Mahal Kita'],
      ['Salamat', 'Mahal Kita', 'Paalam', 'Walang Anuman'],
      ['Okay', 'Hindi Okay', 'Sige', 'Bakit'],
      ['Salamat', 'Kumusta', 'Tama', 'Mali'],
    ];

    List<String> correctPhraseAnswers = ['Kumusta', 'Salamat', 'Okay', 'Salamat'];

    for (int i = 0; i < phraseFilenames.length; i++) {
      String imageUrl = '$basePhraseUrl${phraseFilenames[i]}?alt=media&token=$phraseToken';

      phraseChoices[i].shuffle(Random()); // Shuffle choices for phrases

      quizQuestions.add(
        QuizQuestion(
          imageUrl: imageUrl,
          question: 'What does this phrase mean?',
          choices: phraseChoices[i],
          correctAnswer: correctPhraseAnswers[i],
        ),
      );
    }

    // Shuffle all questions to randomize order
    quizQuestions.shuffle();

    setState(() {}); // Update the UI after adding questions
  }

  void _showCompletionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestCompletionPage(
          onRelearn: _relearn,
          onTest: _test,
          onHome: _goHome,
          correctAnswers: correctAnswers, // Pass correct answers
          totalQuestions: quizQuestions.length, // Pass total questions
        ),
      ),
    );
  }

  void _relearn() {
    setState(() {
      currentIndex = 0; // Reset index
      correctAnswers = 0; // Reset score
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

  void _checkAnswer(String selectedAnswer) {
    final isCorrect = quizQuestions[currentIndex].correctAnswer == selectedAnswer;
    if (isCorrect) {
      correctAnswers++; // Increment correct answers
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Correct!' : 'Incorrect, try again!'),
        duration: const Duration(seconds: 1),
      ),
    );

    if (isCorrect) {
      setState(() {
        if (currentIndex < quizQuestions.length - 1) {
          currentIndex++;
        } else {
          _showCompletionPage();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.currentThemeString == 'Dark';

    if (quizQuestions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final quizQuestion = quizQuestions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz All'),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.black : AppTheme.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              quizQuestion.imageUrl,
              height: 250, // Larger card image
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              quizQuestion.question,
              style: TextStyle(fontSize: 24, color: isDarkMode ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 20),
            // Display choices in a randomized 2x2 grid with square buttons
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: quizQuestion.choices.map((choice) {
                return SizedBox(
                  height: 20, // Button height
                  width: 20,  // Button width
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Make button square
                      ),
                    ),
                    onPressed: () => _checkAnswer(choice),
                    child: Text(
                      choice,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: (currentIndex + 1) / quizQuestions.length,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 10),
            Text(
              '${currentIndex + 1}/${quizQuestions.length}',
              style: TextStyle(fontSize: 20, color: isDarkMode ? Colors.white : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizQuestion {
  final String imageUrl;
  final String question;
  final List<String> choices;
  final String correctAnswer;

  QuizQuestion({
    required this.imageUrl,
    required this.question,
    required this.choices,
    required this.correctAnswer,
  });
}
*/