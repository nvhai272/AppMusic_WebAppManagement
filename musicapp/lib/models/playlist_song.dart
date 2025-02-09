class PlaylistSong {
  final int id;
  final int playlistId;
  final int songId;

  PlaylistSong({
    required this.id,
    required this.playlistId,
    required this.songId,
  });

  // Factory constructor to create a PlaylistSong from JSON
  factory PlaylistSong.fromJson(Map<String, dynamic> json) {
    return PlaylistSong(
      id: json['id'],
      playlistId: json['playlistId'],
      songId: json['songId'],
    );
  }

  // Method to convert PlaylistSong to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playlistId': playlistId,
      'songId': songId,
    };
  }
}
