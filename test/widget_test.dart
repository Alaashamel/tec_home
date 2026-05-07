// This is a placeholder test file for the HomeTec app.
// The app package name is 'hometec_frontend' (from pubspec.yaml).

import 'package:flutter_test/flutter_test.dart';
import 'package:hometec_frontend/main.dart';

void main() {
  testWidgets('App should render without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app starts
    expect(find.byType(MyApp), findsOneWidget);
  });
}
