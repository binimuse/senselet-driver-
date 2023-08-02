import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:senselet_driver/app/modules/home/views/widget/qrscanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import '../../../../../main.dart';
import '../../../../common/widgets/custom_snack_bars.dart';
import '../../../../constants/const.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/sahred_prefrence.dart';
import '../../controllers/home_controller.dart';
import '../../data/muation&query/addlocationmutation.dart';
import '../../data/muation&query/sos.dart';

class NavigationScreen extends StatefulWidget {
  final double orderlat;
  final double orderlng;
  // user lat lng
  final double userlat;
  final double userlng;
  final HomeController homeController;
  final String orderId;
  final String orderHistoryId;

  //location name
  final String picklocationName;
  final String deliverlocationName;
  const NavigationScreen(
      this.orderlat,
      this.orderlng,
      this.userlat,
      this.userlng,
      this.picklocationName,
      this.deliverlocationName,
      this.homeController,
      this.orderId,
      this.orderHistoryId,
      {Key? key})
      : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final Completer<GoogleMapController?> _controller = Completer();
  Set<Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Location location = Location();
  Marker? sourcePosition, destinationPosition;

  StreamSubscription<loc.LocationData>? locationSubscription;
  bool deliveryStarted = false;
  bool showqr = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    //   getNavigation();
    addMarker();
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    timer?.cancel();
    super.dispose();
  }

  Location locationtohausra = new Location();
  late bool serviceEnabled;
  late PermissionStatus permissionGranted;
  late LocationData _locationData;
  late Stream<LocationData> _locationStream;
  void initLocation() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    _locationStream = location.onLocationChanged;
    _locationStream.listen((LocationData currentLocation) {
      sendLocationToHasura(currentLocation);
    });
  }

  void sendLocationToHasura(LocationData currentLocation) async {
    final prefs = await SharedPreferences.getInstance();

    GraphQLClient client = graphQLConfiguration.clientToQuery();
    final MutationOptions options = MutationOptions(
      document: gql(AddLocationMutation.addLocationMutation),
      variables: {
        'location': {
          "type": "Point",
          "coordinates": [currentLocation.latitude, currentLocation.longitude]
        },
        'vehicle_id': prefs.getString(Constants.vehiclesId),
      },
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
    }
  }

  bool startSOS = false;
  sos() async {
    setState(() {
      startSOS = true;
    });

    GraphQLClient client = graphQLConfiguration.clientToQuery();

    QueryResult result = await client.mutate(
      MutationOptions(
        document: gql(SOSMuatation.SOSmuatation),
        variables: <String, dynamic>{
          // 'credential_id': PreferenceUtils.getString(Constants.userId),
        },
      ),
    );

    if (!result.hasException) {
      setState(() {
        startSOS = false;
      });

      ShowCommonSnackBar.awesomeSnackbarSucess("Success", "SOS Sent", context);
      // Get.to(OrderSuccessView());
    } else {
      setState(() {
        startSOS = false;
      });

      print(result.exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffEBF5F4),
        body: sourcePosition == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.terrain,
                    mapToolbarEnabled: false,
                    buildingsEnabled: false,
                    trafficEnabled: false,
                    indoorViewEnabled: false,
                    polylines: Set<Polyline>.of(polylines),
                    initialCameraPosition: CameraPosition(
                      target: LatLng(widget.userlat, widget.userlng),
                      zoom: 13,
                    ),
                    circles: {
                      Circle(
                        circleId: const CircleId('currentCircle'),
                        center: LatLng(widget.orderlat, widget.orderlng),
                        radius: 80,
                        fillColor: themeColor.withOpacity(0.5),
                        strokeColor: themeColor.withOpacity(0.2),
                      ),
                    },
                    markers: {sourcePosition!, destinationPosition!},
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                  Positioned(
                    bottom: 95,
                    right: 10,
                    left: 10,
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
                              colors: [Colors.red, Colors.red],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                startSOS
                                    ? Center(
                                        child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ))
                                    : FloatingActionButton(
                                        heroTag: "phone",
                                        elevation: 0,
                                        onPressed: () {
                                          sos();
                                        },
                                        backgroundColor: Colors.transparent,
                                        child: Text(
                                          'SOS',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    left: 10,
                    child: ConfirmationSlider(
                      iconColor: !deliveryStarted ? themeColor : Colors.yellow,
                      foregroundColor:
                          !deliveryStarted ? themeColor : Colors.yellow,
                      backgroundColorEnd:
                          !deliveryStarted ? themeColor : Colors.yellow,
                      text: deliveryStarted
                          ? 'Finish delivery'
                          : 'Slide to start trip',
                      onConfirmation: () async {
                        setState(() {
                          deliveryStarted = true;
                          widget.homeController
                              .tripStart(context, widget.orderId);
                          if (!showqr) {
                            showqr = true;
                            initLocation(); // Call the function immediately
                            timer = Timer.periodic(Duration(seconds: 300),
                                (Timer t) => initLocation());
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  backgroundColor: Colors.white,
                                  elevation: 8.0,
                                  content: Text(
                                      'Get ready to scan the QR code to complete the delivery'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        widget.homeController.tripComplete(
                                          context,
                                          widget.orderId,
                                          widget.orderHistoryId,
                                        );

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ScanQRCodepage(
                                                        widget.orderId,
                                                        widget.orderHistoryId,
                                                        widget
                                                            .homeController)));
                                      },
                                      child: Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        });
                        // await launchUrl(Uri.parse(
                        //     'google.navigation:q=${widget.orderlat},${widget.orderlng}&key=YOUR_API_KEY'));
                      },
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: 10,
                    right: 10,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Card(
                        // Customize your card with more information about the location
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Pickup Location: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('${widget.picklocationName}'),
                                ],
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Delivery Location: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Text('${widget.deliverlocationName}'),
                                ],
                              ),
                              // Add more information about the location
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }

  void addMarker() {
    setState(() {
      sourcePosition = Marker(
        markerId: const MarkerId('source'),
        position: LatLng(widget.userlat, widget.userlng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
      destinationPosition = Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(widget.orderlat, widget.orderlng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );

      // Create a PolylineOptions object
      final polylineOptions = Polyline(
        polylineId: const PolylineId('route'),
        color: themeColor, // Line color
        width: 5, // Line width
        points: [
          LatLng(widget.userlat, widget.userlng), // Source position
          LatLng(widget.orderlat, widget.orderlng), // Destination position
        ],
      );

      // Add the polyline to the map
      polylines.add(polylineOptions);
    });
  }

  Future<Uint8List> getMarkerIconBytes() async {
    final ByteData byteData = await rootBundle.load('assets/images/pin.png');
    return byteData.buffer.asUint8List();
  }
}
