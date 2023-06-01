import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:senselet_driver/app/common/widgets/custom_snack_bars.dart';
import 'package:senselet_driver/app/routes/app_pages.dart';

import '../../../../main.dart';
import '../../../common/graphql_common_api.dart';
import '../../../constants/reusable/reusable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/constants.dart';
import '../../../utils/sahred_prefrence.dart';
import '../../order_history/controllers/order_history_controller.dart';
import '../data/Model/constantsmodel.dart';
import '../data/Model/drivermodel.dart';
import '../data/Model/orderassignmodel.dart';
import '../data/Model/vehiclemodel.dart';
import '../data/muation&query/acceptorder.dart';
import '../data/muation&query/cancelorder.dart';
import '../data/muation&query/order_history_query_mutation.dart';
import '../data/muation&query/order_sub.dart';
import '../data/muation&query/packgerecived.dart';
import '../data/muation&query/tripcomplete.dart';
import '../data/muation&query/tripstart.dart';
import '../data/muation&query/updatevechle.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import '../views/widget/navigation_screen.dart';

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
    stopAudio();

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
    FlutterRingtonePlayer.stop();
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
    FlutterRingtonePlayer.stop();
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

          getordersub();
          //     PreferenceUtils.setString(Constants.userId, vehicleModel.first.id);
        } else {
          hasorderfetchedsub(false);
          isStatusOn(false);
        }
        await PreferenceUtils.setString(
          Constants.vehiclesId,
          vehicleModel.first.id,
        );

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

  var subscriptionDocument;
  RxList<OrderAssignedHistory> orderAssignedHistory =
      List<OrderAssignedHistory>.of([]).obs;
  void getordersub() async {
    checkifassigned();
    subscriptionDocument =
        gql(orderSubscription.getOrderSubscription(vehicleModel.first.id));

    // Assuming you have set up the GraphQL client correctly
    final QueryOptions options = QueryOptions(document: subscriptionDocument);

    // Use WebSocketLink for subscriptions
    final WebSocketLink websocketLink = WebSocketLink(
      'ws://159.223.227.87:8888/v1/graphql',
      config: const SocketClientConfig(
        headers: {
          'x-hasura-admin-secret': "ad8sddi6roXj9tmejrWwX992by5S5Q",
        },
        autoReconnect: true,
        inactivityTimeout: Duration(seconds: 30),
      ),
    );

    // Create a Link that combines the WebSocketLink and HttpLink
    final Link link = Link.split(
      (request) => request.isSubscription,
      websocketLink,
      HttpLink('http://159.223.227.87:8888/v1/graphql'),
    );

    // Create a GraphQL client with the combined link
    final GraphQLClient client =
        GraphQLClient(link: link, cache: GraphQLCache());

    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      final dynamic data = result.data;
      orderAssignedHistory.value =
          (result.data!['order_assigned_histories'] as List)
              .map((e) => OrderAssignedHistory.fromJson(e))
              .toList();
      hasorderfetchedsub(true);

      if (orderAssignedHistory.isNotEmpty) {
        playAudio();
      }

      // Use the retrieved data as needed
      // For example:
      print(data);
    } else {
      stopAudio();
      hasorderfetchedsub(false);
      print('Error occurred: ${result.exception.toString()}');
    }
  }

  // Define functions to handle audio playback

  void playAudio() async {
    FlutterRingtonePlayer.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.glass,
      looping: true, // Android only - API >= 28
      volume: 0.1, // Android only - API >= 28
      asAlarm: false, // Android only - all APIs
    );
  }

  void stopAudio() {
    FlutterRingtonePlayer.stop();
  }

  @override
  void dispose() {
    FlutterRingtonePlayer.stop();
    super.dispose();
  }

  //cancel Order
  var hasscancelOrder = false.obs;
  var startcancelOrder = false.obs;
  cancelOrder(BuildContext? context, String id) async {
    startcancelOrder(true);

    GraphQLClient client = graphQLConfiguration.clientToQuery();

    QueryResult result = await client.mutate(
      MutationOptions(
        document: gql(CancelOrdermuatation.cancelOrdermuatation),
        variables: <String, dynamic>{
          'id': id,
        },
      ),
    );

    if (!result.hasException) {
      startcancelOrder(false);
      hasscancelOrder(true);

      //  hasorderfetchedsub(false);

      // stopAudio();
    } else {
      startcancelOrder(false);
      hasscancelOrder(false);

      print(result.exception);
    }
  }

  //cancel Order
  var hassacceptOrder = false.obs;
  var startacceptOrder = false.obs;
  acceptOrder(
      BuildContext? context,
      String id,
      String orderId,
      double coordinatlat,
      double coordinatlng,
      String pickupLocationName,
      String deliveryLocation) async {
    startacceptOrder(true);

    GraphQLClient client = graphQLConfiguration.clientToQuery();

    QueryResult result = await client.mutate(
      MutationOptions(
        document: gql(AcceptOrdermuatation.acceptOrdermuatation),
        variables: <String, dynamic>{
          'id': id,
        },
      ),
    );

    if (!result.hasException) {
      startacceptOrder(false);
      hassacceptOrder(true);

      //  hasorderfetchedsub(false);
      stopAudio();
      isStatusOn(false);
      HomeController homeController = Get.find<HomeController>();
      Get.to(NavigationScreen(
          coordinatlat,
          coordinatlng,
          latitude.value,
          longitude.value,
          pickupLocationName,
          deliveryLocation,
          homeController,
          id,
          orderId));

      updateVehicles(context, true);
    } else {
      startacceptOrder(false);
      hassacceptOrder(false);

      print(result.exception);
    }
  }

  //trip Start
  var hasstripStart = false.obs;
  var starttripStart = false.obs;
  tripStart(BuildContext? context, String id) async {
    starttripStart(true);

    GraphQLClient client = graphQLConfiguration.clientToQuery();
    print(id);
    QueryResult result = await client.mutate(
      MutationOptions(
        document: gql(TripStartmuatation.tripStartmuatation),
        variables: <String, dynamic>{
          'id': id,
        },
      ),
    );

    if (!result.hasException) {
      print("jiji");
      starttripStart(false);
      hasstripStart(true);

      //  hasorderfetchedsub(false);

      // stopAudio();
    } else {
      starttripStart(false);
      hasstripStart(false);

      print(result.exception);
    }
  }

  //trip Start
  var hasstripComplete = false.obs;
  var starthastripComplete = false.obs;
  tripComplete(BuildContext? context, String id, String orderId) async {
    starthastripComplete(true);

    GraphQLClient client = graphQLConfiguration.clientToQuery();

    QueryResult result = await client.mutate(
      MutationOptions(
        document: gql(TripCompletemuatation.tripCompletemuatation),
        variables: <String, dynamic>{
          'id': id,
          'order_id': orderId,
        },
      ),
    );

    if (!result.hasException) {
      print("object");

      starthastripComplete(false);
      hasstripComplete(true);

      //  hasorderfetchedsub(false);

      // stopAudio();
    } else {
      print("object2");
      starthastripComplete(false);
      hasstripComplete(false);

      print(result.exception);
    }
  }

//packge received
  var hasspackgereceived = false.obs;
  var startpackgereceived = false.obs;
  packgereceived(BuildContext? context, String id, String orderId) async {
    startpackgereceived(true);

    GraphQLClient client = graphQLConfiguration.clientToQuery();

    QueryResult result = await client.mutate(
      MutationOptions(
        document: gql(Packgereciveduatation.packgereciveduatation),
        variables: <String, dynamic>{
          'id': id,
          'order_id': orderId,
        },
      ),
    );

    if (!result.hasException) {
      startpackgereceived(false);
      hasspackgereceived(true);

      Get.offAllNamed(Routes.MAIN_PAGE);
    } else {
      startpackgereceived(false);
      hasspackgereceived(false);

      print(result.exception);
    }
  }

  void checkifassigned() {
    print("element.order.order_status");
    OrderHistoryController orderHistoryController =
        Get.put(OrderHistoryController());

    Future.delayed(Duration.zero, () {
      orderHistoryController.getOrderModel.forEach((element) {
        if (element.order.order_status.contains("ASSIGNED")) {
          Get.toNamed(Routes.ORDER_HISTORY);
        }
      });
    });
  }
}
