import 'dart:math';
import '../models/verse_model.dart';
import '../models/prayer_model.dart';

class ContentData {
  ContentData._();

  // Tracks the last prayer shown per mood key so we never repeat back-to-back.
  static final Map<String, String> _lastPrayerByMood = {};

  // Pass a mood string to filter, or null to pick from all prayers.
  static PrayerModel pickPrayer(String? mood) {
    final pool = mood != null
        ? prayers.where((p) => p.moods.contains(mood)).toList()
        : List<PrayerModel>.from(prayers);
    if (pool.isEmpty) return prayers[Random().nextInt(prayers.length)];
    if (pool.length == 1) return pool.first;
    final key = mood ?? '_any';
    final lastId = _lastPrayerByMood[key];
    final candidates =
        lastId != null ? pool.where((p) => p.id != lastId).toList() : pool;
    final effective = candidates.isNotEmpty ? candidates : pool;
    final prayer = effective[Random().nextInt(effective.length)];
    _lastPrayerByMood[key] = prayer.id;
    return prayer;
  }

  static const List<VerseModel> verses = [
    // ── Anxiety ──────────────────────────────────────────────────────────────
    VerseModel(
      id: 'v1',
      text:
          'Do not be anxious about anything, but in every situation, by prayer '
          'and petition, with thanksgiving, present your requests to God. And '
          'the peace of God, which transcends all understanding, will guard '
          'your hearts and your minds in Christ Jesus.',
      reference: 'Philippians 4:6–7',
      moods: ['anxiety', 'peace'],
    ),
    VerseModel(
      id: 'v2',
      text: 'Cast all your anxiety on him because he cares for you.',
      reference: '1 Peter 5:7',
      moods: ['anxiety'],
    ),
    VerseModel(
      id: 'v3',
      text:
          'So do not fear, for I am with you; do not be dismayed, for I am your '
          'God. I will strengthen you and help you; I will uphold you with my '
          'righteous right hand.',
      reference: 'Isaiah 41:10',
      moods: ['anxiety', 'hope'],
    ),
    VerseModel(
      id: 'v4',
      text:
          'Therefore do not worry about tomorrow, for tomorrow will worry about '
          'itself. Each day has enough trouble of its own.',
      reference: 'Matthew 6:34',
      moods: ['anxiety'],
    ),
    VerseModel(
      id: 'v5',
      text:
          'When anxiety was great within me, your consolation brought me joy.',
      reference: 'Psalm 94:19',
      moods: ['anxiety'],
    ),
    // ── Peace ─────────────────────────────────────────────────────────────────
    VerseModel(
      id: 'v6',
      text:
          'Peace I leave with you; my peace I give you. I do not give to you as '
          'the world gives. Do not let your hearts be troubled and do not be afraid.',
      reference: 'John 14:27',
      moods: ['peace', 'anxiety'],
    ),
    VerseModel(
      id: 'v7',
      text: 'Be still, and know that I am God.',
      reference: 'Psalm 46:10',
      moods: ['peace'],
    ),
    VerseModel(
      id: 'v8',
      text:
          'You will keep in perfect peace those whose minds are steadfast, '
          'because they trust in you.',
      reference: 'Isaiah 26:3',
      moods: ['peace'],
    ),
    VerseModel(
      id: 'v9',
      text:
          'Let the peace of Christ rule in your hearts, since as members of one '
          'body you were called to peace. And be thankful.',
      reference: 'Colossians 3:15',
      moods: ['peace', 'gratitude'],
    ),
    // ── Gratitude ─────────────────────────────────────────────────────────────
    VerseModel(
      id: 'v10',
      text:
          'Rejoice always, pray continually, give thanks in all circumstances; '
          'for this is God\'s will for you in Christ Jesus.',
      reference: '1 Thessalonians 5:16–18',
      moods: ['gratitude'],
    ),
    VerseModel(
      id: 'v11',
      text:
          'Enter his gates with thanksgiving and his courts with praise; give '
          'thanks to him and praise his name. For the Lord is good and his love '
          'endures forever.',
      reference: 'Psalm 100:4–5',
      moods: ['gratitude'],
    ),
    VerseModel(
      id: 'v12',
      text: 'Give thanks to the Lord, for he is good; his love endures forever.',
      reference: 'Psalm 107:1',
      moods: ['gratitude'],
    ),
    VerseModel(
      id: 'v13',
      text:
          'Always giving thanks to God the Father for everything, in the name '
          'of our Lord Jesus Christ.',
      reference: 'Ephesians 5:20',
      moods: ['gratitude'],
    ),
    // ── Grief ─────────────────────────────────────────────────────────────────
    VerseModel(
      id: 'v14',
      text:
          'The Lord is close to the brokenhearted and saves those who are '
          'crushed in spirit.',
      reference: 'Psalm 34:18',
      moods: ['grief'],
    ),
    VerseModel(
      id: 'v15',
      text: 'Blessed are those who mourn, for they will be comforted.',
      reference: 'Matthew 5:4',
      moods: ['grief', 'hope'],
    ),
    VerseModel(
      id: 'v16',
      text:
          'He will wipe every tear from their eyes. There will be no more death '
          'or mourning or crying or pain, for the old order of things has '
          'passed away.',
      reference: 'Revelation 21:4',
      moods: ['grief', 'hope'],
    ),
    VerseModel(
      id: 'v17',
      text:
          'Even though I walk through the darkest valley, I will fear no evil, '
          'for you are with me; your rod and your staff, they comfort me.',
      reference: 'Psalm 23:4',
      moods: ['grief', 'peace'],
    ),
    // ── Hope ──────────────────────────────────────────────────────────────────
    VerseModel(
      id: 'v18',
      text:
          'For I know the plans I have for you, declares the Lord, plans to '
          'prosper you and not to harm you, plans to give you hope and a future.',
      reference: 'Jeremiah 29:11',
      moods: ['hope'],
    ),
    VerseModel(
      id: 'v19',
      text:
          'But those who hope in the Lord will renew their strength. They will '
          'soar on wings like eagles; they will run and not grow weary, they '
          'will walk and not be faint.',
      reference: 'Isaiah 40:31',
      moods: ['hope'],
    ),
    VerseModel(
      id: 'v20',
      text:
          'May the God of hope fill you with all joy and peace as you trust in '
          'him, so that you may overflow with hope by the power of the Holy Spirit.',
      reference: 'Romans 15:13',
      moods: ['hope', 'peace'],
    ),
    VerseModel(
      id: 'v21',
      text:
          'Because of the Lord\'s great love we are not consumed, for his '
          'compassions never fail. They are new every morning; great is your faithfulness.',
      reference: 'Lamentations 3:22–23',
      moods: ['hope', 'gratitude'],
    ),
    VerseModel(
      id: 'v22',
      text: 'Yes, my soul, find rest in God; my hope comes from him.',
      reference: 'Psalm 62:5',
      moods: ['hope', 'peace'],
    ),
  ];

