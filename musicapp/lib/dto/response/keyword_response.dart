class KeywordResponse {
  final int id;
  final String content;

  KeywordResponse({required this.id, required this.content});

  factory KeywordResponse.fromJson(Map<String, dynamic> json) {
    return KeywordResponse(id: json['id'], content: json['content']);
  }
}
