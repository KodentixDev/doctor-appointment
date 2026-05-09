import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_language.dart';
import '../../core/models/app_user_role.dart';

class NotificationsScreen extends StatefulWidget {
  final AppUserRole role;

  const NotificationsScreen({
    super.key,
    this.role = AppUserRole.patient,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final List<bool> _readState;

  static const _patientItems = [
    _NotificationData(
      icon: Icons.event_available_outlined,
      iconColor: AppColors.success,
      iconBg: AppColors.successLight,
      title: 'N\u{00F6}vb\u{0259}niz t\u{0259}sdiql\u{0259}ndi',
      body:
          'Dr. Nigar Abbasova il\u{0259} 8 May 2026 saat 09:30 randevunuz aktivdir.',
      time: '5 d\u{0259}q \u{0259}vv\u{0259}l',
      unread: true,
    ),
    _NotificationData(
      icon: Icons.alarm_rounded,
      iconColor: AppColors.amber,
      iconBg: AppColors.amberLight,
      title: 'Randevu xat\u{0131}rlatmas\u{0131}',
      body: 'Sabah saat 14:00-da nevroloq q\u{0259}bulu planla\u{015F}d\u{0131}r\u{0131}l\u{0131}b.',
      time: '1 saat \u{0259}vv\u{0259}l',
      unread: true,
    ),
    _NotificationData(
      icon: Icons.chat_bubble_outline_rounded,
      iconColor: AppColors.primary,
      iconBg: AppColors.primaryLight,
      title: 'Yeni h\u{0259}kim mesaj\u{0131}',
      body: 'Dr. Leyla H\u{0259}s\u{0259}nova siz\u{0259} mesaj g\u{00F6}nd\u{0259}rdi.',
      time: 'D\u{00FC}n\u{0259}n',
      unread: false,
    ),
  ];

  static const _doctorItems = [
    _NotificationData(
      icon: Icons.person_add_alt_1_outlined,
      iconColor: AppColors.primary,
      iconBg: AppColors.primaryLight,
      title: 'Yeni randevu al\u{0131}nd\u{0131}',
      body: 'M\u{0259}h\u{0259}mm\u{0259}d Qarda\u{015F}ov bug\u{00FC}n saat 09:30 \u{00FC}\u{00E7}\u{00FC}n qeydiyyatdan ke\u{00E7}di.',
      time: '2 d\u{0259}q \u{0259}vv\u{0259}l',
      unread: true,
    ),
    _NotificationData(
      icon: Icons.warning_amber_rounded,
      iconColor: AppColors.amber,
      iconBg: AppColors.amberLight,
      title: 'Pasiyent gecikm\u{0259} sor\u{011F}usu g\u{00F6}nd\u{0259}rdi',
      body: 'S\u{0259}bin\u{0259} Al\u{0131}yeva n\u{00F6}vb\u{0259} vaxt\u{0131}n\u{0131} d\u{0259}yi\u{015F}m\u{0259}k ist\u{0259}yir.',
      time: '20 d\u{0259}q \u{0259}vv\u{0259}l',
      unread: true,
    ),
    _NotificationData(
      icon: Icons.done_all_rounded,
      iconColor: AppColors.success,
      iconBg: AppColors.successLight,
      title: 'G\u{00FC}nl\u{00FC}k plan yenil\u{0259}ndi',
      body: 'Bu g\u{00FC}n \u{00FC}\u{00E7}\u{00FC}n 6 aktiv q\u{0259}bul g\u{00F6}r\u{00FC}n\u{00FC}r.',
      time: '08:00',
      unread: false,
    ),
  ];

  List<_NotificationData> get _items =>
      widget.role == AppUserRole.doctor ? _doctorItems : _patientItems;

  @override
  void initState() {
    super.initState();
    _readState = _items.map((item) => !item.unread).toList();
  }

  int get _unreadCount => _readState.where((read) => !read).length;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: _buildSummary(context)),
            SliverList.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) => _NotificationCard(
                item: _items[index],
                read: _readState[index],
                onTap: () => setState(() => _readState[index] = true),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.headerGradient,
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 18,
        20,
        18,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('Bildiri\u{015F}l\u{0259}r'),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFFBBF24),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.tr(
                    widget.role == AppUserRole.doctor
                        ? 'H\u{0259}kim hesab\u{0131} \u{00FC}\u{00E7}\u{00FC}n xəbərdarlıqlar'
                        : 'Randevu v\u{0259} mesaj xəbərdarlıqları',
                  ),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8FAAC7),
                  ),
                ),
              ],
            ),
          ),
          if (_unreadCount > 0)
            GestureDetector(
              onTap: () => setState(() {
                for (var i = 0; i < _readState.length; i++) {
                  _readState[i] = true;
                }
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  context.tr('Ham\u{0131}s\u{0131} oxundu'),
                  style: const TextStyle(
                    fontSize: 12,
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

  Widget _buildSummary(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: _SummaryBox(
              value: '$_unreadCount',
              label: context.tr('Oxunmam\u{0131}\u{015F}'),
              color: AppColors.danger,
              bg: AppColors.dangerLight,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SummaryBox(
              value: '${_items.length}',
              label: context.tr('B\u{00FC}t\u{00FC}n bildiri\u{015F}l\u{0259}r'),
              color: AppColors.primary,
              bg: AppColors.primaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final _NotificationData item;
  final bool read;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.item,
    required this.read,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: read ? AppColors.border : AppColors.primaryBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: read ? 0.02 : 0.05),
              blurRadius: 14,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: item.iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 25),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          context.tr(item.title),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                read ? FontWeight.w800 : FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (!read)
                        Container(
                          width: 9,
                          height: 9,
                          margin: const EdgeInsets.only(top: 5, left: 8),
                          decoration: const BoxDecoration(
                            color: AppColors.danger,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.tr(item.body),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    context.tr(item.time),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final Color bg;

  const _SummaryBox({
    required this.value,
    required this.label,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationData {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String body;
  final String time;
  final bool unread;

  const _NotificationData({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.body,
    required this.time,
    required this.unread,
  });
}
