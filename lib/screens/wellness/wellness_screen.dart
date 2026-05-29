import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/answered_prayer.dart';
import '../../services/storage_service.dart';

class WellnessScreen extends StatefulWidget {
  const WellnessScreen({super.key});

  @override
  State<WellnessScreen> createState() => _WellnessScreenState();
}

class _WellnessScreenState extends State<WellnessScreen> {
  List<double> _anxietyData = List.filled(7, 0);
  List<double> _peaceData = List.filled(7, 0);
  List<int> _freqData = List.filled(7, 0);
  int _prayersThisWeek = 0;
  double _answeredMonthPct = 0;
  int _breatheSessions = 0;
  double _anxietyAnsweredPct = 0;
  double _gratitudeAnsweredPct = 0;
  double _peaceAnsweredPct = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final entries = await StorageService.getEntries();
    final prayers = await StorageService.getAnsweredPrayers();
    final breathe = StorageService.getBreatheSessions();

    // Mood trend — count per day of current week
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    final anxietyByDay = List.filled(7, 0.0);
    final peaceByDay = List.filled(7, 0.0);
    final freqByDay = List.filled(7, 0);

    for (final e in entries) {
      final dt = DateTime.tryParse(e.createdAt);
      if (dt == null) continue;
      final diff = dt.difference(DateTime(weekStart.year, weekStart.month, weekStart.day)).inDays;
      if (diff < 0 || diff > 6) continue;
      freqByDay[diff]++;
      if (e.mood == 'anxiety') anxietyByDay[diff]++;
      if (e.mood == 'peace') peaceByDay[diff]++;
    }

    // Answered prayers this month
    final monthStart = DateTime(now.year, now.month, 1);
    final thisMonth = prayers.where((p) =>
        DateTime.tryParse(p.askedDate)?.isAfter(monthStart) ?? false).toList();
    final answeredThisMonth = thisMonth.where((p) => p.status == PrayerStatus.answered).length;
    final answeredMonthPct = thisMonth.isEmpty ? 0.0 : answeredThisMonth / thisMonth.length * 100;

    // Prayer insights by mood
    double pct(List<AnsweredPrayer> list, String mood) {
      final moodPrayers = list.where((p) => p.mood == mood).toList();
      if (moodPrayers.isEmpty) return 0;
      final ans = moodPrayers.where((p) => p.status == PrayerStatus.answered).length;
      return ans / moodPrayers.length * 100;
    }

