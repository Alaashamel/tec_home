import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/room_card.dart';
import 'add_room_screen.dart';

class RoomsStatsScreen extends StatefulWidget {
  const RoomsStatsScreen({super.key});

  @override
  State<RoomsStatsScreen> createState() => _RoomsStatsScreenState();
}

class _RoomsStatsScreenState extends State<RoomsStatsScreen> {
  List<Map<String, dynamic>> rooms = [
    {
      'name': 'Living room',
      'icon': Icons.weekend,
      'lightsOn': 2,
      'temp': 22,
      'tvOn': false,
    },
    {
      'name': 'Bed room',
      'icon': Icons.bed,
      'lightsOn': 0,
      'temp': 22,
    },
    {
      'name': 'Kitchen',
      'icon': Icons.kitchen,
      'lightsOn': 1,
      'fridgeOn': true,
    },
    {
      'name': 'Toilet',
      'icon': Icons.wc,
      'lightsOn': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
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
                const Text(
                  "Rooms & stats",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notifications tapped'), backgroundColor: AppColors.primary),
                    );
                  },
                  child: const Icon(Icons.notifications_none, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...List.generate(rooms.length, (index) {
              var room = rooms[index];
              return Dismissible(
                key: Key('room_${room['name']}_$index'),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  setState(() {
                    rooms.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${room['name']} removed'), backgroundColor: Colors.red),
                  );
                },
                background: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
                child: RoomCard(
                  name: room['name'],
                  icon: room['icon'],
                  lightsOn: room['lightsOn'],
                  temp: room['temp'],
                  tvOn: room['tvOn'],
                  fridgeOn: room['fridgeOn'],
                ),
              );
            }),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddRoomScreen()),
                );
                if (result != null && mounted) {
                  setState(() {
                    rooms.add({
                      'name': result['name'],
                      'icon': Icons.meeting_room,
                      'lightsOn': result['lights'],
                      'temp': (result['temp'] as double).round(),
                    });
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${result['name']} added!'), backgroundColor: AppColors.primary),
                  );
                }
              },
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add, color: AppColors.primary),
                      Text("Add New Room", style: TextStyle(color: AppColors.textLight)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("KW", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Container(
              height: 150,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CustomPaint(
                painter: ChartPainter(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("M", style: TextStyle(fontSize: 10)),
                Text("T", style: TextStyle(fontSize: 10)),
                Text("W", style: TextStyle(fontSize: 10)),
                Text("T", style: TextStyle(fontSize: 10)),
                Text("F", style: TextStyle(fontSize: 10)),
                Text("S", style: TextStyle(fontSize: 10)),
                Text("S", style: TextStyle(fontSize: 10)),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.lineTo(size.width * 0.15, size.height * 0.6);
    path.lineTo(size.width * 0.3, size.height * 0.7);
    path.lineTo(size.width * 0.45, size.height * 0.9);
    path.lineTo(size.width * 0.6, size.height * 0.75);
    path.lineTo(size.width * 0.75, size.height * 0.85);
    path.lineTo(size.width, size.height * 0.7);

    canvas.drawPath(path, paint);

    final fillPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
