import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  const AddProductView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller.nameC,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Product Name"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: controller.priceC,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: "Product Price"),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => controller.addProduct(
                  controller.nameC.text, controller.priceC.text),
              child: Text("Add product"),
            ),
          ],
        ),
      ),
    );
  }
}