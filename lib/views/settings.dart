import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../authentication/login_page.dart';
import '../main.dart';
import '../utils/constants.dart';

class SettingsModal extends StatelessWidget {
  const SettingsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    String selectedTheme = themeProvider.currentThemeString;

    final isDarkMode = selectedTheme == 'Dark';
    final currentTheme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: currentTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isDarkMode
                  ? AppTheme.lightBackgroundColor
                  : AppTheme.cardColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Theme:',
                style: TextStyle(
                  color: isDarkMode ? AppTheme.textColor : Colors.black,
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: const Row(
                    children: [
                      Icon(
                        Icons.list,
                        size: 16,
                        color: AppTheme.secondColor,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Select Theme',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.cardColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  items: ['Light', 'Dark']
                      .map((String theme) => DropdownMenuItem<String>(
                            value: theme,
                            child: Text(
                              theme,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? Colors.white
                                    : AppTheme.cardColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  value: selectedTheme,
                  onChanged: (String? value) {
                    if (value != null) {
                      themeProvider.setTheme(value);
                      Navigator.pop(context);
                    }
                  },
                  selectedItemBuilder: (BuildContext context) {
                    return ['Light', 'Dark'].map((String theme) {
                      return Text(
                        theme,
                        style: TextStyle(
                          height: 2.9,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : AppTheme.cardColor,
                        ),
                      );
                    }).toList();
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    width: 160,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.disabledColor),
                      color: isDarkMode
                          ? AppTheme.cardColor
                          : const Color(0xffdfe3ee),
                    ),
                    elevation: 2,
                  ),
                  iconStyleData: IconStyleData(
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: isDarkMode
                          ? const Color(0xffdfe3ee)
                          : AppTheme.cardColor,
                    ),
                    iconSize: 14,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: isDarkMode ? AppTheme.cardColor : Colors.white,
                    ),
                    offset: const Offset(-20, 0),
                    scrollbarTheme: const ScrollbarThemeData(
                      radius: Radius.circular(40),
                      thickness: WidgetStatePropertyAll<double>(6),
                      thumbVisibility: WidgetStatePropertyAll<bool>(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _showLogoutDialog(context, isDarkMode);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDarkMode ? AppTheme.highlightColor : AppTheme.textColor,
            ),
            child: Text(
              'Logout',
              style: TextStyle(
                color: isDarkMode ? AppTheme.textColor : AppTheme.cardColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? AppTheme.cardColor : Colors.white,
          content: Text(
            "Are you sure you want to log out?",
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(); // Close the dialog
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => LoginPage(
                              onTap: () {},
                            )),
                    (route) => false,
                  ); // Redirect to the login page
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Logout failed: $e'),
                    ),
                  );
                }
              },
              child: Text(
                "Logout",
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
