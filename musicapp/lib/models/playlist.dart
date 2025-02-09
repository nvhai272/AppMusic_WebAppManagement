import 'dart:convert';

class Playlist {
  final int id;
  final String title;
  final String userName;
  final bool isDeleted;
  final int songQty;

  Playlist(
      {required this.id,
      required this.title,
      required this.userName,
      required this.isDeleted,
      required this.songQty});

  // Factory constructor để tạo đối tượng Playlist từ một Map
  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'], // Lấy id từ Map
      title: map['title'], // Lấy tiêu đề từ Map
      userName: map['username'], // Lấy tên người dùng từ Map
      isDeleted: map['isDeleted'], // Lấy trạng thái xóa từ Map
      songQty: map['songQty'], // Lấy số lượng bài hát từ Map
    );
  }

  // Phương thức toMap để chuyển đổi Playlist thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id, // ID của playlist
      'title': title, // Tiêu đề của playlist
      'userName': userName, // Tên người dùng
      'songQty': songQty, // Số lượng bài hát
    };
  }
}
