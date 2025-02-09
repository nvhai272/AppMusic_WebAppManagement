import 'package:flutter/material.dart';

import '../../dto/response/category_response.dart';
import 'album_list.dart';

class CategoryList extends StatelessWidget {
  final List<CategoryResponse> categories;

  const CategoryList({required this.categories, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     // Handle "See more" action
                  //   },
                  //   child: const Text(
                  //     'Xem thêm',
                  //     style: TextStyle(color: Colors.blue, fontSize: 14),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 8),
              // Horizontal album list
              HorizontalAlbumList(albums: category.albums),
            ],
          ),
        );
      },
    );
  }
}
