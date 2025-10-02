import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String token;
  final String password;
  final int? age;
  final String? birthDate;
  final String? gender;
  final Map<String, String>? hero;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.password,
    this.age,    
    this.birthDate,
    this.gender,
    this.hero,
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
      'hero': hero,
    };
  }

// lib/models/user.dart

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
    // Check if 'hero' exists before trying to convert it
    hero: map['hero'] != null ? Map<String, String>.from(map['hero']) : null,
  );
}

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}