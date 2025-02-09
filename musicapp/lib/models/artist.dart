class Artist {
  final int id;
  final String artistName;
  final String? image;
  final String? bio;
  final int? userId;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? modifiedAt;

  // Constructor
  Artist({
    required this.id,
    required this.artistName,
    this.image,
    this.bio,
    this.userId,
    required this.isDeleted,
    this.createdAt,
    this.modifiedAt,
  });

  // Factory constructor to create an Artist object from a JSON map
  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id:          json['id'],
      artistName:  json['artist_name'],
      image:       json['image'],
      bio:         json['bio'],
      userId:      json['user_id'],
      isDeleted:   json['is_deleted'],
      createdAt:   json['created_at'] != null
                      ? DateTime.parse(json['created_at'])
                      : null,
      modifiedAt:  json['modified_at'] != null
                      ? DateTime.parse(json['modified_at'])
                      : null,
    );
  }

  // Method to convert an Artist object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id':           id,
      'artist_name':  artistName,
      'image':        image,
      'bio':          bio,
      'user_id':      userId,
      'is_deleted':   isDeleted,
      'created_at':   createdAt?.toIso8601String(),
      'modified_at':  modifiedAt?.toIso8601String(),
    };
  }
}
