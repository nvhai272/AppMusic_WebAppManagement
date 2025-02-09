import 'package:flutter/material.dart';
import '1.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> _newsData = [
    {
      "title": "Top US universities increase early acceptance rates",
      "date": "January 3, 2025 | 09:05 am GMT+7",
      "image": "assets/yale_university.jpg", // Replace with local asset or network image URL
    },
    {
      "title": "Technology trends to watch in 2025",
      "date": "January 1, 2025 | 10:00 am GMT+7",
      "image": "https://via.placeholder.com/600x300", // Example URL
    },
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
                colors: [Colors.black, Color.fromARGB(255, 219, 4, 76)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // News Carousel Widget
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: NewsCarousel(newsData: _newsData),
          ),
          // Footer positioned at the bottom of the screen
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 60,
              color: Colors.black,
              child: Center(
                child: Text(
                  "Footer Section",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
