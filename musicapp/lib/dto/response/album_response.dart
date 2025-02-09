class AlbumResponse {
  final int id;
  final String title;
  final String? artistName; // Tên nghệ sĩ
  final String? artistImage; // Hình ảnh nghệ sĩ
  final String? image; // Hình ảnh album
  final bool isReleased;
  final DateTime? releaseDate;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? modifiedAt;

  AlbumResponse({
    required this.id,
    required this.title,
    this.artistName,
    this.artistImage,
    this.image,
    required this.isReleased,
    this.releaseDate,
    required this.isDeleted,
    this.createdAt,
    this.modifiedAt,
  });

  factory AlbumResponse.fromJson(Map<String, dynamic> json) {
    return AlbumResponse(
      id: json['id'],
      title: json['title'],
      artistName: json['artistName'], // Lấy tên nghệ sĩ từ response
      artistImage: json['artistImage'], // Lấy hình ảnh nghệ sĩ từ response
      image: json['image'],
      isReleased: json['isReleased'],
      releaseDate: json['releaseDate'] != null
          ? DateTime.parse(json['releaseDate'])
          : null,
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      modifiedAt: json['modifiedAt'] != null
          ? DateTime.parse(json['modifiedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artistName': artistName,
      'artistImage': artistImage,
      'image': image,
      'isReleased': isReleased,
      'releaseDate': releaseDate?.toIso8601String(),
      'isDeleted': isDeleted,
      'createdAt': createdAt?.toIso8601String(),
      'modifiedAt': modifiedAt?.toIso8601String(),
    };
  }
}
