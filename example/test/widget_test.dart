import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_icon_plus_example/main.dart';

void main() {
  testWidgets('Renders DynamicIconExampleApp without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const DynamicIconExampleApp());
    expect(find.text('🎭 DynamicIconPlus Demo'), findsOneWidget);
  });
}
