import 'package:flutter_test/flutter_test.dart';

import 'package:velora/main.dart';

void main() {
  testWidgets('App loads and navigates to home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const VeloraApp());

    // Advance past splash screen delay
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Verify that Home screen content is loaded.
    expect(find.text('Discover Your Signature Scent'), findsOneWidget);
  });
}
