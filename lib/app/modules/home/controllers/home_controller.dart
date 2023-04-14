import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../constants/reusable/reusable.dart';

class HomeController extends GetxController {
  final count = 0.obs;
  final reusableWidget = ReusableWidget();
  var status = false.obs;
  var isStatusOn = false.obs;
  var getDropOffss = false.obs;
  final GlobalKey<ScaffoldState> keyforall = GlobalKey<ScaffoldState>();
  static const CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  late LatLng latLng = const LatLng(37.43296265331129, -122.08832357078792);
  final Completer<GoogleMapController> gcontroller = Completer();
  late GoogleMapController mapController;

  void increment() => count.value++;
}
