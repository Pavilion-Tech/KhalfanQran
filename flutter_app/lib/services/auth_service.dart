// Auth service implementation that works with Firebase Auth
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' hide UserInfo;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth show UserInfo;
import 'package:khalfan_center/models/user_model.dart';
import 'package:khalfan_center/services/firebase_service.dart';

class AuthService {
  final FirebaseService _firebaseService;
  
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Current authenticated user
  UserModel? _currentUser;
  
  // Authentication state
  bool _isAuthenticated = false;
  
  // Authentication state stream controller
  final StreamController<User?> _authStateController = StreamController<User?>.broadcast();
  
  AuthService(this._firebaseService) {
    // Listen to Firebase Auth state changes
    _auth.authStateChanges().listen((user) {
      _authStateController.add(user);
      _loadUserData(user);
    });
  }
  
  // Get auth state changes stream
  Stream<User?> get authStateChanges => _authStateController.stream;
  
  // Load user data from Firestore
  Future<void> _loadUserData(User? user) async {
    if (user != null) {
      try {
        final userData = await _firebaseService.getUserData(user.uid);
        _currentUser = userData;
        _isAuthenticated = true;
      } catch (e) {
        print('Error loading user data: $e');
        _currentUser = null;
        _isAuthenticated = false;
      }
    } else {
      _currentUser = null;
      _isAuthenticated = false;
    }
  }
  
  // Getter for Firebase Auth user
  User? get currentUser => _auth.currentUser;
  
  // Getter for Firebase Service
  FirebaseService getFirebaseService() {
    return _firebaseService;
  }
  
  // Get current authenticated user model
  UserModel? get currentUserModel => _currentUser;
  
  // Check if user is authenticated
  bool get isAuthenticated => _isAuthenticated;
  
  // Get user role
  Future<String?> getUserRole() async {
    if (currentUser == null) return null;
    try {
      final userData = await _firebaseService.getUserData(currentUser!.uid);
      return userData != null ? userRoleToString(userData.role) : null;
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }
  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Use Firebase Auth to sign in
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update last login
      if (credential.user != null) {
        final userData = await _firebaseService.getUserData(credential.user!.uid);
        if (userData != null) {
          final updatedUser = userData.copyWith(
            lastLogin: DateTime.now(),
          );
          await _firebaseService.setUserData(updatedUser);
        }
      }
      
      return credential;
    } catch (e) {
      print('Error signing in with email and password: $e');
      throw e;
    }
  }
  
  // Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required UserRole role,
  }) async {
    try {
      // Use Firebase Auth to create account
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        // Create user model
        final newUser = UserModel(
          id: credential.user!.uid,
          name: fullName,
          email: email,
          phone: phone,
          role: role,
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
        );
        
        // Save to Firestore
        await _firebaseService.setUserData(newUser);
        
        // Update user profile
        await credential.user!.updateDisplayName(fullName);
      }
      
      return credential;
    } catch (e) {
      print('Error signing up with email and password: $e');
      throw e;
    }
  }
  
  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // For now, we're not implementing Google Sign In in the mock
      throw UnimplementedError('Google Sign In is not implemented in mock mode');
    } catch (e) {
      print('Error signing in with Google: $e');
      throw e;
    }
  }
  
  // Verify phone number
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      print('Error verifying phone number: $e');
      throw e;
    }
  }
  
  // Sign in with phone credential
  Future<UserCredential> signInWithPhoneAuthCredential(PhoneAuthCredential credential) async {
    try {
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with phone credential: $e');
      throw e;
    }
  }
  
  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error resetting password: $e');
      throw e;
    }
  }
  
  // Backward compatibility methods
  Future<UserModel?> loginWithEmailAndPassword(String email, String password) async {
    try {
      await signInWithEmailAndPassword(email: email, password: password);
      return _currentUser;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }
  
  // Log out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      _isAuthenticated = false;
    } catch (e) {
      print('Error signing out: $e');
      throw e;
    }
  }
  
  // Alias for logout (for backward compatibility)
  Future<void> logout() async => signOut();
  
  // Get user by ID
  Future<UserModel?> getUserById(String uid) async {
    try {
      return await _firebaseService.getUserData(uid);
    } catch (e) {
      print('Error getting user by ID: $e');
      return null;
    }
  }
  
  // Update user profile
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _firebaseService.setUserData(user);
      
      // Update current user if it's the same user
      if (_currentUser != null && _currentUser!.id == user.id) {
        _currentUser = user;
      }
    } catch (e) {
      print('Error updating user profile: $e');
      throw e;
    }
  }
  
  // Delete user account
  Future<void> deleteUserAccount(String uid) async {
    try {
      await _firebaseService.deleteUser(uid);
      
      // Log out if it's the current user
      if (_currentUser != null && _currentUser!.id == uid) {
        await logout();
      }
    } catch (e) {
      print('Error deleting user account: $e');
      throw e;
    }
  }
  
  // Get all admins
  Future<List<UserModel>> getAllAdmins() async {
    try {
      return await _firebaseService.getUsersByRole(UserRole.admin);
    } catch (e) {
      print('Error getting all admins: $e');
      return [];
    }
  }
  
  // Get all teachers
  Future<List<UserModel>> getAllTeachers() async {
    try {
      return await _firebaseService.getUsersByRole(UserRole.teacher);
    } catch (e) {
      print('Error getting all teachers: $e');
      return [];
    }
  }
  
  // Get all parents
  Future<List<UserModel>> getAllParents() async {
    try {
      return await _firebaseService.getUsersByRole(UserRole.parent);
    } catch (e) {
      print('Error getting all parents: $e');
      return [];
    }
  }
}