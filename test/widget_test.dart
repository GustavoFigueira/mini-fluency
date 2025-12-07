import 'package:flutter_test/flutter_test.dart';

import 'package:mini_fluency/main.dart';

void main() {
  testWidgets('App renders path screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MiniFluencyApp());
    await tester.pump();

    expect(find.text('Carregando...'), findsOneWidget);
  });
}
