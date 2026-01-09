import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignupSubmitted extends SignupEvent {
  final String name;
  final String phone;
  final String email;
  final String address;
  final String password;
  final String confirmPassword;
  final int role;

  SignupSubmitted({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.password,
    required this.confirmPassword,
    required this.role,
  });

  @override
  List<Object?> get props => [
    name,
    phone,
    email,
    address,
    password,
    confirmPassword,
    role,
  ];
}
