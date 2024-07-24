class User {
  final String name;
  final String phoneNum;

  User({required this.name, required this.phoneNum});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      phoneNum: json['phoneNum'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneNum': phoneNum,
      };
}

Map<String, List<User>> factoryContacts = {};
