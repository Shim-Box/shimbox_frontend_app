// lib/utils/firebase_uploader.dart

import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseUploader {
  static Future<String?> uploadImageToFirebase(
    File file,
    String fileName, {
    String folder = 'licenses', // ✅ 기본 폴더는 licenses
  }) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('$folder/$fileName');
      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();
      print('✅ Firebase 업로드 완료: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('🔥 Firebase 업로드 실패: $e');
      return null;
    }
  }
}
