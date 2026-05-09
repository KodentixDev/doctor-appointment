import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_language.dart';
import '../../core/models/app_user_role.dart';

class MessagesScreen extends StatefulWidget {
  final AppUserRole role;

  const MessagesScreen({
    super.key,
    this.role = AppUserRole.patient,
  });

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int _filter = 0;

  static const _patientConversations = [
    _ConversationData(
      initials: 'NA',
      name: 'Dr. Nigar Abbasova',
      roleLabel: 'Kardioloq',
      lastMessage:
          'Analiz cavablar\u{0131}n\u{0131}z\u{0131} g\u{00F6}r\u{00FC}r\u{0259}m, n\u{00F6}vb\u{0259} g\u{00FC}n\u{00FC} m\u{00FC}tl\u{0259}q g\u{0259}lin.',
      time: '10:24',
      unread: 2,
      accent: AppColors.primary,
      appointment: '8 May 2026, 09:30',
    ),
    _ConversationData(
      initials: 'LH',
      name: 'Dr. Leyla H\u{0259}s\u{0259}nova',
      roleLabel: 'Nevroloq',
      lastMessage: 'Qeyd etdiyiniz \u{015F}ikay\u{0259}tl\u{0259}ri konsultasiyada m\u{00FC}zakir\u{0259} ed\u{0259}c\u{0259}yik.',
      time: 'D\u{00FC}n\u{0259}n',
      unread: 0,
      accent: AppColors.success,
      appointment: '15 May 2026, 14:00',
    ),
  ];

  static const _doctorConversations = [
    _ConversationData(
      initials: 'MG',
      name: 'M\u{0259}h\u{0259}mm\u{0259}d Qarda\u{015F}ov',
      roleLabel: 'Pasiyent',
      lastMessage:
          'Salam doktor, randevudan \u{0259}vv\u{0259}l analiz cavablar\u{0131}n\u{0131} g\u{00F6}nd\u{0259}rim?',
      time: '09:48',
      unread: 1,
      accent: AppColors.primary,
      appointment: 'Bug\u{00FC}n, 09:30',
    ),
    _ConversationData(
      initials: 'SA',
      name: 'S\u{0259}bin\u{0259} Al\u{0131}yeva',
      roleLabel: 'Pasiyent',
      lastMessage: 'N\u{00F6}vb\u{0259} vaxt\u{0131}n\u{0131} 30 d\u{0259}qiq\u{0259} gecikdirm\u{0259}k m\u{00FC}mk\u{00FC}nd\u{00FC}r?',
      time: '08:12',
      unread: 3,
      accent: AppColors.amber,
      appointment: 'Bug\u{00FC}n, 11:00',
    ),
    _ConversationData(
      initials: 'EO',
      name: 'Elvin Orucov',
      roleLabel: 'Pasiyent',
      lastMessage: 'T\u{0259}\u{015F}\u{0259}kk\u{00FC}r edir\u{0259}m.',
      time: '7 May',
      unread: 0,
      accent: AppColors.success,
      appointment: '10 May 2026, 16:15',
    ),
  ];

  List<_ConversationData> get _items {
    final source = widget.role == AppUserRole.doctor
        ? _doctorConversations
        : _patientConversations;
    if (_filter == 1) {
      return source.where((item) => item.unread > 0).toList();
    }
    return source;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        body: Column(
          children: [
            _buildHeader(context),
            _buildFilters(context),
            Expanded(
              child: _items.isEmpty ? _buildEmpty(context) : _buildList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final subtitle = widget.role == AppUserRole.doctor
        ? 'Pasiyentl\u{0259}rl\u{0259} yaz\u{0131}\u{015F}malar'
        : 'H\u{0259}kiml\u{0259}rl\u{0259} yaz\u{0131}\u{015F}malar';

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
                  context.tr('Mesajlar'),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryMid,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.tr(subtitle),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8FAAC7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surface600,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.edit_note_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    final filters = [
      context.tr('Ham\u{0131}s\u{0131}'),
      context.tr('Oxunmam\u{0131}\u{015F}'),
    ];

    return Container(
      color: AppColors.bgPage,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        children: List.generate(filters.length, (index) {
          final selected = _filter == index;
          return Padding(
            padding: EdgeInsets.only(right: index == 0 ? 8 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _filter = index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Text(
                  filters[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: selected ? Colors.white : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return _ConversationCard(
          item: item,
          onTap: () => _showConversation(context, item),
        );
      },
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.mark_chat_read_outlined,
            size: 48,
            color: AppColors.textDimmed,
          ),
          const SizedBox(height: 12),
          Text(
            context.tr('Oxunmam\u{0131}\u{015F} mesaj yoxdur'),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  void _showConversation(BuildContext context, _ConversationData item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.82,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                child: Row(
                  children: [
                    _Avatar(item: item, size: 46),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.appointment,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.border),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
                  children: [
                    _MessageBubble(
                      text: item.lastMessage,
                      isMine: false,
                    ),
                    _MessageBubble(
                      text: widget.role == AppUserRole.doctor
                          ? 'Cavab\u{0131}n\u{0131}z\u{0131} burada yaz\u{0131}b pasiyent\u{0259} g\u{00F6}nd\u{0259}r\u{0259} bil\u{0259}rsiniz.'
                          : 'Mesaj\u{0131}n\u{0131}z\u{0131} burada yaz\u{0131}b h\u{0259}kim\u{0259} g\u{00F6}nd\u{0259}r\u{0259} bil\u{0259}rsiniz.',
                      isMine: true,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: context.tr('Mesaj yaz\u{0131}n...'),
                          filled: true,
                          fillColor: AppColors.bgSubtle,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.tr('Mesaj g\u{00F6}nd\u{0259}rildi'),
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.primaryGradient,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConversationCard extends StatelessWidget {
  final _ConversationData item;
  final VoidCallback onTap;

  const _ConversationCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            _Avatar(item: item, size: 52),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        item.time,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.roleLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.lastMessage,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted,
                            height: 1.25,
                          ),
                        ),
                      ),
                      if (item.unread > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          constraints: const BoxConstraints(minWidth: 24),
                          height: 24,
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.danger,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${item.unread}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
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

class _Avatar extends StatelessWidget {
  final _ConversationData item;
  final double size;

  const _Avatar({
    required this.item,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: item.accent,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      alignment: Alignment.center,
      child: Text(
        item.initials,
        style: TextStyle(
          fontSize: size * 0.32,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isMine;

  const _MessageBubble({
    required this.text,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primary : AppColors.bgSubtle,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isMine ? const Radius.circular(4) : null,
            bottomLeft: isMine ? null : const Radius.circular(4),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isMine ? Colors.white : AppColors.textSub,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}

class _ConversationData {
  final String initials;
  final String name;
  final String roleLabel;
  final String lastMessage;
  final String time;
  final int unread;
  final Color accent;
  final String appointment;

  const _ConversationData({
    required this.initials,
    required this.name,
    required this.roleLabel,
    required this.lastMessage,
    required this.time,
    required this.unread,
    required this.accent,
    required this.appointment,
  });
}
