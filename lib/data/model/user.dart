class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String birthDate;
  final String profilePicture;
  final String timezone;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.profilePicture,
    required this.timezone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      birthDate: json['birth_date'],
      profilePicture: json['profile_picture'],
      timezone: json['timezone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'birth_date': birthDate,
      'profile_picture': profilePicture,
      'timezone': timezone,
    };
  }
}
