import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_framework/responsive_framework.dart';
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
        Text('Get in Touch', style: textTheme.headlineSmall)
            .animate()
            .slideX(
              begin: -0.3,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
            )
            .fadeIn(duration: const Duration(milliseconds: 400)),

        const SizedBox(height: 32),

        // ResponsiveRowColumn(
        //   layout: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
        //       ? ResponsiveRowColumnType.COLUMN
        //       : ResponsiveRowColumnType.ROW,
        //   rowCrossAxisAlignment: CrossAxisAlignment.start,
        //   columnCrossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     // ResponsiveRowColumnItem(
        //     //   rowFlex: 1,
        //     //   child: _buildContactInfo(context, textTheme, colorScheme)
        //     //       .animate()
        //     //       .slideX(
        //     //         begin: -0.5,
        //     //         duration: const Duration(milliseconds: 800),
        //     //         curve: Curves.easeOutCubic,
        //     //       )
        //     //       .fadeIn(
        //     //         delay: const Duration(milliseconds: 200),
        //     //         duration: const Duration(milliseconds: 600),
        //     //       ),
        //     // ),
        //     // ResponsiveRowColumnItem(
        //     //   rowFlex: 1,
        //     //   child: _buildContactForm(context, textTheme, colorScheme)
        //     //       .animate()
        //     //       .slideX(
        //     //         begin: 0.5,
        //     //         duration: const Duration(milliseconds: 800),
        //     //         curve: Curves.easeOutCubic,
        //     //       )
        //     //       .fadeIn(
        //     //         delay: const Duration(milliseconds: 400),
        //     //         duration: const Duration(milliseconds: 600),
        //     //       ),
        //     // ),
        //   ],
        // ),
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

  Widget _buildContactInfo(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: EdgeInsets.only(
        right: ResponsiveBreakpoints.of(context).smallerThan(TABLET) ? 0 : 16,
        bottom: ResponsiveBreakpoints.of(context).smallerThan(TABLET) ? 16 : 0,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Let\'s Work Together',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'I\'m always excited to work on new projects and collaborate with amazing people. '
            'Whether you have a project in mind or just want to say hello, feel free to reach out!',
            style: textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 24),
          _buildContactItem(
            context,
            Icons.email_outlined,
            'Email',
            'your.email@example.com',
            textTheme,
            colorScheme,
            () => UrlLauncherService.openUrl('mailto:your.email@example.com'),
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            context,
            Icons.phone_outlined,
            'Phone',
            '+1 (555) 123-4567',
            textTheme,
            colorScheme,
            () => UrlLauncherService.openUrl('tel:+15551234567'),
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            context,
            Icons.location_on_outlined,
            'Location',
            'San Francisco, CA',
            textTheme,
            colorScheme,
            null,
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: EdgeInsets.only(
        left: ResponsiveBreakpoints.of(context).smallerThan(TABLET) ? 0 : 16,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send a Message',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            'Your Name',
            Icons.person_outline,
            colorScheme,
            textTheme,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            'Your Email',
            Icons.email_outlined,
            colorScheme,
            textTheme,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            'Your Message',
            Icons.message_outlined,
            colorScheme,
            textTheme,
            maxLines: 4,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Handle form submission
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Message sent! I\'ll get back to you soon.'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Send Message',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
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
        'url': 'https://linkedin.com/in/yourprofile',
      },
      {
        'icon': Icons.code,
        'label': 'GitHub',
        'url': 'https://github.com/yourusername',
      },
      {
        'icon': Icons.web,
        'label': 'Portfolio',
        'url': 'https://yourwebsite.com',
      },
      {
        'icon': Icons.alternate_email,
        'label': 'Twitter',
        'url': 'https://twitter.com/yourusername',
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

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    TextTheme textTheme,
    ColorScheme colorScheme,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon,
    ColorScheme colorScheme,
    TextTheme textTheme, {
    int maxLines = 1,
  }) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surface,
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    IconData icon,
    String label,
    String url,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return InkWell(
      onTap: () => UrlLauncherService.openUrl(url),
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
