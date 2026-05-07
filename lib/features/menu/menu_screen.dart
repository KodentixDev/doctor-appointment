import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../auth/login_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  static const _items = [
    _MenuItem(
      'Ətrafdakı Xəstəxanalar',
      Icons.location_on_outlined,
      AppColors.danger,
      AppColors.dangerLight,
      false,
    ),
    _MenuItem(
      'Favorilərim',
      Icons.star_border_rounded,
      AppColors.amber,
      AppColors.amberLight,
      false,
    ),
    _MenuItem(
      'Həkimlər',
      Icons.medical_services_outlined,
      AppColors.primary,
      AppColors.primaryLight,
      false,
    ),
    _MenuItem(
      'Vəkil Olduqlarım',
      Icons.group_outlined,
      AppColors.primary,
      AppColors.primaryLight,
      false,
    ),
    _MenuItem(
      'Ayarlar',
      Icons.settings_outlined,
      AppColors.textMuted,
      AppColors.bgSubtle,
      false,
    ),
    _MenuItem(
      'Profilim',
      Icons.person_2_outlined,
      AppColors.textMuted,
      AppColors.bgSubtle,
      false,
    ),
    _MenuItem(
      'Haqqımızda',
      Icons.info_outline,
      AppColors.textMuted,
      AppColors.bgSubtle,
      false,
    ),
    _MenuItem(
      'Çıxış Yap',
      Icons.logout_rounded,
      AppColors.danger,
      AppColors.dangerLight,
      true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.35,
                ),
                itemCount: _items.length,
                itemBuilder: (ctx, i) {
                  final item = _items[i];
                  return GestureDetector(
                    onTap: item.isDanger
                        ? () => Navigator.pushAndRemoveUntil(
                            ctx,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (_) => false,
                          )
                        : () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: item.isDanger
                              ? const Color(0xFFFAE0DE)
                              : AppColors.border,
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: item.iconBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              item.icon,
                              color: item.iconColor,
                              size: 20,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.1,
                              color: item.isDanger
                                  ? AppColors.danger
                                  : AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.bgDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        bottom: 22,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MENÜ',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              color: Color(0xFF2A4060),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.07),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'MG',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Mahammad Gardaşov',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'FIN: ••• ••• ••',
                    style: TextStyle(fontSize: 11, color: Color(0xFF3A5070)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final String label;
  final IconData icon;
  final Color iconColor, iconBg;
  final bool isDanger;
  const _MenuItem(
    this.label,
    this.icon,
    this.iconColor,
    this.iconBg,
    this.isDanger,
  );
}
