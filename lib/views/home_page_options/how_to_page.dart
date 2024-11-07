import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../utils/constants.dart';
import 'home_page.dart';

class HowToPage extends StatefulWidget {
  const HowToPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HowToPageState createState() => _HowToPageState();
}

class _HowToPageState extends State<HowToPage> {
  int currentIndex = 0;

  final List<Map<String, String>> steps = [
    {
      'title': 'Learn',
      'description':
          'Dive into our engaging graphical card sets designed to help you master the fundamentals of FSL. Each card offers bite-sized lessons to enhance your confidence and retention.',
      'image': 'assets/How To/tutorial_learn.png',
    },
    {
      'title': 'Test',
      'description':
          'Put your knowledge to the test with Unawa’s innovative camera feature. Capture real-world scenarios and evaluate your practical skills, ensuring you\'re ready to communicate effectively.',
      'image': 'assets/How To/tutorial_test.png',
    },
    {
      'title': 'Achieve',
      'description':
          'Celebrate your learning journey by unlocking achievements as you progress! Track your milestones and see how far you\'ve come in mastering FSL, motivating you to continue your learning adventure.',
      'image': 'assets/How To/tutorial_achievements.png',
    },
  ];

  void _showCompletionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
  }

  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        steps.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: index == currentIndex ? 14.0 : 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            color: index == currentIndex ? AppTheme.mainColor : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.currentThemeString == 'Dark';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'How To',
          style: TextStyle(
            color: AppTheme.textColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.black : AppTheme.mainColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: constraints.maxHeight * 0.05),
                    child: PageView.builder(
                      itemCount: steps.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        Map<String, String> step = steps[index];
                        return HowToCard(
                          title: step['title']!,
                          description: step['description']!,
                          imagePath: step['image']!,
                          isDarkMode: isDarkMode,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildDotIndicator(),
                const SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }
}

class HowToCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final bool isDarkMode;

  const HowToCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double imageHeight = constraints.maxHeight * 0.6;
          double imageWidth = constraints.maxWidth * 0.7;

          return SingleChildScrollView(
            // Added to allow scrolling if content overflows
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: imageHeight,
                  width: imageWidth,
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 34,
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
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



/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../utils/constants.dart';
import 'home_page.dart';

class HowToPage extends StatefulWidget {
  const HowToPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HowToPageState createState() => _HowToPageState();
}

class _HowToPageState extends State<HowToPage> {
  int currentIndex = 0;

  final List<Map<String, String>> steps = [
    {
      'title': 'Learn',
      'description':
          'Dive into our engaging graphical card sets designed to help you master the fundamentals of FSL. Each card offers bite-sized lessons to enhance your confidence and retention.',
      'image': 'assets/How To/tutorial_learn.png',
    },
    {
      'title': 'Test',
      'description':
          'Put your knowledge to the test with Unawa’s innovative camera feature. Capture real-world scenarios and evaluate your practical skills, ensuring you\'re ready to communicate effectively.',
      'image': 'assets/How To/tutorial_test.png',
    },
    {
      'title': 'Achieve',
      'description':
          'Celebrate your learning journey by unlocking achievements as you progress! Track your milestones and see how far you\'ve come in mastering FSL, motivating you to continue your learning adventure.',
      'image': 'assets/How To/tutorial_achievements.png',
    },
  ];

  void _onSwipeRight() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--; // Move to previous step
      }
    });
  }

  void _onSwipeLeft() {
    setState(() {
      if (currentIndex < steps.length - 1) {
        currentIndex++; // Move to next step
      } else {
        _showCompletionPage(); // Show completion page on the last step
      }
    });
  }

  void _showCompletionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
  }

  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        steps.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: index == currentIndex ? 14.0 : 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            color: index == currentIndex ? AppTheme.mainColor : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.currentThemeString == 'Dark';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'How To',
          style: TextStyle(
            color: AppTheme.textColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.black : AppTheme.mainColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: constraints.maxHeight * 0.05),
                    child: Stack(
                      alignment: Alignment.center,
                      children: steps.asMap().entries.map((entry) {
                        int idx = entry.key;
                        Map<String, String> step = entry.value;
                        return Positioned.fill(
                          child: Visibility(
                            visible: idx == currentIndex,
                            child: HowToCard(
                              title: step['title']!,
                              description: step['description']!,
                              imagePath: step['image']!,
                              onSwipeRight:
                                  currentIndex > 0 ? _onSwipeRight : null,
                              onSwipeLeft: currentIndex < steps.length - 1
                                  ? _onSwipeLeft
                                  : null,
                              isDarkMode: isDarkMode,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Space above the dot indicator
                _buildDotIndicator(),
                const SizedBox(
                    height: 50), // Increased space below the dot indicator
              ],
            ),
          );
        },
      ),
    );
  }
}

// Define a custom swipeable card widget similar to UnawaCard for HowToPage
class HowToCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeLeft;
  final bool isDarkMode;

  const HowToCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.onSwipeRight,
    this.onSwipeLeft,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! > 0 && onSwipeRight != null) {
            onSwipeRight!(); // Swipe Right
          } else if (details.primaryVelocity! < 0 && onSwipeLeft != null) {
            onSwipeLeft!(); // Swipe Left
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Set image size relative to the parent container's constraints
            double imageHeight = constraints.maxHeight *
                0.6; // Adjust height for upward positioning
            double imageWidth = constraints.maxWidth * 0.7;

            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment:
                  MainAxisAlignment.start, // Align items to the start (top)
              children: [
                // Centered, responsive image
                Container(
                  height: imageHeight,
                  width: imageWidth,
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(
                    height: 30), // Adjusted spacing between image and title
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 34,
                    color: isDarkMode
                        ? Colors.white
                        : Colors.black, // Dark mode text color
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10), // Reduced spacing
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: isDarkMode
                          ? Colors.white70
                          : Colors.black54, // Dark mode text color
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
*/