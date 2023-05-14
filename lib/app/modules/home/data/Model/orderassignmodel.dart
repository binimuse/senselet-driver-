class OrderAssignedHistory {
  dynamic accepted;
  dynamic acceptedAt;
  dynamic arrived;
  dynamic arrivedAt;
  dynamic canceled;
  dynamic canceledAt;
  String id;
  dynamic rejected;
  dynamic rejectedAt;
  dynamic tripCompleted;
  dynamic tripCompletedAt;
  dynamic tripStarted;
  dynamic tripStartedAt;
  String vehicleId;
  Order order;

  OrderAssignedHistory({
    this.accepted,
    this.acceptedAt,
    this.arrived,
    this.arrivedAt,
    this.canceled,
    this.canceledAt,
    required this.id,
    this.rejected,
    this.rejectedAt,
    this.tripCompleted,
    this.tripCompletedAt,
    this.tripStarted,
    this.tripStartedAt,
    required this.vehicleId,
    required this.order,
  });

  factory OrderAssignedHistory.fromJson(Map<String, dynamic> json) =>
      OrderAssignedHistory(
        accepted: json["accepted"],
        acceptedAt: json["accepted_at"],
        arrived: json["arrived"],
        arrivedAt: json["arrived_at"],
        canceled: json["canceled"],
        canceledAt: json["canceled_at"],
        id: json["id"],
        rejected: json["rejected"],
        rejectedAt: json["rejected_at"],
        tripCompleted: json["trip_completed"],
        tripCompletedAt: json["trip_completed_at"],
        tripStarted: json["trip_started"],
        tripStartedAt: json["trip_started_at"],
        vehicleId: json["vehicle_id"],
        order: Order.fromJson(json["order"]),
      );

  Map<String, dynamic> toJson() => {
        "accepted": accepted,
        "accepted_at": acceptedAt,
        "arrived": arrived,
        "arrived_at": arrivedAt,
        "canceled": canceled,
        "canceled_at": canceledAt,
        "id": id,
        "rejected": rejected,
        "rejected_at": rejectedAt,
        "trip_completed": tripCompleted,
        "trip_completed_at": tripCompletedAt,
        "trip_started": tripStarted,
        "trip_started_at": tripStartedAt,
        "vehicle_id": vehicleId,
        "order": order.toJson(),
      };
}

class Order {
  String id;
  String deliveryLocationName;
  Location deliveryLocation;
  String pickupLocationName;
  String detail;
  String order_status;
  Location pickupLocation;

  Order({
    required this.id,
    required this.deliveryLocationName,
    required this.deliveryLocation,
    required this.pickupLocationName,
    required this.detail,
    required this.order_status,
    required this.pickupLocation,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        deliveryLocationName: json["delivery_location_name"],
        deliveryLocation: Location.fromJson(json["delivery_location"]),
        pickupLocationName: json["pickup_location_name"],
        detail: json["detail"],
        order_status: json["order_status"],
        pickupLocation: Location.fromJson(json["pickup_location"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "delivery_location_name": deliveryLocationName,
        "delivery_location": deliveryLocation.toJson(),
        "pickup_location_name": pickupLocationName,
        "detail": detail,
        "order_status": order_status,
        "pickup_location": pickupLocation.toJson(),
      };
}

class Location {
  String type;

  List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}
