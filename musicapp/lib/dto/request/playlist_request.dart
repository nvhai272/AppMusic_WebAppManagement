class PlaylistRequest {
  final String title;
  final int userId;

  PlaylistRequest({
    required this.title,
    required this.userId,
  });

  /// Convert the object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'userId': userId,
    };
  }
}
