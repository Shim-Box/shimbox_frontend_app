import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:shimbox_app/controllers/bottom_nav_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/api_service.dart';
import 'package:shimbox_app/utils/firebase_uploader.dart'; // ✅ FirebaseUploader 클래스
import 'package:url_launcher/url_launcher.dart'; // ✅ 문자 전송용

class PhotoCaptureModal extends StatefulWidget {
  final String phoneNumber;
  final Function(File) onSend;

  const PhotoCaptureModal({
    super.key,
    required this.phoneNumber,
    required this.onSend,
  });

  @override
  State<PhotoCaptureModal> createState() => _PhotoCaptureModalState();
}

class _PhotoCaptureModalState extends State<PhotoCaptureModal> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _pickImage();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ✅ 다이얼로그 본문
        Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 80,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child:
              _image == null
                  ? const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  )
                  : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.file(
                          _image!,
                          width: double.infinity,
                          height: 260,
                          fit: BoxFit.cover,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_image != null) {
                            widget.onSend(_image!);
                            Navigator.of(context, rootNavigator: false).pop();
                          }
                        },

                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(16),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '고객에게 문자 보내기 >',
                            style: TextStyle(
                              color: Color(0xFF61D5AB),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
        ),

        // ✅ 다시찍기: 다이얼로그 바깥, 사진 상단 오른쪽에 겹치게 (살짝 아래로)
        Positioned(
          top: 220, // 🔽 기존보다 아래로 조정
          right: 36,
          child: GestureDetector(
            onTap: () async {
              await _pickImage(); // ✅ 다시 촬영
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '다시찍기',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  SvgPicture.asset(
                    'assets/images/delivery/re.svg',
                    width: 20,
                    height: 20,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
