class PrayerModel {
  final String id;
  final String title;
  final String body;
  final List<String> moods;

  const PrayerModel({
    required this.id,
    required this.title,
    required this.body,
    required this.moods,
  });
}
