import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';
import 'theme/philotes_colors.dart';

class PhilotesApp extends StatelessWidget {
  const PhilotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Philotes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: PhilotesColors.ivory,
        colorScheme: ColorScheme.fromSeed(
          seedColor: PhilotesColors.navy,
          primary: PhilotesColors.navy,
          secondary: PhilotesColors.gold,
          surface: PhilotesColors.ivory,
        ),
      ),
      home: const PhilotesWelcomeScreen(),
    );
  }
}
