class GetCancellationreasonsQuery {
  static dynamic getcancellationreasons() {
    return '''
query{
  cancellation_reasons(where: {source: {_eq: DRIVER}}) {
    name
    description
    id
    source
  }
}


 ''';
  }
}
