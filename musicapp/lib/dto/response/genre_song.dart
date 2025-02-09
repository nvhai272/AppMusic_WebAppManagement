class GenreSong {
  final int id;
  final int genreId;
  final int songId;

  GenreSong({
    required this.id,
    required this.genreId,
    required this.songId,
  });

  // Factory constructor to create a GenreSong from JSON
  factory GenreSong.fromJson(Map<String, dynamic> json) {
    return GenreSong(
      id: json['id'],
      genreId: json['genreId'],
      songId: json['songId'],
    );
  }

  // Method to convert a GenreSong to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'genreId': genreId,
      'songId': songId,
    };
  }
}
