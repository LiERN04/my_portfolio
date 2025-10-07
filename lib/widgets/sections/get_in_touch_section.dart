import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/url_launcher_service.dart';

class GetInTouchSection extends StatelessWidget {
  const GetInTouchSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
              children: [
                Icon(
                  Icons.connect_without_contact,
                  color: colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      colorScheme.secondary,
                      colorScheme.primary,
                      colorScheme.tertiary,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    'Get in Touch',
                    style: textTheme.headlineMedium?.copyWith(
                      fontFamily: 'monospace',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32.0,
                    ),
                  ),
                ),
              ],
            )
            .animate()
            .slideX(
              begin: -0.3,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
            )
            .fadeIn(duration: const Duration(milliseconds: 400)),

        const SizedBox(height: 32),

        _buildSocialLinks(context, textTheme, colorScheme)
            .animate()
            .slideY(
              begin: 0.3,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
            )
            .fadeIn(
              delay: const Duration(milliseconds: 600),
              duration: const Duration(milliseconds: 600),
            ),
      ],
    );
  }

  Widget _buildSocialLinks(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    final socialLinks = [
      {
        'icon': Icons.link,
        'label': 'LinkedIn',
        'url': 'https://www.linkedin.com/in/lik-ern-leong-73873a1a0/',
        'isDownload': false,
      },
      {
        'icon': Icons.code,
        'label': 'GitHub',
        'url': 'https://github.com/LiERN04',
        'isDownload': false,
      },
      {
        'icon': Icons.document_scanner,
        'label': 'Resume',
        'url': 'assets/documents/Lik_Ern_Leong-Software_Engineer.pdf',
        'isDownload': true,
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.1),
            colorScheme.secondary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Connect With Me',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Follow me on social media or check out my work!',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.85),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: socialLinks
                .map(
                  (social) => _buildSocialButton(
                    context,
                    social['icon'] as IconData,
                    social['label'] as String,
                    social['url'] as String,
                    social['isDownload'] as bool? ?? false,
                    colorScheme,
                    textTheme,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    IconData icon,
    String label,
    String url,
    bool isDownload,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return InkWell(
      onTap: () {
        if (isDownload) {
          UrlLauncherService.downloadAsset(url, 'Lik_Ern_Leong_Resume.pdf');
        } else {
          UrlLauncherService.openUrl(url);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
