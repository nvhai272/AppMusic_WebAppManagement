import 'package:flutter/material.dart';
import 'package:musicapp/pages/general_widget/footer.dart';
import 'package:musicapp/pages/general_widget/header.dart';
import 'package:musicapp/pages/user_page.dart';
import 'package:musicapp/providers/song_provider.dart';
import 'package:provider/provider.dart';

import 'favourite_album_page.dart';
import 'general_widget/audio_card.dart';
import 'home_content_viewer.dart';
import 'home_widget/search_by_keyword_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeContent(), // HomeContent widget for the first page
    FavouriteAlbumPage(),
    SearchScreen(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen gradient background
          Container(
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
          ),
          // Header positioned at the top of the screen
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: GeneralHeader(),
          ),

          // Content in between header and footer
          Positioned.fill(
            top: 70, // Offset to account for header height
            bottom: 60, // Offset to account for footer height
            child: SafeArea(
              child: _pages[
                  _currentIndex], // Safe area to avoid UI elements overlap
            ),
          ),
          // Above the footer

          // AudioCard positioned above the footer
          Consumer<SongProvider>(
            builder: (context, songProvider, child) {
              return songProvider.shouldShow()
                  ? Positioned(
                      left: 0,
                      right: 0,
                      bottom: 80,
                      // bottom:
                      //     50, // Adjust the bottom to avoid overlap with the footer
                      child: AudioCard(),
                    )
                  : const SizedBox.shrink();
            },
          ),
          // Footer positioned at the bottom of the screen
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GeneralFooter(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
