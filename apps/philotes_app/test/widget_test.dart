import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/main.dart';

void main() {
  testWidgets('Philotes welcome screen smoke test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PhilotesApp());

    expect(find.text('PHILOTES'), findsOneWidget);
    expect(find.text('A COMMUNITY FOR FRIENDSHIP'), findsOneWidget);
    expect(find.text('Join the Community'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);

    expect(find.text('BROUGHT TO YOU BY'), findsOneWidget);
    expect(find.text('TITAN'), findsOneWidget);
  });
}
