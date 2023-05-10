import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:senselet_driver/app/modules/home/views/widget/nav_drawer.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/const.dart';
import '../../../theme/custom_sizes.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  @override
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.keyforall,
      appBar: controller.reusableWidget.buildAppforpages(context, true),
      drawer: NavDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                googlemap(),
                // tonePrice(context),
                flotingButoontop(),
                flotingButoon(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  googlemap() {
    return Obx(() {
      return GoogleMap(
        mapType: MapType.normal,
        mapToolbarEnabled: true,
        buildingsEnabled: false,
        trafficEnabled: false,
        indoorViewEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            controller.latitude.value,
            controller.longitude.value,
          ),
          zoom: 5.0,
        ),
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        circles: {
          Circle(
            circleId: const CircleId('currentCircle'),
            center: LatLng(
              controller.latitude.value,
              controller.longitude.value,
            ),
            radius: 100,
            fillColor: themebackground,
            strokeColor: themeColorFaded,
          ),
        },
        myLocationButtonEnabled: true,
        compassEnabled: false,
        onMapCreated: (GoogleMapController thiscontroller) {
          controller.gcontroller.complete(thiscontroller);
          controller.mapControllers = thiscontroller;
        },
        markers: Set<Marker>.of(controller.markers),
      );
    });
  }

  tonePrice(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(45.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(children: [
            Container(
              height: 12.h,
              width: 82.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [themeColor, themeColorFaded],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.grey),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ///SCHEDULE DATE
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Tone Price".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16.sp,
                            ),
                          ),
                          Text(
                            "${23} ETB",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 16.sp,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  ///MIDDLE DIVIDER
                  Column(
                    children: [
                      SizedBox(
                        height: CustomSizes.icon_size_6 / 2,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Icon(
                            FontAwesomeIcons.circleDot,
                            size: CustomSizes.icon_size_6,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: CustomSizes.mp_w_4,
                        ),
                      ),
                      SizedBox(
                        height: CustomSizes.icon_size_6 / 2,
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Icon(
                            FontAwesomeIcons.circleDot,
                            size: CustomSizes.icon_size_6,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  ///BIO TICKET NUMBER
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                            elevation: 2,
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(CustomSizes.radius_4),
                            child: const SizedBox()),
                        SizedBox(
                          width: CustomSizes.mp_w_6,
                        ),
                        Material(
                            elevation: 2,
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(CustomSizes.radius_4),
                            child: const SizedBox()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 250,
              right: 0,
              top: 16,
              bottom: 16,
              child: Icon(
                FontAwesomeIcons.truckRampBox,
                size: 50,
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  flotingButoon(BuildContext context) {
    return Obx(
      () => controller.hasConstatFeched.isTrue
          ? Positioned(
              bottom: 20,
              left: 30,
              right: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, 1),
                          blurRadius: 6,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(90),
                      gradient: const LinearGradient(
                        colors: [themeColor, themeColorFaded],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: FloatingActionButton(
                      heroTag: "phone",
                      isExtended: true,
                      elevation: 0,
                      onPressed: () {
                        _makePhoneCall(
                            controller.constantModel.first.shortCode);
                      },
                      backgroundColor: Colors.transparent,
                      child: const Icon(Icons.call),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        backgroundColor: controller.vehicleModel.first.active
                            ? Colors.green
                            : Colors.red,
                      ),
                      onPressed: () async {
                        bool val = !controller.vehicleModel.first.active;
                        controller.vehicleModel.first.active = val;

                        if (val == true) {
                          controller.isStatusOn(true);
                        } else {
                          controller.isStatusOn(false);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                controller.vehicleModel.first.active
                                    ? "ON"
                                    : "OFF",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Transform.scale(
                              scale: 1.5,
                              child: Switch(
                                value: controller.isStatusOn.value,
                                activeColor: themeColorFaded,
                                onChanged: (val) {
                                  controller.vehicleModel.first.active = val;
                                  if (val == true) {
                                    controller.isStatusOn(true);
                                  } else {
                                    controller.isStatusOn(false);
                                  }
                                  controller.updateVehicles(context, false);
                                },
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ))
          : SizedBox(),
    );
  }

  _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri, mode: LaunchMode.externalApplication);
  }

  flotingButoontop() {
    return Positioned(
      top: 30,
      left: 30,
      right: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: "menu",
            isExtended: true,
            elevation: 0,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
              ),
              child: Icon(
                Icons.menu,
                color: themeColor,
                size: 24.0,
              ),
            ),
            onPressed: () {
              controller.keyforall.currentState!.openDrawer();
            },
          ),
        ],
      ),
    );
  }
}
