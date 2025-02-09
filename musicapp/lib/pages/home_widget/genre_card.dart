import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../models/genre.dart';
class GenreCard extends StatelessWidget {
  final Genre genre;
  final VoidCallback? onTap;
  const GenreCard({super.key, required this.genre,required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color genreColor = Colours.getColourFromString(genre.color.toUpperCase());
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: genreColor.withOpacity(0.2),
          border: Border.all(color: genreColor, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          genre.title,
          style: TextStyle(
            color: genreColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}