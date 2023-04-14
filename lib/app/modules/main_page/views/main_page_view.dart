import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../home/views/home_view.dart';
import '../controllers/main_page_controller.dart';

class MainPageView extends GetView<MainPageController> {
  const MainPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: SafeArea(
        child: Obx(() {
          return IndexedStack(
            index: controller.currentPageIndex.value,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              HomeView(),
            ],
          );
        }),
      ),
    );
  }
}
