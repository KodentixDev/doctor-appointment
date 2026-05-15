import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/localization/app_language.dart';
import '../../core/theme/app_theme.dart';
import '../auth/data/accounts_api.dart';
import '../auth/login_screen.dart';

class ParametrlerScreen extends StatefulWidget {
  const ParametrlerScreen({super.key});

  @override
  State<ParametrlerScreen> createState() => _ParametrlerScreenState();
}

class _ParametrlerScreenState extends State<ParametrlerScreen> {
  bool _reminder = true;
  final _accountsApi = AccountsApi();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F5FF),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 16, bottom: 40),
                children: [
                  _sectionLabel(context, 'GÖRÜNÜŞ'),
                  _buildSection([
                    _SettingRow(
                      icon: Icons.translate_rounded,
                      iconColor: const Color(0xFF1B4FD8),
                      iconBg: const Color(0xFFEFF6FF),
                      title: context.tr('Tətbiq dili'),
                      subtitle: context.tr('İnterfeys dili'),
                      trailing: _LangValue(language: context.language.label),
                      onTap: _showLanguagePicker,
                    ),
                    const _Divider(),
                    _SettingRow(
                      icon: Icons.dark_mode_outlined,
                      iconColor: context.isDark
                          ? const Color(0xFF60A5FA)
                          : const Color(0xFF7D93AB),
                      iconBg: context.isDark
                          ? const Color(0xFF1C2128)
                          : const Color(0xFFF5F8FF),
                      title: context.tr('Tünd tema'),
                      subtitle: context.tr(
                        context.isDark ? 'Dark mode aktiv' : 'Dark mode deaktiv',
                      ),
                      trailing: _buildSwitch(
                        context.isDark,
                        (v) => context.themeController.setDark(v),
                      ),
                    ),
                  ]),
                  _sectionLabel(context, 'BİLDİRİŞLƏR'),
                  _buildSection([
                    _SettingRow(
                      icon: Icons.notifications_none_rounded,
                      iconColor: const Color(0xFF1B4FD8),
                      iconBg: const Color(0xFFEFF6FF),
                      title: context.tr('Növbə xatırlatması'),
                      subtitle: context.tr('1 gün əvvəl bildiriş'),
                      trailing: _buildSwitch(
                        _reminder,
                        (v) => setState(() => _reminder = v),
                      ),
                    ),
                  ]),
                  _sectionLabel(context, 'HESAB'),
                  _buildSection([
                    _SettingRow(
                      icon: Icons.logout_rounded,
                      iconColor: const Color(0xFFD42B2B),
                      iconBg: const Color(0xFFFFECEC),
                      title: context.tr('Çıxış Et'),
                      titleColor: const Color(0xFFD42B2B),
                      subtitle: context.tr('Hesabdan çıxış'),
                      subtitleColor: const Color(0xFFD42B2B),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFFD42B2B),
                        size: 24,
                      ),
                      onTap: () async {
                        try {
                          await _accountsApi.logout();
                        } catch (_) {
                          await _accountsApi.clearSession();
                        }
                        if (!context.mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (_) => false,
                        );
                      },
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF040E1C), Color(0xFF0D2240)],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 14,
        16,
        22,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF132D54),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          Expanded(
            child: Text(
              context.tr('Parametrlər'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 16, 10),
      child: Text(
        context.tr(text),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: Color(0xFF7D93AB),
        ),
      ),
    );
  }

  Widget _buildSection(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(children: children),
    );
  }

  Widget _buildSwitch(bool value, ValueChanged<bool> onChanged) {
    return Transform.scale(
      scale: 0.9,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        activeTrackColor: const Color(0xFF1B4FD8),
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: const Color(0xFFCBD8E5),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _LanguagePicker(),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final Color? titleColor;
  final String subtitle;
  final Color? subtitleColor;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    this.titleColor,
    required this.subtitle,
    this.subtitleColor,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: titleColor ?? const Color(0xFF0B1829),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: subtitleColor ?? const Color(0xFF7D93AB),
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _LangValue extends StatelessWidget {
  final String language;

  const _LangValue({required this.language});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          language,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1B4FD8),
          ),
        ),
        const SizedBox(width: 2),
        const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF1B4FD8),
          size: 20,
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 76),
      height: 0.5,
      color: const Color(0xFFE8EFF8),
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker();

  @override
  Widget build(BuildContext context) {
    final selected = context.language;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        20 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E8F4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                context.tr('Dil Seçin'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0B1829),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F8FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: Color(0xFF7D93AB),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...AppLanguage.values.map((language) {
            final isSelected = selected == language;
            return GestureDetector(
              onTap: () {
                context.languageController.setLanguage(language);
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFBFD7F8)
                        : const Color(0xFFE8EFF8),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1B4FD8)
                            : const Color(0xFFF5F8FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        language.code,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF7D93AB),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        language.label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? const Color(0xFF1B4FD8)
                              : const Color(0xFF0B1829),
                        ),
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1B4FD8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      )
                    else
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFD8E4F0),
                            width: 2,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
