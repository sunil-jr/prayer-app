class Prayer {
  final String id;
  final String title;
  final String body;
  final String category;
  final DateTime? lastPrayedAt;

  const Prayer({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    this.lastPrayedAt,
  });

  Prayer copyWith({
    String? id,
    String? title,
    String? body,
    String? category,
    DateTime? lastPrayedAt,
  }) =>
      Prayer(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        category: category ?? this.category,
        lastPrayedAt: lastPrayedAt ?? this.lastPrayedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'category': category,
        'lastPrayedAt': lastPrayedAt?.toIso8601String(),
      };

  factory Prayer.fromJson(Map<String, dynamic> json) => Prayer(
        id: json['id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        category: json['category'] as String,
        lastPrayedAt: json['lastPrayedAt'] != null
            ? DateTime.parse(json['lastPrayedAt'] as String)
            : null,
      );
}
