import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/localization/app_language.dart';
import '../../core/models/account_user.dart';
import '../../core/models/app_user_role.dart';
import '../../core/network/api_exception.dart';
import '../doctor/doctor_home_screen.dart';
import '../home/home_screen.dart';
import 'data/accounts_api.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _accountsApi = AccountsApi();
  AppUserRole _selectedRole = AppUserRole.citizen;
  bool _isLoading = false;
  bool _obscurePassword = true;

  String? _savedEmail;
  String? _savedPassword;
  AppUserRole? _savedRole;

  static const _keyEmail = 'quick_fill_email';
  static const _keyPassword = 'quick_fill_password';
  static const _keyRole = 'quick_fill_role';

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_keyEmail);
    final password = prefs.getString(_keyPassword);
    final roleStr = prefs.getString(_keyRole);
    if (!mounted || email == null || password == null) return;
    setState(() {
      _savedEmail = email;
      _savedPassword = password;
      _savedRole = roleStr == 'doctor' ? AppUserRole.doctor : AppUserRole.citizen;
    });
  }

  Future<void> _saveCreds(String email, String password, AppUserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPassword, password);
    await prefs.setString(_keyRole, role == AppUserRole.doctor ? 'doctor' : 'citizen');
  }

  void _quickFill() {
    if (_savedEmail == null || _savedPassword == null) return;
    setState(() {
      _emailController.text = _savedEmail!;
      _passwordController.text = _savedPassword!;
      if (_savedRole != null) _selectedRole = _savedRole!;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate() || _isLoading) return;

    setState(() => _isLoading = true);
    try {
      final selectedRole = _selectedRole;
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final user = await _accountsApi.login(email: email, password: password);
      if (user.role != selectedRole) {
        await _accountsApi.clearSession();
        if (!mounted) return;
        _showError(
          selectedRole == AppUserRole.doctor
              ? context.tr('Bu hesab həkim hesabı deyil.')
              : context.tr('Bu hesab vətəndaş hesabı deyil.'),
        );
        return;
      }
      await _saveCreds(email, password, selectedRole);
      if (!mounted) return;
      _openRoleHome(user);
    } on ApiException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError(context.tr('Daxil olmaq mümkün olmadı.'));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _openRoleHome(AccountUser user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => user.role == AppUserRole.doctor
            ? DoctorHomeScreen(user: user)
            : HomeScreen(user: user),
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF040E1C),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF040E1C),
                              Color(0xFF091F3C),
                              Color(0xFF0D2A50),
                            ],
                          ),
                        ),
                        child: SafeArea(
                          bottom: false,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 12,
                                right: 20,
                                child: _LanguageSelector(),
                              ),
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const _LogoImage(size: 80),
                                    const SizedBox(height: 22),
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w900,
                                          height: 1,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: context.tr('Həkim'),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text: context.tr('Növbə'),
                                            style: const TextStyle(
                                              color: Color(0xFF60A5FA),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      child: Text(
                                        context.tr(
                                          'Həkim və vətəndaş hesabları üçün təhlükəsiz giriş.',
                                        ),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF8FAAC7),
                                          height: 1.6,
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
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 28,
                        bottom: bottomPadding + 24,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr('Daxil ol'),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0B1829),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _RoleSelector(
                              value: _selectedRole,
                              onChanged: _isLoading
                                  ? null
                                  : (role) =>
                                        setState(() => _selectedRole = role),
                            ),
                            const SizedBox(height: 16),
                            _AuthField(
                              controller: _emailController,
                              label: context.tr('E-poçt'),
                              hintText: context.tr(
                                'E-poçt ünvanınızı daxil edin',
                              ),
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                final email = value?.trim() ?? '';
                                if (email.isEmpty) {
                                  return context.tr('E-poçt daxil edin');
                                }
                                if (!email.contains('@')) {
                                  return context.tr('Düzgün e-poçt daxil edin');
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            _AuthField(
                              controller: _passwordController,
                              label: context.tr('Şifrə'),
                              hintText: context.tr('Şifrənizi daxil edin'),
                              icon: Icons.lock_outline_rounded,
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? context.tr('Şifrə daxil edin')
                                  : null,
                            ),
                            if (_savedEmail != null) ...[
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: _isLoading ? null : _quickFill,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFBFD7F8),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.bolt_rounded,
                                        color: Color(0xFF1B4FD8),
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${context.tr('Tez doldur')} · $_savedEmail',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1B4FD8),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              height: 58,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF1B4FD8),
                                      Color(0xFF2563EB),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: _isLoading ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    disabledBackgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  icon: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.4,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.login_rounded,
                                          size: 22,
                                        ),
                                  label: Text(
                                    context.tr(
                                      _selectedRole == AppUserRole.doctor
                                          ? 'Həkim kimi daxil ol'
                                          : 'Vətəndaş kimi daxil ol',
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Center(
                              child: TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const RegisterScreen(),
                                        ),
                                      ),
                                child: Text(
                                  context.tr('Vətəndaş kimi qeydiyyatdan keç'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LogoImage extends StatelessWidget {
  final double size;

  const _LogoImage({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: const [
          BoxShadow(color: Color(0x441B4FD8), blurRadius: 24, spreadRadius: 4),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset('assets/logo.png', fit: BoxFit.cover),
    );
  }
}

class _RoleSelector extends StatelessWidget {
  final AppUserRole value;
  final ValueChanged<AppUserRole>? onChanged;

  const _RoleSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EFF8)),
      ),
      child: Row(
        children: [
          _RoleOption(
            role: AppUserRole.citizen,
            value: value,
            icon: Icons.person_outline_rounded,
            label: context.tr('Vətəndaş'),
            onChanged: onChanged,
          ),
          const SizedBox(width: 4),
          _RoleOption(
            role: AppUserRole.doctor,
            value: value,
            icon: Icons.medical_services_outlined,
            label: context.tr('Həkim'),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _RoleOption extends StatelessWidget {
  final AppUserRole role;
  final AppUserRole value;
  final IconData icon;
  final String label;
  final ValueChanged<AppUserRole>? onChanged;

  const _RoleOption({
    required this.role,
    required this.value,
    required this.icon,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = role == value;

    return Expanded(
      child: GestureDetector(
        onTap: onChanged == null ? null : () => onChanged!(role),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 46,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 19,
                color: selected
                    ? const Color(0xFF1B4FD8)
                    : const Color(0xFF7D93AB),
              ),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: selected
                        ? const Color(0xFF1B4FD8)
                        : const Color(0xFF7D93AB),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _AuthField({
    required this.controller,
    required this.label,
    this.hintText,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF5F8FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE8EFF8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE8EFF8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF1B4FD8), width: 1.4),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selected = context.language;

    return PopupMenuButton<AppLanguage>(
      initialValue: selected,
      onSelected: context.languageController.setLanguage,
      color: Colors.white,
      itemBuilder: (context) => AppLanguage.values
          .map(
            (language) =>
                PopupMenuItem(value: language, child: Text(language.label)),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              selected.code,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
