AppCalendar
===========

Кроссплатформенный (Flutter) календарь с:
- Списком событий дня (красные карточки с временным диапазоном)
- Управлением несколькими календарями (нижний лист «Календари» + создание нового с напоминаниями)
- Профилем и разделами: уведомления, настройки (часовой пояс, тема), о приложении
- Настройкой напоминаний (значение, единица, канал доставки)
- Темной/светлой/системной темой (через SettingsProvider)

Стек:
- Flutter (Windows desktop целевая платформа)
- Provider (EventProvider, CalendarProvider, SettingsProvider)
- url_launcher (внешние ссылки)
- uuid (генерация идентификаторов)

Структура:
```
lib/
	main.dart
	theme/app_theme.dart
	models/ (event.dart, calendar.dart)
	providers/ (event_provider.dart, calendar_provider.dart, settings_provider.dart)
	screens/ (...)
```

Запуск (Windows):
1. Включить Developer Mode (симлинки необходимы для плагинов).
2. Установить Flutter SDK и добавить в PATH.
3. Выполнить:
```powershell
flutter pub get
flutter run -d windows
```

Git репозиторий (если ещё не инициализирован):
```powershell
# Установить Git (если не установлен): winget install --id Git.Git -e
git init
git add .
git commit -m "Initial commit"
```

Создание репозитория на GitHub (варианты):
1. Через веб: создать пустой репозиторий, скопировать URL (HTTPS).
2. Через GitHub CLI (если установлен):
```powershell
gh repo create <username>/AppCalendar --private --source . --remote origin --push
```

Ручное добавление удалённого репо:
```powershell
git branch -m main
git remote add origin https://github.com/<username>/AppCalendar.git
git push -u origin main
```

Лицензия / права: не указаны. Добавьте LICENSE при необходимости.

TODO идеи:
- Persist настроек (SharedPreferences)
- Расширить список часовых поясов
- Анимации переходов и герои
- Редактирование событий
```
