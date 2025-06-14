import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseUploader {
  static Future<String?> uploadImageToFirebase(
    File file,
    String fileName, {
    String folder = 'licenses', // ✅ 기본 폴더는 licenses
  }) async {
    try {
      print('📤 Firebase 업로드 시작: $fileName');
      print('📁 업로드 대상 경로: $folder/$fileName');
      print('📄 실제 파일 경로: ${file.path}');
      final ref = FirebaseStorage.instance.ref().child('$folder/$fileName');

      final uploadTask = await ref.putFile(file);
      print('✅ Firebase putFile 완료: ${uploadTask.state}');

      final downloadUrl = await ref.getDownloadURL();
      print('✅ Firebase 업로드 완료, URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('🔥 Firebase 업로드 실패: $e');
      return null;
    }
  }
}
