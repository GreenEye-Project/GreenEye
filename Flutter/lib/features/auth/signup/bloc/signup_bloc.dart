import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_event.dart';
import 'signup_state.dart';
import '../../data/auth_repository.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository repo;

  SignupBloc(this.repo) : super(SignupInitial()) {
    on<SignupSubmitted>(_onSignup);
  }

  Future<void> _onSignup(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());
    try {
      await repo.register(
        name: event.name,
        phone: event.phone,
        email: event.email,
        address: event.address,
        password: event.password,
        confirmPassword: event.confirmPassword,
        role: event.role,
      );

      emit(SignupSuccess(event.email, event.role));
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}
