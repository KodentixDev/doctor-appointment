import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import '../../core/localization/app_language.dart';
import '../../core/network/api_exception.dart';
import '../appointments/data/appointments_api.dart';
import '../hospitals/data/hospitals_api.dart';
import 'confirmation_screen.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final _appointmentsApi = AppointmentsApi();
  final _hospitalsApi = HospitalsApi();
  final _search = TextEditingController();
  final _optionScrollController = ScrollController();

  int _step = 0;
  HospitalCity? _city;
  HospitalInfo? _hospital;
  HospitalDepartment? _department;
  HospitalDoctor? _doctor;
  String? _selectedDate;
  Map<String, String>? _selectedSlot;

  List<HospitalCity> _cities = [];
  List<HospitalInfo> _hospitals = [];
  List<HospitalDepartment> _departments = [];
  List<HospitalDoctor> _doctors = [];
  DateTime _visibleMonth = DateTime(DateTime.now().year, DateTime.now().month);
  List<String> _availableDates = [];
  List<Map<String, String>> _slots = [];
  bool _loadingOptions = false;
  bool _loadingDays = false;
  bool _loadingSlots = false;
  bool _booking = false;
  String? _optionsError;
  String? _availabilityError;

  static const _steps = ['Şəhər', 'Xəstəxana', 'Bölmə', 'Həkim', 'Vaxt'];

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  @override
  void dispose() {
    _search.dispose();
    _optionScrollController.dispose();
    super.dispose();
  }

  String get _query => _search.text.trim().toLowerCase();

  bool get _canContinue {
    return switch (_step) {
      0 => _city != null && !_loadingOptions,
      1 => _hospital != null && !_loadingOptions,
      2 => _department != null && !_loadingOptions,
      3 => _doctor != null && !_loadingOptions,
      4 => _selectedDate != null && _selectedSlot != null && !_booking,
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: PopScope(
        canPop: _step == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && _step > 0) _goBack();
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF0F5FF),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = math.min(
                  math.max(0.0, constraints.maxWidth - 24),
                  760.0,
                );
                final listHeight = math.max(
                  230.0,
                  math.min(430.0, constraints.maxHeight - 360),
                );

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                  child: Center(
                    child: SizedBox(
                      width: width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _ProgressHeader(currentStep: _step, labels: _steps),
                          const SizedBox(height: 18),
                          _WizardCard(
                            step: _step,
                            title: _title(context),
                            subtitle: _subtitle(context),
                            footer: _buildFooter(context),
                            child: _buildStepBody(context, listHeight),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepBody(BuildContext context, double listHeight) {
    if (_step == 4) return _buildDateStep(context);

    final label = switch (_step) {
      0 => 'Şəhər axtarın',
      1 => 'Xəstəxana axtarın',
      2 => 'Bölmə axtarın',
      _ => 'Həkim axtarın',
    };
    final hint = switch (_step) {
      0 => 'Şəhər adı yazın...',
      1 => 'Xəstəxana adı yazın...',
      2 => 'Bölmə adı yazın...',
      _ => 'Həkim adı və ya ixtisas yazın...',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr(label),
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0B1829),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _search,
          onChanged: (_) {
            setState(() {});
            _resetOptionScroll();
          },
          decoration: InputDecoration(
            hintText: context.tr(hint),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Color(0xFFD8E4F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Color(0xFFD8E4F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.4,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(height: listHeight, child: _buildOptionList(context)),
      ],
    );
  }

  Widget _buildOptionList(BuildContext context) {
    if (_loadingOptions) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_optionsError != null) {
      return _StepError(message: _optionsError!, onRetry: _retryCurrentStep);
    }

    final items = _filteredOptions(context);
    if (items.isEmpty) {
      return Center(
        child: Text(
          context.tr('Nəticə tapılmadı'),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF7D93AB),
          ),
        ),
      );
    }

    return Scrollbar(
      controller: _optionScrollController,
      thumbVisibility: true,
      child: ListView.separated(
        controller: _optionScrollController,
        itemCount: items.length,
        padding: EdgeInsets.zero,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = items[index];
          return _OptionTile(
            title: item.title,
            subtitle: item.subtitle,
            selected: item.selected,
            icon: item.icon,
            onTap: item.onTap,
          );
        },
      ),
    );
  }

  List<_OptionViewData> _filteredOptions(BuildContext context) {
    if (_step == 0) {
      return _cities
          .where((item) => _matches(context, item.name, ''))
          .map(
            (item) => _OptionViewData(
              title: item.name,
              subtitle: '',
              icon: Icons.location_on_outlined,
              selected: _city == item,
              onTap: () => _selectCity(item),
            ),
          )
          .toList();
    }
    if (_step == 1) {
      return _hospitals
          .where((item) => _matches(context, item.name, item.address))
          .map(
            (item) => _OptionViewData(
              title: item.name,
              subtitle: item.address,
              icon: Icons.local_hospital_outlined,
              selected: _hospital == item,
              onTap: () => _selectHospital(item),
            ),
          )
          .toList();
    }
    if (_step == 2) {
      return _departments
          .where((item) => _matches(context, item.name, item.description))
          .map(
            (item) => _OptionViewData(
              title: item.name,
              subtitle: item.description,
              icon: Icons.apartment_outlined,
              selected: _department == item,
              onTap: () => _selectDepartment(item),
            ),
          )
          .toList();
    }
    return _doctors
        .where((item) => _matches(context, item.name, item.specialty))
        .map(
          (item) => _OptionViewData(
            title: item.name,
            subtitle: item.specialty,
            icon: Icons.person_rounded,
            selected: _doctor == item,
            onTap: () => _selectDoctor(item),
          ),
        )
        .toList();
  }

  Widget _buildDateStep(BuildContext context) {
    if (_loadingDays) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 80),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_availabilityError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 56),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 42, color: Color(0xFFCBD8E5)),
            const SizedBox(height: 12),
            Text(
              _availabilityError!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7D93AB),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _loadAvailability,
              child: Text(context.tr('Yenidən cəhd et')),
            ),
          ],
        ),
      );
    }

    if (_availableDates.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 56),
        child: Column(
          children: [
            const Icon(
              Icons.event_busy_outlined,
              size: 42,
              color: Color(0xFFCBD8E5),
            ),
            const SizedBox(height: 12),
            Text(
              context.tr('Bu həkim üçün boş gün tapılmadı'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7D93AB),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _loadAvailability,
              child: Text(context.tr('Yenidən cəhd et')),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 620;
        final calendar = _CalendarPanel(
          visibleMonth: _visibleMonth,
          availableDates: _availableDates,
          selectedDate: _selectedDate,
          onPrevious: () => setState(
            () => _visibleMonth = DateTime(
              _visibleMonth.year,
              _visibleMonth.month - 1,
            ),
          ),
          onNext: () => setState(
            () => _visibleMonth = DateTime(
              _visibleMonth.year,
              _visibleMonth.month + 1,
            ),
          ),
          onSelect: _selectDate,
        );
        final slots = _SlotsPanel(
          loading: _loadingSlots,
          slots: _slots,
          selectedSlot: _selectedSlot,
          hasSelectedDate: _selectedDate != null,
          onSelect: (slot) => setState(() => _selectedSlot = slot),
        );

        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: calendar),
              const SizedBox(width: 26),
              Expanded(child: slots),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [calendar, const SizedBox(height: 18), slots],
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        if (_step > 0) ...[
          SizedBox(
            height: 48,
            child: TextButton.icon(
              onPressed: _booking ? null : _goBack,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF8FAFC),
                foregroundColor: const Color(0xFF0B1829),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18),
              ),
              icon: const Icon(Icons.arrow_back_rounded),
              label: Text(
                context.tr('Geri'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _canContinue ? _goNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: const Color(0xFFCBD8E5),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              icon: _booking
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      _step == 4
                          ? Icons.check_circle_outline_rounded
                          : Icons.arrow_forward_rounded,
                    ),
              label: Text(
                context.tr(_step == 4 ? 'Randevunu Təsdiqlə' : 'Növbəti'),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _selectCity(HospitalCity city) {
    setState(() {
      if (_city != city) {
        _hospital = null;
        _department = null;
        _doctor = null;
        _hospitals = [];
        _departments = [];
        _doctors = [];
        _optionsError = null;
        _clearAvailability();
      }
      _city = city;
    });
  }

  void _selectHospital(HospitalInfo hospital) {
    setState(() {
      if (_hospital != hospital) {
        _department = null;
        _doctor = null;
        _departments = [];
        _doctors = [];
        _optionsError = null;
        _clearAvailability();
      }
      _hospital = hospital;
    });
  }

  void _selectDepartment(HospitalDepartment department) {
    setState(() {
      if (_department != department) {
        _doctor = null;
        _doctors = [];
        _optionsError = null;
        _clearAvailability();
      }
      _department = department;
    });
  }

  void _selectDoctor(HospitalDoctor doctor) {
    setState(() {
      if (_doctor != doctor) {
        _optionsError = null;
        _clearAvailability();
      }
      _doctor = doctor;
    });
  }

  Future<void> _retryCurrentStep() => _loadStepData(_step);

  Future<void> _loadCities() async {
    setState(() {
      _loadingOptions = true;
      _optionsError = null;
    });
    try {
      final cities = await _hospitalsApi.cities();
      if (!mounted) return;
      setState(() {
        _cities = cities;
        _loadingOptions = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _optionsError = e.message;
        _loadingOptions = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _optionsError = context.tr('Məlumatlar yüklənmədi');
        _loadingOptions = false;
      });
    }
  }

  Future<void> _loadHospitals() async {
    final city = _city;
    if (city == null) return;

    setState(() {
      _loadingOptions = true;
      _optionsError = null;
      _hospitals = [];
      _hospital = null;
      _departments = [];
      _department = null;
      _doctors = [];
      _doctor = null;
      _clearAvailability();
    });
    try {
      final hospitals = await _hospitalsApi.hospitals(cityId: city.id);
      if (!mounted || _city != city) return;
      setState(() {
        _hospitals = hospitals;
        _loadingOptions = false;
      });
    } on ApiException catch (e) {
      if (!mounted || _city != city) return;
      setState(() {
        _optionsError = e.message;
        _loadingOptions = false;
      });
    } catch (_) {
      if (!mounted || _city != city) return;
      setState(() {
        _optionsError = context.tr('Məlumatlar yüklənmədi');
        _loadingOptions = false;
      });
    }
  }

  Future<void> _loadDepartments() async {
    final hospital = _hospital;
    if (hospital == null) return;

    setState(() {
      _loadingOptions = true;
      _optionsError = null;
      _departments = [];
      _department = null;
      _doctors = [];
      _doctor = null;
      _clearAvailability();
    });
    try {
      final departments = await _hospitalsApi.departments(
        hospitalId: hospital.id,
      );
      if (!mounted || _hospital != hospital) return;
      setState(() {
        _departments = departments;
        _loadingOptions = false;
      });
    } on ApiException catch (e) {
      if (!mounted || _hospital != hospital) return;
      setState(() {
        _optionsError = e.message;
        _loadingOptions = false;
      });
    } catch (_) {
      if (!mounted || _hospital != hospital) return;
      setState(() {
        _optionsError = context.tr('Məlumatlar yüklənmədi');
        _loadingOptions = false;
      });
    }
  }

  Future<void> _loadDoctors() async {
    final hospital = _hospital;
    final department = _department;
    if (hospital == null || department == null) return;

    setState(() {
      _loadingOptions = true;
      _optionsError = null;
      _doctors = [];
      _doctor = null;
      _clearAvailability();
    });
    try {
      final doctors = await _hospitalsApi.doctors(
        hospitalId: hospital.id,
        departmentId: department.id,
      );
      if (!mounted || _hospital != hospital || _department != department) {
        return;
      }
      setState(() {
        _doctors = doctors;
        _loadingOptions = false;
      });
    } on ApiException catch (e) {
      if (!mounted || _hospital != hospital || _department != department) {
        return;
      }
      setState(() {
        _optionsError = e.message;
        _loadingOptions = false;
      });
    } catch (_) {
      if (!mounted || _hospital != hospital || _department != department) {
        return;
      }
      setState(() {
        _optionsError = context.tr('Məlumatlar yüklənmədi');
        _loadingOptions = false;
      });
    }
  }

  void _resetOptionScroll() {
    if (!_optionScrollController.hasClients) return;
    _optionScrollController.jumpTo(0);
  }

  void _clearAvailability() {
    _selectedDate = null;
    _selectedSlot = null;
    _availableDates = [];
    _slots = [];
    _availabilityError = null;
    _loadingDays = false;
    _loadingSlots = false;
  }

  Future<void> _goNext() async {
    if (!_canContinue) return;
    if (_step == 4) {
      await _bookAppointment();
      return;
    }

    final nextStep = _step + 1;
    setState(() {
      _step = nextStep;
      _search.clear();
    });
    _resetOptionScroll();

    await _loadStepData(nextStep);
  }

  void _goBack() {
    if (_step == 0) return;
    setState(() {
      _step -= 1;
      _search.clear();
    });
    _resetOptionScroll();
  }

  Future<void> _loadStepData(int step) async {
    switch (step) {
      case 0:
        return _loadCities();
      case 1:
        return _loadHospitals();
      case 2:
        return _loadDepartments();
      case 3:
        return _loadDoctors();
      case 4:
        return _loadAvailability();
    }
  }

  Future<void> _loadAvailability() async {
    final doctor = _doctor;
    if (doctor == null) return;

    setState(() {
      _loadingDays = true;
      _availabilityError = null;
      _availableDates = [];
      _slots = [];
      _selectedDate = null;
      _selectedSlot = null;
    });

    try {
      final dates = await _appointmentsApi.availableDays(doctor.id);
      if (!mounted || _doctor != doctor) return;
      setState(() {
        _availableDates = dates;
        _loadingDays = false;
        if (dates.isNotEmpty) {
          final firstDate = DateTime.tryParse(dates.first);
          if (firstDate != null) {
            _visibleMonth = DateTime(firstDate.year, firstDate.month);
          }
        }
      });
      if (dates.isNotEmpty) {
        await _selectDate(dates.first);
      }
    } on ApiException catch (e) {
      if (!mounted || _doctor != doctor) return;
      setState(() {
        _availabilityError = e.message;
        _loadingDays = false;
      });
    } catch (_) {
      if (!mounted || _doctor != doctor) return;
      setState(() {
        _availabilityError = context.tr('Boş günlər yüklənmədi');
        _loadingDays = false;
      });
    }
  }

  Future<void> _selectDate(String date) async {
    final doctor = _doctor;
    if (doctor == null) return;

    setState(() {
      _selectedDate = date;
      _selectedSlot = null;
      _slots = [];
      _loadingSlots = true;
    });

    try {
      final slots = await _appointmentsApi.availableSlots(doctor.id, date);
      if (!mounted || _doctor != doctor || _selectedDate != date) return;
      setState(() {
        _slots = slots;
        _loadingSlots = false;
      });
    } catch (_) {
      if (!mounted || _doctor != doctor || _selectedDate != date) return;
      setState(() => _loadingSlots = false);
    }
  }

  Future<void> _bookAppointment() async {
    final doctor = _doctor;
    final date = _selectedDate;
    final slot = _selectedSlot;
    if (doctor == null || date == null || slot == null) return;

    setState(() => _booking = true);
    try {
      final appointment = await _appointmentsApi.bookAppointment(
        doctorId: doctor.id,
        appointmentDate: date,
        startTime: slot['start'] ?? '',
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmationScreen(appointment: appointment),
        ),
      );
    } on ApiException catch (e) {
      _showSnack(e.message, isError: true);
      if (date.isNotEmpty) await _selectDate(date);
    } catch (_) {
      _showSnack(context.tr('Randevu yaratmaq mümkün olmadı.'), isError: true);
    } finally {
      if (mounted) setState(() => _booking = false);
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  bool _matches(BuildContext context, String title, String subtitle) {
    if (_query.isEmpty) return true;
    return title.toLowerCase().contains(_query) ||
        subtitle.toLowerCase().contains(_query) ||
        context.tr(title).toLowerCase().contains(_query) ||
        context.tr(subtitle).toLowerCase().contains(_query);
  }

  String _title(BuildContext context) {
    return context.tr(switch (_step) {
      0 => 'Şəhər seçin',
      1 => 'Xəstəxana seçin',
      2 => 'Bölmə seçin',
      3 => 'Həkim seçin',
      _ => 'Tarix və vaxt seçin',
    });
  }

  String _subtitle(BuildContext context) {
    return switch (_step) {
      0 => context.tr('Randevu almaq istədiyiniz şəhəri seçin'),
      1 =>
        '${_city?.name ?? ''} ${context.tr('şəhərindəki xəstəxanaları seçin')}',
      2 => '${_hospital?.name ?? ''} ${context.tr('xəstəxanasının bölmələri')}',
      3 => '${_department?.name ?? ''} ${context.tr('bölməsindəki həkimlər')}',
      _ => _doctor?.name ?? '',
    };
  }
}

class _StepError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _StepError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 38, color: Color(0xFFCBD8E5)),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7D93AB),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onRetry,
            child: Text(context.tr('Yenidən cəhd et')),
          ),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final int currentStep;
  final List<String> labels;

  const _ProgressHeader({required this.currentStep, required this.labels});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length * 2 - 1, (index) {
        if (index.isOdd) {
          final filled = (index ~/ 2) < currentStep;
          return Expanded(
            child: Container(
              height: 2,
              color: filled ? AppColors.primary : const Color(0xFFDDE6F2),
            ),
          );
        }

        final step = index ~/ 2;
        final done = step < currentStep;
        final active = step == currentStep;
        final color = done || active ? AppColors.primary : Colors.white;
        final border = done || active
            ? AppColors.primary
            : const Color(0xFFDDE6F2);

        return Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: border, width: active ? 3 : 2),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.18),
                          blurRadius: 0,
                          spreadRadius: 5,
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: done
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 18,
                    )
                  : Text(
                      '${step + 1}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: active ? Colors.white : const Color(0xFF90A1BA),
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              context.tr(labels[step]),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: active ? AppColors.primary : const Color(0xFF90A1BA),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _WizardCard extends StatelessWidget {
  final int step;
  final String title;
  final String subtitle;
  final Widget child;
  final Widget footer;

  const _WizardCard({
    required this.step,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0B1829),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    '${context.tr('Addım')} ${step + 1}/5',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF90A1BA),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE1E8F0)),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 26, 28, 18),
            child: child,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 26),
            child: footer,
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFEFF6FF) : Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: selected ? AppColors.primary : const Color(0xFFDDE6F2),
              width: selected ? 1.6 : 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : const Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: selected ? Colors.white : AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr(title),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0B1829),
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        context.tr(subtitle),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarPanel extends StatelessWidget {
  final DateTime visibleMonth;
  final List<String> availableDates;
  final String? selectedDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ValueChanged<String> onSelect;

  const _CalendarPanel({
    required this.visibleMonth,
    required this.availableDates,
    required this.selectedDate,
    required this.onPrevious,
    required this.onNext,
    required this.onSelect,
  });

  static const _monthNames = [
    'Yanvar',
    'Fevral',
    'Mart',
    'Aprel',
    'May',
    'İyun',
    'İyul',
    'Avqust',
    'Sentyabr',
    'Oktyabr',
    'Noyabr',
    'Dekabr',
  ];

  static const _weekdays = ['BE', 'ÇA', 'Çə', 'CA', 'Cü', 'Şə', 'Ba'];

  @override
  Widget build(BuildContext context) {
    final days = _calendarDays();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _MonthButton(icon: Icons.chevron_left_rounded, onTap: onPrevious),
            Expanded(
              child: Text(
                '${context.tr(_monthNames[visibleMonth.month - 1])} ${visibleMonth.year}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0B1829),
                ),
              ),
            ),
            _MonthButton(icon: Icons.chevron_right_rounded, onTap: onNext),
          ],
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 42,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            if (index < 7) {
              return Center(
                child: Text(
                  context.tr(_weekdays[index]),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF90A1BA),
                  ),
                ),
              );
            }

            final date = days[index - 7];
            if (date == null) return const SizedBox.shrink();
            final iso = _iso(date);
            final available = availableDates.contains(iso);
            final selected = selectedDate == iso;

            return GestureDetector(
              onTap: available ? () => onSelect(iso) : null,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary
                      : available
                      ? const Color(0xFFEFF6FF)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: selected
                        ? Colors.white
                        : available
                        ? AppColors.primary
                        : const Color(0xFFCBD5E1),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  List<DateTime?> _calendarDays() {
    final first = DateTime(visibleMonth.year, visibleMonth.month);
    final total = DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day;
    final offset = first.weekday - 1;
    return List.generate(35, (index) {
      final day = index - offset + 1;
      if (day < 1 || day > total) return null;
      return DateTime(visibleMonth.year, visibleMonth.month, day);
    });
  }

  String _iso(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

class _MonthButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MonthButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFDDE6F2)),
        ),
        child: Icon(icon, color: const Color(0xFF0B1829)),
      ),
    );
  }
}

class _SlotsPanel extends StatelessWidget {
  final bool loading;
  final List<Map<String, String>> slots;
  final Map<String, String>? selectedSlot;
  final bool hasSelectedDate;
  final ValueChanged<Map<String, String>> onSelect;

  const _SlotsPanel({
    required this.loading,
    required this.slots,
    required this.selectedSlot,
    required this.hasSelectedDate,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (slots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Text(
          context.tr(
            hasSelectedDate ? 'Bu tarixdə boş vaxt yoxdur' : 'Tarix seçin',
          ),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF90A1BA),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('Saat seçin'),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0B1829),
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: slots.map((slot) {
            final selected =
                selectedSlot?['start'] == slot['start'] &&
                selectedSlot?['end'] == slot['end'];
            return ChoiceChip(
              selected: selected,
              label: Text(slot['start'] ?? ''),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: selected ? Colors.white : AppColors.primary,
                fontWeight: FontWeight.w900,
              ),
              backgroundColor: const Color(0xFFEFF6FF),
              side: BorderSide(
                color: selected ? AppColors.primary : const Color(0xFFBFD7F8),
              ),
              onSelected: (_) => onSelect(slot),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _OptionViewData {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _OptionViewData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
}
