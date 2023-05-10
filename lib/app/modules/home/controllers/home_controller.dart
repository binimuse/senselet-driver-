import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../common/graphql_common_api.dart';
import '../../../constants/reusable/reusable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/constants.dart';
import '../../../utils/sahred_prefrence.dart';
import '../data/Model/constantsmodel.dart';
import '../data/Model/drivermodel.dart';
import '../data/muation&query/order_history_query_mutation.dart';

class HomeController extends GetxController {
  final count = 0.obs;
  final reusableWidget = ReusableWidget();

  int distance = 10000;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var mapControllers;
  var status = false.obs;
  var isStatusOn = false.obs;
  final GlobalKey<ScaffoldState> keyforall = GlobalKey<ScaffoldState>();
  final Completer<GoogleMapController> gcontroller = Completer();

  late BitmapDescriptor destinationIcon;
  late BitmapDescriptor sourceIcon;
  var markers = <Marker>{}.obs;
  void increment() => count.value++;

  @override
  void onInit() async {
    super.onInit();

    getConstats();

    if (await _checkLocationPermission()) {
      var position = await Geolocator.getCurrentPosition();
      latitude.value = position.latitude;
      longitude.value = position.longitude;

      _updateCameraPosition();
    }
  }

  Future<bool> _checkLocationPermission() async {
    var permission = await Permission.location.status;
    if (permission != PermissionStatus.granted) {
      permission = await Permission.location.request();
      if (permission != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void _updateCameraPosition() {
    if (mapControllers != null) {
      mapControllers.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(latitude.value, longitude.value),
        14.0,
      ));
    }
  }

  RxList<ConstantModel> constantModel = List<ConstantModel>.of([]).obs;
  RxList<DriverModel> driverModel = List<DriverModel>.of([]).obs;
  GraphQLCommonApi graphQLCommonApi = GraphQLCommonApi();

  var startloadingConstat = false.obs;
  var hasConstatFeched = false.obs;
  void getConstats() async {
    try {
      startloadingConstat(true);

      final result = await graphQLCommonApi.mutation(
          GetConstatsandDriverQuery.getConstatsanddriver(
              PreferenceUtils.getString(Constants.userId)),
          {});

      if (result != null) {
        constantModel.value = (result['constants'] as List)
            .map((e) => ConstantModel.fromJson(e))
            .toList();

        driverModel.value = (result['credentials'] as List)
            .map((e) => DriverModel.fromJson(e))
            .toList();
      }

      startloadingConstat(false);
      hasConstatFeched(true);
    } on Exception catch (e) {
      print(e);
      hasConstatFeched(false);
      startloadingConstat(false);
    }
  }
}
