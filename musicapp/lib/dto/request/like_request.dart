class SongLikeRequest {
  final int userId;
  final int itemId;

  SongLikeRequest({
    required this.itemId,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'userId': userId,
    };
  }
}
