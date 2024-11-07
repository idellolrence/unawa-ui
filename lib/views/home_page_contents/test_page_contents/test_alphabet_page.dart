import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';
import '../../../utils/constants.dart';
import '../../home_page_options/home_page.dart';
import '../test_page.dart';
import 'test_completion_page.dart';

class TestAlphabetPage extends StatefulWidget {
  const TestAlphabetPage({super.key});

  @override
  _TestAlphabetPageState createState() => _TestAlphabetPageState();
}

class _TestAlphabetPageState extends State<TestAlphabetPage> {
  int currentIndex = 0;
  int correctAnswers = 0;
  List<QuizQuestion> quizQuestions = [];

  @override
  void initState() {
    super.initState();
    fetchQuizQuestions();
  }

  void fetchQuizQuestions() {
    const String baseUrl =
        'https://firebasestorage.googleapis.com/v0/b/unawa-43922.appspot.com/o/alphabet%2F';
    const String token = '77f11ae4-cfe8-4726-810f-1f8780db2e77';

    for (int i = 0; i < 26; i++) {
      String letter = String.fromCharCode(65 + i); // A-Z
      String filename = 'card_${String.fromCharCode(97 + i)}.png';
      String imageUrl = '$baseUrl$filename?alt=media&token=$token';

      List<String> choices = [
        letter,
        String.fromCharCode(65 + ((i + 1) % 26)), // Random other letters
        String.fromCharCode(65 + ((i + 2) % 26)),
        String.fromCharCode(65 + ((i + 3) % 26))
      ]..shuffle();

      quizQuestions.add(
        QuizQuestion(
          imageUrl: imageUrl,
          question: 'Which letter is this?',
          choices: choices,
          correctAnswer: letter,
        ),
      );
    }
    setState(() {});
  }

  void _showCompletionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestCompletionPage(
          onRelearn: _relearn,
          onTest: _test,
          onHome: _goHome,
          correctAnswers: correctAnswers,
          totalQuestions: quizQuestions.length,
        ),
      ),
    );
  }

  void _relearn() {
    setState(() {
      currentIndex = 0;
      correctAnswers = 0;
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Correct!' : 'Incorrect, try again!'),
        duration: const Duration(seconds: 1),
      ),
    );

    if (isCorrect) {
      correctAnswers++;
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

    // Get device width and height for responsive design
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alphabet Quiz'),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.black : AppTheme.mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05), // Responsive padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              quizQuestion.imageUrl,
              height: height * 0.3, // Responsive image height
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              quizQuestion.question,
              style: TextStyle(
                fontSize: width * 0.06, // Responsive text size
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            // Display choices in a 2x2 grid with responsive button sizes
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: quizQuestion.choices.map((choice) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                        width * 0.4, height * 0.08), // Responsive button size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () => _checkAnswer(choice),
                  child: Text(
                    choice,
                    style: TextStyle(
                        fontSize: width * 0.04), // Responsive text size
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
              style: TextStyle(
                fontSize: width * 0.05, // Responsive text size
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
import '../../../main.dart';
import '../../../utils/constants.dart';
import '../../home_page_options/home_page.dart';
import '../test_page.dart';
import 'test_completion_page.dart';

class TestAlphabetPage extends StatefulWidget {
  const TestAlphabetPage({super.key});

  @override
  _TestAlphabetPageState createState() => _TestAlphabetPageState();
}

class _TestAlphabetPageState extends State<TestAlphabetPage> {
  int currentIndex = 0;
  int correctAnswers = 0; // New variable to track correct answers
  List<QuizQuestion> quizQuestions = [];

  @override
  void initState() {
    super.initState();
    fetchQuizQuestions();
  }

  // Function to generate quiz questions for each alphabet
  void fetchQuizQuestions() {
    const String baseUrl =
        'https://firebasestorage.googleapis.com/v0/b/unawa-43922.appspot.com/o/alphabet%2F';
    const String token = '77f11ae4-cfe8-4726-810f-1f8780db2e77';

    for (int i = 0; i < 26; i++) {
      String letter = String.fromCharCode(65 + i); // A-Z
      String filename = 'card_${String.fromCharCode(97 + i)}.png';
      String imageUrl = '$baseUrl$filename?alt=media&token=$token';

      List<String> choices = [
        letter,
        String.fromCharCode(65 + ((i + 1) % 26)), // Random other letters
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
          correctAnswers: correctAnswers, // Pass correct answers count
          totalQuestions: quizQuestions.length, // Pass total questions
        ),
      ),
    );
  }

  void _relearn() {
    setState(() {
      currentIndex = 0; // Reset index
      correctAnswers = 0; // Reset correct answers count
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Correct!' : 'Incorrect, try again!'),
        duration: const Duration(seconds: 1),
      ),
    );

    if (isCorrect) {
      correctAnswers++; // Increment correct answer count
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
        title: const Text('Alphabet Quiz'),
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
              style: TextStyle(
                  fontSize: 24,
                  color: isDarkMode ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 20),
            // Display choices in a randomized 2x2 grid with square buttons
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: quizQuestion.choices.map((choice) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Make button square
                    ),
                  ),
                  onPressed: () => _checkAnswer(choice),
                  child: Text(
                    choice,
                    style: const TextStyle(fontSize: 16),
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
              style: TextStyle(
                  fontSize: 20,
                  color: isDarkMode ? Colors.white : Colors.black),
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