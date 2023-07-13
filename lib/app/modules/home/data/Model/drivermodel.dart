class DriverModel {
  DriverModel({
    this.verifiedAt,
    required this.username,
    required this.roles,
    this.phoneNumber,
    this.isActive,
    required this.gender,
    required this.firstName,
    this.id,
    required this.fatherName,
    this.emailVerified,
    required this.email,
    this.createdAt,
    required this.birthdate,
  });

  dynamic verifiedAt;
  String username;
  String roles;
  String? phoneNumber;
  bool? isActive;
  String gender;
  String firstName;
  String? id;
  String fatherName;
  bool? emailVerified;
  String email;
  DateTime? createdAt;
  String birthdate;

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] ?? null,
      username: json['username'],
      verifiedAt: json['verifiedAt'],
      roles: json['roles'],
      phoneNumber: json['phone_number'] ?? null,
      isActive: json['isActive'] ?? null,
      gender: json['gender'],
      firstName: json['first_name'],
      fatherName: json['father_name'],
      emailVerified: json['email_verified'] ?? null,
      email: json['email'],
      createdAt: json['createdAt'] ?? null,
      birthdate: json['birthdate'],
    );
  }
}
