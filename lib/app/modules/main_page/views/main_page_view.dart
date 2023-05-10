import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../account/controllers/account_controller.dart';
import '../../account/views/account_view_exit.dart';
import '../../home/views/home_view.dart';
import '../controllers/main_page_controller.dart';

class MainPageView extends GetView<MainPageController> {
  const MainPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.put(AccountController());
        if (controller.currentPageIndex.value == 0) {
          // Ask the user if they want to exit the app if they are on the home page
          final shouldExit = await Get.to(const AccountViewExit());
          return shouldExit ?? false;
        } else {
          // Go back to the home page if the user presses the back button on any other page
          controller.changeBottomPage(0);
          return false;
        }
      },
      child: Scaffold(
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
      ),
    );
  }
}
