import 'package:go_router/go_router.dart';

import 'package:art_critique/features/critique/presentation/pages/critique_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CritiquePage(),
    ),
  ],
);
