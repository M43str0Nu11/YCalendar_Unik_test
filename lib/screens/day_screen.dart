import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../theme/app_theme.dart';
import 'create_event_screen.dart';

class DayScreen extends StatelessWidget {
  const DayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final date = provider.selectedDate;

    return Scaffold(
      appBar: AppBar(
        title: Text('События: ${date.day}.${date.month}.${date.year}'),
      ),
      body: RefreshIndicator(
        onRefresh: provider.loadForSelectedDate,
        child: provider.eventsForSelectedDate.isEmpty
            ? ListView(
                children: const [
                  SizedBox(height: 60),
                  Center(
                    child: Text(
                      'Нет событий на выбранную дату',
                      style: TextStyle(color: AppTheme.secondaryText),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: provider.eventsForSelectedDate.length,
                itemBuilder: (context, index) {
                  final e = provider.eventsForSelectedDate[index];
                  return Dismissible(
                    key: Key(e.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => provider.deleteEvent(e.id),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ListTile(
                      title: Text(e.title),
                      subtitle: Text(
                        e.description ?? '',
                        style: const TextStyle(color: AppTheme.secondaryText),
                      ),
                      trailing: Text(
                        e.startTime != null
                            ? '${e.startTime!.hour}:${e.startTime!.minute.toString().padLeft(2, '0')}'
                            : '',
                        style: const TextStyle(color: AppTheme.secondaryText),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateEventScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
