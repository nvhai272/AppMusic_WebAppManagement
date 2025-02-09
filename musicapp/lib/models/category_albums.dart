class CategoryAlbum {
  final int id;
  final int categoryId;
  final int albumId;

  // Constructor
  CategoryAlbum({
    required this.id,
    required this.categoryId,
    required this.albumId,
  });

  // Factory constructor to create a CategoryAlbum object from a JSON map
  factory CategoryAlbum.fromJson(Map<String, dynamic> json) {
    return CategoryAlbum(
      id:          json['id'],
      categoryId:  json['category_id'],
      albumId:     json['album_id'],
    );
  }

  // Method to convert a CategoryAlbum object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id':          id,
      'category_id': categoryId,
      'album_id':    albumId,
    };
  }
}
