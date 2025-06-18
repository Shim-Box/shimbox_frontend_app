import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimbox_app/controllers/bottom_nav_controller.dart';
import 'package:shimbox_app/utils/navigation_helper.dart';
import 'package:shimbox_app/pages/delivery/photo_capture_modal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimbox_app/utils/firebase_uploader.dart';
import '../../utils/api_service.dart';
import 'package:shimbox_app/models/test_user_data.dart' as localUser;

class DeliveryDetailPage extends StatefulWidget {
  final Map<String, dynamic> area;

  const DeliveryDetailPage({super.key, required this.area});

  @override
  State<DeliveryDetailPage> createState() => _DeliveryDetailPageState();
}

class _DeliveryDetailPageState extends State<DeliveryDetailPage> {
  int? expandedIndex;

  List<List<int>> deliveryStatus = [];
  List<Map<String, dynamic>> deliveryAreas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('token');
      localUser.UserData.token = savedToken;
      print('📦 DeliveryDetailPage에서 토큰 로드: $savedToken');

      fetchData();
    });
  }

  Future<void> fetchData() async {
    try {
      final data = await ApiService.fetchDeliverySummary();
      setState(() {
        deliveryAreas =
            data.expand<Map<String, dynamic>>((area) {
              return area['groups'].map<Map<String, dynamic>>((group) {
                return {
                  'name': area['shippingLocation'],
                  'address': group['detailAddress'],
                  'total': group['count'],
                  'phone': '01012345678',
                  'products': group['products'],
                };
              });
            }).toList();

        deliveryStatus =
            deliveryAreas.map((e) {
              return List.generate(
                e['products'].length,
                (i) => _statusToInt(e['products'][i]['shippingStatus']),
              );
            }).toList();

        isLoading = false;
      });
    } catch (e) {
      print('Error loading delivery data: $e');
      setState(() => isLoading = false);
    }
  }

  int _statusToInt(String status) {
    switch (status) {
      case '배송시작':
        return 1;
      case '배송완료':
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.area['name']} 배달 건',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 37),
          child: Center(
            child: GestureDetector(
              onTap: () {
                Get.find<BottomNavController>().changeBottomNav(0);
              },
              child: SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset(
                  'assets/images/home/back.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 16,
                ),
                child: ListView.builder(
                  itemCount: deliveryAreas.length,
                  itemBuilder: (context, index) {
                    final item = deliveryAreas[index];
                    final isExpanded = expandedIndex == index;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap:
                              () => setState(
                                () => expandedIndex = isExpanded ? null : index,
                              ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF4F4F4),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/images/home/marker.svg',
                                      width: 24,
                                      height: 24,
                                      color: Color(0xFF61D5AB),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${item['name']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${item['total']}건',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isExpanded) ...[
                          SizedBox(height: 10),
                          _buildDropdownContent(index, item),
                        ],
                        SizedBox(height: 12),
                      ],
                    );
                  },
                ),
              ),
    );
  }

  Widget _buildDropdownContent(int areaIndex, Map<String, dynamic> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(item['products'].length, (i) {
        final product = item['products'][i];
        final status = deliveryStatus[areaIndex][i];
        final textColor = status == 2 ? Color(0xFF7A7A7A) : Colors.black;
        final iconColor = status == 2 ? Color(0xFF7A7A7A) : Color(0xFF61D5AB);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${product['recipientName']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${product['address']} ${product['detailAddress']}',
                        style: TextStyle(fontSize: 14, color: textColor),
                      ),
                    ],
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/delivery/phone.svg',
                  width: 20,
                  height: 20,
                  color: iconColor,
                ),
                SizedBox(width: 12),
                GestureDetector(
                  onTap:
                      () => startNaviToAddressWithNaver(
                        '${product['address']} ${product['detailAddress']}',
                      ),
                  child: SvgPicture.asset(
                    'assets/images/delivery/nav.svg',
                    width: 20,
                    height: 20,
                    color: iconColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '예상 도착 시간: ${product['estimatedArrivalTime']}',
              style: TextStyle(color: textColor, fontSize: 14),
            ),
            SizedBox(height: 16),
            _buildStatusButton(areaIndex, i, status, product),
            SizedBox(height: 24),
            if (i < item['products'].length - 1)
              Divider(color: Colors.grey[300], height: 1),
            SizedBox(height: 24),
          ],
        );
      }),
    );
  }

  Widget _buildStatusButton(
    int areaIndex,
    int i,
    int status,
    Map<String, dynamic> product,
  ) {
    if (status == 2) {
      return OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          foregroundColor: Color(0xFFAAAAAA),
          side: BorderSide(color: Color(0xFFAAAAAA)),
          minimumSize: Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/delivery/complete.svg',
              width: 20,
              height: 20,
              color: Color(0xFFAAAAAA),
            ),
            SizedBox(width: 8),
            Text('배송 완료', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );
    } else if (status == 1) {
      return ElevatedButton(
        onPressed: () async {
          // 👉 먼저 서버에 상태를 배송완료로 업데이트
          final statusUpdated = await ApiService.updateProductStatus(
            product['productId'],
            '배송완료',
          );

          if (!statusUpdated) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('배송완료 상태 전환 실패')));
            return;
          }

          // 👉 서버 반영을 조금 기다림
          await Future.delayed(Duration(milliseconds: 700));

          // 👉 상태 전환 성공하면 카메라 모달 띄움
          await showDialog(
            context: context,
            useRootNavigator: false,
            builder:
                (_) => PhotoCaptureModal(
                  phoneNumber: product['recipientPhone'] ?? '01012345678',
                  productId: product['productId'],
                  onSend: (image) async {
                    final url = await FirebaseUploader.uploadImage(
                      image,
                      folder: 'deliveries',
                    );

                    print('🧪 Firebase 업로드된 URL: $url');

                    if (url != null) {
                      final smsText = '배송이 완료되었습니다.\n사진 확인: $url';
                      final uri = Uri.parse(
                        'sms:${product['recipientPhone']}?body=${Uri.encodeComponent(smsText)}',
                      );

                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }

                      final imgSuccess = await ApiService.sendDeliveryImage(
                        productId: product['productId'],
                        imageUrl: url,
                      );

                      if (imgSuccess) {
                        // 📌 이 위치에서 setState 호출하는 것이 안전함
                        if (mounted) {
                          setState(() {
                            deliveryStatus[areaIndex][i] = 2;
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('이미지 URL 저장 실패')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Firebase 업로드 실패')),
                      );
                    }
                  },
                ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF61D5AB),
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text('배송 도착', style: TextStyle(fontWeight: FontWeight.bold)),
      );
    } else {
      return OutlinedButton(
        onPressed: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => Center(child: CircularProgressIndicator()),
          );
          final success = await ApiService.updateProductStatus(
            product['productId'],
            '배송시작',
          );
          Navigator.of(context).pop();

          if (success) {
            await Future.delayed(Duration(seconds: 1)); // 아주 약간 대기

            setState(() {
              deliveryStatus[areaIndex][i] = 1;
            });
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('배송 시작 처리에 실패했습니다.')));
          }
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Color(0xFF61D5AB),
          side: BorderSide(color: Color(0xFF61D5AB)),
          minimumSize: Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text('배송 시작', style: TextStyle(fontWeight: FontWeight.bold)),
      );
    }
  }
}
