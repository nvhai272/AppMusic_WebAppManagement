class PlaylistResponse {
  final int id;
  final String title;
  final String userName;
  final bool isDeleted;
  final int songQty;

  // Constructor của PlaylistResponse
  PlaylistResponse({
    required this.id,
    required this.title,
    required this.userName,
    required this.isDeleted,
    required this.songQty,
  });

  // Factory constructor để tạo đối tượng PlaylistResponse từ một Map
  factory PlaylistResponse.fromJson(Map<String, dynamic> json) {
    return PlaylistResponse(
      id: json['id'],
      title: json['title'],
      userName: json['username'],
      isDeleted: json['isDeleted'],
      songQty: json['songQty'],
    );
  }

  // Factory constructor để tạo danh sách PlaylistResponse từ mảng JSON
  // static List<PlaylistResponse> fromJsonList(List<dynamic> jsonList) {
  //   return jsonList.map((json) => PlaylistResponse.fromJson(json)).toList();
  // }

  // Nếu bạn cần chuyển đối tượng PlaylistResponse thành Map, có thể dùng phương thức này
  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'title': title,
  //     'username': userName,
  //     'isDeleted': isDeleted,
  //     'songQty': songQty,
  //   };
  // }
}
