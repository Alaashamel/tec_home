import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/shared_prefs_helper.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final Function(Locale) onLocaleChanged;

  const SettingsScreen({
    super.key,
    required this.onThemeChanged,
    required this.onLocaleChanged
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDark = false;
  String _currentLang = 'en';

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  void _loadCurrentSettings() async {
    bool dark = await SharedPrefsHelper.isDarkMode();
    String? lang = await SharedPrefsHelper.getLanguage();
    setState(() {
      _isDark = dark;
      _currentLang = lang ?? 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader("Appearance"),
          _buildSettingTile(
            "Dark Mode",
            "Adjust the app's visual theme",
            Switch(
              value: _isDark,
              activeThumbColor: AppColors.primary,
              onChanged: (val) async {
                setState(() => _isDark = val);
                await SharedPrefsHelper.setDarkMode(val);
                widget.onThemeChanged(val);
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader("Language"),
          _buildSettingTile(
            "App Language",
            "Choose your preferred language",
            DropdownButton<String>(
              value: _currentLang,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
              items: const [
                DropdownMenuItem(value: 'en', child: Text("English", style: TextStyle(fontSize: 14))),
                DropdownMenuItem(value: 'es', child: Text("Español", style: TextStyle(fontSize: 14))),
                DropdownMenuItem(value: 'ar', child: Text("العربية", style: TextStyle(fontSize: 14))),
              ],
              onChanged: (val) async {
                if (val != null) {
                  setState(() => _currentLang = val);
                  await SharedPrefsHelper.saveLanguage(val);
                  widget.onLocaleChanged(Locale(val));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textLight,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile(String title, String subtitle, Widget trailing) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.textMedium, fontSize: 13)),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}