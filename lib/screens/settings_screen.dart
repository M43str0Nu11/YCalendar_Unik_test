import 'package:flutter/material.dart';
import 'timezone_screen.dart';
import 'theme_mode_sheet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Настройки'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _tile(
            context,
            icon: Icons.public,
            title: 'Часовой пояс',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TimezoneScreen()),
            ),
          ),
          _divider(),
          _tile(
            context,
            icon: Icons.color_lens_outlined,
            title: 'Тема оформления',
            onTap: () async {
              showModalBottomSheet(
                context: context,
                builder: (_) => const ThemeModeSheet(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 16),
            Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500))),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Divider(height: 1, color: Colors.grey.shade300);
}
