import 'package:flutter/material.dart';
import 'utils/theme_colors.dart';

class SettingsScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onResetProgress;

  const SettingsScreen({
    Key? key,
    required this.themeMode,
    required this.onToggleTheme,
    required this.onResetProgress,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = widget.themeMode == ThemeMode.dark;
    final primaryColor = ThemeColors.primaryColor;
    final cardColor = ThemeColors.getCardColor(isDark);
    final textColor = ThemeColors.getTextColor(isDark);
    final accentColor = ThemeColors.getAccentColor(isDark);

    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Container(
            color: cardColor,
            child: ListTile(
              leading: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: primaryColor,
              ),
              title: Text(
                isDark ? 'Dark Mode' : 'Light Mode',
                style: TextStyle(color: textColor),
              ),
              trailing: Switch(
                value: isDark,
                onChanged: (_) => widget.onToggleTheme(),
                activeColor: primaryColor,
              ),
              onTap: widget.onToggleTheme,
            ),
          ),
          const Divider(height: 0),
          Container(
            color: cardColor,
            child: ListTile(
              leading: Icon(Icons.refresh, color: primaryColor),
              title: Text('Reset Progress', style: TextStyle(color: textColor)),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: cardColor,
                    title: Text(
                      'Reset Progress',
                      style: TextStyle(color: textColor),
                    ),
                    content: Text(
                      'Are you sure you want to reset all your progress? This cannot be undone.',
                      style: TextStyle(color: textColor),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(
                          'Reset',
                          style: TextStyle(color: ThemeColors.errorColor),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  widget.onResetProgress();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Progress reset!',
                        style: TextStyle(color: textColor),
                      ),
                      backgroundColor: cardColor,
                    ),
                  );
                }
              },
            ),
          ),
          const Divider(height: 0),
          Container(
            color: cardColor,
            child: ListTile(
              leading: Icon(Icons.info_outline, color: primaryColor),
              title: Text('About', style: TextStyle(color: textColor)),
              subtitle: Text(
                'Fitness Tracker App\nVersion 1.0.0',
                style: TextStyle(color: ThemeColors.getMutedTextColor(isDark)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
