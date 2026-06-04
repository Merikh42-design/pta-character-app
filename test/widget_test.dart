import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pta_character_app/app.dart';

void main() {
  testWidgets('ABC wizard loads and shows creation steps', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: PtaApp()),
    );

    expect(find.text('Create Character - ABC Wizard'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Step 1: Choose Your Class'), findsOneWidget);
    expect(find.text('Class'), findsWidgets);
    expect(find.text('Next'), findsOneWidget);
  });
}