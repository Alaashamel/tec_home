import 'package:flutter/material.dart';
import 'login_screen.dart';

class ConfirmMailScreen extends StatelessWidget {
  const ConfirmMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.mark_email_read, size: 80, color: Colors.green),
          const SizedBox(height: 20),
          const Text("Confirm Mail", style: TextStyle(fontSize: 24)),
          const Text("A reset link has been sent to your email", textAlign: TextAlign.center),
          const SizedBox(height: 40),
          ElevatedButton(onPressed: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
          }, child: const Text("Back to Login")),
        ]),
      ),
    );
  }
}