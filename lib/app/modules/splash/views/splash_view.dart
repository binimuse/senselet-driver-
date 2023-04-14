import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/const.dart';
import '../../network/controllers/network_controller.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  final NetworkController networkManager = Get.find<NetworkController>();
  SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => networkManager.connectionStatus.value != 0
        ? Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [themeColor, themeColorFaded],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.decal),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 200,
                      width: 220,
                    ),
                    //  Image.asset("assets/images/name.gif")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.appName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.sp,
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          "Dry Cargo Services",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : FutureBuilder(
            future: _showProgressBar(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return noConn();
              } else {
                return const SizedBox(
                  width: 42.0,
                  height: 42.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [themeColor, themeColorFaded],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )),
                  ),
                );
              }
            },
          ));
  }

  Future<void> _showProgressBar() async {
    return await Future.delayed(const Duration(seconds: 1));
//
  }

  noConn() {
    final NetworkController networkManager = Get.find<NetworkController>();

    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/no.png",
          height: 50,
          width: 40,
        ),
        Positioned(
          bottom: Get.height * 0.15,
          left: Get.width * 0.3,
          right: Get.width * 0.3,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 13),
                  blurRadius: 25,
                  color: const Color(0xFF5666C2).withOpacity(0.17),
                ),
              ],
            ),
            // ignore: deprecated_member_use
            child: MaterialButton(
              color: SOFT_BLUE,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              onPressed: () {
                networkManager.restart();
                controller.update();
                Get.reload();
              },
              child: Text(
                "retry".toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
