import 'package:flutter/material.dart';

import '../../core/localization/app_language.dart';
import '../../core/network/api_exception.dart';
import 'data/accounts_api.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _api = AccountsApi();
  final _email = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _finCode = TextEditingController();
  final _password = TextEditingController();
  final _password2 = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscurePassword2 = true;

  @override
  void dispose() {
    _email.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    _finCode.dispose();
    _password.dispose();
    _password2.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate() || _isLoading) return;

    setState(() => _isLoading = true);
    try {
      await _api.registerCitizen(
        email: _email.text.trim(),
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        phone: _phone.text.trim(),
        finCode: _finCode.text.trim(),
        password: _password.text,
        password2: _password2.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('Qeydiyyat tamamlandı. İndi daxil olun.')),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } on ApiException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError(context.tr('Qeydiyyat mümkün olmadı.'));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF040E1C),
        foregroundColor: Colors.white,
        title: Text(context.tr('Vətəndaş qeydiyyatı')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.tr('Vətəndaş hesabı yaradın'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0B1829),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.tr(
                    'Qeydiyyat yalnız vətəndaşlar üçündür. Həkim hesabları administrator tərəfindən yaradılır.',
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7D93AB),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                _Field(
                  controller: _email,
                  label: context.tr('E-poçt'),
                  hintText: context.tr('E-poçt ünvanınızı daxil edin'),
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
                Row(
                  children: [
                    Expanded(
                      child: _Field(
                        controller: _firstName,
                        label: context.tr('Ad'),
                        hintText: context.tr('Adınız'),
                        icon: Icons.person_outline_rounded,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _Field(
                        controller: _lastName,
                        label: context.tr('Soyad'),
                        hintText: context.tr('Soyadınız'),
                        icon: Icons.person_outline_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _Field(
                  controller: _phone,
                  label: context.tr('Telefon'),
                  hintText: '+994501234567',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                _Field(
                  controller: _finCode,
                  label: context.tr('FIN kodu'),
                  hintText: 'ABC1234',
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 12),
                _Field(
                  controller: _password,
                  label: context.tr('Şifrə'),
                  hintText: context.tr('Minimum 8 simvol'),
                  icon: Icons.lock_outline_rounded,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.tr('Şifrə daxil edin');
                    }
                    if (value.length < 8) {
                      return context.tr('Şifrə minimum 8 simvol olmalıdır');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _Field(
                  controller: _password2,
                  label: context.tr('Şifrə təkrarı'),
                  hintText: context.tr('Şifrəni təkrar daxil edin'),
                  icon: Icons.lock_reset_rounded,
                  obscureText: _obscurePassword2,
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _obscurePassword2 = !_obscurePassword2),
                    icon: Icon(
                      _obscurePassword2
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.tr('Bu xananı doldurun');
                    }
                    if (value != _password.text) {
                      return context.tr('Şifrələr uyğun gəlmir.');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1B4FD8), Color(0xFF2563EB)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.4,
                              ),
                            )
                          : const Icon(Icons.person_add_alt_rounded),
                      label: Text(
                        context.tr('Qeydiyyatdan keç'),
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
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _Field({
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
      validator:
          validator ??
          (value) => value == null || value.trim().isEmpty
              ? context.tr('Bu xananı doldurun')
              : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
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
