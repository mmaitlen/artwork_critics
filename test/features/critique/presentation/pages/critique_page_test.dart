import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:art_critique/features/critique/domain/entities/persona_critique.dart';
import 'package:art_critique/features/critique/domain/entities/persona_id.dart';
import 'package:art_critique/features/critique/presentation/bloc/critique_bloc.dart';
import 'package:art_critique/features/critique/presentation/bloc/critique_event.dart';
import 'package:art_critique/features/critique/presentation/bloc/critique_state.dart';
import 'package:art_critique/features/critique/presentation/pages/critique_page.dart';
import 'package:art_critique/features/critique/presentation/widgets/persona_critique_card.dart';

class MockCritiqueBloc extends MockBloc<CritiqueEvent, CritiqueState>
    implements CritiqueBloc {}

Widget _wrap(CritiqueBloc bloc) => MaterialApp(
      home: BlocProvider<CritiqueBloc>.value(
        value: bloc,
        child: const CritiqueView(),
      ),
    );

void main() {
  late MockCritiqueBloc mockBloc;

  final stubCritiques = PersonaId.values
      .map(
        (p) => PersonaCritique(
          personaId: p,
          critiqueText: '${p.label} critique text',
        ),
      )
      .toList();

  setUp(() {
    mockBloc = MockCritiqueBloc();
  });

  tearDown(() => mockBloc.close());

  testWidgets('initial state shows three idle persona cards', (tester) async {
    when(() => mockBloc.state).thenReturn(const CritiqueInitial());
    await tester.pumpWidget(_wrap(mockBloc));

    expect(find.byType(PersonaCritiqueCard), findsNWidgets(3));
    expect(
      find.text('Upload an artwork to receive a critique.'),
      findsNWidgets(3),
    );
  });

  testWidgets('loading state shows shimmer in each card', (tester) async {
    when(() => mockBloc.state).thenReturn(const CritiqueLoading());
    await tester.pumpWidget(_wrap(mockBloc));

    expect(find.byType(PersonaCritiqueCard), findsNWidgets(3));
    expect(find.byType(FractionallySizedBox), findsWidgets);
  });

  testWidgets('loaded state shows critique text in each card', (tester) async {
    when(() => mockBloc.state).thenReturn(CritiqueLoaded(stubCritiques));
    await tester.pumpWidget(_wrap(mockBloc));

    for (final critique in stubCritiques) {
      expect(find.text(critique.critiqueText), findsOneWidget);
    }
  });

  testWidgets('error state shows snackbar', (tester) async {
    when(() => mockBloc.state).thenReturn(const CritiqueInitial());
    whenListen(
      mockBloc,
      Stream.fromIterable([const CritiqueError('something went wrong')]),
    );

    await tester.pumpWidget(_wrap(mockBloc));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('something went wrong'), findsOneWidget);
  });
}
