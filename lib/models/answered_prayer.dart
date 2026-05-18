enum PrayerStatus { pending, answered, archive }

class AnsweredPrayer {
  final String id;
  final String title;
  final String? mood;
  final String askedDate;      // ISO 8601
  final String? answeredDate;  // ISO 8601, null while pending
  final PrayerStatus status;
  final String? answerNote;

  const AnsweredPrayer({
    required this.id,
    required this.title,
    this.mood,
    required this.askedDate,
    this.answeredDate,
    required this.status,
    this.answerNote,
  });

  AnsweredPrayer copyWith({
    String? title,
    String? mood,
    String? askedDate,
    String? answeredDate,
    PrayerStatus? status,
    String? answerNote,
  }) =>
      AnsweredPrayer(
        id: id,
        title: title ?? this.title,
        mood: mood ?? this.mood,
        askedDate: askedDate ?? this.askedDate,
        answeredDate: answeredDate ?? this.answeredDate,
        status: status ?? this.status,
        answerNote: answerNote ?? this.answerNote,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'mood': mood,
        'askedDate': askedDate,
        'answeredDate': answeredDate,
        'status': status.name,
        'answerNote': answerNote,
      };

  factory AnsweredPrayer.fromJson(Map<String, dynamic> json) => AnsweredPrayer(
        id: json['id'] as String,
        title: json['title'] as String,
        mood: json['mood'] as String?,
        askedDate: json['askedDate'] as String,
        answeredDate: json['answeredDate'] as String?,
        status: PrayerStatus.values.firstWhere(
          (s) => s.name == (json['status'] as String? ?? 'pending'),
          orElse: () => PrayerStatus.pending,
        ),
        answerNote: json['answerNote'] as String?,
      );
}
