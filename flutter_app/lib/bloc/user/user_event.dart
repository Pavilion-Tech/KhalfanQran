import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserProfileEvent extends UserEvent {
  final String userId;

  const LoadUserProfileEvent({
    required this.userId,
  });

  @override
  List<Object> get props => [userId];
}

class UpdateUserProfileEvent extends UserEvent {
  final String userId;
  final String fullName;
  final String phone;
  final String? email;

  const UpdateUserProfileEvent({
    required this.userId,
    required this.fullName,
    required this.phone,
    this.email,
  });

  @override
  List<Object?> get props => [userId, fullName, phone, email];
}

class UpdateUserProfileImageEvent extends UserEvent {
  final String userId;
  final File imageFile;

  const UpdateUserProfileImageEvent({
    required this.userId,
    required this.imageFile,
  });

  @override
  List<Object> get props => [userId, imageFile];
}

class ChangePasswordEvent extends UserEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword];
}
