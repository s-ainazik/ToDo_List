import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final bool isDarkTheme;
  final Function(bool) onThemeToggle;

  const SettingsPage({
    super.key,
    required this.isDarkTheme,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Настройки',
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Тёмная тема',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Switch(
                          value: isDarkTheme,
                          onChanged: onThemeToggle,
                          thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
                            if (states.contains(WidgetState.selected)) {
                              return Colors.blue;
                            }
                            return Colors.grey;
                          }),
                          trackColor: WidgetStateProperty.resolveWith<Color>((states) {
                            if (states.contains(WidgetState.selected)) {
                              return Colors.blue.withValues(alpha: 0.5); // ✅ новая версия
                            }
                            return Colors.grey.withValues(alpha: 0.5);   // ✅ новая версия
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      isDarkTheme
                          ? 'Использовать светлое\nоформление приложения'
                          : 'Использовать тёмное\nоформление приложения',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}