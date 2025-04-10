import 'dart:convert';

import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final String? name;
  final String? email;
  final String? password;
  final String? phone;
  final String? photo;
  final String? position;
  final String? token;

  const Employee({
    this.name,
    this.email,
    this.password,
    this.phone,
    this.photo,
    this.position,
    this.token,
  });

  @override
  String toString() =>
      'Employee(name: $name, email: $email, password: $password, phone: $phone, photo: $photo, position: $position, token: $token)';

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'password': password,
    'phone': phone,
    'photo': photo,
    'position': position,
    'token': token,
  };

  factory Employee.fromMap(Map<String, dynamic> map) => Employee(
    name: map['name'],
    email: map['email'],
    password: map['password'],
    phone: map['phone'],
    photo: map['photo'],
    position: map['position'],
    token: map['token'],
  );

  String toJson() => json.encode(toMap());

  factory Employee.fromJson(String source) =>
      Employee.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    phone,
    photo,
    position,
    token,
  ];
}
