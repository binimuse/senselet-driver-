class Updatevheclemuatation {
  static const String updatevheclemuatation = r'''
    mutation  update_vehicles(
      $location: geography!,
      $credential_id: uuid!,
      $active: Boolean!,
    ){
      action:   
      update_vehicles(where: {credential_id: {_eq: $credential_id}}, _set: {active: $active, location: $location}) {
    affected_rows
  }
    }
 ''';
}
