class Packgereciveduatation {
  static const String packgereciveduatation = r'''
    mutation  update_order_assigned_histories_by_pk(
      $id: uuid!,
    ){
      action:   
  update_order_assigned_histories_by_pk(pk_columns: {id: $id}, _set: {package_received: true}) {
    canceled
  }
    }
 ''';
}
