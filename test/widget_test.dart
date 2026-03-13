import 'package:flutter_test/flutter_test.dart';

import 'package:art_critique/core/di/injection.dart';
import 'package:art_critique/main.dart';

void main() {
  setUp(() {
    configureDependencies();
  });

  tearDown(() {
    sl.reset();
  });

  testWidgets('app renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const ArtCritiqueApp());
    expect(find.byType(ArtCritiqueApp), findsOneWidget);
  });
}
