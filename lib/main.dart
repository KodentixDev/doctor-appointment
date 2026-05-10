import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/localization/app_language.dart';
import 'features/splash/splash_screen.dart';

final appLanguageController = AppLanguageController();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(
    AppLanguageScope(
      controller: appLanguageController,
      child: const HekimNovbeApp(),
    ),
  );
}

class HekimNovbeApp extends StatelessWidget {
  const HekimNovbeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: context.tr('Həkim Növbə'),
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
