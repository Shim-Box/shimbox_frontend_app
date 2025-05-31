import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shimbox_app/controllers/bottom_nav_controller.dart';
import 'package:shimbox_app/utils/navigation_helper.dart';
import 'package:shimbox_app/utils/sms_helper.dart'; // ✅ 문자 전송 함수 임포트
import 'package:shimbox_app/pages/delivery/photo_capture_modal.dart'; // ✅ 사진 모달 임포트

class DeliveryDetailPage extends StatefulWidget {
  final Map<String, dynamic> area;

  const DeliveryDetailPage({super.key, required this.area});

  @override
  State<DeliveryDetailPage> createState() => _DeliveryDetailPageState();
}

class _DeliveryDetailPageState extends State<DeliveryDetailPage> {
  int? expandedIndex;

  List<List<int>> deliveryStatus = List.generate(
    4,
    (_) => List.generate(2, (_) => 0),
  );

  final List<Map<String, dynamic>> deliveryAreas = [
    {
      'name': '노원구 상계동',
      'total': 20,
      'address': '서울특별시 노원구 동일로 1345',
      'phone': '01093767255',
    },
    {
      'name': '강서구 방화동',
      'total': 30,
      'address': '서울특별시 강서구 금낭화로 168',
      'phone': '01093767255',
    },
    {
      'name': '강남구 삼성동',
      'total': 15,
      'address': '서울특별시 강남구 봉은사로 524',
      'phone': '01093767255',
    },
    {
      'name': '송파구 잠실동',
      'total': 25,
      'address': '서울특별시 송파구 올림픽로 300',
      'phone': '01093767255',
    },
  ];

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
        child: ListView.builder(
          itemCount: deliveryAreas.length,
          itemBuilder: (context, index) {
            final item = deliveryAreas[index];
            final isExpanded = expandedIndex == index;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      expandedIndex = isExpanded ? null : index;
                    });
                  },
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item['name']} (배송완료)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${item['total']} / ${item['total']}건 완료',
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
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isExpanded)
                  Column(
                    children: [
                      SizedBox(height: 10),
                      _buildDropdownContent(index, deliveryAreas[index]),
                    ],
                  ),
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
      children: List.generate(2, (i) {
        int status = deliveryStatus[areaIndex][i];
        Color textColor = status == 2 ? Color(0xFF7A7A7A) : Colors.black;
        Color iconColor = status == 2 ? Color(0xFF7A7A7A) : Color(0xFF61D5AB);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item['name']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                      Text(
                        '${item['address']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                SvgPicture.asset(
                  'assets/images/delivery/phone.svg',
                  width: 20,
                  height: 20,
                  color: iconColor,
                ),
                SizedBox(width: 12),
                GestureDetector(
                  onTap: () async {
                    await startNaviToAddressWithNaver(item['address']);
                  },
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
              '배송 건수 : ${i + 1}건',
              style: TextStyle(color: textColor, fontSize: 14),
            ),
            SizedBox(height: 16),
            _buildStatusButton(areaIndex, i, status, item), // ✅ item 전달
            SizedBox(height: 24),
            if (i < 1)
              Divider(color: Colors.grey[300], thickness: 1, height: 1),
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
    Map<String, dynamic> item,
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
          final imageSent = await showDialog(
            context: context,
            useRootNavigator: false,
            builder:
                (_) => PhotoCaptureModal(
                  phoneNumber: item['phone'],
                  onSend: (image) {
                    // 문자 전송은 현재 보류, 아래는 추후 서버 연동용
                    // await sendSms(item['phone'], '택배 도착했습니다. 문 앞에 두었습니다.');
                    // Navigator.of(context).pop(true);

                    // 상태 갱신: 배송 완료 처리
                    setState(() {
                      deliveryStatus[areaIndex][i] = 2;
                    });
                    // 다시 area를 유지시켜서 pageIndex == 3 상태를 보장
                    final ctrl = Get.find<BottomNavController>();
                    ctrl.selectedArea.value = widget.area;
                    ctrl.pageIndex.value = 3;
                  },
                ),
          );

          if (imageSent == true) {
            setState(() {
              deliveryStatus[areaIndex][i] = 2;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF61D5AB),
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text('배송 도착', style: TextStyle(fontWeight: FontWeight.bold)),
      );
    } else {
      return OutlinedButton(
        onPressed: () {
          setState(() {
            deliveryStatus[areaIndex][i] = 1; // 이제 배송 시작 → 배송 도착 버튼으로 바뀜
          });
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Color(0xFF61D5AB),
          side: BorderSide(color: Color(0xFF61D5AB)),
          backgroundColor: Colors.white,
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
