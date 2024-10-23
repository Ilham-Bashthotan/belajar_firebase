import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get streamAuthStatus => auth.authStateChanges();

  void resetPassword(String email) async {
    if (email != "" && GetUtils.isEmail(email)) {
      try {
        await auth.sendPasswordResetEmail(email: email);
        Get.dialog(
          AlertDialog(
            title: Text("Berhasil"),
            content:
                Text("Kami telah mengirimkan reset password ke email $email."),
          ),
        ).then((value) => Get.back());
      } catch (e) {
        Get.dialog(
          AlertDialog(
            title: Text("Terjadi kesalahan"),
            content: Text("Tidak dapat mengirimkan reset password."),
          ),
        );
      }
    } else {
      Get.dialog(
        AlertDialog(
          title: Text("Terjadi kesalahan"),
          content: Text("Email tidak valid."),
        ),
      );
    }
  }

  void signup(String email, String pass) async {
    try {
      UserCredential myUser =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      await myUser.user!.sendEmailVerification();
      Get.dialog(
        AlertDialog(
          title: Text("Verifikasi Email"),
          content: Text("Kami telah mengirimkan email verifikasi ke $email."),
        ),
      ).then(
        (value) => Get.back(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
        Get.dialog(
          AlertDialog(
            title: Text("Terjadi Kesalahan"),
            content: Text("Kata sandi yang diberikan terlalu lemah."),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
        Get.dialog(
          AlertDialog(
            title: Text("Terjadi Kesalahan"),
            content: Text("Akun sudah ada untuk email $email."),
          ),
        );
      }
    } catch (e) {
      log("$e");
      Get.dialog(
        AlertDialog(
          title: Text("Terjadi Kesalahan"),
          content: Text("Tidak dapat mendaftarkan akun ini."),
        ),
      );
    }
  }

  void login(String email, String pass) async {
    try {
      UserCredential myUser = await auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      if (myUser.user!.emailVerified) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.dialog(
          AlertDialog(
            title: Text("Terjadi Kesalahan"),
            content: Text(
                "Kamu perlu verifikasi email dulu. Apakah kamu ingin dikirimakn verivikasi ulang?"),
            actions: [
              OutlinedButton(
                  onPressed: () => Get.back(), child: Text("Kembali")),
              ElevatedButton(
                onPressed: () async {
                  await myUser.user!.sendEmailVerification();
                  Get.back();
                },
                child: Text("Kirim Ulang"),
              )
            ],
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
        Get.dialog(
          AlertDialog(
            title: Text("Terjadi Kesalahan"),
            content: Text("Tidak ada pengguna yang ditemukan untuk email itu."),
          ),
        );
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
        Get.dialog(
          AlertDialog(
            title: Text("Terjadi Kesalahan"),
            content: Text("Kata sandi salah diberikan untuk pengguna itu."),
          ),
        );
      } else {
        log("$e");
        Get.dialog(
          AlertDialog(
            title: Text("Terjadi Kesalahan"),
            content: Text("Tidak dapat login dengan akun ini."),
          ),
        );
      }
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
