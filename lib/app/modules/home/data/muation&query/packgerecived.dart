class Packgereciveduatation {
  static const String packgereciveduatation = r'''
mutation update_order_assigned_histories_by_pk(
  $id: uuid!,
  $order_id: uuid!
  ) {
  action1: update_order_assigned_histories_by_pk(pk_columns: {id: $id}, _set: {package_received: true}) {
    canceled
  }
  action2: update_orders_by_pk(pk_columns: {id: $order_id}, _set: {order_status: DELIVERED}) {
    id
  }
}

 ''';
}
