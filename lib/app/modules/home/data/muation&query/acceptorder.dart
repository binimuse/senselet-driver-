class AcceptOrdermuatation {
  static const String acceptOrdermuatation = r'''
    mutation  update_order_assigned_histories_by_pk(
      $id: uuid!,
    ){
      action:   
  update_order_assigned_histories_by_pk(pk_columns: {id: $id}, _set: {accepted: true}) {
    canceled
  }
    }
 ''';
}
