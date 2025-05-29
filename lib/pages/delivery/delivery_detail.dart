import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shimbox_app/controllers/bottom_nav_controller.dart';

class DeliveryDetailPage extends StatefulWidget {
  final Map<String, dynamic> area;

  const DeliveryDetailPage({super.key, required this.area});

  @override
  State<DeliveryDetailPage> createState() => _DeliveryDetailPageState();
}

class _DeliveryDetailPageState extends State<DeliveryDetailPage> {
  int? expandedIndex;

  final List<Map<String, dynamic>> deliveryAreas = [
    {'name': '고척동', 'total': 20},
    {'name': '오류동', 'total': 30},
    {'name': '신도림동', 'total': 100},
    {'name': '개봉동', 'total': 30},
  ];

  // 배송 상태
  List<List<int>> deliveryStatus = List.generate(
    4,
    (_) => List.generate(2, (_) => 0),
  );

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
                      _buildDropdownContent(index),
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

  Widget _buildDropdownContent(int areaIndex) {
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
                        '경기도 광명시 광명 2동',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                      Text(
                        '오리로 52-2 (산타빌라 205호)',
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
            _buildStatusButton(areaIndex, i, status),
            SizedBox(height: 24),
            if (i < 1)
              Divider(color: Colors.grey[300], thickness: 1, height: 1),
            SizedBox(height: 24),
          ],
        );
      }),
    );
  }

  Widget _buildStatusButton(int areaIndex, int i, int status) {
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
        onPressed: () {
          setState(() {
            deliveryStatus[areaIndex][i] += 1;
          });
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
            deliveryStatus[areaIndex][i] += 1;
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
