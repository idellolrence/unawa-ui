import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../utils/constants.dart';
import '../home_page_contents/achievements_page.dart';
import '../home_page_contents/learn_page.dart';
import '../home_page_contents/test_page.dart';
import '../settings.dart';
import 'about_page.dart';
import 'how_to_page.dart';
import 'profile_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.currentThemeString == 'Dark';

    final List<Widget> widgetOptions = <Widget>[
      _buildHomeOptions(context),
      const ProfilePage(userName: AutofillHints.username),
      const AboutPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox(
          height: 100, // Adjust height for the logo
          child: Image.asset(
            'assets/Logos, Logo Marks, and Launcher Icon/logo_white.png',
            fit: BoxFit.contain,
            scale: 10, // Adjust scale for the logo size
          ),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.black : AppTheme.mainColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showSettingsModal(context);
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: widgetOptions,
      ),
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        onButtonPressed: _onItemTapped,
        iconSize: 30,
        activeColor: isDarkMode ? Colors.white : Theme.of(context).primaryColor,
        selectedIndex: _selectedIndex,
        barItems: [
          BarItem(
            icon: HugeIcons.strokeRoundedHome02,
            title: 'Home',
          ),
          BarItem(
            icon: HugeIcons.strokeRoundedUser,
            title: 'Profile',
          ),
          BarItem(
            icon: HugeIcons.strokeRoundedInformationCircle,
            title: 'About',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeOptions(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHomeOption(
              context,
              image: 'assets/Buttons Images/Home/learn_button.png',
              title: 'Learn',
              description: 'Learn sign language with interactive modules',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LearnPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildHomeOption(
              context,
              image: 'assets/Buttons Images/Home/test_button.png',
              title: 'Test',
              description: 'Test your skills with challenges',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TestPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildHomeOption(
              context,
              image: 'assets/Buttons Images/Home/achievements_button.png',
              title: 'Achievements',
              description: 'Track your progress and achievements',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AchievementsPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildHomeOption(
              context,
              image: 'assets/Buttons Images/Home/how to_button.png',
              title: 'How To',
              description: 'Guidelines and tutorials for learning',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HowToPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeOption(
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
          color: Theme.of(context).cardColor,
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
                height: 80, // Adjusted height for images
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

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const SettingsModal();
      },
    );
  }
}