  static const List<PrayerModel> prayers = [
    // ── Anxiety ───────────────────────────────────────────────────────────────
    PrayerModel(
      id: 'p1',
      title: 'Prayer for an Anxious Heart',
      moods: ['anxiety'],
      body: 'Lord,\n\nMy mind races and my heart is restless. I bring every '
          'worry before you now and lay it at your feet. You have told me not '
          'to be anxious, and I trust your word even when my feelings say '
          'otherwise. Guard my heart and mind with your peace that I cannot '
          'manufacture on my own.\n\nAmen.',
    ),
    PrayerModel(
      id: 'p2',
      title: 'Evening Prayer for Rest',
      moods: ['anxiety', 'peace'],
      body: 'Heavenly Father,\n\nAs this day ends, I release every burden I '
          'carried into your hands. The worries of tomorrow belong to you. '
          'Still the noise within me and let me rest in the safety of your '
          'presence. You neither slumber nor sleep — so I can.\n\nAmen.',
    ),
    PrayerModel(
      id: 'p3',
      title: 'Prayer in the Storm',
      moods: ['anxiety', 'peace'],
      body: 'Prince of Peace,\n\nThe storm feels overwhelming right now. I '
          'cannot see the way through, but you can. Speak peace over the '
          'waves inside me. Help me to keep my eyes on you and not on the '
          'chaos around me. I trust that you are in this boat with me.\n\nAmen.',
    ),
    // ── Peace ─────────────────────────────────────────────────────────────────
    PrayerModel(
      id: 'p4',
      title: 'Prayer for Stillness',
      moods: ['peace'],
      body: 'God,\n\nTeach me to be still. In a world that demands constant '
          'motion, draw me into the quiet place of your presence. Let your '
          'peace settle over me like morning dew — gentle, unhurried, and '
          'enough. I choose to rest in who you are.\n\nAmen.',
    ),
    PrayerModel(
      id: 'p5',
      title: 'Evening Peace Prayer',
      moods: ['peace'],
      body: 'Lord,\n\nThank you for this day. As I close my eyes, may your '
          'peace stand guard over my heart through the night. Let me wake '
          'tomorrow with a spirit renewed in you, ready to receive whatever '
          'the new day holds.\n\nAmen.',
    ),
    // ── Gratitude ─────────────────────────────────────────────────────────────
    PrayerModel(
      id: 'p6',
      title: 'Morning Gratitude',
      moods: ['gratitude'],
      body: 'Gracious God,\n\nThank you for the gift of this morning — for '
          'breath in my lungs and another day to walk in your grace. Open my '
          'eyes to the small mercies I so easily overlook. Let gratitude be '
          'the first word on my lips and the last before I sleep.\n\nAmen.',
    ),
    PrayerModel(
      id: 'p7',
      title: 'Prayer of Thanksgiving',
      moods: ['gratitude'],
      body: 'Father,\n\nI come before you with a thankful heart. For every '
          'answered prayer and every season of waiting, for friendships that '
          'carry me and trials that have shaped me — thank you. Your '
          'goodness has followed me all my days.\n\nAmen.',
    ),
    PrayerModel(
      id: 'p8',
      title: 'Thankful in All Things',
      moods: ['gratitude'],
      body: 'Lord,\n\nYou call me to give thanks in every circumstance — not '
          'for every circumstance, but in it. That is hard. Help me to find '
          'the thread of your faithfulness woven through even the difficult '
          'seasons, and let gratitude grow there.\n\nAmen.',
    ),
    // ── Grief ─────────────────────────────────────────────────────────────────
    PrayerModel(
      id: 'p9',
      title: 'Prayer in Grief',
      moods: ['grief'],
      body: 'Lord,\n\nI am hurting in a way that words can barely hold. '
          'You know this pain — you wept at the grave of your friend. Sit '
          'with me here. I do not need answers right now. I just need to '
          'know you are near, and that you see every tear.\n\nAmen.',
    ),
    PrayerModel(
      id: 'p10',
      title: 'Prayer for the Brokenhearted',
      moods: ['grief', 'hope'],
      body: 'Father,\n\nYou are close to the brokenhearted — and that is '
          'where I am. My loss is real and the ache goes deep. Hold what '
          'I cannot carry. When I cannot pray in words, hear the groanings '
          'of my spirit. And in your mercy, let hope return — even slowly, '
          'even quietly.\n\nAmen.',
    ),
    // ── Hope ──────────────────────────────────────────────────────────────────
    PrayerModel(
      id: 'p11',
      title: 'Prayer of Hope',
      moods: ['hope'],
      body: 'God of Hope,\n\nSome days hope feels very far away. Remind me '
          'that your plans for me are good — not despite the hard seasons, '
          'but through them. Renew my strength like the eagle. Let me run '
          'again. Let me believe again that the best is not behind me.\n\nAmen.',
    ),
    PrayerModel(
      id: 'p12',
      title: 'Prayer for a New Beginning',
      moods: ['hope'],
      body: 'Lord,\n\nYour mercies are new every morning. Even if yesterday '
          'was hard — even if a whole season was hard — today is a new day '
          'in your hands. I ask for the courage to begin again. Your '
          'faithfulness has not run out. Neither has your love for me.\n\nAmen.',
    ),
  ];
}
