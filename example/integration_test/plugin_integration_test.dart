import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dynamic_icon_plus/dynamic_icon_plus.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('supportsAlternateIcons integration test', (WidgetTester tester) async {
    final bool supported = await DynamicIconPlus.supportsAlternateIcons;
    expect(supported, isNotNull);
  });
}
