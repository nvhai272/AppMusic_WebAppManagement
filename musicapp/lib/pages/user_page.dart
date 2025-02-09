import 'package:flutter/material.dart';
import 'package:musicapp/models/user.dart';
import 'package:musicapp/pages/favourite_song_page.dart';
import 'package:musicapp/pages/login_page.dart';
import 'package:musicapp/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'change_password_page.dart';
import 'playlist_page.dart';
import 'privacy_page.dart';
import 'user_profile_detail.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 62, 62, 62),
              Color.fromARGB(255, 0, 0, 0)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: user == null
            ? const Center(
                child: Text(
                  'No user data available. Please log in again.',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: (user.avatar?.isNotEmpty ?? false)
                          ? NetworkImage(
                              'http://localhost:8080/api/files/download/image/${user.avatar}')
                          : null,
                      child: (user.avatar?.isEmpty ?? true)
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                    title: Text(
                      user.fullName ?? 'Unknown User',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: const Text(
                      'View Profile',
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  _buildSettingItem(context, 'Favourite', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavouritePage(
                          userId: user.id!,
                        ),
                      ),
                    );
                  }),
                  _buildSettingItem(context, 'Playlist', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaylistPage(),
                      ),
                    );
                  }),
                  _buildSettingItem(context, 'Change Theme'),
                  _buildSettingItem(context, 'Change Password', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordPage(),
                      ),
                    );
                  }),
                  _buildSettingItem(context, 'Privacy and Social', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivacyPolicyPage(),
                      ),
                    );
                  }),
                  _buildSettingItem(context, 'Sign Out', () async {
                    await userProvider.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  }),
                ],
              ),
      ),
    );
  }

  // Build individual setting items
  Widget _buildSettingItem(BuildContext context, String title,
      [VoidCallback? onTap]) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
      ),
      onTap: onTap,
    );
  }
}
