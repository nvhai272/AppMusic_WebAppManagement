class Album {
  final int id;
  final String title;
  final int? artistId;
  final String? image;
  final bool isReleased;
  final DateTime? releaseDate;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? modifiedAt;

  // Constructor
  Album({
    required this.id,
    required this.title,
    this.artistId,
    this.image,
    required this.isReleased,
    this.releaseDate,
    required this.isDeleted,
    this.createdAt,
    this.modifiedAt,
  });


  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id:           json['id'],
      title:        json['title'],
      artistId:     json['artist_id'],
      image:        json['image'],
      isReleased:   json['is_released'],
      releaseDate:  json['release_date'] != null
                      ? DateTime.parse(json['release_date'])
                      : null,
      isDeleted:    json['is_deleted'],
      createdAt:    json['created_at'] != null
                      ? DateTime.parse(json['created_at'])
                      : null,
      modifiedAt:   json['modified_at'] != null
                      ? DateTime.parse(json['modified_at'])
                      : null,
    );
  }

  // Method to convert an Album object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id':           id,
      'title':        title,
      'artist_id':    artistId,
      'image':        image,
      'is_released':  isReleased,
      'release_date': releaseDate?.toIso8601String(),
      'is_deleted':   isDeleted,
      'created_at':   createdAt?.toIso8601String(),
      'modified_at':  modifiedAt?.toIso8601String(),
    };
  }
}
