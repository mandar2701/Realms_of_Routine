import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String token;
  final String password;
  final String? age;
  final String? birthDate;
  final String? gender;
  final String? duty;
  final String? focus;
  final String? goal;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.password,
    this.age,
    this.birthDate,
    this.gender,
    this.duty,
    this.focus,
    this.goal,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'token': token,
      'password': password,
      'age': age,
      'birthDate': birthDate,
      'gender': gender,
      'duty': duty,
      'focus': focus,
      'goal': goal,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      token: map['token'] ?? '',
      password: map['password'] ?? '',
      age: map['age'],
      birthDate: map['birthDate'],
      gender: map['gender'],
      duty: map['duty'],
      focus: map['focus'],
      goal: map['goal'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}