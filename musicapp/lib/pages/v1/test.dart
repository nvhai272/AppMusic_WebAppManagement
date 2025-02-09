import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicPlayerScreen(),
    );
  }
}

class MusicPlayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/5.jpg"), // Replace with your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Blur Effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Adjust blur intensity
            child: Container(
              color: Colors.black.withOpacity(0.3), // Add a slight tint
            ),
          ),
          // Foreground Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.arrow_drop_down, color: Colors.white),
                      Text(
                        "JVKE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.more_vert, color: Colors.white),
                    ],
                  ),
                ),
                // Main Image
                Expanded(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/images/5.jpg", // Replace with your album cover
                        width: 250,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Song Title and Artist
                SizedBox(height: 20),
                Text(
                  "this is what falling in love felt like",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  "JVKE",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                // Music Controls
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.shuffle, color: Colors.white),
                    Icon(Icons.skip_previous, color: Colors.white),
                    Icon(Icons.play_circle_filled, size: 50, color: Colors.white),
                    Icon(Icons.skip_next, color: Colors.white),
                    Icon(Icons.repeat, color: Colors.white),
                  ],
                ),
                // Progress Bar
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("0:00", style: TextStyle(color: Colors.grey)),
                      Expanded(
                        child: Slider(
                          value: 0.3,
                          onChanged: (value) {},
                          activeColor: Colors.white,
                          inactiveColor: Colors.grey,
                        ),
                      ),
                      Text("2:00", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                // Footer Controls
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.devices, color: Colors.white),
                      Icon(Icons.share, color: Colors.white),
                      Icon(Icons.menu, color: Colors.white),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
