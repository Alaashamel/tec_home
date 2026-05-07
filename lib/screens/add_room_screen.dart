import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final TextEditingController roomNameController = TextEditingController();
  final TextEditingController lightsController = TextEditingController();
  final TextEditingController devicesController = TextEditingController();
  final TextEditingController tempController = TextEditingController();
  String? errorMessage;

  void _handleDone() {
    setState(() => errorMessage = null);
    if (roomNameController.text.trim().isEmpty) {
      setState(() => errorMessage = 'Please enter room name');
      return;
    }
    Navigator.pop(context, {
      'name': roomNameController.text.trim(),
      'lights': int.tryParse(lightsController.text) ?? 0,
      'devices': int.tryParse(devicesController.text) ?? 0,
      'temp': double.tryParse(tempController.text) ?? 22.0,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "+ Add New Room",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              _inputField("room name", roomNameController, TextInputType.text),
              _inputField("number of lights", lightsController, TextInputType.number),
              _inputField("number of devices", devicesController, TextInputType.number),
              _inputField("temperature in C", tempController, TextInputType.number),
              if (errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 100,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _handleDone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text("Done", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(Icons.home_work_outlined, size: 50, color: AppColors.primary),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "HomeTec",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller, TextInputType keyboardType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.inputText),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.fieldFill,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            errorText: label.contains('name') && errorMessage != null && controller.text.isEmpty
                ? 'Required'
                : null,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
