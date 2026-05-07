import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String _language = 'Azərbaycanca';

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
                  _sectionLabel('GÖRÜNÜŞ'),
                  _buildSection([
                    _SettingRow(
                      icon: Icons.translate_rounded,
                      iconColor: const Color(0xFF1A5AD7),
                      iconBg: const Color(0xFFEAF1FF),
                      title: 'Tətbiq dili',
                      subtitle: 'İnterfeys dili',
                      trailing: _LangValue(language: _language),
                      onTap: _showLanguagePicker,
                    ),
                    const _Divider(),
                    _SettingRow(
                      icon: Icons.dark_mode_outlined,
                      iconColor: const Color(0xFF6F8197),
                      iconBg: const Color(0xFFF4F6FA),
                      title: 'Tünd tema',
                      subtitle: 'Dark mode aktivdir',
                      trailing: _buildSwitch(_darkMode, (v) => setState(() => _darkMode = v)),
                    ),
                  ]),
                  _sectionLabel('BİLDİRİŞLƏR'),
                  _buildSection([
                    _SettingRow(
                      icon: Icons.notifications_none_rounded,
                      iconColor: const Color(0xFF1A5AD7),
                      iconBg: const Color(0xFFEAF1FF),
                      title: 'Növbə xatırlatması',
                      subtitle: '1 gün əvvəl bildiriş',
                      trailing: _buildSwitch(_reminder, (v) => setState(() => _reminder = v)),
                    ),
                    const _Divider(),
                    _SettingRow(
                      icon: Icons.sms_outlined,
                      iconColor: const Color(0xFF1A5AD7),
                      iconBg: const Color(0xFFEAF1FF),
                      title: 'SMS bildirişi',
                      subtitle: 'Nömrənizə SMS',
                      trailing: _buildSwitch(_sms, (v) => setState(() => _sms = v)),
                    ),
                  ]),
                  _sectionLabel('HESAB'),
                  _buildSection([
                    _SettingRow(
                      icon: Icons.logout_rounded,
                      iconColor: const Color(0xFFE53935),
                      iconBg: const Color(0xFFFFEAEA),
                      title: 'Çıxış Et',
                      titleColor: const Color(0xFFE53935),
                      subtitle: 'Hesabdan çıxış',
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
          const Expanded(
            child: Text(
              'Parametrlər',
              textAlign: TextAlign.center,
              style: TextStyle(
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

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 16, 8),
      child: Text(
        text,
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
      builder: (_) => _LanguagePicker(
        selected: _language,
        onSave: (lang) => setState(() => _language = lang),
      ),
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

class _LanguagePicker extends StatefulWidget {
  final String selected;
  final ValueChanged<String> onSave;

  const _LanguagePicker({required this.selected, required this.onSave});

  @override
  State<_LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<_LanguagePicker> {
  late String _sel;

  static const _langs = [
    ('AZ', 'Azərbaycanca', 'Azərbaycan'),
    ('RU', 'Русский', 'Rusiya'),
    ('GB', 'English', 'İngilis'),
  ];

  @override
  void initState() {
    super.initState();
    _sel = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
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
              const Text(
                'Dil Seçin',
                style: TextStyle(
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
          ..._langs.map((lang) {
            final isSelected = _sel == lang.$2;
            return GestureDetector(
              onTap: () => setState(() => _sel = lang.$2),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFEAF1FF)
                      : Colors.white,
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
                        lang.$1,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang.$2,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isSelected
                                  ? const Color(0xFF1A5AD7)
                                  : const Color(0xFF06152B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lang.$3,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF8B98AA),
                            ),
                          ),
                        ],
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
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                widget.onSave(_sel);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF071427),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Yadda Saxla',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
