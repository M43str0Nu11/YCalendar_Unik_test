import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool pushApp = true;
  bool email = true;
  bool browser = false;
  bool caldav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Уведомления'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _switchTile(
              'Пуш в приложении', pushApp, (v) => setState(() => pushApp = v)),
          _divider(),
          _switchTile(
              'Письмо на почту', email, (v) => setState(() => email = v)),
          _divider(),
          _switchTile(
              'Пуш в браузере', browser, (v) => setState(() => browser = v)),
          _divider(),
          _switchTile(
              'Через CalDav', caldav, (v) => setState(() => caldav = v)),
        ],
      ),
    );
  }

  Widget _switchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }

  Widget _divider() => Divider(height: 1, color: Colors.grey.shade300);
}
