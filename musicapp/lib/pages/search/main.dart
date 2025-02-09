import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/item_provider.dart';
import 'search_page.dart';  // Import the search page

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ItemProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Item Search App',
      home: SearchPage(),  // Set SearchPage as the home page
    );
  }
}
