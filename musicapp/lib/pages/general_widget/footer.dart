import 'package:flutter/material.dart';

class GeneralFooter extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Color footerBackgroundColor;

  const GeneralFooter({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.footerBackgroundColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ensures the footer fills the entire width
      height: 80, // Height of the footer
      decoration: BoxDecoration(
        color: footerBackgroundColor, // Footer background color
        // borderRadius: const BorderRadius.only(
        //   topLeft: Radius.circular(20.0), // Rounded top corners
        //   topRight: Radius.circular(20.0),
        // ),
      ),
      // child: Center(
          child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed
        iconSize: 30,
        backgroundColor: Colors
            .transparent, // Keep transparent to use container's background
        currentIndex: currentIndex,
        onTap: onTap,
        elevation: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 196, 193, 193),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      )
      // ),
    );
  }
}
