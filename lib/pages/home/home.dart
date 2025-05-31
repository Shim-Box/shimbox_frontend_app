// 추가된 파일 import
import 'survey_module.dart';

// 기존 import 유지
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shimbox_app/controllers/bottom_nav_controller.dart';
import './alarmScreen.dart';
import '../delivery/delivery_detail.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> deliveryAreas = [
    {'name': '고척동', 'total': 20},
    {'name': '오류동', 'total': 30},
    {'name': '신도림동', 'total': 100},
    {'name': '개봉동', 'total': 30},
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  bool showSurvey = false;
  final bottomController = Get.find<BottomNavController>();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 31),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 유저 정보 영역
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/images/home/hong.png',
                              width: 63.84,
                              height: 63,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '홍길동님',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/home/marker.svg',
                                    width: 17,
                                    height: 17,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '서울시, 구로구',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => AlarmScreen()),
                            ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: SvgPicture.asset(
                            'assets/images/home/alarm.svg',
                            width: 19,
                            height: 21,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // 출근/퇴근 박스
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        final now = DateTime.now();
                        final time =
                            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

                        if (_currentPage == 0) {
                          bottomController.isCheckedIn.value = true;
                          bottomController.checkInTime.value = time;
                          bottomController.isCheckedOut.value = false;
                        } else {
                          if (bottomController.isCheckedIn.value) {
                            bottomController.isCheckedOut.value = true;
                            bottomController.checkOutTime.value = time;
                            setState(() => showSurvey = true);
                          }
                        }
                      },
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: Color(0xFF61D5AB),
                          borderRadius: BorderRadius.circular(21),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 14.0,
                              ),
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: 2,
                                onPageChanged:
                                    (index) =>
                                        setState(() => _currentPage = index),
                                itemBuilder: (context, index) {
                                  return Obx(() {
                                    String label = '';
                                    String message = '길동님, 오늘 하루도 힘차게 시작해 볼까요?';

                                    if (index == 0) {
                                      label =
                                          bottomController.isCheckedIn.value
                                              ? '출근완료 ${bottomController.checkInTime.value}'
                                              : '출근';
                                    } else {
                                      if (bottomController.isCheckedOut.value) {
                                        label =
                                            '퇴근완료 ${bottomController.checkOutTime.value}';
                                        message = '길동님, 오늘 하루도 고생하셨어요';
                                      } else {
                                        label = '퇴근';
                                      }
                                    }

                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              message,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              label,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.asset(
                                            'assets/images/home/btncar.png',
                                            width: 35,
                                            height: 35,
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(2, (dotIndex) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    child: Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color:
                                            dotIndex == _currentPage
                                                ? Colors.white
                                                : Colors.white.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // 오늘의 배송
                  Text(
                    '오늘의 배송',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),

                  // 배송 상태
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/home/bus.png',
                        width: 78.68,
                        height: 61,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 11.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '0',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF61D5AB),
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' / 300 건 완료',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 6,
                                      width: 223,
                                      color: Colors.grey[300],
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: 0.2,
                                      child: Container(
                                        height: 6,
                                        color: Color(0xFF61D5AB),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // 배송 목록
                  Expanded(
                    child: ListView.builder(
                      itemCount: deliveryAreas.length,
                      itemBuilder: (context, index) {
                        final area = deliveryAreas[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 5.0,
                            left: 10,
                            right: 10,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 0,
                            leading: Container(
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
                                  color: Color(0xFF171412),
                                ),
                              ),
                            ),
                            title: Text(
                              '${area['name']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '0 / ${area['total']}건 미완료',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(Icons.chevron_right, size: 28),
                            ),

                            // home.dart
                            onTap: () {
                              Get.find<BottomNavController>()
                                  .goToDeliveryDetail(area);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        if (showSurvey)
          SurveyModule(
            onClose: (route) {
              bottomController.changeBottomNav(0);
              _pageController.jumpToPage(0);

              setState(() {
                _currentPage = 0;
                showSurvey = false;

                // ✅ 여기! GetX 상태 초기화
                bottomController.isCheckedIn.value = false;
                bottomController.checkInTime.value = '';
              });
            },
          ),
      ],
    );
  }
}
