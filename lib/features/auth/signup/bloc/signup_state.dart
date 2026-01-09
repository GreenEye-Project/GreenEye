import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final String email;
  final int role;

  SignupSuccess(this.email, this.role);

  @override
  List<Object?> get props => [email, role];
}

class SignupFailure extends SignupState {
  final String message;
  SignupFailure(this.message);

  @override
  List<Object?> get props => [message];
}
