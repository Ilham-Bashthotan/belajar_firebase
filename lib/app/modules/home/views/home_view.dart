import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

import '../controllers/home_controller.dart';
import '../../../controllers/auth_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final AuthController authC = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () => authC.logout(), icon: Icon(Icons.logout)),
        ],
      ),
      // Onetime
      // FutureBuilder(
      //   future: controller.getData(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       var listAllDocs = snapshot.data!.docs;
      //       return ListView.builder(
      //         itemCount: listAllDocs.length,
      //         itemBuilder: (context, index) => ListTile(
      //           title: Text(
      //             "${(listAllDocs[index].data() as Map<String, dynamic>)["name"]}",
      //           ),
      //           subtitle: Text(
      //             "Rp ${(listAllDocs[index].data() as Map<String, dynamic>)["price"]}",
      //           ),
      //         ),
      //       );
      //     }
      //     return Center(child: CircularProgressIndicator());
      //   },
      // ),
      // Realtime
      body: StreamBuilder(
        stream: controller.streamData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            var listAllDocs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: listAllDocs.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () => Get.toNamed(
                  Routes.EDIT_PRODUCT,
                  arguments: listAllDocs[index].id,
                ),
                title: Text(
                  "${(listAllDocs[index].data() as Map<String, dynamic>)["name"]}",
                ),
                subtitle: Text(
                  "Rp ${(listAllDocs[index].data() as Map<String, dynamic>)["price"]}",
                ),
                trailing: IconButton(
                  onPressed: () =>
                      controller.deleteProduct(listAllDocs[index].id),
                  icon: Icon(Icons.delete),
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.ADD_PRODUCT),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
