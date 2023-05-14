class OrderHistoryQueryMutation {
  dynamic getMyOrdersHistory(String vehcle) {
    return """
query MyQuery {
  order_assigned_histories(where: {vehicle_id: {_eq: "$vehcle"}}, order_by: {id: desc}) {
    id
    created_at
    order_id
    accepted
    accepted_at
    accepted_by_id
    arrived
    arrived_at
    canceled
    canceled_at
    canceled_by_id
    cancellation_reason
    package_received
    rejected
    rejected_at
    rejected_by_id
    rejection_reason
    trip_completed
    trip_completed_at
    trip_started
    trip_started_at
    updated_at
    vehicle_id
       order {
        id
      order_status
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

  dynamic getMyOrdersHistorysub(String vehcle) {
    return """
subscription MyQuery {
  order_assigned_histories(where: {vehicle_id: {_eq: "$vehcle"}}, order_by: {id: desc}) {
    id
    created_at
    order_id
    accepted
    accepted_at
    accepted_by_id
    arrived
    arrived_at
    canceled
    canceled_at
    canceled_by_id
    cancellation_reason
    package_received
    rejected
    rejected_at
    rejected_by_id
    rejection_reason
    trip_completed
    trip_completed_at
    trip_started
    trip_started_at
    updated_at
    vehicle_id
       order {
      order_status
           id
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
