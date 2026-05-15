import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import '../../core/localization/app_language.dart';
import 'data/medical_records_api.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen>
    with SingleTickerProviderStateMixin {
  final _api = MedicalRecordsApi();
  late final TabController _tabs;

  MedicalData? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _api.load();
      if (!mounted) return;
      setState(() {
        _data = data;
        _loading = false;
      });
    } on MedicalApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = context.tr('Tibbi məlumatlar yüklənmədi');
        _loading = false;
      });
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
        backgroundColor: AppColors.bgPage,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? _buildError(context)
                  : _buildTabs(context),
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
          colors: AppColors.headerGradient,
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        left: 16,
        right: 16,
        bottom: 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surface600,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('Tibbi Məlumatlarım'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      context.tr('Profil, əməliyyatlar, diaqnozlar'),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8FAAC7),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _load,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surface600,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TabBar(
            controller: _tabs,
            labelColor: Colors.white,
            unselectedLabelColor: const Color(0xFF8FAAC7),
            labelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(color: Color(0xFF60A5FA), width: 3),
              insets: EdgeInsets.symmetric(horizontal: 8),
            ),
            tabs: [
              Tab(text: context.tr('Profil')),
              Tab(text: context.tr('Əməliyyatlar')),
              Tab(text: context.tr('Diaqnozlar')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 52, color: AppColors.textDimmed),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _load,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.tr('Yenidən cəhd et')),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    final data = _data!;
    return TabBarView(
      controller: _tabs,
      children: [
        _ProfileTab(
          profile: data.profile,
          api: _api,
          onSaved: _load,
        ),
        _SurgeriesTab(
          surgeries: data.surgeries,
          api: _api,
          onChanged: _load,
        ),
        _DiagnosesTab(
          diagnoses: data.diagnoses,
          api: _api,
          onChanged: _load,
        ),
      ],
    );
  }
}

// ── Profile Tab ───────────────────────────────────────────────────────────────

class _ProfileTab extends StatefulWidget {
  final MedicalProfile profile;
  final MedicalRecordsApi api;
  final VoidCallback onSaved;

  const _ProfileTab({
    required this.profile,
    required this.api,
    required this.onSaved,
  });

  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  late final TextEditingController _bloodType;
  late final TextEditingController _allergies;
  late final TextEditingController _chronic;
  late final TextEditingController _medications;
  late final TextEditingController _contactName;
  late final TextEditingController _contactPhone;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _bloodType = TextEditingController(text: p.bloodType);
    _allergies = TextEditingController(text: p.allergies);
    _chronic = TextEditingController(text: p.chronicDiseases);
    _medications = TextEditingController(text: p.currentMedications);
    _contactName = TextEditingController(text: p.emergencyContactName);
    _contactPhone = TextEditingController(text: p.emergencyContactPhone);
  }

  @override
  void dispose() {
    _bloodType.dispose();
    _allergies.dispose();
    _chronic.dispose();
    _medications.dispose();
    _contactName.dispose();
    _contactPhone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await widget.api.updateProfile(
        MedicalProfile(
          bloodType: _bloodType.text.trim(),
          allergies: _allergies.text.trim(),
          chronicDiseases: _chronic.text.trim(),
          currentMedications: _medications.text.trim(),
          emergencyContactName: _contactName.text.trim(),
          emergencyContactPhone: _contactPhone.text.trim(),
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('Profil yadda saxlandı')),
          behavior: SnackBarBehavior.floating,
        ),
      );
      widget.onSaved();
    } on MedicalApiException catch (e) {
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
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel(context, 'TİBBİ MƏLUMATLAR'),
              _MedSection(
                children: [
                  _MedField(
                    icon: Icons.bloodtype_outlined,
                    label: context.tr('Qan qrupu'),
                    hint: 'A+, B-, AB+, O+',
                    controller: _bloodType,
                  ),
                  _MedField(
                    icon: Icons.warning_amber_outlined,
                    label: context.tr('Allergiyalar'),
                    hint: context.tr('Penisilin, Aspirin...'),
                    controller: _allergies,
                    maxLines: 3,
                  ),
                  _MedField(
                    icon: Icons.monitor_heart_outlined,
                    label: context.tr('Xronik xəstəliklər'),
                    hint: context.tr('Şəkərli diabet, hipertenziya...'),
                    controller: _chronic,
                    maxLines: 3,
                  ),
                  _MedField(
                    icon: Icons.medication_outlined,
                    label: context.tr('İstifadə olunan dərmanlar'),
                    hint: context.tr('Metformin 500mg...'),
                    controller: _medications,
                    maxLines: 3,
                    isLast: true,
                  ),
                ],
              ),
              _sectionLabel(context, 'TƏCİLİ ƏLAQƏ'),
              _MedSection(
                children: [
                  _MedField(
                    icon: Icons.person_outline_rounded,
                    label: context.tr('Ad Soyad'),
                    hint: context.tr('Əlaqə şəxsinin adı'),
                    controller: _contactName,
                  ),
                  _MedField(
                    icon: Icons.phone_outlined,
                    label: context.tr('Nömrə'),
                    hint: '+994 50 000 00 00',
                    controller: _contactPhone,
                    keyboardType: TextInputType.phone,
                    isLast: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _SaveBar(saving: _saving, onSave: _save),
        ),
      ],
    );
  }
}

