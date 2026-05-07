import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/shared_prefs_helper.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';
import 'forgot_password_screen.dart';
import 'social_login_screen.dart';

class LoginScreen extends StatefulWidget {
  final Function(bool)? onThemeChanged;
  final Function(Locale)? onLocaleChanged;

  const LoginScreen({
    super.key,
    this.onThemeChanged,
    this.onLocaleChanged,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool obscurePassword = true;
  String? errorMessage;

  // Frontend Logic: Email Validation
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _handleSignIn() async {
    setState(() => errorMessage = null);
    String email = emailController.text.trim();
    String password = passwordController.text;

    // Frontend Logic: Field checks
    if (email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = 'Please fill in all fields');
      return;
    }
    if (!_isValidEmail(email)) {
      setState(() => errorMessage = 'Please enter a valid email');
      return;
    }
    if (password.length < 6) {
      setState(() => errorMessage = 'Password must be at least 6 characters');
      return;
    }

    // Frontend Logic: Saving state locally
    await SharedPrefsHelper.saveLoginState(
        true,
        email: email,
        name: email.split('@')[0],
        method: 'email'
    );

    if (!mounted) return;

    // Fixed navigation: Passing required non-nullable callbacks
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          onThemeChanged: widget.onThemeChanged,
          onLocaleChanged: widget.onLocaleChanged,
        ),
      ),
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
              const SizedBox(height: 50),

              // Figma Brand Logo Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.home_work_rounded, size: 50, color: AppColors.primary),
                    const SizedBox(height: 8),
                    const Text(
                      "HomeTec",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              const Text(
                "Welcome back",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Login to manage your smart home",
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textMedium,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 45),

              // Email Input with High Font Clarity
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.inputText,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: "Email Address",
                  labelStyle: const TextStyle(color: AppColors.textMedium, fontSize: 14, fontWeight: FontWeight.w500),
                  floatingLabelStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.fieldBorder, width: 1.5),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Password Input
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.inputText,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: AppColors.textMedium, fontSize: 14, fontWeight: FontWeight.w500),
                  floatingLabelStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.fieldBorder, width: 1.5),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => obscurePassword = !obscurePassword),
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textMedium,
                      size: 20,
                    ),
                  ),
                ),
              ),

              if (errorMessage != null) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],

              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => rememberMe = !rememberMe),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: rememberMe,
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            onChanged: (val) => setState(() => rememberMe = val!),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                            "Remember me",
                            style: TextStyle(color: AppColors.textMedium, fontSize: 14, fontWeight: FontWeight.w500)
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPasswordScreen())),
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Main Sign In Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: CustomButton(
                  text: "Sign In",
                  onPressed: _handleSignIn,
                ),
              ),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: AppColors.textMedium, fontSize: 15)
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SocialLoginScreen(
                              onThemeChanged: widget.onThemeChanged,
                              onLocaleChanged: widget.onLocaleChanged,
                            )
                        ),
                      );
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}