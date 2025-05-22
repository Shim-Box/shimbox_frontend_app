import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

// 건강 페이지 메인 클래스
class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  // 날짜 포맷
  String _formattedDate() {
    final now = DateTime.now();
    final weekdayKor = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    final formatted = DateFormat('yy.MM.dd').format(now);
    final weekday = weekdayKor[now.weekday - 1];
    return '$formatted $weekday';
  }

  @override
  Widget build(BuildContext context) {
    // 데이터 (추후 DB 연동)
    final userName = '홍길동';
    final fatigueLevel = 'HIGH';
    final fatigueColor = const Color(0xFFFF8A8A);
    final fatigueMessage = '오늘은 좀 피곤하실 것 같네요.\n휴식이 필요해요!';

    final stepCount = '8,235';
    final stepAverage = '주간 평균 7,000보';

    final heartRateValue = '76';
    final heartRateChange = '+5 bpm';

    final workTime = '8시간';
    final workTimeSub = '주간 평균 7시간';
    final workChartHeights = [77.0, 78.0, 55.0, 76.0, 71.0];
    final workChartLabels = ['월요일', '화요일', '수요일', '목요일', '금요일'];

    final deliveryCount = '300건';
    final deliverySub = '평균 대비 +10%';
    final deliveryChartHeights = [65.0, 60.0, 72.0, 55.0, 53.0];
    final deliveryChartLabels = ['월요일', '화요일', '수요일', '목요일', '금요일'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 날짜 + 제목 + 웨어러블 버튼
                const SizedBox(height: 25),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formattedDate(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$userName님의 건강 리포트',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(40, 40),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/health/wearable.png',
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "웨어러블\n연동",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // 피로도 정보
                const SizedBox(height: 15),
                Row(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: fatigueColor,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "예상 피로도",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            fatigueLevel,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        fatigueMessage,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                // 걸음 수 + 심박수 카드
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: _healthCard(
                        iconPath: 'assets/images/health/chart.svg',
                        title: '걸음 수',
                        value: stepCount,
                        sub: stepAverage,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 68,
                      color: const Color(0xFFE3E3E3),
                      margin: const EdgeInsets.only(left: 12, right: 28),
                    ),
                    Expanded(
                      child: _healthCard(
                        iconPath: 'assets/images/health/heart.svg',
                        title: '심박수',
                        value: '$heartRateValue bpm',
                        sub: heartRateChange,
                        subColor: const Color(0xFF61D5AB),
                      ),
                    ),
                  ],
                ),

                // 근무시간 + 배달 건수 차트
                const SizedBox(height: 50),
                _metricCardWithBarChart(
                  iconPath: 'assets/images/health/time.svg',
                  title: '근무시간',
                  value: workTime,
                  subtitle: workTimeSub,
                  barHeights: workChartHeights,
                  barLabels: workChartLabels,
                ),
                const SizedBox(height: 25),
                _metricCardWithBarChart(
                  iconPath: 'assets/images/health/delivery.svg',
                  title: '배달 건수',
                  value: deliveryCount,
                  subtitle: deliverySub,
                  subtitleColor: const Color(0xFF61D5AB),
                  barHeights: deliveryChartHeights,
                  barLabels: deliveryChartLabels,
                  iconWidth: 23,
                  iconHeight: 23,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 공통 카드 위젯 (걸음 수, 심박수 등)
  Widget _healthCard({
    required String iconPath,
    required String title,
    required String value,
    required String sub,
    Color? subColor,
  }) {
    final isBpm = value.toLowerCase().contains('bpm');
    final split = isBpm ? value.split(' ') : [value];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Color(0xFF61D5AB),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 11),
        isBpm
            ? Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${split[0]} ',
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: 'bpm',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            )
            : Text(
              value,
              style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
        const SizedBox(height: 11),
        Text(
          sub,
          style: TextStyle(fontSize: 17, color: subColor ?? Colors.grey),
        ),
      ],
    );
  }

  // 차트 포함 메트릭 카드 (근무시간, 배달 건수 등)
  Widget _metricCardWithBarChart({
    required String iconPath,
    required String title,
    required String value,
    required String subtitle,
    required List<double> barHeights,
    required List<String> barLabels,
    Color? subtitleColor,
    double iconWidth = 20,
    double iconHeight = 20,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: iconWidth,
              height: iconHeight,
              colorFilter: const ColorFilter.mode(
                Color(0xFF61D5AB),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      height: -3,
                    ),
                  ),
                  const SizedBox(height: 15),
                  subtitle.contains("평균 대비")
                      ? Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: "평균 대비",
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xFF7B7B7B),
                                height: -3,
                              ),
                            ),
                            TextSpan(
                              text: subtitle.replaceFirst("평균 대비", ""),
                              style: TextStyle(
                                fontSize: 17,
                                color: subtitleColor ?? Colors.grey,
                                height: -3,
                              ),
                            ),
                          ],
                        ),
                      )
                      : Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 17,
                          color: subtitleColor ?? Colors.grey,
                          height: -3,
                        ),
                      ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(barHeights.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 23,
                        height: barHeights[index],
                        decoration: BoxDecoration(
                          color: const Color(0xFF61D5AB),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        barLabels[index],
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }
}