// ── Surgeries Tab ─────────────────────────────────────────────────────────────

class _SurgeriesTab extends StatelessWidget {
  final List<SurgeryRecord> surgeries;
  final MedicalRecordsApi api;
  final VoidCallback onChanged;

  const _SurgeriesTab({
    required this.surgeries,
    required this.api,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        surgeries.isEmpty
            ? _EmptyState(
                icon: Icons.cut_outlined,
                label: context.tr('Əməliyyat tarixi yoxdur'),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: surgeries.length,
                itemBuilder: (_, i) => _RecordCard(
                  icon: Icons.cut_outlined,
                  iconColor: AppColors.danger,
                  iconBg: AppColors.dangerLight,
                  title: surgeries[i].name.isNotEmpty
                      ? surgeries[i].name
                      : context.tr('Əməliyyat #${surgeries[i].id}'),
                  line1: surgeries[i].date.isNotEmpty
                      ? surgeries[i].date
                      : null,
                  line2: surgeries[i].hospital.isNotEmpty
                      ? surgeries[i].hospital
                      : null,
                  note: surgeries[i].notes.isNotEmpty
                      ? surgeries[i].notes
                      : null,
                  onDelete: () async {
                    final ok = await _confirmDelete(context);
                    if (!ok) return;
                    try {
                      await api.deleteSurgery(surgeries[i].id);
                      onChanged();
                    } on MedicalApiException catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.message),
                          backgroundColor: AppColors.danger,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
              ),
        Positioned(
          right: 16,
          bottom: 24,
          child: FloatingActionButton.extended(
            heroTag: 'add_surgery',
            onPressed: () => _showAddDialog(context),
            backgroundColor: AppColors.danger,
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              context.tr('Əlavə et'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => _ConfirmDialog(message: context.tr('Silmək istədiyinizə əminsiniz?')),
    );
    return result ?? false;
  }

  void _showAddDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddSurgerySheet(api: api, onSaved: onChanged),
    );
  }
}

// ── Diagnoses Tab ─────────────────────────────────────────────────────────────

class _DiagnosesTab extends StatelessWidget {
  final List<DiagnosisRecord> diagnoses;
  final MedicalRecordsApi api;
  final VoidCallback onChanged;

  const _DiagnosesTab({
    required this.diagnoses,
    required this.api,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        diagnoses.isEmpty
            ? _EmptyState(
                icon: Icons.assignment_outlined,
                label: context.tr('Diaqnoz tarixi yoxdur'),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: diagnoses.length,
                itemBuilder: (_, i) => _RecordCard(
                  icon: Icons.assignment_outlined,
                  iconColor: AppColors.primary,
                  iconBg: AppColors.primaryLight,
                  title: diagnoses[i].name.isNotEmpty
                      ? diagnoses[i].name
                      : context.tr('Diaqnoz #${diagnoses[i].id}'),
                  line1: diagnoses[i].date.isNotEmpty
                      ? diagnoses[i].date
                      : null,
                  line2: diagnoses[i].doctorName.isNotEmpty
                      ? diagnoses[i].doctorName
                      : null,
                  note: diagnoses[i].notes.isNotEmpty
                      ? diagnoses[i].notes
                      : null,
                  onDelete: () async {
                    final ok = await _confirmDelete(context);
                    if (!ok) return;
                    try {
                      await api.deleteDiagnosis(diagnoses[i].id);
                      onChanged();
                    } on MedicalApiException catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.message),
                          backgroundColor: AppColors.danger,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
              ),
        Positioned(
          right: 16,
          bottom: 24,
          child: FloatingActionButton.extended(
            heroTag: 'add_diagnosis',
            onPressed: () => _showAddDialog(context),
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              context.tr('Əlavə et'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => _ConfirmDialog(message: context.tr('Silmək istədiyinizə əminsiniz?')),
    );
    return result ?? false;
  }

  void _showAddDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddDiagnosisSheet(api: api, onSaved: onChanged),
    );
  }
}

// ── Add Surgery Sheet ─────────────────────────────────────────────────────────

class _AddSurgerySheet extends StatefulWidget {
  final MedicalRecordsApi api;
  final VoidCallback onSaved;

  const _AddSurgerySheet({required this.api, required this.onSaved});

  @override
  State<_AddSurgerySheet> createState() => _AddSurgerySheetState();
}

class _AddSurgerySheetState extends State<_AddSurgerySheet> {
  final _name = TextEditingController();
  final _date = TextEditingController();
  final _hospital = TextEditingController();
  final _notes = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _date.dispose();
    _hospital.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty || _date.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      await widget.api.addSurgery(
        name: _name.text.trim(),
        date: _date.text.trim(),
        hospital: _hospital.text.trim(),
        notes: _notes.text.trim(),
      );
      if (!mounted) return;
      Navigator.pop(context);
      widget.onSaved();
    } on MedicalApiException catch (e) {
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
          content: Text(context.tr('Əməliyyat əlavə edilmədi')),
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
    return _AddSheet(
      title: context.tr('Əməliyyat əlavə et'),
      saving: _saving,
      onSave: _save,
      children: [
        _SheetField(
          controller: _name,
          label: context.tr('Əməliyyatın adı'),
          hint: context.tr('Appendektomiya'),
          required: true,
        ),
        _SheetField(
          controller: _date,
          label: context.tr('Tarix'),
          hint: 'YYYY-MM-DD',
          keyboardType: TextInputType.datetime,
          required: true,
        ),
        _SheetField(
          controller: _hospital,
          label: context.tr('Xəstəxana'),
          hint: context.tr('Respublika Klinik Xəstəxanası'),
        ),
        _SheetField(
          controller: _notes,
          label: context.tr('Qeydlər'),
          hint: context.tr('Əlavə məlumat...'),
          maxLines: 3,
        ),
      ],
    );
  }
}

// ── Add Diagnosis Sheet ───────────────────────────────────────────────────────

class _AddDiagnosisSheet extends StatefulWidget {
  final MedicalRecordsApi api;
  final VoidCallback onSaved;

  const _AddDiagnosisSheet({required this.api, required this.onSaved});

  @override
  State<_AddDiagnosisSheet> createState() => _AddDiagnosisSheetState();
}

class _AddDiagnosisSheetState extends State<_AddDiagnosisSheet> {
  final _name = TextEditingController();
  final _date = TextEditingController();
  final _doctorName = TextEditingController();
  final _notes = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _date.dispose();
    _doctorName.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty || _date.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      await widget.api.addDiagnosis(
        name: _name.text.trim(),
        date: _date.text.trim(),
        doctorName: _doctorName.text.trim(),
        notes: _notes.text.trim(),
      );
      if (!mounted) return;
      Navigator.pop(context);
      widget.onSaved();
    } on MedicalApiException catch (e) {
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
          content: Text(context.tr('Diaqnoz əlavə edilmədi')),
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
    return _AddSheet(
      title: context.tr('Diaqnoz əlavə et'),
      saving: _saving,
      onSave: _save,
      children: [
        _SheetField(
          controller: _name,
          label: context.tr('Diaqnozun adı'),
          hint: context.tr('Hipertenziya, III mərhələ'),
          required: true,
        ),
        _SheetField(
          controller: _date,
          label: context.tr('Tarix'),
          hint: 'YYYY-MM-DD',
          keyboardType: TextInputType.datetime,
          required: true,
        ),
        _SheetField(
          controller: _doctorName,
          label: context.tr('Həkim'),
          hint: 'Dr. Leyla Əliyeva',
        ),
        _SheetField(
          controller: _notes,
          label: context.tr('Qeydlər'),
          hint: context.tr('Əlavə məlumat...'),
          maxLines: 3,
        ),
      ],
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

Widget _sectionLabel(BuildContext context, String key) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 16, 10),
    child: Text(
      context.tr(key),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.1,
        color: AppColors.textMuted,
      ),
    ),
  );
}

class _MedSection extends StatelessWidget {
  final List<Widget> children;

