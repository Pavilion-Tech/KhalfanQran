import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  final String? role;

  const AuthAuthenticated({
    required this.user,
    this.role,
  });

  @override
  List<Object?> get props => [user, role];
}

class AuthUnauthenticated extends AuthState {}

class AuthPhoneCodeSent extends AuthState {
  final String verificationId;
  final int? resendToken;

  const AuthPhoneCodeSent({
    required this.verificationId,
    this.resendToken,
  });

  @override
  List<Object?> get props => [verificationId, resendToken];
}

class AuthPhoneTimeout extends AuthState {
  final String verificationId;

  const AuthPhoneTimeout({
    required this.verificationId,
  });

  @override
  List<Object> get props => [verificationId];
}

class AuthPasswordResetSent extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
