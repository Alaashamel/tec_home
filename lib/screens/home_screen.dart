import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/shared_prefs_helper.dart';
import '../widgets/bottom_nav_bar.dart';
import 'profile_screen.dart';
import 'rooms_stats_screen.dart';
import 'favorite_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool)? onThemeChanged;
  final Function(Locale)? onLocaleChanged;

  const HomeScreen({super.key, this.onThemeChanged, this.onLocaleChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<Widget> get _pages => [
    HomeContent(
      onThemeChanged: widget.onThemeChanged,
      onLocaleChanged: widget.onLocaleChanged,
    ),
    const FavoriteScreen(),
    const RoomsStatsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final Function(bool)? onThemeChanged;
  final Function(Locale)? onLocaleChanged;

  const HomeContent({super.key, this.onThemeChanged, this.onLocaleChanged});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int _selectedModeIndex = 0;
  bool _lightsOn = true;
  bool _lockOn = true;

  final List<Map<String, dynamic>> _quickModes = [
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.beach_access, 'label': 'Away'},
    {'icon': Icons.wb_sunny, 'label': 'Sleep'},
    {'icon': Icons.fitness_center, 'label': 'Gym'},
    {'icon': Icons.local_cafe, 'label': 'Party'},
  ];

  @override
  void initState() {
    super.initState();
    _loadQuickMode();
  }

  Future<void> _loadQuickMode() async {
    int mode = await SharedPrefsHelper.getQuickMode();
    setState(() => _selectedModeIndex = mode);
  }

  Future<void> _selectMode(int index) async {
    setState(() => _selectedModeIndex = index);
    await SharedPrefsHelper.saveQuickMode(index);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mode changed to ${_quickModes[index]['label']}'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                Column(
                  children: [
                    Icon(Icons.home_work_outlined, size: 40, color: AppColors.primary),
                    const Text(
                      "HomeTec",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SettingsScreen(
                          onThemeChanged: widget.onThemeChanged ?? (v) {},
                          onLocaleChanged: widget.onLocaleChanged ?? (l) {},
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.settings, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Quick Modes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('View all modes'), backgroundColor: AppColors.primary),
                    );
                  },
                  child: const Icon(Icons.arrow_forward, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_quickModes.length, (index) {
                  return _quickModeItem(
                    _quickModes[index]['icon'],
                    _quickModes[index]['label'],
                    _selectedModeIndex == index,
                    () => _selectMode(index),
                  );
                }),
              ),
            ),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('System toggled'),
                    backgroundColor: AppColors.primary,
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("System Status : Enable", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        const Text("4 devices in use", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Energy Usage : 20.14 kWh", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        Text("Security : All doors are locked", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Favorite",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FavoriteScreen()),
                    );
                  },
                  child: const Text(
                    "See All",
                    style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.5,
              children: [
                _favoriteItem(Icons.lightbulb_outline, "Living room lights", _lightsOn,
                    onToggle: (v) => setState(() => _lightsOn = v)),
                _favoriteItem(Icons.thermostat, "Temperature", false, extra: "22 °C", isInfo: true),
                _favoriteItem(Icons.lock_outline, "Main Door Lock", _lockOn,
                    onToggle: (v) => setState(() => _lockOn = v)),
                _favoriteItem(Icons.videocam_outlined, "Security Camera", false, isNavigation: true),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _quickModeItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                boxShadow: isSelected
                    ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))]
                    : null,
              ),
              child: Icon(icon, color: isSelected ? Colors.white : AppColors.primary),
            ),
            const SizedBox(height: 5),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _favoriteItem(IconData icon, String title, bool value,
      {Function(bool)? onToggle, String? extra, bool isInfo = false, bool isNavigation = false}) {
    return GestureDetector(
      onTap: isNavigation
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening Security Camera...'), backgroundColor: AppColors.primary),
              );
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: value ? AppColors.primary.withValues(alpha: 0.1) : AppColors.cardBg,
          borderRadius: BorderRadius.circular(15),
          border: value ? Border.all(color: AppColors.primary.withValues(alpha: 0.3)) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: value ? AppColors.primary.withValues(alpha: 0.2) : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: value ? AppColors.primary : Colors.grey, size: 20),
                ),
                if (onToggle != null)
                  Switch(
                    value: value,
                    onChanged: onToggle,
                    activeThumbColor: AppColors.switchGreen,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                if (isNavigation) const Icon(Icons.chevron_right, size: 20),
              ],
            ),
            const Spacer(),
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
            if (extra != null)
              Text(extra, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            if (onToggle != null)
              Text(value ? "ON" : "OFF", style: TextStyle(fontSize: 10, color: value ? AppColors.switchGreen : Colors.grey)),
          ],
        ),
      ),
    );
  }
}