  const _MedSection({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(children: children),
    );
  }
}

class _MedField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool isLast;

  const _MedField({
    required this.icon,
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
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
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: controller,
                      maxLines: maxLines,
                      keyboardType: keyboardType,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDimmed,
                        ),
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
            ],
          ),
        ),
        if (!isLast)
          Container(
            margin: const EdgeInsets.only(left: 72),
            height: 0.5,
            color: AppColors.border,
          ),
      ],
    );
  }
}

class _RecordCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String? line1;
  final String? line2;
  final String? note;
  final VoidCallback onDelete;

  const _RecordCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    this.line1,
    this.line2,
    this.note,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 2),
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
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (line1 != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        line1!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
                if (line2 != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    line2!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
                if (note != null && note!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    note!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.dangerLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.danger,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String label;

  const _EmptyState({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 52, color: AppColors.textDimmed),
          const SizedBox(height: 14),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _SaveBar extends StatelessWidget {
  final bool saving;
  final VoidCallback onSave;

  const _SaveBar({required this.saving, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgPage,
        boxShadow: [
          BoxShadow(color: Color(0x0E000000), blurRadius: 20, offset: Offset(0, -4)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ElevatedButton.icon(
            onPressed: saving ? null : onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save_outlined, size: 22),
            label: Text(
              context.tr('Yadda Saxla'),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddSheet extends StatelessWidget {
  final String title;
  final bool saving;
  final VoidCallback onSave;
  final List<Widget> children;

  const _AddSheet({
    required this.title,
    required this.saving,
    required this.onSave,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.only(bottom: bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 16, 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: saving ? null : onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        context.tr('Əlavə et'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool required;
  final int maxLines;
  final TextInputType? keyboardType;

  const _SheetField({
    required this.controller,
    required this.label,
    required this.hint,
    this.required = false,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          hintText: hint,
          filled: true,
          fillColor: AppColors.bgSubtle,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
          ),
        ),
      ),
    );
  }
}

class _ConfirmDialog extends StatelessWidget {
  final String message;

  const _ConfirmDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.dangerLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.delete_outline, color: AppColors.danger, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.bgSubtle,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      context.tr('Ləğv et'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSub,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      context.tr('Sil'),
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
