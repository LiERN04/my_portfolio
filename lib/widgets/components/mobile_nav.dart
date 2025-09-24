import 'package:flutter/material.dart';

class MobileNavigation extends StatelessWidget {
  final Function(String) onSectionTap;

  const MobileNavigation({super.key, required this.onSectionTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showNavigationSheet(context),
      child: const Icon(Icons.menu),
    );
  }

  void _showNavigationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNavItem(context, 'about', 'About Me', Icons.info_outline),
            _buildNavItem(context, 'skills', 'I specialize in', Icons.code),
            _buildNavItem(context, 'projects', 'Projects', Icons.work_outline),
            _buildNavItem(
              context,
              'contact',
              'Get In Touch',
              Icons.email_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String id,
    String title,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onSectionTap(id);
      },
    );
  }
}
