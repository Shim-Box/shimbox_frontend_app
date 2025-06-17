import 'survey_module.dart';

// 기존 import 유지
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shimbox_app/controllers/bottom_nav_controller.dart';
import './alarmScreen.dart';
import '../delivery/delivery_detail.dart';
import 'package:shimbox_app/models/test_user_data.dart';
import 'package:shimbox_app/utils/api_service.dart';
import 'package:shimbox_app/models/test_user_data.dart';
import 'package:shimbox_app/models/test_user_data.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> deliveryAreas = []; // ✅ API 연동으로 대체됨
  int totalDeliveries = 0;
  int completedDeliveries = 0;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool showSurvey = false;

  final bottomController = Get.find<BottomNavController>();

  @override
  void initState() {
    super.initState();
    fetchDeliverySummary();
  }

  Future<void> fetchDeliverySummary() async {
    try {
      final data = await ApiService.fetchDeliverySummary();
      int total = 0;
      int completed = 0;

      final areas =
          data.map<Map<String, dynamic>>((area) {
            final int totalCount = (area['totalCount'] ?? 0).toInt();
            final int completedCount = (area['completedCount'] ?? 0).toInt();

            total += totalCount;
            completed += completedCount;

            return {
              'name': area['shippingLocation'],
              'total': totalCount,
              'completed': completedCount,
            };
          }).toList();

      setState(() {
        deliveryAreas = areas;
        totalDeliveries = total;
        completedDeliveries = completed;
      });
    } catch (e) {
      print('❌ 배송 요약 불러오기 실패: $e');
    }
  }

  String getShortName(String fullName) {
    if (fullName.length <= 2) return fullName;
    return fullName.substring(fullName.length - 2);
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 38),
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
                                '${UserData.name ?? '사용자'}님',
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
                                    '${UserData.residence ?? '지역 정보 없음'}', // ← 여기에 적용
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

                  SizedBox(height: 35),

                  // 출근/퇴근 박스
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        print('🟢 버튼 눌림: $_currentPage');

                        final now = DateTime.now();
                        final time =
                            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

                        if (_currentPage == 0) {
                          final success =
                              await ApiService.updateAttendanceStatus("출근");
                          print('🔁 출근 요청 결과: $success');
                          if (success) {
                            bottomController.isCheckedIn.value = true;
                            bottomController.checkInTime.value = time;
                            bottomController.isCheckedOut.value = false;
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('출근 상태 변경 실패')),
                            );
                          }
                        } else {
                          if (bottomController.isCheckedIn.value) {
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
                                    final String displayName = getShortName(
                                      UserData.name ?? '사용자',
                                    );
                                    String label = '';
                                    String message =
                                        '$displayName님, 오늘 하루도 힘차게 시작해 볼까요?';

                                    if (index == 0) {
                                      label =
                                          bottomController.isCheckedIn.value
                                              ? '출근완료 ${bottomController.checkInTime.value}'
                                              : '출근';
                                    } else {
                                      if (bottomController.isCheckedOut.value) {
                                        label =
                                            '퇴근완료 ${bottomController.checkOutTime.value}';
                                        message =
                                            '$displayName님, 오늘 하루도 고생하셨어요';
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

                  SizedBox(height: 50),

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
                                      text: '$completedDeliveries',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF61D5AB),
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' / $totalDeliveries 건 완료',
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
                                      widthFactor:
                                          totalDeliveries > 0
                                              ? completedDeliveries /
                                                  totalDeliveries
                                              : 0,
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
                              '${area['completed']} / ${area['total']}건 완료',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(Icons.chevron_right, size: 28),
                            ),
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
            onSubmit: (finish1, finish2, finish3) async {
              print('📤 설문 제출 시작');

              final dummySuccess = await ApiService.createDummyHealthRecord();
              if (!dummySuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('건강 데이터 생성 실패')));
                return;
              }

              final surveySuccess = await ApiService.submitHealthSurvey(
                finish1: finish1,
                finish2: finish2,
                finish3: finish3,
              );

              if (!surveySuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('설문 제출 실패')));
                return;
              }

              final now = DateTime.now();
              final time =
                  '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

              final offSuccess = await ApiService.updateAttendanceStatus("퇴근");
              if (!offSuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('퇴근 상태 변경 실패')));
                return;
              }

              bottomController.isCheckedOut.value = true;
              bottomController.checkOutTime.value = time;

              setState(() {
                _currentPage = 0;
                showSurvey = false;
                bottomController.isCheckedIn.value = false;
                bottomController.checkInTime.value = '';
              });

              bottomController.changeBottomNav(0);
              _pageController.jumpToPage(0);
            },
            onClose: (_) {
              setState(() => showSurvey = false);
            },
          ),
      ],
    );
  }
}
