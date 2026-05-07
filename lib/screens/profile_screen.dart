import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_button.dart';
import '../utils/shared_prefs_helper.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? _profileImagePath;
  bool _isEditing = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    String? name = await SharedPrefsHelper.getUserName();
    String? email = await SharedPrefsHelper.getUserEmail();
    String? phone = await SharedPrefsHelper.getUserPhone();
    String? imagePath = await SharedPrefsHelper.getProfileImage();
    setState(() {
      nameController.text = name ?? "Bill Sanders";
      emailController.text = email ?? "bll.sanders@example.com";
      phoneController.text = phone ?? "+1 234 567 890";
      _profileImagePath = imagePath;
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() => _profileImagePath = image.path);
        await SharedPrefsHelper.saveProfileImage(image.path);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile image updated!'), backgroundColor: AppColors.primary),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected'), backgroundColor: Colors.grey),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Unable to pick image'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isEditing = false);
    await SharedPrefsHelper.saveLoginState(true,
        email: emailController.text, name: nameController.text);
    await SharedPrefsHelper.saveUserPhone(phoneController.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: AppColors.primary),
    );
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
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
              const Text(
                "Your Profile",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                      image: _profileImagePath != null && File(_profileImagePath!).existsSync()
                          ? DecorationImage(
                              image: FileImage(File(_profileImagePath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _profileImagePath == null || !File(_profileImagePath!).existsSync()
                        ? const Icon(Icons.person, size: 80, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, size: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Personal information",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20),
              _profileField("Your Name :", nameController, enabled: _isEditing),
              _profileField("Email :", emailController, enabled: _isEditing),
              _profileField("Phone Number :", phoneController, enabled: _isEditing),
              const SizedBox(height: 40),
              if (_isEditing)
                CustomButton(
                  text: "Save Changes",
                  onPressed: _saveProfile,
                )
              else
                CustomButton(
                  text: "Edit Profile",
                  onPressed: () => setState(() => _isEditing = true),
                ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  setState(() {
                    nameController.text = "Bill Sanders";
                    emailController.text = "bll.sanders@example.com";
                    phoneController.text = "+1 234 567 890";
                    _profileImagePath = null;
                  });
                },
                child: const Text(
                  "Reset to Default",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await SharedPrefsHelper.logout();
                  if (!mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  "Log out",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "By continuing, you agree to our Terms of Service and have read our Policy",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: AppColors.textLight),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileField(String label, TextEditingController controller, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textDark, fontWeight: FontWeight.w600)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 5),
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.fieldBorder)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textLight)),
              ),
              style: TextStyle(fontSize: 14, color: enabled ? Colors.black : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
