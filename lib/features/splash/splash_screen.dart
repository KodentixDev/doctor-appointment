import 'package:flutter/material.dart';
import '../../core/localization/app_language.dart';
import '../../core/models/account_user.dart';
import '../../core/models/app_user_role.dart';
import '../auth/login_screen.dart';
import '../auth/data/accounts_api.dart';
import '../doctor/doctor_home_screen.dart';
import '../home/home_screen.dart';

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
  final _accountsApi = AccountsApi();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _fadeAnim = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
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

    Future.delayed(const Duration(milliseconds: 2200), () async {
      if (!mounted) return;
      try {
        final user = await _accountsApi.me();
        if (!mounted) return;
        _openRoleHome(user);
      } catch (_) {
        await _accountsApi.clearSession();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  void _openRoleHome(AccountUser user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => user.role == AppUserRole.doctor
            ? DoctorHomeScreen(user: user)
            : HomeScreen(user: user),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF040E1C), Color(0xFF091F3C), Color(0xFF0D2A50)],
          ),
        ),
        child: SafeArea(
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
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x441B4FD8),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset('assets/logo.png', fit: BoxFit.cover),
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
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
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
                          style: const TextStyle(color: Color(0xFF2563EB)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Subtitle
                FadeTransition(
                  opacity: _fadeAnim,
                  child: Text(
                    context.tr('Mərkəzi həkim növbə sistemi').toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                      color: Color(0xFF3A6090),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                // Progress bar
                FadeTransition(
                  opacity: _fadeAnim,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      height: 3,
                      width: 120,
                      color: const Color(0xFF1B3D70),
                      child: AnimatedBuilder(
                        animation: _barAnim,
                        builder: (_, _) => FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _barAnim.value,
                          child: Container(color: const Color(0xFF2563EB)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
