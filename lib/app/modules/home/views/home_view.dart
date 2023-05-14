import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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

                Obx(
                  () => controller.hasorderfetchedsub.value == true
                      ? Subscription(
                          options: SubscriptionOptions(
                            document: controller.subscriptionDocument,
                          ),
                          builder: (dynamic result) {
                            if (result.hasException) {
                              return Text(result.exception.toString());
                            }

                            if (result.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return popupdialogue(context, result.data);
                          })
                      : SizedBox(),
                ),

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
                        backgroundColor: controller.isStatusOn.value
                            ? Colors.green
                            : Colors.red,
                      ),
                      onPressed: () async {
                        // bool val = !controller.vehicleModel.first.active;
                        // controller.vehicleModel.first.active = val;

                        // if (val == true) {
                        //   controller.isStatusOn(true);
                        // } else {
                        //   controller.isStatusOn(false);
                        // }
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
                                controller.isStatusOn.value ? "ON" : "OFF",
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
                                    controller.getordersub();
                                  } else {
                                    controller.hasorderfetchedsub(false);
                                    controller.isStatusOn(false);
                                    controller.stopAudio();
                                  }
                                  // controller.getConstats();
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

  Widget popupdialogue(BuildContext context, data) {
    return data["order_assigned_histories"].length > 0
        ? FutureBuilder(
            future: _showProgressBar2(),
            builder: (context, snapshot) {
              return Container(
                width: Get.width,
                height: 31.h,
                margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, top: 20),
                          width: 25.w,
                          height: 15.h,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 68, 171, 255)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              )),
                          child: Icon(
                            Icons.local_shipping_rounded,
                            size: 15.w,
                            color: themeColor,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 5.h,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.my_location,
                                      size: 5.w,
                                      color: themeColorFaded,
                                    ),
                                    Expanded(
                                      child: RichText(
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'From : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: Colors.grey)),
                                            TextSpan(
                                              text: controller
                                                      .orderAssignedHistory
                                                      .first
                                                      .order
                                                      .pickupLocationName
                                                      .toString()
                                                      .split(',')[1]
                                                      ?.trim() ??
                                                  '',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2.4.w),
                                  child: SizedBox(
                                    height: 2.h,
                                    child: DottedLine(
                                      dashLength: 10,
                                      direction: Axis.vertical,
                                      dashColor:
                                          Color.fromARGB(255, 68, 171, 255),
                                      dashGapLength: 1.5,
                                      lineThickness: 1,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 5.5.w,
                                      color: themeColorFaded,
                                    ),
                                    RichText(
                                      maxLines: 1,
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: 'To : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.grey)),
                                          TextSpan(
                                            text: controller
                                                    .orderAssignedHistory
                                                    .first
                                                    .order
                                                    .deliveryLocationName
                                                    .toString()
                                                    .split(',')[1]
                                                    .trim() ??
                                                '',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Detail:-",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.grey)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        controller.orderAssignedHistory.first
                                            .order.detail
                                            .toString(),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 17.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 20.w,
                                height: 6.h,
                                decoration: BoxDecoration(
                                    color: themeColor,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(6),
                                        bottomRight: Radius.circular(6))),
                                child: Center(
                                    child: Text(
                                  "New Order",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                )),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(width: 2.w,)
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              height: 6.h,
                              width: 42.w,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    controller.cancelOrder(
                                        context,
                                        controller
                                            .orderAssignedHistory.first.id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 1.h),
                                  ),
                                  child: Text('Decline',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)),
                                ),
                              )),
                          SizedBox(
                              height: 6.h,
                              width: 42.w,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    controller.acceptOrder(
                                      context,
                                      controller.orderAssignedHistory.first.id,
                                      controller.orderAssignedHistory.first
                                          .order.pickupLocation.coordinates[0],
                                      controller.orderAssignedHistory.first
                                          .order.pickupLocation.coordinates[1],
                                      controller.orderAssignedHistory.first
                                          .order.pickupLocationName,
                                      controller.orderAssignedHistory.first
                                          .order.deliveryLocationName,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 1.h),
                                  ),
                                  child: Text('Accept',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)),
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1,
                    )
                  ],
                ),
              );
            },
          )
        : FutureBuilder(
            future: _showProgressBar(),
            builder: (context, snapshot) {
              return SizedBox();
            },
          );
  }

  Future<void> _showProgressBar() async {
    return controller.stopAudio();

//
  }

  Future<void> _showProgressBar2() async {
    return controller.playAudio();

//
  }
}
