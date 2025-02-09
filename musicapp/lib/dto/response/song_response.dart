class SongResponse {
  final int id;
  final String title;
  final String audioPath;
  final int? likeAmount;
  final String lyricFilePath;
  final bool isPending;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final String albumTitle;
  final String albumImage;
  final String artistName;

  SongResponse({
    required this.id,
    required this.title,
    required this.audioPath,
    this.likeAmount,
    required this.lyricFilePath,
    required this.isPending,
    required this.isDeleted,
    required this.createdAt,
    required this.modifiedAt,
    required this.albumTitle,
    required this.albumImage,
    required this.artistName,
  });

  // Factory constructor to create a Song from JSON
  factory SongResponse.fromJson(Map<String, dynamic> json) {
    return SongResponse(
      id: json['id'],
      title: json['title'],
      audioPath: json['audioPath'],
      likeAmount: json['likeAmount'],
      lyricFilePath: json['lyricFilePath'],
      isPending: json['isPending'],
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      modifiedAt: DateTime.parse(json['modifiedAt']),
      albumTitle: json['albumTitle'],
      albumImage: json['albumImage'],
      artistName: json['artistName'],
    );
  }

  // Method to convert a Song to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'audioPath': audioPath,
      'likeAmount': likeAmount,
      'lyricFilePath': lyricFilePath,
      'isPending': isPending,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'albumTitle': albumTitle,
      'albumImage': albumImage,
      'artistName': artistName,
    };
  }
}
