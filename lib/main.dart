import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/event_provider.dart';
import 'providers/calendar_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/timeline_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const AppCalendar());
}

class AppCalendar extends StatelessWidget {
  const AppCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) => MaterialApp(
          title: 'App Calendar',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.lightTheme.copyWith(brightness: Brightness.dark),
          themeMode: settings.themeMode,
          home: const TimelineScreen(),
        ),
      ),
    );
  }
}
