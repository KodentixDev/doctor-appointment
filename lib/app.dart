import 'package:flutter/material.dart';
import 'features/splash/splash_screen.dart';

class HekimNovbeApp extends StatelessWidget {
  const HekimNovbeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HəkimNövbə',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B6BF0)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
