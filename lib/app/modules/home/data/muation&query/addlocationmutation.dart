class AddLocationMutation {
  static const String addLocationMutation = """
  mutation addLocation(\$lat: Float, \$lng: Float) {
    insert_location(objects: {lat: \$lat, lng: \$lng}) {
      affected_rows
    }
  }
  """;
}
