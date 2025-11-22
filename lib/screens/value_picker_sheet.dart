import 'package:flutter/material.dart';

class ValuePickerSheet extends StatelessWidget {
  final int current;
  const ValuePickerSheet({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    final values = List<int>.generate(60, (i) => i + 1); // 1..60
    return SafeArea(
      child: ListView.builder(
        itemCount: values.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
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
                ],
              ),
            );
          }
          final v = values[index - 1];
          final selected = v == current;
          return ListTile(
            title: Text('$v'),
            trailing:
                selected ? const Icon(Icons.check, color: Colors.red) : null,
            onTap: () => Navigator.pop(context, v),
          );
        },
      ),
    );
  }
}
