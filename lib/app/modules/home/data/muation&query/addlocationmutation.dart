class AddLocationMutation {
  static const String addLocationMutation = r'''
    mutation  insert_vehicle_location_history(
      $location: geography!,
      $vehicle_id: uuid!,
     
    ){
      action:   
      insert_vehicle_location_history(objects: {location: $location,vehicle_id:$vehicle_id}) {
    affected_rows
  }
    }
 ''';
}
