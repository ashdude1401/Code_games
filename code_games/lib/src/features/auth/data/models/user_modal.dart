class UserEntity {
  final String userID;
  final String email;
  final String password; // Hashed
  final String fullName;
  final String profilePicture;
  final String bio;
  final DateTime registrationDate;
  final DateTime lastLoginDate;
  final List<String> groups; // List of groupIDs

  UserEntity(
      {required this.userID,
      required this.email,
      required this.password,
      required this.fullName,
      required this.profilePicture,
      required this.bio,
      required this.registrationDate,
      required this.lastLoginDate,
      required this.groups});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'password': password,
      'fullName': fullName,
      'profilePicture': profilePicture,
      'bio': bio,
      'registrationDate': registrationDate.toIso8601String(),
      'lastLoginDate': lastLoginDate.toIso8601String(),
      'groups': groups,
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      userID: map['userID'],
      email: map['email'],
      password: map['password'],
      fullName: map['fullName'],
      profilePicture: map['profilePicture'],
      bio: map['bio'],
      registrationDate: DateTime.parse(map['registrationDate']),
      lastLoginDate: DateTime.parse(map['lastLoginDate']),
      groups: map['groups'].cast<String>(),
    );
  }
}
