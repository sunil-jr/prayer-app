class VerseModel {
  final String id;
  final String text;
  final String reference;
  final List<String> moods;

  const VerseModel({
    required this.id,
    required this.text,
    required this.reference,
    required this.moods,
  });
}
