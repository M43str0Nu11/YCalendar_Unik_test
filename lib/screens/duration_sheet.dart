import 'package:flutter/material.dart';

class DurationSheet extends StatelessWidget {
  final int current;
  const DurationSheet({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    final options = [15, 30, 60];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                const Text('Длительность',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const Spacer(flex: 2),
              ],
            ),
            const SizedBox(height: 8),
            ...options.map((d) => _tile(context, d, d == current)).toList(),
            _tile(context, -1, current != 15 && current != 30 && current != 60,
                label: 'Другое'),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, int minutes, bool selected,
      {String? label}) {
    return ListTile(
      title: Text(label ?? '$minutes минут'),
      trailing: selected ? const Icon(Icons.check, color: Colors.red) : null,
      onTap: () async {
        if (minutes == -1) {
          final custom = await showModalBottomSheet<int>(
            context: context,
            builder: (_) => const _CustomDurationSheet(),
          );
          if (!context.mounted) return;
          if (custom != null) Navigator.pop(context, custom);
        } else {
          Navigator.pop(context, minutes);
        }
      },
    );
  }
}

class _CustomDurationSheet extends StatefulWidget {
  const _CustomDurationSheet();

  @override
  State<_CustomDurationSheet> createState() => _CustomDurationSheetState();
}

class _CustomDurationSheetState extends State<_CustomDurationSheet> {
  int _value = 45;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                const Text('Минут',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const Spacer(flex: 2),
                TextButton(
                  onPressed: () => Navigator.pop(context, _value),
                  child: const Text('Сохранить',
                      style: TextStyle(color: Colors.red)),
                )
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: 181, // 1..180
              itemBuilder: (context, index) {
                final v = index + 1;
                final selected = v == _value;
                return ListTile(
                  title: Text('$v'),
                  trailing: selected
                      ? const Icon(Icons.check, color: Colors.red)
                      : null,
                  onTap: () => setState(() => _value = v),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
