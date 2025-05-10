import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:khalfan_center/bloc/auth/auth_event.dart';
import 'package:khalfan_center/bloc/auth/auth_state.dart';
import 'package:khalfan_center/services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  StreamSubscription? _authStateSubscription;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    _authStateSubscription = authService.authStateChanges.listen((user) {
      add(AuthStateChangedEvent(user));
    });

    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<AuthStateChangedEvent>(_onAuthStateChanged);
    on<SignUpWithEmailEvent>(_onSignUpWithEmail);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignInWithPhoneEvent>(_onSignInWithPhone);
    on<VerifyPhoneOtpEvent>(_onVerifyPhoneOtp);
    on<ResetPasswordEvent>(_onResetPassword);
    on<SignOutEvent>(_onSignOut);
  }

  FutureOr<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      User? user = authService.currentUser;
      if (user != null) {
        String? role = await authService.getUserRole();
        emit(AuthAuthenticated(user: user, role: role));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  FutureOr<void> _onAuthStateChanged(AuthStateChangedEvent event, Emitter<AuthState> emit) async {
    if (event.user != null) {
      String? role = await authService.getUserRole();
      emit(AuthAuthenticated(user: event.user!, role: role));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  FutureOr<void> _onSignUpWithEmail(SignUpWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.signUpWithEmailAndPassword(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
        phone: event.phone,
        role: event.role,
      );
      // AuthStateChangedEvent will be triggered by the listener
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  FutureOr<void> _onSignInWithEmail(SignInWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      // AuthStateChangedEvent will be triggered by the listener
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  FutureOr<void> _onSignInWithGoogle(SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.signInWithGoogle();
      // AuthStateChangedEvent will be triggered by the listener
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  FutureOr<void> _onSignInWithPhone(SignInWithPhoneEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await authService.signInWithPhoneAuthCredential(credential);
            // AuthStateChangedEvent will be triggered by the listener
          } catch (e) {
            emit(AuthError(message: e.toString()));
            emit(AuthUnauthenticated());
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(AuthError(message: e.message ?? 'Verification failed'));
          emit(AuthUnauthenticated());
        },
        codeSent: (String verificationId, int? resendToken) {
          emit(AuthPhoneCodeSent(
            verificationId: verificationId,
            resendToken: resendToken,
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          emit(AuthPhoneTimeout(verificationId: verificationId));
        },
      );
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  FutureOr<void> _onVerifyPhoneOtp(VerifyPhoneOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: event.verificationId,
        smsCode: event.otp,
      );
      await authService.signInWithPhoneAuthCredential(credential);
      // AuthStateChangedEvent will be triggered by the listener
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  FutureOr<void> _onResetPassword(ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.resetPassword(event.email);
      emit(AuthPasswordResetSent());
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  FutureOr<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.signOut();
      // AuthStateChangedEvent will be triggered by the listener
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
