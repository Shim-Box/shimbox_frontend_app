import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlarmScreen extends StatelessWidget {
  final List<Map<String, String>> alarmData = [
    {'title': '배송완료를 눌렀는지 확인해주세요', 'subtitle': '경기도 광명시 광명 2동'},
    {'title': '배송완료를 눌렀는지 확인해주세요', 'subtitle': '경기도 광명시 광명 2동'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 31),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 뒤로가기 버튼
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  'assets/images/home/back.svg',
                  width: 9,
                  height: 18,
                  color: Color(0xFF000000),
                ),
              ),

              SizedBox(height: 39),

              // '알림' 텍스트
              Text(
                '알림',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 26),
              // 알림 리스트
              Expanded(
                child: ListView.builder(
                  itemCount: alarmData.length,
                  itemBuilder: (context, index) {
                    final alarm = alarmData[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 35.0, left: 11),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: SvgPicture.asset(
                              'assets/images/home/alarmG.svg',
                              width: 17.14,
                              height: 22.22,
                              color: Color(0xFF61D5AB),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '배송완료',
                                        style: TextStyle(
                                          color: Color(0xFF61D5AB),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '를 눌렀는지 확인해주세요',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  alarm['subtitle']!,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
