class User {
  String userId;
  String username;
  String firstName;
  String lastName;
  String middleName;
  String extName;
  int userRoleId;
  int roleId;
  String roleDescription;
  String officeCode;
  String officeDescription;
  String token;

  // Constructor
  User({
    required this.userId,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.extName,
    required this.userRoleId,
    required this.roleId,
    required this.roleDescription,
    required this.officeCode,
    required this.officeDescription,
    required this.token,
  });

  // Factory method to create DTOUser from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      middleName: json['middle_name'],
      extName: json['ext_name'],
      userRoleId: json['user_role_id'],
      roleId: json['role_id'],
      roleDescription: json['role_description'],
      officeCode: json['office_code'],
      officeDescription: json['office_description'],
      token: json['token'],
    );
  }

  // Method to convert DTOUser to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'middle_name': middleName,
      'ext_name': extName,
      'user_role_id': userRoleId,
      'role_id': roleId,
      'role_description': roleDescription,
      'office_code': officeCode,
      'office_description': officeDescription,
      'token': token,
    };
  }
}
