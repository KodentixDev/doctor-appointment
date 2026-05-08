import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/localization/app_language.dart';

class HaqqindaScreen extends StatelessWidget {
  const HaqqindaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F3F7),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildAppCard(context),
              const SizedBox(height: 12),
              _buildInfoCard(context),
              const SizedBox(height: 12),
              _buildLinksCard(context),
              const SizedBox(height: 24),
              _buildCopyright(context),
              const SizedBox(height: 32),
            ],
          ),
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
          Expanded(
            child: Text(
              context.tr('Haqqında'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFFFFA726),
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildAppCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.medical_services_outlined,
              color: Color(0xFF1A5AD7),
              size: 38,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'HəkimNövbə',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF06152B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.tr('Versiya 2.4.0 (Build 241)'),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8B98AA),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.tr('Azərbaycan Respublikası Səhiyyə\nNazirliyinin rəsmi tətbiqi'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8B98AA),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.account_balance_outlined,
            label: context.tr('Nazirlik'),
            value: context.tr('Səhiyyə Nazirliyi'),
          ),
          const _RowDivider(),
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: context.tr('Buraxılış tarixi'),
            value: 'Yanvar 2025',
          ),
          const _RowDivider(),
          _InfoRow(
            icon: Icons.language_outlined,
            label: context.tr('Rəsmi sayt'),
            value: 'e-health.gov.az',
            isLink: true,
          ),
          const _RowDivider(),
          _InfoRow(
            icon: Icons.email_outlined,
            label: context.tr('Dəstək'),
            value: 'support@ehealth.az',
            isLink: true,
          ),
          const _RowDivider(),
          _InfoRow(
            icon: Icons.phone_outlined,
            label: context.tr('Kömək xətti'),
            value: '*3003',
            isLink: true,
            isLast: true,
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title ${context.tr('tezliklə əlavə olunacaq')}'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildLinksCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _NavRow(
            icon: Icons.description_outlined,
            label: context.tr('İstifadə şərtləri'),
            onTap: () => _showComingSoon(context, context.tr('İstifadə şərtləri')),
          ),
          const _RowDivider(),
          _NavRow(
            icon: Icons.lock_outline_rounded,
            label: context.tr('Gizlilik siyasəti'),
            isLast: true,
            onTap: () => _showComingSoon(context, context.tr('Gizlilik siyasəti')),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyright(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        context.tr(
          '© 2025-2026 Azərbaycan Respublikası Səhiyyə Nazirliyi. Bütün hüquqlar qorunur',
        ),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Color(0xFFB8C4D0),
          height: 1.5,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLink;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLink = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF8B98AA), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF06152B),
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isLink ? const Color(0xFF1A5AD7) : const Color(0xFF8B98AA),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isLast;
  final VoidCallback onTap;

  const _NavRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF8B98AA), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF06152B),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFB8C4D0),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      height: 0.5,
      color: const Color(0xFFEDF0F5),
    );
  }
}
