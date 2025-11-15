import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/main.dart';
import 'package:flutter_ecommerce/features/injection_container.dart' as di;

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await di.init();
  });

  testWidgets('App loads and shows login page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that login page is shown
    expect(find.text('E-Commerce'), findsWidgets);
  });
}
