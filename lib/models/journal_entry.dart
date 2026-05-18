class JournalEntry {
  final String id;
  final String title;
  final String body;
  final String createdAt;  // ISO 8601
  final String? mood;
  final bool isFavorited;

  const JournalEntry({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.mood,
    this.isFavorited = false,
  });

  JournalEntry copyWith({
    String? title,
    String? body,
    String? createdAt,
    String? mood,
    bool? isFavorited,
  }) =>
      JournalEntry(
        id: id,
        title: title ?? this.title,
        body: body ?? this.body,
        createdAt: createdAt ?? this.createdAt,
        mood: mood ?? this.mood,
        isFavorited: isFavorited ?? this.isFavorited,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'createdAt': createdAt,
        'mood': mood,
        'isFavorited': isFavorited,
      };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
        id: json['id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        createdAt: json['createdAt'] as String,
        mood: json['mood'] as String?,
        isFavorited: json['isFavorited'] as bool? ?? false,
      );
}
