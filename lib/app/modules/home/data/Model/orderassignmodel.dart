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

  factory OrderAssignedHistory.fromMap(Map<String, dynamic> map) {
    return OrderAssignedHistory(
      accepted: map["accepted"],
      acceptedAt: map["accepted_at"],
      arrived: map["arrived"],
      arrivedAt: map["arrived_at"],
      canceled: map["canceled"],
      canceledAt: map["canceled_at"],
      id: map["id"],
      rejected: map["rejected"],
      rejectedAt: map["rejected_at"],
      tripCompleted: map["trip_completed"],
      tripCompletedAt: map["trip_completed_at"],
      tripStarted: map["trip_started"],
      tripStartedAt: map["trip_started_at"],
      vehicleId: map["vehicle_id"],
      order: Order.fromMap(map["order"]),
    );
  }
}

class Order {
  String id;
  String deliveryLocationName;
  Location deliveryLocation;
  String pickupLocationName;
  String detail;
  String created_at;
  String order_status;
  Location pickupLocation;

  Order({
    required this.id,
    required this.deliveryLocationName,
    required this.deliveryLocation,
    required this.pickupLocationName,
    required this.detail,
    required this.created_at,
    required this.order_status,
    required this.pickupLocation,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        deliveryLocationName: json["delivery_location_name"],
        deliveryLocation: Location.fromJson(json["delivery_location"]),
        pickupLocationName: json["pickup_location_name"],
        detail: json["detail"],
        created_at: json["created_at"],
        order_status: json["order_status"],
        pickupLocation: Location.fromJson(json["pickup_location"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "delivery_location_name": deliveryLocationName,
        "delivery_location": deliveryLocation.toJson(),
        "pickup_location_name": pickupLocationName,
        "detail": detail,
        "created_at": created_at,
        "order_status": order_status,
        "pickup_location": pickupLocation.toJson(),
      };

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map["id"],
      deliveryLocationName: map["delivery_location_name"],
      deliveryLocation: Location.fromMap(map["delivery_location"]),
      pickupLocationName: map["pickup_location_name"],
      detail: map["detail"],
      created_at: map["created_at"],
      order_status: map["order_status"],
      pickupLocation: Location.fromMap(map["pickup_location"]),
    );
  }
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

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      type: map["type"],
      coordinates:
          List<double>.from(map["coordinates"].map((x) => x.toDouble())),
    );
  }
}
