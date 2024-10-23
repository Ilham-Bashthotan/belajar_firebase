import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  late TextEditingController nameC;
  late TextEditingController priceC;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addProduct(String name, String price) async {
    CollectionReference products = firestore.collection("products");
    try {
      String dateNow = DateTime.now().toIso8601String();

      await products.add(
        {
          "name": name,
          "price": int.parse(price),
          "dateNow": dateNow,
        },
      );
      Get.dialog(
        AlertDialog(
          title: Text("Berhasil"),
          content: Text("Berhasil menambahkan produk."),
        ),
      ).then(
        (value) {
          nameC.clear();
          priceC.clear();
          Get.back();
        },
      );
    } catch (e) {
      log("$e");
      Get.dialog(
        AlertDialog(
          title: Text("Terjadi kesalahan"),
          content: Text("Tidak berhasil menambahkan produk."),
        ),
      );
    }
  }

  @override
  void onInit() {
    nameC = TextEditingController();
    priceC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    nameC.dispose();
    priceC.dispose();
    super.onClose();
  }
}
