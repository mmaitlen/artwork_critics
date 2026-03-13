import 'package:flutter/material.dart';

import 'package:art_critique/core/di/injection.dart';
import 'package:art_critique/core/router/app_router.dart';

void main() {
  configureDependencies();
  runApp(const ArtCritiqueApp());
}

class ArtCritiqueApp extends StatelessWidget {
  const ArtCritiqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Art Critique',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
