class PlaylistSongRequest {
  int playlistId;
  int songId;

  PlaylistSongRequest({
    required this.playlistId,
    required this.songId,
  });

  // Convert a PlaylistSongRequestModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'playlistId': playlistId,
      'songId': songId,
    };
  }

  // Create a PlaylistSongRequestModel from JSON
  factory PlaylistSongRequest.fromJson(Map<String, dynamic> json) {
    return PlaylistSongRequest(
      playlistId: json['playlistId'],
      songId: json['songId'],
    );
  }
}
