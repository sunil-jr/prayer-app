import 'package:flutter_test/flutter_test.dart';
import 'package:sg/app.dart';

void main() {
  testWidgets('App renders home screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SoulGraceApp());
    await tester.pump();
    expect(find.byType(SoulGraceApp), findsOneWidget);
  });
}
