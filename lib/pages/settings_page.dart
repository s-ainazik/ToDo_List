import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final Function(bool) onThemeToggle;
  const SettingsPage({super.key, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки', style: TextStyle(fontWeight: FontWeight.normal)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Тёмная тема', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        Switch(
                          value: isDarkTheme,
                          onChanged: onThemeToggle,
                          activeColor: Colors.blue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isDarkTheme
                          ? 'Использовать светлое оформление приложения'
                          : 'Использовать тёмное оформление приложения',
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