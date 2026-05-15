import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_language.dart';
import '../../core/models/account_user.dart';
import '../../core/models/app_user_role.dart';
import '../../core/network/api_exception.dart';
import '../auth/data/accounts_api.dart';
import '../hospitals/data/hospitals_api.dart';

class MelumatlarimScreen extends StatefulWidget {
  final AccountUser? user;
  final AppUserRole role;

  const MelumatlarimScreen({
    super.key,
    this.user,
    this.role = AppUserRole.citizen,
  });

  @override
  State<MelumatlarimScreen> createState() => _MelumatlarimScreenState();
}

class _MelumatlarimScreenState extends State<MelumatlarimScreen> {
  late final Future<HospitalDoctor>? _doctorProfileFuture;
  final _accountsApi = AccountsApi();

  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _finCtrl;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _doctorProfileFuture = widget.role == AppUserRole.doctor
        ? HospitalsApi().doctorProfile()
        : null;
    _firstNameCtrl = TextEditingController(text: widget.user?.firstName ?? '');
    _lastNameCtrl = TextEditingController(text: widget.user?.lastName ?? '');
    _phoneCtrl = TextEditingController(text: widget.user?.phone ?? '');
    _finCtrl = TextEditingController(text: widget.user?.finCode ?? '');
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _finCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await _accountsApi.updateMe(
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        finCode: _finCtrl.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('Məlumatlarınız yadda saxlandı')),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('Yadda saxlamaq mümkün olmadı')),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F5FF),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  _buildProfileCard(context),
                  _sectionLabel(
                    context,
                    widget.role == AppUserRole.doctor
                        ? 'HƏKİM MƏLUMATLARİ'
                        : 'ŞƏXSİ MƏLUMATLAR',
                  ),
                  _buildPersonalInfo(context),
                  _sectionLabel(context, 'ƏLAQƏ MƏLUMATLARİ'),
                  _buildContactInfo(context),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildSaveButton(context),
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
              context.tr('Məlumatlarım'),
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

  Widget _buildProfileCard(BuildContext context) {
    final isDoctor = widget.role == AppUserRole.doctor;
    final firstLine = widget.user?.firstName.isNotEmpty == true
        ? widget.user!.firstName
        : context.tr(isDoctor ? 'Həkim' : 'Vətəndaş');
    final secondLine = widget.user?.lastName ?? '';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1B4FD8), Color(0xFF2563EB)],
              ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              widget.user?.initials ?? (isDoctor ? 'DR' : 'HN'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDoctor ? 'Dr. $firstLine' : firstLine,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0B1829),
                    height: 1.15,
                  ),
                ),
                if (secondLine.isNotEmpty)
                  Text(
                    secondLine,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0B1829),
                      height: 1.15,
                    ),
                  ),
                const SizedBox(height: 5),
                Text(
                  isDoctor
                      ? '${context.tr('Həkim hesabı')}  •  ${context.tr('Təsdiqlənib')}'
                      : 'FIN: ${widget.user?.finCode ?? '-'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7D93AB),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String key) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 10),
      child: Text(
        context.tr(key),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
          color: Color(0xFF7D93AB),
        ),
      ),
    );
  }

  Widget _buildPersonalInfo(BuildContext context) {
    if (widget.role == AppUserRole.doctor) {
      return FutureBuilder<HospitalDoctor>(
        future: _doctorProfileFuture,
        builder: (context, snapshot) {
          final profile = snapshot.data;
          return _InfoCard(
            children: [
              _EditableRow(
                icon: Icons.person_outline_rounded,
                label: context.tr('Ad'),
                controller: _firstNameCtrl,
              ),
              const _RowDivider(),
              _EditableRow(
                icon: Icons.person_outline_rounded,
                label: context.tr('Soyad'),
                controller: _lastNameCtrl,
              ),
              const _RowDivider(),
              _InfoRow(
                icon: Icons.medical_services_outlined,
                label: context.tr('İxtisas'),
                value: profile?.specialty.isNotEmpty == true
                    ? profile!.specialty
                    : snapshot.connectionState == ConnectionState.waiting
                    ? '...'
                    : '-',
              ),
              const _RowDivider(),
              _InfoRow(
                icon: Icons.apartment_outlined,
                label: context.tr('Bölmə'),
                value: profile?.departmentName.isNotEmpty == true
                    ? profile!.departmentName
                    : '-',
              ),
              const _RowDivider(),
              _InfoRow(
                icon: Icons.local_hospital_outlined,
                label: context.tr('İş yeri'),
                value: profile?.hospitalName.isNotEmpty == true
                    ? profile!.hospitalName
                    : '-',
              ),
            ],
          );
        },
      );
    }

    return _InfoCard(
      children: [
        _EditableRow(
          icon: Icons.person_outline_rounded,
          label: context.tr('Ad'),
          controller: _firstNameCtrl,
        ),
        const _RowDivider(),
        _EditableRow(
          icon: Icons.person_outline_rounded,
          label: context.tr('Soyad'),
          controller: _lastNameCtrl,
        ),
        const _RowDivider(),
        _InfoRow(
          icon: Icons.badge_outlined,
          label: 'FIN',
          value: widget.user?.finCode ?? '-',
          badge: context.tr('Təsdiqlənib'),
        ),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    if (widget.role == AppUserRole.doctor) {
      return FutureBuilder<HospitalDoctor>(
        future: _doctorProfileFuture,
        builder: (context, snapshot) {
          final profile = snapshot.data;
          return _InfoCard(
            children: [
              _EditableRow(
                icon: Icons.phone_outlined,
                label: context.tr('Mobil nömrə'),
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
              ),
              const _RowDivider(),
              _InfoRow(
                icon: Icons.email_outlined,
                label: context.tr('E-poçt'),
                value: profile?.email.isNotEmpty == true
                    ? profile!.email
                    : widget.user?.email ?? '-',
              ),
            ],
          );
        },
      );
    }

    return _InfoCard(
      children: [
        _EditableRow(
          icon: Icons.phone_outlined,
          label: context.tr('Mobil nömrə'),
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
        ),
        const _RowDivider(),
        _InfoRow(
          icon: Icons.email_outlined,
          label: context.tr('E-poçt'),
          value: widget.user?.email ?? '-',
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF0F5FF),
        boxShadow: [
          BoxShadow(
            color: Color(0x0E000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B4FD8), Color(0xFF2563EB)],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: ElevatedButton.icon(
            onPressed: _saving ? null : _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            icon: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save_outlined, size: 22),
            label: Text(
              context.tr('Yadda Saxla'),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Info Card wrapper ─────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(children: children),
    );
  }
}

// ── Editable Row ──────────────────────────────────────────────────────────────

class _EditableRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const _EditableRow({
    required this.icon,
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF1B4FD8), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7D93AB),
                  ),
                ),
                const SizedBox(height: 2),
                TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0B1829),
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.edit_outlined,
            color: Color(0xFFCBD8E5),
            size: 20,
          ),
        ],
      ),
    );
  }
}

// ── Read-only Info Row ────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? badge;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF1B4FD8), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7D93AB),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0B1829),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          if (badge != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFD6F5E8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0B7A4A),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 72),
      height: 0.5,
      color: const Color(0xFFE8EFF8),
    );
  }
}
