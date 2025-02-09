import 'album_response.dart';

class CategoryResponse {
  final int id;
  final String title;

  final String description;
  final bool isDeleted;

  final List<AlbumResponse> albums;

  CategoryResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.isDeleted,
    required this.albums,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    var albumsJson = json['albums'] as List;
    List<AlbumResponse> albumsList = albumsJson
        .map((albumJson) => AlbumResponse.fromJson(albumJson))
        .toList();

    return CategoryResponse(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isDeleted: json['isDeleted'],
      albums: albumsList,
    );
  }
}
