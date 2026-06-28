import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Date Formatting for Spanish locale
  await initializeDateFormatting('es', null);

  // Set system UI overlay style for premium dark look
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0F1117),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Firebase using native configuration files (google-services.json & GoogleService-Info.plist)
  await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: NutrifitApp(),
    ),
  );
}
