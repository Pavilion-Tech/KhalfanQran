import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:khalfan_center/config/app_config.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Upload profile image
  Future<String> uploadProfileImage(File imageFile, String userId) async {
    try {
      String extension = path.extension(imageFile.path);
      String fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}$extension';
      
      Reference storageRef = _storage.ref().child('profile_images/$fileName');
      
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }
  
  // Upload document
  Future<String> uploadDocument(File documentFile, String studentId, String documentType) async {
    try {
      String extension = path.extension(documentFile.path);
      String fileName = '${studentId}_${documentType}_${DateTime.now().millisecondsSinceEpoch}$extension';
      
      Reference storageRef = _storage.ref().child('documents/$fileName');
      
      UploadTask uploadTask = storageRef.putFile(documentFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }
  
  // Upload news image
  Future<String> uploadNewsImage(File imageFile) async {
    try {
      String extension = path.extension(imageFile.path);
      String fileName = 'news_${const Uuid().v4()}$extension';
      
      Reference storageRef = _storage.ref().child('news_images/$fileName');
      
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }
  
  // Upload event image
  Future<String> uploadEventImage(File imageFile) async {
    try {
      String extension = path.extension(imageFile.path);
      String fileName = 'event_${const Uuid().v4()}$extension';
      
      Reference storageRef = _storage.ref().child('event_images/$fileName');
      
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }
  
  // Delete file by URL
  Future<void> deleteFileByUrl(String fileUrl) async {
    try {
      Reference storageRef = _storage.refFromURL(fileUrl);
      await storageRef.delete();
    } catch (e) {
      rethrow;
    }
  }
  
  // List files in a folder
  Future<List<String>> listFilesInFolder(String folderPath) async {
    try {
      List<String> fileUrls = [];
      ListResult result = await _storage.ref().child(folderPath).listAll();
      
      for (var item in result.items) {
        String downloadUrl = await item.getDownloadURL();
        fileUrls.add(downloadUrl);
      }
      
      return fileUrls;
    } catch (e) {
      rethrow;
    }
  }
  
  // Get file metadata
  Future<Map<String, dynamic>> getFileMetadata(String fileUrl) async {
    try {
      Reference storageRef = _storage.refFromURL(fileUrl);
      FullMetadata metadata = await storageRef.getMetadata();
      
      return {
        'name': metadata.name,
        'size': metadata.size,
        'contentType': metadata.contentType,
        'createdTime': metadata.timeCreated,
        'updatedTime': metadata.updated,
      };
    } catch (e) {
      rethrow;
    }
  }
}
