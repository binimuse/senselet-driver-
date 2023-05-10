import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:senselet_driver/app/common/widgets/custom_snack_bars.dart';

import '../../../../main.dart';
import '../../../common/graphql_common_api.dart';
import '../../../constants/reusable/reusable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/constants.dart';
import '../../../utils/sahred_prefrence.dart';
import '../data/Model/constantsmodel.dart';
import '../data/Model/drivermodel.dart';
import '../data/Model/vehiclemodel.dart';
import '../data/muation&query/order_history_query_mutation.dart';
import '../data/muation&query/order_sub.dart';
import '../data/muation&query/updatevechle.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final count = 0.obs;
  final reusableWidget = ReusableWidget();

  int distance = 10000;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var mapControllers;

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
    WidgetsBinding.instance.addObserver(this);
    getConstats();
    getordersub();

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

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      updateVehicles(null, true);
    }
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
  RxList<VehicleModel> vehicleModel = List<VehicleModel>.of([]).obs;
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

        vehicleModel.value = (result['vehicles'] as List)
            .map((e) => VehicleModel.fromJson(e))
            .toList();

        if (vehicleModel.first.active == true) {
          isStatusOn(true);
        } else {
          isStatusOn(false);
        }

        startloadingConstat(false);
        hasConstatFeched(true);
      }
    } on Exception catch (e) {
      print(e);
      hasConstatFeched(false);
      startloadingConstat(false);
    }
  }

  //update Vehicles
  var hassupdateVehicles = false.obs;
  var startupdateVehicles = false.obs;

  updateVehicles(BuildContext? context, bool isfromexit) async {
    startupdateVehicles(true);

    GraphQLClient client = graphQLConfiguration.clientToQuery();

    QueryResult result = await client.mutate(
      MutationOptions(
        document: gql(Updatevheclemuatation.updatevheclemuatation),
        variables: <String, dynamic>{
          'location': {
            "type": "Point",
            "coordinates": [latitude.value, longitude.value]
          },
          'credential_id': PreferenceUtils.getString(Constants.userId),
          'active': isfromexit == true ? false : vehicleModel.first.active,
        },
      ),
    );

    if (!result.hasException) {
      startupdateVehicles(false);
      hassupdateVehicles(true);

      // Get.to(OrderSuccessView());
    } else {
      startupdateVehicles(false);
      hassupdateVehicles(false);

      print(result.exception);
    }
  }

  OrderSubscription orderSubscription = OrderSubscription();
  var hasorderfetchedsub = false.obs;
  late final subscriptionDocument;
  void getordersub() async {
    subscriptionDocument = gql(orderSubscription
        .getOrderSubscription(PreferenceUtils.getString(Constants.vehiclesId)));
    if (subscriptionDocument != null) {
     
      hasorderfetchedsub(true);
    } else {
      hasorderfetchedsub(false);
    }
  }
}
