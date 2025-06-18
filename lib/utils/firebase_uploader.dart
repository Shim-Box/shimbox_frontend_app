import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class FirebaseUploader {
  // ✅ 통일된 이름으로 외부에서 사용
  static Future<String?> uploadImage(
    File file, {
    String folder = 'licenses',
  }) async {
    try {
      final fileName = '${const Uuid().v4()}.jpg'; // UUID로 고유 파일 이름 생성
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

  static Future<String?> uploadImageToFirebase(
    File file,
    String fileName, {
    String folder = 'licenses',
  }) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('$folder/$fileName');
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('🔥 Firebase 업로드 실패: $e');
      return null;
    }
  }
}
