import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';
import 'calendars_sheet.dart';
import 'about_app_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Профиль'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ProfileHeader(),
          const SizedBox(height: 16),
          _SectionCard(children: [
            _Item(
              icon: Icons.notifications_none,
              title: 'Уведомления',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              ),
            ),
            _Item(
              icon: Icons.view_module_outlined,
              title: 'Календари',
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const CalendarsSheet(),
              ),
            ),
            _Item(
              icon: Icons.settings_outlined,
              title: 'Настройки',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _SectionCard(children: [
            const _Item(
              icon: Icons.chat_bubble_outline,
              title: 'Поддержка',
              danger: true,
              onTap: null,
            ),
            _Item(
              icon: Icons.help_outline,
              title: 'Справка',
              onTap: () async {
                final uri = Uri.parse(
                    'https://passport.yandex.ru/auth/session?track_id=0039d630f1a2906525d2dbf26148741dae');
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
            ),
            _Item(
              icon: Icons.info_outline,
              title: 'О приложении',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutAppScreen()),
              ),
            ),
            const _Item(
                icon: Icons.feedback_outlined,
                title: 'Обратная связь',
                onTap: null),
            const _Item(icon: Icons.logout, title: 'Выход', onTap: null),
          ]),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade800,
              border: Border.all(color: AppTheme.accentBlueRing, width: 2),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Максим Цыганов', style: AppTheme.h2),
                SizedBox(height: 4),
                Text('mkstcyganov@yandex.ru', style: AppTheme.bodySecondary),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              Divider(height: 1, color: AppTheme.border.withValues(alpha: 0.6)),
          ]
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool danger;
  final VoidCallback? onTap;
  const _Item(
      {required this.icon,
      required this.title,
      this.danger = false,
      this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: danger ? AppTheme.danger : AppTheme.black),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: danger
                    ? AppTheme.body.copyWith(color: AppTheme.danger)
                    : AppTheme.body,
              ),
            ),
            const Icon(Icons.chevron_right, size: 20),
          ],
        ),
      ),
    );
  }
}
