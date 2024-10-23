import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProductController extends GetxController {
  late TextEditingController nameC;
  late TextEditingController priceC;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Object?>> getData(String docID) async {
    DocumentReference docRef = firestore.collection('products').doc(docID);
    return docRef.get();
  }

  void editProduct(String name, String price, String docID) async {
    DocumentReference docData = firestore.collection("products").doc(docID);
    try {
      await docData.update(
        {
          "name": name,
          "price": int.parse(price),
        },
      );
      Get.dialog(
        AlertDialog(
          title: Text("Berhasil"),
          content: Text("Berhasil mengubah produk."),
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
          content: Text("Tidak berhasil mengubah produk."),
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
