import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../theme/app_theme.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  TimeOfDay? _start;
  TimeOfDay? _end;
  DateTime? _date;
  bool _allDay = false;
  String _lastEventId = '';

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickTime({required bool isStart}) async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t == null) return;
    if (!mounted) return;
    setState(() {
      if (isStart) {
        _start = t;
      } else {
        _end = t;
      }
    });
  }

  Future<void> _pickDate() async {
    final provider = Provider.of<EventProvider>(context, listen: false);
    final initial = _date ?? provider.selectedDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    if (!mounted) return;
    setState(() {
      _date = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context, listen: false);
    final selected = _date ?? provider.selectedDate;
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Создать событие'),
        actions: [
          TextButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;
              DateTime? startDt;
              DateTime? endDt;
              if (!_allDay && _start != null) {
                startDt = DateTime(
                  selected.year,
                  selected.month,
                  selected.day,
                  _start!.hour,
                  _start!.minute,
                );
              }
              if (!_allDay && _end != null) {
                endDt = DateTime(
                  selected.year,
                  selected.month,
                  selected.day,
                  _end!.hour,
                  _end!.minute,
                );
              }
              if (startDt != null && endDt != null && !startDt.isBefore(endDt)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Время начала должно быть раньше времени окончания'),
                  ),
                );
                return;
              }
              final eventId = await provider.addEvent(
                title: _titleController.text.trim(),
                start: startDt,
                end: endDt,
                description: _descController.text.trim(),
                date: selected,
              );
              _lastEventId = eventId;
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Событие создано'),
                  action: SnackBarAction(
                    label: 'Отменить',
                    onPressed: () {
                      provider.deleteEvent(_lastEventId);
                    },
                  ),
                  duration: const Duration(seconds: 4),
                ),
              );
            },
            child: const Text('Сохранить', style: TextStyle(color: AppTheme.primary)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Название',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Введите название' : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Дата',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('${selected.day}.${selected.month}.${selected.year}'),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Весь день'),
                value: _allDay,
                onChanged: (v) {
                  setState(() {
                    _allDay = v;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              if (!_allDay) ...[
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _pickTime(isStart: true),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Время начала',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(_start == null ? 'Не выбрано' : _start!.format(context)),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _pickTime(isStart: false),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Время окончания',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(_end == null ? 'Не выбрано' : _end!.format(context)),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
