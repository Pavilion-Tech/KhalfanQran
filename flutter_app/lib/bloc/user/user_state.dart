import 'package:equatable/equatable.dart';
import 'package:khalfan_center/models/user_model.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;

  const UserLoaded({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}

class PasswordChanged extends UserState {}

class UserError extends UserState {
  final String message;

  const UserError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
