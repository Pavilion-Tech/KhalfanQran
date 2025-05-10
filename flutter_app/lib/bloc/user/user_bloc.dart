import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:khalfan_center/bloc/user/user_event.dart';
import 'package:khalfan_center/bloc/user/user_state.dart';
import 'package:khalfan_center/models/user_model.dart';
import 'package:khalfan_center/services/firebase_service.dart';
import 'package:khalfan_center/services/storage_service.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseService firebaseService;
  final StorageService storageService;

  UserBloc({
    required this.firebaseService,
    required this.storageService,
  }) : super(UserInitial()) {
    on<LoadUserProfileEvent>(_onLoadUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<UpdateUserProfileImageEvent>(_onUpdateUserProfileImage);
    on<ChangePasswordEvent>(_onChangePassword);
  }

  FutureOr<void> _onLoadUserProfile(LoadUserProfileEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      UserModel? user = await firebaseService.getUserById(event.userId);
      if (user != null) {
        emit(UserLoaded(user: user));
      } else {
        emit(const UserError(message: 'User not found'));
      }
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  FutureOr<void> _onUpdateUserProfile(UpdateUserProfileEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await firebaseService.updateUser(event.userId, {
        'fullName': event.fullName,
        'phone': event.phone,
        if (event.email != null) 'email': event.email,
      });
      
      UserModel? updatedUser = await firebaseService.getUserById(event.userId);
      if (updatedUser != null) {
        emit(UserLoaded(user: updatedUser));
      } else {
        emit(const UserError(message: 'Failed to load updated user'));
      }
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  FutureOr<void> _onUpdateUserProfileImage(UpdateUserProfileImageEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      // Upload the new image
      String imageUrl = await storageService.uploadProfileImage(event.imageFile, event.userId);
      
      // Get the current user to check if there's an existing profile image
      UserModel? currentUser = await firebaseService.getUserById(event.userId);
      
      // Update the user profile with the new image URL
      await firebaseService.updateUser(event.userId, {
        'profileImageUrl': imageUrl,
      });
      
      // If there was an existing profile image, delete it from storage
      if (currentUser != null && currentUser.profileImageUrl.isNotEmpty) {
        try {
          await storageService.deleteFileByUrl(currentUser.profileImageUrl);
        } catch (e) {
          // Just log the error but continue
          print('Failed to delete old profile image: $e');
        }
      }
      
      // Load the updated user
      UserModel? updatedUser = await firebaseService.getUserById(event.userId);
      if (updatedUser != null) {
        emit(UserLoaded(user: updatedUser));
      } else {
        emit(const UserError(message: 'Failed to load updated user'));
      }
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  FutureOr<void> _onChangePassword(ChangePasswordEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      if (firebaseService.currentUser != null) {
        // Reauthenticate the user
        await firebaseService.currentUser!.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: firebaseService.currentUser!.email!,
            password: event.currentPassword,
          ),
        );
        
        // Change the password
        await firebaseService.currentUser!.updatePassword(event.newPassword);
        
        // Emit success state
        emit(PasswordChanged());
        
        // Reload user profile
        UserModel? user = await firebaseService.getUserById(firebaseService.currentUser!.uid);
        if (user != null) {
          emit(UserLoaded(user: user));
        }
      } else {
        emit(const UserError(message: 'User not authenticated'));
      }
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }
}
