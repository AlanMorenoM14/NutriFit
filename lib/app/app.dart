import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';

/// Root application widget.
class NutrifitApp extends ConsumerWidget {
  const NutrifitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'NutriFit',
      debugShowCheckedModeBanner: false,
      theme: NutrifitTheme.darkTheme,
      routerConfig: router,
    );
  }
}
