import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class RoomCard extends StatefulWidget {
  final String name;
  final IconData icon;
  final int lightsOn;
  final int? temp;
  final bool? tvOn;
  final bool? fridgeOn;

  const RoomCard({
    required this.name,
    required this.icon,
    required this.lightsOn,
    this.temp,
    this.tvOn,
    this.fridgeOn,
    super.key,
  });

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  late int _lightsOn;
  late bool _tvOn;
  late bool _fridgeOn;

  @override
  void initState() {
    super.initState();
    _lightsOn = widget.lightsOn;
    _tvOn = widget.tvOn ?? false;
    _fridgeOn = widget.fridgeOn ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg, // Fixed: Uses the defined cardBg color
        borderRadius: BorderRadius.circular(24), // Modern Figma radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
                widget.icon,
                color: AppColors.primary,
                size: 28
            ),
          ),
          const SizedBox(width: 16),

          // Content Area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark, // High contrast font
                      ),
                    ),
                    if (widget.name == "Living room")
                      Transform.scale(
                        scale: 0.8, // Slightly smaller switch for elegance
                        child: Switch(
                          value: _lightsOn > 0,
                          onChanged: (v) {
                            setState(() => _lightsOn = v ? 2 : 0);
                            _showStatusSnackBar(context, v ? 'Lights turned on' : 'Lights turned off');
                          },
                          activeTrackColor: AppColors.switchGreen.withValues(alpha: 0.4),
                          activeThumbColor: AppColors.switchGreen,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),

                // Secondary Info Row
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _lightsOn = _lightsOn > 0 ? 0 : 2),
                      child: Text(
                        _lightsOn > 0 ? "$_lightsOn lights on" : "All lights Off",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _lightsOn > 0 ? AppColors.switchGreen : AppColors.textMedium,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (widget.temp != null) ...[
                      const Icon(Icons.thermostat_rounded, size: 16, color: AppColors.textMedium),
                      Text(
                          " ${widget.temp}°C",
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w600
                          )
                      ),
                    ],
                  ],
                ),

                // Device Specific Status
                if (widget.tvOn != null || widget.fridgeOn != null) ...[
                  const SizedBox(height: 8),
                  const Divider(height: 1, thickness: 0.5),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (widget.tvOn != null)
                        _buildSmallToggleButton(
                            icon: Icons.tv_rounded,
                            label: "TV",
                            isActive: _tvOn,
                            onTap: () {
                              setState(() => _tvOn = !_tvOn);
                              _showStatusSnackBar(context, _tvOn ? 'TV is now On' : 'TV is now Off');
                            }
                        ),
                      if (widget.fridgeOn != null)
                        _buildSmallToggleButton(
                            icon: Icons.kitchen_rounded,
                            label: "Fridge",
                            isActive: _fridgeOn,
                            onTap: () {
                              setState(() => _fridgeOn = !_fridgeOn);
                              _showStatusSnackBar(context, _fridgeOn ? 'Fridge is now On' : 'Fridge is now Off');
                            }
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper for small device toggles
  Widget _buildSmallToggleButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Row(
          children: [
            Icon(
                icon,
                size: 16,
                color: isActive ? AppColors.switchGreen : AppColors.textMedium
            ),
            const SizedBox(width: 4),
            Text(
                label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? AppColors.switchGreen : AppColors.textMedium
                )
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}