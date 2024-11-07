import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../utils/constants.dart';

class ProfilePage extends StatefulWidget {
  final String userName;

  const ProfilePage({super.key, required this.userName});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  String _gender = '-';

  bool _isEditing = false;
  User? currentUser;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _ageController = TextEditingController();

    _loadUserProfile();
    _checkVerificationStatus();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _checkVerificationStatus() async {
    await currentUser?.reload();
    setState(() {
      _isVerified = currentUser?.emailVerified ?? false;
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .update({'isVerified': _isVerified});
  }

  Future<void> sendVerificationEmail() async {
    if (currentUser != null && !_isVerified) {
      try {
        await currentUser!.sendEmailVerification();
        final isDarkMode = Provider.of<ThemeProvider>(context, listen: false)
                .currentThemeString ==
            'Dark';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'A verification email has been sent to your email.',
              style: TextStyle(
                color: isDarkMode
                    ? Colors.white
                    : Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            backgroundColor: isDarkMode
                ? Colors.black
                : Theme.of(context).colorScheme.primary,
          ),
        );
      } catch (e) {
        final isDarkMode = Provider.of<ThemeProvider>(context, listen: false)
                .currentThemeString ==
            'Dark';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Failed to send verification email. Please try again.'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'OK',
              textColor: isDarkMode ? Colors.white : null,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  Future<void> _loadUserProfile() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      _nameController.text = data['fullName'] ?? '';
      _usernameController.text = data['username'] ?? '';
      _emailController.text = data['email'] ?? currentUser?.email ?? '';
      _ageController.text = data['age'].toString();
      _gender = data['gender'] ?? '-';
      _isVerified = data['isVerified'] ?? false;
      setState(() {});
    } else {
      _nameController.text = currentUser?.displayName ?? '';
      _emailController.text = currentUser?.email ?? '';
    }
  }

  Future<void> _saveUserProfile() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({
        'fullName': _nameController.text,
        'username': _usernameController.text,
        'email': _emailController.text,
        'age': int.tryParse(_ageController.text) ?? 0,
        'gender': _gender,
      });
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to update profile. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.currentThemeString == 'Dark';

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildProfileHeader(isDarkMode),
                const SizedBox(height: 20),
                _buildInfoCard(isDarkMode),
                const SizedBox(height: 20),
                _buildActionButtons(isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isDarkMode) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor:
              isDarkMode ? AppTheme.cardColor : AppTheme.disabledColor,
          backgroundImage: currentUser?.photoURL != null
              ? NetworkImage(currentUser!.photoURL!)
              : null,
          child: currentUser?.photoURL == null
              ? Icon(
                  Icons.person,
                  size: 50,
                  color: isDarkMode
                      ? AppTheme.disabledColor
                      : AppTheme.lightBackgroundColor,
                )
              : null,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isVerified ? Icons.verified : Icons.warning,
              color: _isVerified ? Colors.green : Colors.yellow,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              _nameController.text,
              style: TextStyle(
                color: isDarkMode ? AppTheme.textColor : AppTheme.cardColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(bool isDarkMode) {
    return Card(
      color: isDarkMode ? AppTheme.cardColor : AppTheme.lightBackgroundColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Full Name', _nameController, isDarkMode),
            const SizedBox(height: 8),
            _buildInfoRow('Username', _usernameController, isDarkMode),
            const SizedBox(height: 8),
            _buildInfoRow('Email', _emailController, isDarkMode),
            const SizedBox(height: 8),
            _buildInfoRow('Age', _ageController, isDarkMode),
            const SizedBox(height: 8),
            _buildGenderRow(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      String label, TextEditingController controller, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            color: isDarkMode ? AppTheme.textColor : AppTheme.cardColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        _isEditing
            ? TextField(
                controller: controller,
                style: TextStyle(
                  color: isDarkMode
                      ? AppTheme.lightBackgroundColor
                      : AppTheme.cardColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppTheme.cardColor
                      : AppTheme.lightBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? AppTheme.mainColor
                          : AppTheme.disabledColor,
                      width: 2,
                    ),
                  ),
                ),
              )
            : Text(
                controller.text,
                style: TextStyle(
                  color: isDarkMode ? AppTheme.textColor : AppTheme.cardColor,
                  fontSize: 16,
                ),
              ),
      ],
    );
  }

  Widget _buildGenderRow(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender:',
          style: TextStyle(
            color: isDarkMode ? AppTheme.textColor : AppTheme.cardColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        _isEditing
            ? DropdownButtonFormField<String>(
                value: _gender,
                onChanged: (value) => setState(() => _gender = value ?? '-'),
                items: ['Male', 'Female', '-']
                    .map((gender) => DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                style: TextStyle(
                  color: isDarkMode
                      ? AppTheme.lightBackgroundColor
                      : AppTheme.cardColor,
                ),
                dropdownColor: isDarkMode
                    ? AppTheme.cardColor
                    : AppTheme.lightBackgroundColor,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppTheme.cardColor
                      : AppTheme.lightBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
            : Text(
                _gender,
                style: TextStyle(
                  color: isDarkMode ? AppTheme.textColor : AppTheme.cardColor,
                  fontSize: 16,
                ),
              ),
      ],
    );
  }

  Widget _buildActionButtons(bool isDarkMode) {
    return Column(
      children: [
        _isEditing
            ? ElevatedButton(
                onPressed: _saveUserProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDarkMode ? AppTheme.cardColor : AppTheme.mainColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ElevatedButton(
                onPressed: () => setState(() => _isEditing = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDarkMode ? AppTheme.cardColor : AppTheme.mainColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
        const SizedBox(height: 16),
        if (!_isVerified) // Show "Verify Profile" button only if not verified
          ElevatedButton(
            onPressed: sendVerificationEmail,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDarkMode ? AppTheme.cardColor : AppTheme.mainColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              'Verify Profile',
              style: TextStyle(color: Colors.white),
            ),
          ),
      ],
    );
  }
}



/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../utils/constants.dart';

class ProfilePage extends StatefulWidget {
  final String userName;

  const ProfilePage({super.key, required this.userName});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  String _gender = '-';

  bool _isEditing = false;
  User? currentUser;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _ageController = TextEditingController();

    _loadUserProfile();
    _checkVerificationStatus();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _checkVerificationStatus() async {
    await currentUser?.reload();
    setState(() {
      _isVerified = currentUser?.emailVerified ?? false;
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .update({'isVerified': _isVerified});
  }

  Future<void> sendVerificationEmail() async {
    if (currentUser != null && !_isVerified) {
      try {
        await currentUser!.sendEmailVerification();
        // ignore: use_build_context_synchronously
        final isDarkMode = Provider.of<ThemeProvider>(context, listen: false)
                .currentThemeString ==
            'Dark';
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'A verification email has been sent to your email.',
              style: TextStyle(
                color: isDarkMode
                    ? Colors.white
                    // ignore: use_build_context_synchronously
                    : Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            backgroundColor: isDarkMode
                ? Colors.black
                // ignore: use_build_context_synchronously
                : Theme.of(context).colorScheme.primary,
          ),
        );
      } catch (e) {
        // ignore: use_build_context_synchronously
        final isDarkMode = Provider.of<ThemeProvider>(context, listen: false)
                .currentThemeString ==
            'Dark';
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Failed to send verification email. Please try again.'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'OK',
              textColor: isDarkMode ? Colors.white : null,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  Future<void> _loadUserProfile() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      _nameController.text = data['fullName'] ?? '';
      _usernameController.text = data['username'] ?? '';
      _emailController.text = data['email'] ?? currentUser?.email ?? '';
      _ageController.text = data['age'].toString();
      _gender = data['gender'] ?? '-';
      _isVerified = data['isVerified'] ?? false;
      setState(() {});
    } else {
      _nameController.text = currentUser?.displayName ?? '';
      _emailController.text = currentUser?.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.currentThemeString == 'Dark';

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildProfileHeader(isDarkMode),
                const SizedBox(height: 20),
                _buildInfoCard(isDarkMode),
                const SizedBox(height: 20),
                _buildActionButtons(isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isDarkMode) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor:
              isDarkMode ? AppTheme.cardColor : AppTheme.disabledColor,
          backgroundImage: currentUser?.photoURL != null
              ? NetworkImage(currentUser!.photoURL!)
              : null,
          child: currentUser?.photoURL == null
              ? Icon(
                  Icons.person,
                  size: 50,
                  color: isDarkMode
                      ? AppTheme.disabledColor
                      : AppTheme.lightBackgroundColor,
                )
              : null,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isVerified ? Icons.verified : Icons.warning,
              color: _isVerified ? Colors.green : Colors.yellow,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              _nameController.text,
              style: TextStyle(
                color: isDarkMode ? AppTheme.textColor : AppTheme.cardColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(bool isDarkMode) {
    return Card(
      color: isDarkMode ? AppTheme.cardColor : AppTheme.lightBackgroundColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Full Name', _nameController, isDarkMode),
            const SizedBox(height: 8),
            _buildInfoRow('Username', _usernameController, isDarkMode),
            const SizedBox(height: 8),
            _buildInfoRow('Email', _emailController, isDarkMode),
            const SizedBox(height: 8),
            _buildInfoRow('Age', _ageController, isDarkMode),
            const SizedBox(height: 8),
            _buildGenderRow(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      String label, TextEditingController controller, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            color: isDarkMode ? AppTheme.textColor : AppTheme.cardColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        _isEditing
            ? TextField(
                controller: controller,
                style: TextStyle(
                  color: isDarkMode
                      ? AppTheme.lightBackgroundColor
                      : AppTheme.cardColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppTheme.cardColor
                      : AppTheme.lightBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? AppTheme.mainColor
                          : AppTheme.disabledColor,
                      width: 2,
                    ),
                  ),
                ),
              )
            : Text(
                controller.text,
                style: TextStyle(
                  color: isDarkMode ? AppTheme.textColor : AppTheme.cardColor,
                  fontSize: 16,
                ),
              ),
      ],
    );
  }

  Widget _buildGenderRow(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender:',
          style: TextStyle(
            color: isDarkMode ? AppTheme.textColor : AppTheme.cardColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        _isEditing
            ? DropdownButton<String>(
                value: _gender,
                items: <String>['-', 'Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: isDarkMode
                            ? AppTheme.textColor
                            : AppTheme.cardColor,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _gender = newValue!;
                  });
                },
              )
            : Text(
                _gender,
                style: TextStyle(
                  color: isDarkMode ? AppTheme.textColor : AppTheme.cardColor,
                  fontSize: 16,
                ),
              ),
      ],
    );
  }

  Widget _buildActionButtons(bool isDarkMode) {
    const double buttonWidth = 200; // Define a fixed width for the buttons

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isVerified) // Only show this button if the user is not verified
              SizedBox(
                width: buttonWidth, // Set the fixed width
                child: ElevatedButton(
                  onPressed: () {
                    sendVerificationEmail();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15)), // Adjust vertical padding
                  child: const Row(
                    mainAxisSize:
                        MainAxisSize.min, // Keep the row's size minimal
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center the content
                    children: [
                      Icon(Icons.verified_user,
                          color: Colors.white), // Add the verify icon
                      SizedBox(
                          width: 8), // Add some space between icon and text
                      Text(
                        'Verify Profile',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8), // Add space between buttons
        SizedBox(
          width: buttonWidth, // Set the fixed width
          child: ElevatedButton(
            onPressed: _isEditing ? _saveProfile : _editProfile,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.mainColor,
                padding: const EdgeInsets.symmetric(
                    vertical: 15)), // Adjust vertical padding
            child: Row(
              mainAxisSize: MainAxisSize.min, // Keep the row's size minimal
              mainAxisAlignment: MainAxisAlignment.center, // Center the content
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedFileEdit,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  _isEditing ? 'Save' : 'Edit',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _editProfile() {
    setState(() {
      _isEditing = true;
    });
  }

  void _saveProfile() async {
    final updatedData = {
      'fullName': _nameController.text,
      'username': _usernameController.text,
      'email': _emailController.text,
      'age': int.tryParse(_ageController.text) ?? 0,
      'gender': _gender,
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update(updatedData);
      setState(() {
        _isEditing = false;
      });
      // ignore: empty_catches
    } catch (e) {}
  }
}
*/