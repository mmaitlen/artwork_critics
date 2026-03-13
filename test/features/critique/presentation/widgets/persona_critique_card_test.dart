import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:art_critique/features/critique/domain/entities/persona_critique.dart';
import 'package:art_critique/features/critique/domain/entities/persona_id.dart';
import 'package:art_critique/features/critique/presentation/widgets/persona_critique_card.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: child));

void main() {
  group('PersonaCritiqueCard', () {
    test('PersonaId labels are correct', () {
      expect(PersonaId.buyer.label, 'The Buyer');
      expect(PersonaId.admirer.label, 'The Admirer');
      expect(PersonaId.skeptic.label, 'The Skeptic');
    });

    testWidgets('shows persona label', (tester) async {
      await tester.pumpWidget(
        _wrap(const PersonaCritiqueCard(personaId: PersonaId.buyer)),
      );
      expect(find.text('The Buyer'), findsOneWidget);
    });

    testWidgets('shows loading shimmer when isLoading is true', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PersonaCritiqueCard(
            personaId: PersonaId.admirer,
            isLoading: true,
          ),
        ),
      );
      expect(find.byType(FractionallySizedBox), findsWidgets);
      expect(find.text('Upload an artwork to receive a critique.'), findsNothing);
    });

    testWidgets('shows critique text when loaded', (tester) async {
      const critique = PersonaCritique(
        personaId: PersonaId.skeptic,
        critiqueText: 'My 5th grader could do that.',
      );
      await tester.pumpWidget(
        _wrap(
          const PersonaCritiqueCard(
            personaId: PersonaId.skeptic,
            critique: critique,
          ),
        ),
      );
      expect(find.text('My 5th grader could do that.'), findsOneWidget);
    });

    testWidgets('shows error message on error', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PersonaCritiqueCard(
            personaId: PersonaId.buyer,
            error: 'network failure',
          ),
        ),
      );
      expect(find.text('Unable to generate critique.'), findsOneWidget);
    });

    testWidgets('shows placeholder when idle', (tester) async {
      await tester.pumpWidget(
        _wrap(const PersonaCritiqueCard(personaId: PersonaId.admirer)),
      );
      expect(
        find.text('Upload an artwork to receive a critique.'),
        findsOneWidget,
      );
    });
  });
}