    if (mounted) {
      setState(() {
        _anxietyData = anxietyByDay;
        _peaceData = peaceByDay;
        _freqData = freqByDay;
        _prayersThisWeek = freqByDay.fold(0, (a, b) => a + b);
        _answeredMonthPct = answeredMonthPct;
        _breatheSessions = breathe;
        _anxietyAnsweredPct = pct(prayers, 'anxiety');
        _gratitudeAnsweredPct = pct(prayers, 'gratitude');
        _peaceAnsweredPct = pct(prayers, 'peace');
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                20,
                topPad + 28,
                20,
                MediaQuery.of(context).viewPadding.bottom + kBottomNavigationBarHeight + 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.wellnessTitle, style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.wellnessSubtitle,
                    style: GoogleFonts.nunito(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  _MoodTrendCard(
                    anxietyData: _anxietyData,
                    peaceData: _peaceData,
                    isEmpty: _prayersThisWeek == 0,
                  ),
                  const SizedBox(height: 16),
                  _PrayerFrequencyCard(
                    data: _freqData,
                    total: _prayersThisWeek,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _MiniStatCard(
                          icon: Icons.check_circle_outline,
                          iconColor: AppColors.accentGreen,
                          iconBg: AppColors.accentGreenBg,
                          value: '${_answeredMonthPct.round()}%',
                          label: AppStrings.wellnessAnsweredMonth,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MiniStatCard(
                          icon: Icons.air,
                          iconColor: AppColors.primaryMid,
                          iconBg: AppColors.tagPeace,
                          value: '$_breatheSessions',
                          label: AppStrings.wellnessBreathingSessions,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _InsightsCard(
                    anxiety: _anxietyAnsweredPct,
                    gratitude: _gratitudeAnsweredPct,
                    peace: _peaceAnsweredPct,
                  ),
                ],
              ),
            ),
    );
  }
}

// ── Mood trend card ────────────────────────────────────────────────────────────

class _MoodTrendCard extends StatelessWidget {
  final List<double> anxietyData;
  final List<double> peaceData;
  final bool isEmpty;

  const _MoodTrendCard({
    required this.anxietyData,
    required this.peaceData,
    required this.isEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return _WCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, size: 18, color: AppColors.primaryMid),
              const SizedBox(width: 8),
              Text(
                AppStrings.wellnessMoodTrend,
                style: GoogleFonts.nunito(
                  color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  AppStrings.wellnessNoData,
                  style: GoogleFonts.nunito(
                    color: AppColors.textSecondary, fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else ...[
            SizedBox(
              height: 150,
              child: CustomPaint(
                painter: _LineChartPainter(
                  series: [anxietyData, peaceData],
                  colors: [AppColors.accentOrange, AppColors.accentGreen],
                ),
                size: Size.infinite,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                  .map((d) => Text(
                        d,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ))
                  .toList(),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              _LegendDot(color: AppColors.accentOrange, label: 'Anxiety'),
              const SizedBox(width: 16),
              _LegendDot(color: AppColors.accentGreen, label: 'Peace'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.nunito(
          color: AppColors.textSecondary, fontSize: 11,
        )),
      ],
    );
  }
}

// ── Prayer frequency card ──────────────────────────────────────────────────────

class _PrayerFrequencyCard extends StatelessWidget {
  final List<int> data;
  final int total;

  const _PrayerFrequencyCard({required this.data, required this.total});

  @override
  Widget build(BuildContext context) {
    return _WCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined, size: 18, color: AppColors.primaryMid),
              const SizedBox(width: 8),
              Text(
                AppStrings.wellnessPrayerFreq,
                style: GoogleFonts.nunito(
                  color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: CustomPaint(
              painter: _BarChartPainter(data: data, color: AppColors.primaryMid),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .map((d) => Text(
                      d,
                      style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 10,
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Text(
                  '$total',
                  style: GoogleFonts.nunito(
                    color: AppColors.text, fontSize: 28, fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  AppStrings.wellnessPrayersThisWeek,
                  style: GoogleFonts.nunito(
                    color: AppColors.textSecondary, fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mini stat card ─────────────────────────────────────────────────────────────

class _MiniStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;

  const _MiniStatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.nunito(
              color: AppColors.text, fontSize: 26, fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.nunito(color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ── Prayer insights card ───────────────────────────────────────────────────────

class _InsightsCard extends StatelessWidget {
  final double anxiety;
  final double gratitude;
  final double peace;

  const _InsightsCard({
    required this.anxiety,
    required this.gratitude,
    required this.peace,
  });

  @override
  Widget build(BuildContext context) {
    return _WCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.wellnessInsightsTitle,
            style: GoogleFonts.nunito(
              color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _InsightRow(
            label: AppStrings.wellnessAnxietyPrayers,
            pct: anxiety,
            color: AppColors.accentOrange,
          ),
          const SizedBox(height: 14),
          _InsightRow(
            label: AppStrings.wellnessGratitudePrayers,
            pct: gratitude,
            color: AppColors.accentGreen,
          ),
          const SizedBox(height: 14),
          _InsightRow(
            label: AppStrings.wellnessPeacePrayers,
            pct: peace,
            color: AppColors.primaryMid,
          ),
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  final String label;
  final double pct;
  final Color color;

  const _InsightRow({required this.label, required this.pct, required this.color});

  @override
  Widget build(BuildContext context) {
    final display = pct == 0 ? 'No data' : '${pct.round()}${AppStrings.wellnessAnsweredSuffix}';
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.nunito(color: AppColors.text, fontSize: 13),
          ),
        ),
        Text(
          display,
          style: GoogleFonts.nunito(
            color: pct == 0 ? AppColors.textSecondary : color,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ── Shared card wrapper ────────────────────────────────────────────────────────

class _WCard extends StatelessWidget {
  final Widget child;

  const _WCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}

// ── Line chart painter ─────────────────────────────────────────────────────────

class _LineChartPainter extends CustomPainter {
  final List<List<double>> series;
  final List<Color> colors;

  const _LineChartPainter({required this.series, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    // Grid
    final gridPaint = Paint()
      ..color = const Color(0xFFEEEAE4)
      ..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final y = size.height * (1 - i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final allValues = series.expand((s) => s).where((v) => v > 0);
    final maxV = allValues.isEmpty ? 1.0 : allValues.reduce(max);

    for (int s = 0; s < series.length; s++) {
      final data = series[s];
      final color = colors[s];
      final n = data.length;

      final linePaint = Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final dotPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      final path = Path();
      bool started = false;

      for (int i = 0; i < n; i++) {
        final x = n == 1 ? size.width / 2 : size.width * i / (n - 1);
        final y = size.height * (1 - (data[i] / maxV).clamp(0, 1));
        if (!started) {
          path.moveTo(x, y);
          started = true;
        } else {
          path.lineTo(x, y);
        }
        canvas.drawCircle(Offset(x, y), 3.5, dotPaint);
      }
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter old) =>
      old.series != series || old.colors != colors;
}

// ── Bar chart painter ──────────────────────────────────────────────────────────

class _BarChartPainter extends CustomPainter {
  final List<int> data;
  final Color color;

  const _BarChartPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final maxV = data.reduce(max).toDouble();
    if (maxV == 0) return;

    final slotW = size.width / data.length;
    final barW = slotW * 0.5;

    final paint = Paint()..color = color..style = PaintingStyle.fill;
    const rr = Radius.circular(4);

    for (int i = 0; i < data.length; i++) {
      if (data[i] == 0) continue;
      final x = slotW * i + (slotW - barW) / 2;
      final barH = size.height * data[i] / maxV;
      final y = size.height - barH;
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, y, barW, barH), rr),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_BarChartPainter old) =>
      old.data != data || old.color != color;
}
