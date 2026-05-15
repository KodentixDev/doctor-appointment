import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/localization/app_language.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

final appLanguageController = AppLanguageController();
final appThemeController = AppThemeController();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Future.wait([
    appLanguageController.load(),
    appThemeController.load(),
  ]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(
    AppLanguageScope(
      controller: appLanguageController,
      child: AppThemeScope(
        controller: appThemeController,
        child: const HekimNovbeApp(),
      ),
    ),
  );
}

class HekimNovbeApp extends StatelessWidget {
  const HekimNovbeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appThemeController,
      builder: (context, _) => MaterialApp(
        title: context.tr('Həkim Növbə'),
        debugShowCheckedModeBanner: false,
        theme: HnTheme.light,
        darkTheme: HnTheme.dark,
        themeMode: appThemeController.themeMode,
        home: const SplashScreen(),
      ),
    );
  }
}
