import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:khalfan_center/models/user_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class AuthStateChangedEvent extends AuthEvent {
  final User? user;

  const AuthStateChangedEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class SignUpWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String phone;
  final UserRole role;

  const SignUpWithEmailEvent({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phone,
    required this.role,
  });

  @override
  List<Object> get props => [email, password, fullName, phone, role];
}

class SignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmailEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class SignInWithGoogleEvent extends AuthEvent {}

class SignInWithPhoneEvent extends AuthEvent {
  final String phoneNumber;

  const SignInWithPhoneEvent({
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyPhoneOtpEvent extends AuthEvent {
  final String verificationId;
  final String otp;

  const VerifyPhoneOtpEvent({
    required this.verificationId,
    required this.otp,
  });

  @override
  List<Object> get props => [verificationId, otp];
}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  const ResetPasswordEvent({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}

class SignOutEvent extends AuthEvent {}
