// Model: Item
import 'package:flutter/material.dart';

class Genre {
  // final int id;
  // final String title;
  // final String image;
  // final Color color;
  final int id;
  final String title;
  final String image;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final String color;
  final int colorId;

  // Genre({required this.id, required this.title, required this.image,});
  // Genre(
  //     {required this.id,
  //     required this.title,
  //     required this.image,
  //     required this.color});

  Genre({
    required this.id,
    required this.title,
    required this.image,
    required this.isDeleted,
    required this.createdAt,
    required this.modifiedAt,
    required this.color,
    required this.colorId,
  });

  // Factory method to create a Genre instance from JSON
  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      modifiedAt: DateTime.parse(json['modifiedAt']),
      color: json['color'],
      colorId: json['colorId'],
    );
  }

  // Method to convert Genre instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'color': color,
      'colorId': colorId,
    };
  }
}
// Factory method to create an Item from JSON
// factory Genre.fromJson(Map<String, dynamic> json) {
//   return Genre(
//     id: json['id'],
//     title: json['title'],
//     image: json['image'],
//   );
// }
// factory Genre.fromJson(Map<String, dynamic> json) {
//   return Genre(
//     id: json['id'],
//     title: json['title'],
//     image: json['image'],
//     color: colorMapping[json['color']] ?? Colors.blue,
//   );
// }
//
// Map<String, dynamic> toJson() {
//   return {
//     'id': id,
//     'title': title,
//     'image': image,
//   };
// }
// Map<String, dynamic> toJson() {
//   return {
//     'id': id,
//     'title': title,
//     'image': image,
//     'color': color,
//   };
// }
// }

final Map<String, Color> colorMapping = {
  "brown": Colors.brown,
  "blue": Colors.blue,
  "red": Colors.red,
  "green": Colors.green,
  "pink": Colors.pink,
  "yellow": Colors.yellow,
};
