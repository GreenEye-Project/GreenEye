import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects/features/auth/forgot_password/forgot_password_screen.dart';
import 'package:projects/features/auth/otp/verify_otp_screen.dart';
import 'package:projects/features/auth/reset_password/reset_password_screen.dart';
import '/features/auth/signup/bloc/signup_bloc.dart';
import '/features/auth/data/auth_repository.dart';
import '/features/auth/signup/screens/signup_screen.dart';
//import '/features/presentation/farmer/screens/home_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SignupBloc(context.read<AuthRepository>()),
          ),
          // Future blocs can also use context.read<AuthRepository>()
        ],
        child: MaterialApp(
          title: 'GreenEye',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
          ),
          //home: const SignupScreen(),
          home: const SignupScreen(),
        ),
      ),
    );
  }
}
