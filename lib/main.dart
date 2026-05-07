import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const HekimNovbeApp());
}

class HekimNovbeApp extends StatelessWidget {
  const HekimNovbeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HəkimNövbə',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFFF2F4F7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1746A2),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: const SplashScreen(),
    );
  }
}
