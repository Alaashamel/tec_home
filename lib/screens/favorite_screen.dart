import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/shared_prefs_helper.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Map<String, dynamic>> favoriteItems = [
    {'id': 'light', 'name': 'Living room lights', 'icon': Icons.lightbulb_outline, 'status': true, 'type': 'switch'},
    {'id': 'temp', 'name': 'Temperature', 'icon': Icons.thermostat, 'value': '22 °C', 'status': false, 'type': 'info'},
    {'id': 'lock', 'name': 'Main Door Lock', 'icon': Icons.lock_outline, 'status': true, 'type': 'switch'},
    {'id': 'camera', 'name': 'Security Camera', 'icon': Icons.videocam_outlined, 'status': false, 'type': 'navigation'},
    {'id': 'ac', 'name': 'AC Control', 'icon': Icons.ac_unit, 'status': true, 'type': 'switch'},
    {'id': 'fan', 'name': 'Ceiling Fan', 'icon': Icons.wind_power, 'status': false, 'type': 'switch'},
  ];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    List<String> favorites = await SharedPrefsHelper.getFavorites();
    if (favorites.isNotEmpty) {
      setState(() {
        for (var item in favoriteItems) {
          item['status'] = favorites.contains(item['id']);
        }
      });
    }
  }

  Future<void> _toggleFavorite(String id, bool value) async {
    setState(() {
      for (var item in favoriteItems) {
        if (item['id'] == id) {
          item['status'] = value;
        }
      }
    });
    List<String> favorites = favoriteItems
        .where((item) => item['status'] == true)
        .map((item) => item['id'] as String)
        .toList();
    await SharedPrefsHelper.saveFavorites(favorites);
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
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                const Text(
                  "Favorite Devices",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.1,
              ),
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final item = favoriteItems[index];
                return _buildFavoriteCard(item);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> item) {
    bool isOn = item['status'] as bool;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isOn ? AppColors.primary.withValues(alpha: 0.1) : AppColors.cardBg,
        borderRadius: BorderRadius.circular(15),
        border: isOn ? Border.all(color: AppColors.primary.withValues(alpha: 0.3)) : null,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isOn ? AppColors.primary.withValues(alpha: 0.2) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: isOn ? AppColors.primary : Colors.grey,
                  size: 24,
                ),
              ),
              if (item['type'] == 'switch')
                Switch(
                  value: isOn,
                  onChanged: (value) => _toggleFavorite(item['id'], value),
                  activeThumbColor: AppColors.primary,
                ),
              if (item['type'] == 'navigation')
                const Icon(Icons.chevron_right, size: 20),
            ],
          ),
          const Spacer(),
          Text(
            item['name'],
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (item['type'] == 'info')
            Text(
              item['value'] ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          if (item['type'] == 'switch')
            Text(
              isOn ? "ON" : "OFF",
              style: TextStyle(
                fontSize: 10,
                color: isOn ? AppColors.switchGreen : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
