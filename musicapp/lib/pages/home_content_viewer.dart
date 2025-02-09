import 'package:flutter/material.dart';
import 'package:musicapp/dto/response/category_response.dart';

import '../services/api/category_api.dart';
import 'home_widget/category_widget.dart';
import 'home_widget/genre_button.dart';
import 'home_widget/new_slider.dart';


class HomeContent extends StatelessWidget {
  final CategoryApi categoryApi = CategoryApi();

  HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 62, 62, 62), Color.fromARGB(255, 0, 0, 0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Add GenreButton at the top of the screen
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: GenreButton(), // Genre buttons widget
            ),
            const SizedBox(height: 40,),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: NewsCarousel(), // News carousel widget
            ),
            // FutureBuilder for categories
            Expanded(
              child: FutureBuilder<List<CategoryResponse>>(
                future: categoryApi
                    .fetchCategories(context), // Fetch categories from API
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No categories found'));
                  }

                  final categories = snapshot.data!;
                  return CategoryList(
                      categories: categories); // Display the category list
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
