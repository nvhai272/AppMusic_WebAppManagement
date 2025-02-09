import 'album.dart';

class Category {
  final int id;
  final String title;
  final String image;
  final String description;
  final bool isDeleted;
  final String createdAt;
  final String modifiedAt;
  final List<Album> albums;

  Category({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.isDeleted,
    required this.createdAt,
    required this.modifiedAt,
    required this.albums, // Cập nhật albumIds
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      description: json['description'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      modifiedAt: json['modifiedAt'],
      albums: (json['albums'] as List)
          .map((albumJson) =>
              Album.fromJson(albumJson)) 
          .toList(), 
    );
  }
}
