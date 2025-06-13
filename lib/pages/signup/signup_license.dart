import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/signup_data.dart';
import '../../utils/database.dart';
import '../../utils/api_service.dart';
import '../../utils/firebase_uploader.dart';

class LicenseVerifyPage extends StatefulWidget {
  const LicenseVerifyPage({super.key});

  @override
  State<LicenseVerifyPage> createState() => _LicenseVerifyPageState();
}

class _LicenseVerifyPageState extends State<LicenseVerifyPage> {
  final ImagePicker _picker = ImagePicker();
  String? _licenseImagePath;
  bool _cameraLoading = false; // 상태 변수 추가

  // 2초 후 카메라 열기 메서드
  Future<void> _openCameraWithDelay() async {
    setState(() {
      _cameraLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _licenseImagePath = image.path;
        signupData.licenseImage = _licenseImagePath;
      });
    }

    setState(() {
      _cameraLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '면허증 인증',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 23,
                    height: 1.4,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '기사님의\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '운전면허증',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF54D2A7),
                      ),
                    ),
                    TextSpan(
                      text: '과\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '화물운송 종사자격증',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF54D2A7),
                      ),
                    ),
                    TextSpan(
                      text: '을 준비해주세요',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '자격을 확인하기 위한 인증이에요.',
                style: TextStyle(fontSize: 14, color: Color(0xFFBDBDBD)),
              ),
              const SizedBox(height: 50),

              // 이미지 미리보기
              Center(
                child: Column(
                  children: [
                    if (_licenseImagePath == null)
                      GestureDetector(
                        onTap: _cameraLoading ? null : _openCameraWithDelay,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/signup/license_sample.png',
                              width: 350,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _cameraLoading
                                  ? '2초 후 카메라가 열립니다...'
                                  : '샘플 이미지를 눌러 촬영을 시작하세요',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Image.file(
                        File(_licenseImagePath!),
                        width: 330,
                        height: 240,
                        fit: BoxFit.cover,
                      ),
                    const SizedBox(height: 20),
                    // if (_licenseImagePath != null)
                    // Text(
                    //   '선택된 이미지: $_licenseImagePath',
                    //   style: const TextStyle(
                    //     fontSize: 12,
                    //     color: Colors.grey,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: SizedBox(
          height: 60,
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                _licenseImagePath != null
                    ? () async {
                      final file = File(_licenseImagePath!);
                      final fileName =
                          'license_${signupData.name}_${DateTime.now().millisecondsSinceEpoch}.jpg';

                      final downloadUrl =
                          await FirebaseUploader.uploadImageToFirebase(
                            file,
                            fileName,
                          );

                      if (downloadUrl != null) {
                        signupData.licenseImage = downloadUrl;
                        Navigator.pushNamed(context, '/signup_experience');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('면허증 업로드 실패')),
                        );
                      }
                    }
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _licenseImagePath != null
                      ? const Color(0xFF54D2A7)
                      : const Color(0xFFD3D3D3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '다음',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
