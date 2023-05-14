class CancelOrdermuatation {
  static const String cancelOrdermuatation = r'''
    mutation  update_order_assigned_histories_by_pk(
      $id: uuid!,
    ){
      action:   
  update_order_assigned_histories_by_pk(pk_columns: {id: $id}, _set: {rejected: true}) {
    canceled
  }
    }
 ''';
}
