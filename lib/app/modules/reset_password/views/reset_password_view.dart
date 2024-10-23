import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/reset_password_controller.dart';
import '../../../controllers/auth_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  ResetPasswordView({super.key});

  final AuthController authC = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password Screen'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller.emailC,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => authC.resetPassword(controller.emailC.text),
              child: Text("Reset"),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text("Sudah punyua akun?"),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text("Login!"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
