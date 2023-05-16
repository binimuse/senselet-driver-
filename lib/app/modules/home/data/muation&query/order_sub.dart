class OrderSubscription {
  dynamic getOrderSubscription(String vehicleid) {
    return """
subscription MySubscription {

  order_assigned_histories(where: 
  {rejected: {_is_null: true},
   accepted: {_is_null: true}, 
   trip_started: {_is_null: true}, 
 trip_completed: {_is_null: true}, 
    vehicle_id: {_eq: "$vehicleid"}, 
   canceled: {_is_null: true}}) {
    accepted
    accepted_at
    arrived
    arrived_at
    canceled
    canceled_at
    id
    rejected
    rejected_at
    trip_completed
    trip_completed_at
    trip_started
    trip_started_at
    vehicle_id
    order {
      id
      created_at
      delivery_location_name
      delivery_location
      pickup_location_name
      pickup_location
      detail
    }
  }
}

    """;
  }
}
