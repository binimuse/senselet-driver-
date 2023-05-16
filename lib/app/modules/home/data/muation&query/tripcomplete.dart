class TripCompletemuatation {
  static const String tripCompletemuatation = r'''
mutation updateOrderAndAssignedHistoriesByPk($id: uuid!, $order_id: uuid!) {
  action1: update_order_assigned_histories_by_pk(pk_columns: {id: $id}, _set: {trip_completed: true}) {
    canceled
  }
  action2: update_orders_by_pk(pk_columns: {id: $order_id}, _set: {delivered: true, order_status: ARRIVED}) {
    id
  }
}


 ''';
}
