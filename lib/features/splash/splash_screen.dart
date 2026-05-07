import 'package:flutter/material.dart';
import '../../core/localization/app_language.dart';
import '../auth/login_screen.dart';
import '../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _barAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );
    _barAnim = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
    );
    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Logo
              ScaleTransition(
                scale: _scaleAnim,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.bgDarkMid,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: AppColors.bgDarkBorder,
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.medical_services_rounded,
                      color: AppColors.primaryMid,
                      size: 54,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // App name
              FadeTransition(
                opacity: _fadeAnim,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                      height: 1,
                    ),
                    children: [
                      TextSpan(
                        text: context.tr('Həkim '),
                        style: const TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: context.tr('Növbə'),
                        style: const TextStyle(color: AppColors.primaryMid),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeTransition(
                opacity: _fadeAnim,
                child: Text(
                  context.tr('Mərkəzi həkim növbə sistemi').toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                    color: Color(0xFF3A5070),
                  ),
                ),
              ),
              const Spacer(flex: 2),
              // Progress bar
              FadeTransition(
                opacity: _fadeAnim,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      height: 3,
                      color: AppColors.bgDarkBorder,
                      child: AnimatedBuilder(
                        animation: _barAnim,
                        builder: (_, __) => FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _barAnim.value,
                          child: Container(color: AppColors.primaryMid),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const SizedBox.shrink(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
