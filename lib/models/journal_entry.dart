class JournalEntry {
  final String id;
  final String title;
  final String body;
  final String createdAt; // ISO 8601
  final String? mood;

  const JournalEntry({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.mood,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'createdAt': createdAt,
        'mood': mood,
      };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
        id: json['id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        createdAt: json['createdAt'] as String,
        mood: json['mood'] as String?,
      );
}
