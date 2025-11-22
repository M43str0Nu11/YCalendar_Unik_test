import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  static final _agreementUri =
      Uri.parse('https://yandex.ru/legal/calendar_mobile_agreement/ru/');

  Future<void> _openAgreement() async {
    await launchUrl(_agreementUri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('О приложении'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Color(0xFFFFD3D3),
                  child: CircleAvatar(
                    radius: 44,
                    backgroundColor: Colors.red,
                    child: Text('31',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
                SizedBox(height: 24),
                Text('Яндекс',
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
                SizedBox(height: 12),
                Text('Версия 1.13.9',
                    style: TextStyle(fontSize: 16, color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: ListTile(
              title: const Text('Пользовательское соглашение',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.chevron_right),
              onTap: _openAgreement,
            ),
          ),
          const SizedBox(height: 48),
          const Center(
            child: Text('© 2024–2025 Yandex',
                style: TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }
}
