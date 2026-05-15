import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import '../../core/localization/app_language.dart';
import '../../core/models/app_user_role.dart';
import '../../core/network/api_exception.dart';
import 'data/notifications_api.dart';

class NotificationsScreen extends StatefulWidget {
  final AppUserRole role;

  const NotificationsScreen({super.key, this.role = AppUserRole.citizen});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _api = NotificationsApi();

  List<AppNotification> _items = [];
  bool _loading = true;
  String? _error;
  bool _markingAll = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await _api.list();
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = context.tr('Bildirişlər yüklənmədi');
        _loading = false;
      });
    }
  }

  Future<void> _markAllRead() async {
    if (_markingAll) return;
    setState(() => _markingAll = true);
    try {
      await _api.markAllRead();
      if (!mounted) return;
      setState(() {
        for (final n in _items) {
          n.isRead = true;
        }
      });
    } catch (_) {
      // Silently update local state even if API fails
      if (mounted) {
        setState(() {
          for (final n in _items) {
            n.isRead = true;
          }
        });
      }
    } finally {
      if (mounted) setState(() => _markingAll = false);
    }
  }

  Future<void> _markRead(AppNotification item) async {
    if (item.isRead) return;
    setState(() => item.isRead = true);
    try {
      await _api.markRead(item.id);
    } catch (_) {
      // Local state already updated; ignore API errors
    }
  }

  int get _unreadCount => _items.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        body: RefreshIndicator(
          onRefresh: _load,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context)),
              if (!_loading && _error == null) ...[
                SliverToBoxAdapter(child: _buildSummary(context)),
                if (_items.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmpty(context),
                  )
                else
                  SliverList.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, i) => _NotificationCard(
                      item: _items[i],
                      onTap: () => _markRead(_items[i]),
                    ),
                  ),
              ] else if (_loading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildError(context),
                ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
            ],
          ),
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
                  context.tr('Bildirişlər'),
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
                        ? 'Həkim hesabı üçün xəbərdarlıqlar'
                        : 'Randevu və mesaj xəbərdarlıqları',
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
          if (!_loading && _unreadCount > 0)
            GestureDetector(
              onTap: _markingAll ? null : _markAllRead,
              child: AnimatedOpacity(
                opacity: _markingAll ? 0.5 : 1.0,
                duration: const Duration(milliseconds: 200),
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
                    context.tr('Hamısı oxundu'),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
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
              label: context.tr('Oxunmamış'),
              color: AppColors.danger,
              bg: AppColors.dangerLight,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SummaryBox(
              value: '${_items.length}',
              label: context.tr('Bütün bildirişlər'),
              color: AppColors.primary,
              bg: AppColors.primaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            size: 52,
            color: AppColors.textDimmed,
          ),
          const SizedBox(height: 14),
          Text(
            context.tr('Bildiriş yoxdur'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            size: 44,
            color: AppColors.textDimmed,
          ),
          const SizedBox(height: 12),
          Text(
            _error ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _load,
            child: Text(context.tr('Yenidən cəhd et')),
          ),
        ],
      ),
    );
  }
}

// ── Notification Card ─────────────────────────────────────────────────────────

class _NotificationCard extends StatelessWidget {
  final AppNotification item;
  final VoidCallback onTap;

  const _NotificationCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final unread = !item.isRead;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: unread ? AppColors.primaryBorder : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: unread ? 0.05 : 0.02),
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
                color: _bgColor(item.notificationType),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _icon(item.notificationType),
                color: _fgColor(item.notificationType),
                size: 25,
              ),
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
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: unread
                                ? FontWeight.w900
                                : FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (unread)
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
                    item.body,
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
                    _formatTime(item.createdAt),
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

  static IconData _icon(String type) => switch (type) {
    'appointment_confirmed' => Icons.event_available_outlined,
    'appointment_cancelled' => Icons.event_busy_outlined,
    'appointment_completed' => Icons.done_all_rounded,
    'prescription_ready' => Icons.description_outlined,
    'waitlist_slot_available' => Icons.alarm_rounded,
    _ => Icons.notifications_outlined,
  };

  static Color _fgColor(String type) => switch (type) {
    'appointment_confirmed' => AppColors.success,
    'appointment_cancelled' => AppColors.danger,
    'appointment_completed' => AppColors.primary,
    'prescription_ready' => const Color(0xFF0369A1),
    'waitlist_slot_available' => AppColors.amber,
    _ => AppColors.textMuted,
  };

  static Color _bgColor(String type) => switch (type) {
    'appointment_confirmed' => AppColors.successLight,
    'appointment_cancelled' => AppColors.dangerLight,
    'appointment_completed' => AppColors.primaryLight,
    'prescription_ready' => const Color(0xFFE0F2FE),
    'waitlist_slot_available' => AppColors.amberLight,
    _ => AppColors.bgSubtle,
  };

  static String _formatTime(String iso) {
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'İndicə';
    if (diff.inMinutes < 60) return '${diff.inMinutes} dəq əvvəl';
    if (diff.inHours < 24) return '${diff.inHours} saat əvvəl';
    if (diff.inDays == 1) return 'Dünən';
    if (diff.inDays < 7) return '${diff.inDays} gün əvvəl';
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
  }
}

// ── Summary Box ───────────────────────────────────────────────────────────────

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
