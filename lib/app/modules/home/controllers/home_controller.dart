import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Object?>> getData() async {
    CollectionReference products = firestore.collection("products");
    return products.get();
  }

  Stream<QuerySnapshot<Object?>> streamData() {
    CollectionReference products = firestore.collection("products");

    debugPrint("ihhh");
    return products
        .orderBy('dateNow', descending: true)
        // .where('price', isGreaterThan: 10000) // harus didaftarkan di firebase
        .snapshots();
  }

  void deleteProduct(String docId) {
    DocumentReference docRef = firestore.collection('products').doc(docId);

    try {
      Get.dialog(
        AlertDialog(
          title: Text("Konfirmasi"),
          content: Text("Apakah anda yakin ingin menghapus data ini?"),
          actions: [
            OutlinedButton(
              onPressed: () => Get.back(),
              child: Text("Tidak"),
            ),
            ElevatedButton(
              onPressed: () async {
                await docRef.delete();
                Get.back();
                Get.dialog(
                  AlertDialog(
                    title: Text("Berhasil"),
                    content: Text("Produk berhasil dihapus."),
                  ),
                );
              },
              child: Text("Hapus"),
            ),
          ],
        ),
      );
    } catch (e) {
      log("$e");
      Get.dialog(
        AlertDialog(
          title: Text("Terjadi Kesalahan"),
          content: Text("Tidak dapat menghapus produk."),
        ),
      );
    }
  }
}
