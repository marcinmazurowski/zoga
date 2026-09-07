import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../widgets/zoga_logo.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  Future<void> _open(String url) => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              const ZogaLogo(fontSize: 30),
              const SizedBox(height: 24),
              _Card(
                child: Column(
                  children: [
                    const Text(
                      '"Ruch, dotyk i precyzja pracy prowadzą do zmiany '
                      'nie tylko postawy, ale i świadomości siebie."',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.grey[200]),
                    const SizedBox(height: 16),
                    const Text(
                      'Zoga Multidimensional Movement to metodologia terapii ruchem '
                      'łącząca wiedzę naukową z praktyką terapeutyczną. Ciało traktowane '
                      'jest jak mapa — poprzez pracę z powięzią, technikami neuromięśniowymi '
                      'i praktyką somatyczną.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Oferta',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    _offerRow(Icons.school_outlined, 'Szkolenia i kursy'),
                    _offerRow(Icons.home_work_outlined, 'Terapia ruchem w domu'),
                    _offerRow(Icons.event_outlined, 'Wydarzenia'),
                    _offerRow(Icons.person_search_outlined, 'Znajdź terapeutę'),
                    _offerRow(Icons.menu_book_outlined, 'Sklep — książki i akcesoria'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kontakt',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    _linkRow(Icons.language, 'zoga-movement.com', () => _open('https://www.zoga-movement.com/')),
                    _linkRow(Icons.camera_alt_outlined, '@zoga_movement (Instagram)',
                        () => _open('https://www.instagram.com/zoga_movement/')),
                  ],
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _offerRow(IconData icon, String label) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
          ],
        ),
      );

  Widget _linkRow(IconData icon, String label, VoidCallback onTap) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 14, color: AppColors.primary)),
            ],
          ),
        ),
      );
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}
