class Updatenotificationsbypk {
  static const String updateNotification = r'''
mutation  update_notifications ($id: Int!){
 action: update_notifications(_set: {read: true}, where: {read: {_eq: false}, user_id: {_eq: $id}}) {
affected_rows
  }
}
 ''';
}
