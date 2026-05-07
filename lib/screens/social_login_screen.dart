import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/shared_prefs_helper.dart';
import '../widgets/custom_button.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SocialLoginScreen extends StatefulWidget {
  final Function(bool)? onThemeChanged;
  final Function(Locale)? onLocaleChanged;

  const SocialLoginScreen({super.key, this.onThemeChanged, this.onLocaleChanged});

  @override
  State<SocialLoginScreen> createState() => _SocialLoginScreenState();
}

class _SocialLoginScreenState extends State<SocialLoginScreen> {
  bool _isLoading = false;

  Future<void> _handleSocialLogin(String method, String name, String email) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    await SharedPrefsHelper.saveLoginState(true, email: email, name: name, method: method);
    setState(() => _isLoading = false);
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          onThemeChanged: widget.onThemeChanged,
          onLocaleChanged: widget.onLocaleChanged,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.home_work_outlined, size: 60, color: AppColors.primary),
                          const Text(
                            "HomeTec",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "Let's Get Started",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40),
                    _socialButton(
                      icon: Icons.face,
                      text: "Face Recognition",
                      color: AppColors.primary,
                      onPressed: () => _handleSocialLogin("face", "User Face", "face@example.com"),
                    ),
                    const SizedBox(height: 20),
                    _socialButton(
                      icon: Icons.alternate_email,
                      text: "Twitter / X",
                      color: AppColors.twitterBlue,
                      onPressed: () => _handleSocialLogin("twitter", "Twitter User", "twitter@example.com"),
                    ),
                    const SizedBox(height: 20),
                    _socialButton(
                      icon: Icons.g_mobiledata,
                      text: "Google",
                      color: AppColors.googleRed,
                      onPressed: () => _handleSocialLogin("google", "Google User", "google@example.com"),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? ", style: TextStyle(color: AppColors.textLight)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          },
                          child: const Text(
                            "Signin",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      text: "Create an Account",
                      onPressed: () {
                        _handleSocialLogin("email", "New User", "newuser@example.com");
                      },
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

  Widget _socialButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
    );
  }
}
