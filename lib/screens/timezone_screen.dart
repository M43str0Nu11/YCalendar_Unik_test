import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class TimezoneScreen extends StatefulWidget {
  const TimezoneScreen({super.key});

  @override
  State<TimezoneScreen> createState() => _TimezoneScreenState();
}

class _TimezoneScreenState extends State<TimezoneScreen> {
  String _query = '';
  String _selected = DateTime.now().timeZoneName;

  // Simple static sample list (for demonstration)
  final _zones = const [
    'UTC',
    'Europe/Moscow',
    'Europe/Berlin',
    'Europe/London',
    'Asia/Tokyo',
    'America/New_York',
    'America/Los_Angeles',
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _zones
        .where((z) => z.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Часовой пояс'),
        actions: [
          TextButton(
            onPressed: () {
              settings.setTimezone(_selected);
              Navigator.pop(context);
            },
            child: const Text('Сохранить', style: TextStyle(color: Colors.red)),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Поиск...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.grey.shade300),
              itemBuilder: (context, index) {
                final zone = filtered[index];
                final selected = zone == _selected;
                return ListTile(
                  title: Text(zone),
                  trailing: selected
                      ? const Icon(Icons.check, color: Colors.red)
                      : null,
                  onTap: () => setState(() => _selected = zone),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
