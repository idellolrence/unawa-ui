import 'package:flutter/material.dart';

class AchievementsPage extends StatefulWidget {
  AchievementsPage({super.key});

  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final List<List<String>> imageSets = [
    ['assets/beginner.png'],
    ['assets/firsttime.png'],
    ['assets/highfive.png'],
    ['assets/ben10.png'],
    ['assets/hero.png'],
    ['assets/Ace.png'],
    ['assets/phrase.png'],
    ['assets/fivevowels.png'],
    ['assets/ily.png'],
    ['assets/like.png'],
    ['assets/greetings.png'],
    ['assets/tyt.png'],
    ['assets/uuuuu.png'],
  ];

  final List<String> buttonIcons = [
    'assets/beginner_icon.png',
    'assets/first_icon.png',
    'assets/hi5_icon.png',
    'assets/ben10_icon.png',
    'assets/hero_icon.png',
    'assets/ace_icon.png',
    'assets/phrase_icon.png',
    'assets/fivevowels_icon.png',
    'assets/ily_icon.png',
    'assets/okay_icon.png',
    'assets/greetings_icon.png',
    'assets/tyt_icon.png',
    'assets/uuuuu_icon.png',
  ];

  final List<String> titles = [
    'Unawa Beginner',
    'First time, yes!',
    'Hi five!',
    'Ben-TEN!',
    'Halfway Hero',
    'Alphabet Ace',
    'Phrase Pro',
    'Five Fingers for Five Vowels',
    'Mahal Din Kita',
    'Okay Lang!',
    'Greetings Guru',
    'Thank You too?',
    'YOU YOU YOU YOU YOU YOU YOU',
  ];

  final List<String> descriptions = [
    'Successfully test your first sign. Congratulations on completing the beginner level.',
    'Successfully test your first phrase. You did it! Your first achievement unlocked!',
    'Successfully test any five letters of the alphabet. A round of applause for your high five!',
    'Successfully test any ten letters. You are the Ben 10 of achievements!',
    'Successfully test 13 letters of the alphabet. A true hero deserves recognition!',
    'Successfully test all 26 alphabet letters. You are the ace in this game!',
    'Successfully test all four phrases. Keep up the great work with phrases!',
    'Successfully test the "A, E, I, O, U" vowel signs. You have mastered all five vowels!',
    'Successfully test the "mahal kita" sign phrase. An expression of love! Well done!',
    'Successfully test the "kumusta" sign phrase. You did it, and that’s awesome!',
    'Successfully test the "hi" sign phrase. Well, hello there!',
    'Successfully test the "salamat" sign phrase. Thanks for being awesome!',
    'Successfully test the letter "U". You’ve reached an unbelievable achievement!',
  ];

  final Set<int> _hoveredButtons = {};

  void _showImageDialog(BuildContext context, List<String> imagePaths, String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8F4EC),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var path in imagePaths) 
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.asset(path),
                ),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 4.0),
              Text(description),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SizedBox(
          height: 100, // Adjust height for the logo
          child: Image.asset(
            'assets/Logos, Logo Marks, and Launcher Icon/logo_white.png',
            fit: BoxFit.contain,
            scale: 10, // Adjust scale for the logo size
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 columns for 3x3 grid
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.8, // Adjust card height as needed
          ),
          itemCount: imageSets.length,
          itemBuilder: (context, index) {
            return MouseRegion(
              onEnter: (_) {
                setState(() {
                  _hoveredButtons.add(index);
                });
              },
              onExit: (_) {
                setState(() {
                  _hoveredButtons.remove(index);
                });
              },
              child: ElevatedButton(
                onPressed: () {
                  _showImageDialog(context, imageSets[index], titles[index], descriptions[index]);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12.0),
                  backgroundColor: _hoveredButtons.contains(index)
                      ? const Color(0xFFCDE8E5) // Hover color
                      : const Color(0xFFEEF7FF), // Default color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      buttonIcons[index],
                      height: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      titles[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
