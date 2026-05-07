import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/localization/app_language.dart';
import '../auth/login_screen.dart';

class ParametrlerScreen extends StatefulWidget {
  const ParametrlerScreen({super.key});

  @override
  State<ParametrlerScreen> createState() => _ParametrlerScreenState();
}

class _ParametrlerScreenState extends State<ParametrlerScreen> {
  bool _darkMode = false;
  bool _reminder = true;
  bool _sms = true;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F3F7),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 32),
                children: [
                  _sectionLabel(context, 'GÖRÜNÜŞ'),
                  _buildSection([
                    _SettingRow(
                      icon: Icons.translate_rounded,
                      iconColor: const Color(0xFF1A5AD7),
                      iconBg: const Color(0xFFEAF1FF),
                      title: context.tr('Tətbiq dili'),
                      subtitle: context.tr('İnterfeys dili'),
                      trailing: _LangValue(language: context.language.label),
                      onTap: _showLanguagePicker,
                    ),
                    const _Divider(),
                    _SettingRow(
                      icon: Icons.dark_mode_outlined,
                      iconColor: const Color(0xFF6F8197),
                      iconBg: const Color(0xFFF4F6FA),
                      title: context.tr('Tünd tema'),
                      subtitle: context.tr('Dark mode aktivdir'),
                      trailing: _buildSwitch(
                        _darkMode,
                        (v) => setState(() => _darkMode = v),
                      ),
                    ),
                  ]),
                  _sectionLabel(context, 'BİLDİRİŞLƏR'),
                  _buildSection([
                    _SettingRow(
                      icon: Icons.notifications_none_rounded,
                      iconColor: const Color(0xFF1A5AD7),
                      iconBg: const Color(0xFFEAF1FF),
                      title: context.tr('Növbə xatırlatması'),
                      subtitle: context.tr('1 gün əvvəl bildiriş'),
                      trailing: _buildSwitch(
                        _reminder,
                        (v) => setState(() => _reminder = v),
                      ),
                    ),
                    const _Divider(),
                    _SettingRow(
                      icon: Icons.sms_outlined,
                      iconColor: const Color(0xFF1A5AD7),
                      iconBg: const Color(0xFFEAF1FF),
                      title: context.tr('SMS bildirişi'),
                      subtitle: context.tr('Nömrənizə SMS'),
                      trailing: _buildSwitch(
                        _sms,
                        (v) => setState(() => _sms = v),
                      ),
                    ),
                  ]),
                  _sectionLabel(context, 'HESAB'),
                  _buildSection([
                    _SettingRow(
                      icon: Icons.logout_rounded,
                      iconColor: const Color(0xFFE53935),
                      iconBg: const Color(0xFFFFEAEA),
                      title: context.tr('Çıxış Et'),
                      titleColor: const Color(0xFFE53935),
                      subtitle: context.tr('Hesabdan çıxış'),
                      subtitleColor: const Color(0xFFE57373),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFFE53935),
                        size: 24,
                      ),
                      onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (_) => false,
                      ),
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
      color: const Color(0xFF071427),
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
                color: const Color(0xFF162336),
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
      padding: const EdgeInsets.fromLTRB(20, 18, 16, 8),
      child: Text(
        context.tr(text),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: Color(0xFF8B98AA),
        ),
      ),
    );
  }

  Widget _buildSection(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitch(bool value, ValueChanged<bool> onChanged) {
    return Transform.scale(
      scale: 0.88,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        activeTrackColor: const Color(0xFF1A5AD7),
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: const Color(0xFFD0D9E6),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(13),
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
                      color: titleColor ?? const Color(0xFF06152B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: subtitleColor ?? const Color(0xFF8B98AA),
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
            color: Color(0xFF1A5AD7),
          ),
        ),
        const SizedBox(width: 2),
        const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF1A5AD7),
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
      margin: const EdgeInsets.only(left: 74),
      height: 0.5,
      color: const Color(0xFFEDF0F5),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                context.tr('Dil Seçin'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF06152B),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F3F7),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: Color(0xFF6F8197),
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
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFEAF1FF) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF9FBFFF)
                        : const Color(0xFFE8ECF2),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1A5AD7)
                            : const Color(0xFFF0F3F7),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        language.code,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF6F8197),
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
                              ? const Color(0xFF1A5AD7)
                              : const Color(0xFF06152B),
                        ),
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1A5AD7),
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
                            color: const Color(0xFFD0D9E6),
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
