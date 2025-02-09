class News {
  final int id;
  final String title;
  final String image;
  final String content;
  final bool isActive;
  final String createdAt;
  final String modifiedAt;

  News({
    required this.id,
    required this.title,
    required this.image,
    required this.content,
    required this.isActive,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      content: json['content'],
      isActive: json['isActive'],
      createdAt: json['createdAt'],
      modifiedAt: json['modifiedAt'],
    );
  }

  // Optionally, if you want to convert the object back to a JSON format:
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'content': content,
      'isActive': isActive,
      'createdAt': createdAt,
      'modifiedAt': modifiedAt,
    };
  }
}
