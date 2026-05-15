import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import '../../core/localization/app_language.dart';
import '../hospitals/data/hospitals_api.dart';

class DoctorSchedulesScreen extends StatefulWidget {
  const DoctorSchedulesScreen({super.key});

  @override
  State<DoctorSchedulesScreen> createState() => _DoctorSchedulesScreenState();
}

class _DoctorSchedulesScreenState extends State<DoctorSchedulesScreen> {
  final _api = HospitalsApi();

  List<HospitalTimeSlot> _slots = [];
  bool _loading = true;
  String? _error;

  static const _weekdays = [
    'Bazar ertəsi',
    'Çərşənbə axşamı',
    'Çərşənbə',
    'Cümə axşamı',
    'Cümə',
    'Şənbə',
    'Bazar',
  ];

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
      final slots = await _api.doctorSchedules();
      slots.sort((a, b) {
        final day = a.weekday.compareTo(b.weekday);
        if (day != 0) return day;
        return a.startTime.compareTo(b.startTime);
      });
      if (!mounted) return;
      setState(() {
        _slots = slots;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _showSlotDialog({HospitalTimeSlot? slot}) async {
    var weekday = slot?.weekday ?? 0;
    final start = TextEditingController(
      text: slot == null ? '09:00' : _shortTime(slot.startTime),
    );
    final end = TextEditingController(
      text: slot == null ? '09:30' : _shortTime(slot.endTime),
    );
    final successMessage = context.tr(
      slot == null ? 'Vaxt aralığı əlavə edildi' : 'Vaxt aralığı yeniləndi',
    );

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(context.tr(slot == null ? 'Yeni vaxt' : 'Vaxtı yenilə')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                initialValue: weekday,
                decoration: InputDecoration(
                  labelText: context.tr('Həftə günü'),
                ),
                items: List.generate(
                  _weekdays.length,
                  (index) => DropdownMenuItem(
                    value: index,
                    child: Text(context.tr(_weekdays[index])),
                  ),
                ),
                onChanged: (value) {
                  if (value == null) return;
                  setDialogState(() => weekday = value);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: start,
                decoration: InputDecoration(
                  labelText: context.tr('Başlama'),
                  hintText: '09:00',
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: end,
                decoration: InputDecoration(
                  labelText: context.tr('Bitmə'),
                  hintText: '09:30',
                ),
                keyboardType: TextInputType.datetime,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(context.tr('Ləğv et')),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(context.tr(slot == null ? 'Yarat' : 'Yenilə')),
            ),
          ],
        ),
      ),
    );

    if (saved != true) return;

    try {
      if (slot == null) {
        await _api.createDoctorSchedule(
          weekday: weekday,
          startTime: start.text,
          endTime: end.text,
        );
      } else {
        await _api.updateDoctorSchedule(
          id: slot.id,
          weekday: weekday,
          startTime: start.text,
          endTime: end.text,
        );
      }
      _showSnack(successMessage);
      await _load();
    } catch (e) {
      _showSnack(e.toString(), isError: true);
    }
  }

  Future<void> _deleteSlot(HospitalTimeSlot slot) async {
    final deletedMessage = context.tr('Vaxt aralığı silindi');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('Vaxt aralığı silinsin?')),
        content: Text('${context.tr(slot.weekdayDisplay)}  ${slot.shortRange}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.tr('Ləğv et')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: Text(context.tr('Sil')),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _api.deleteDoctorSchedule(slot.id);
      _showSnack(deletedMessage);
      await _load();
    } catch (e) {
      _showSnack(e.toString(), isError: true);
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.danger : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _shortTime(String value) {
    if (value.length >= 5) return value.substring(0, 5);
    return value;
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
            _Header(onAdd: () => _showSlotDialog()),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 46,
              color: AppColors.textDimmed,
            ),
            const SizedBox(height: 12),
            Text(
              context.tr('Xəta baş verdi'),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _load,
              child: Text(context.tr('Yenidən cəhd et')),
            ),
          ],
        ),
      );
    }
    if (_slots.isEmpty) {
      return Center(
        child: Text(
          context.tr('Cədvəl yoxdur'),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        itemCount: _slots.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final slot = _slots[index];
          return _ScheduleTile(
            slot: slot,
            onEdit: () => _showSlotDialog(slot: slot),
            onDelete: () => _deleteSlot(slot),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onAdd;

  const _Header({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.headerGradient,
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 14,
        16,
        18,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('İş qrafiki'),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                Text(
                  context.tr('Həftəlik vaxt aralıqları'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFBFD7F8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onAdd,
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _ScheduleTile extends StatelessWidget {
  final HospitalTimeSlot slot;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ScheduleTile({
    required this.slot,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.schedule_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(slot.weekdayDisplay),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  slot.shortRange,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: AppColors.danger),
          ),
        ],
      ),
    );
  }
}
