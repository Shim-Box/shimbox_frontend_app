import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimbox_app/pages/health/health_connect_service.dart';
import 'package:shimbox_app/pages/wearable/wearable.dart';

class HealthPage extends StatefulWidget {
  const HealthPage({super.key});

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  String _stepCount = '연동 필요';
  int? _weeklyAverage;
  bool _isLoadingStep = false;
  bool _isLoadingHeartRate = false;
  bool _isHealthConnected = false;

  final fatigueLevel = 'HIGH';
  final fatigueColor = const Color(0xFFFF8A8A);
  final fatigueMessage = '오늘은 좀 피곤하실 것 같네요.\n휴식이 필요해요!';

  final workTime = '8시간';
  final workTimeSub = '주간 평균 7시간';
  final workChartHeights = [77.0, 78.0, 55.0, 76.0, 71.0];
  final workChartLabels = ['월요일', '화요일', '수요일', '목요일', '금요일'];

  final deliveryCount = '300건';
  final deliverySub = '평균 대비 +10%';
  final deliveryChartHeights = [65.0, 60.0, 72.0, 55.0, 53.0];
  final deliveryChartLabels = ['월요일', '화요일', '수요일', '목요일', '금요일'];

  @override
  void initState() {
    super.initState();
    _checkHealthConnection();
  }

  Future<void> _checkHealthConnection() async {
    final prefs = await SharedPreferences.getInstance();
    final isConnected = prefs.getBool('health_connected') ?? false;
    setState(() {
      _isHealthConnected = isConnected;
    });
    if (isConnected) {
      _fetchStepCount();
    } else {
      setState(() {
        _stepCount = '연동 필요';
      });
    }
  }

  Future<void> _tryConnectHealthService() async {
    if (_isHealthConnected) {
      // 연동 완료 상태에서 버튼 클릭 시 해제 다이얼로그 표시
      final shouldDisconnect = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('연동 해제'),
              content: const Text('웨어러블 연동을 해제하시겠습니까?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('해제'),
                ),
              ],
            ),
      );

      if (shouldDisconnect == true) {
        await HealthConnectService.disconnect();
        setState(() {
          _isHealthConnected = false;
          _stepCount = '연동 필요';
          _weeklyAverage = null;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('웨어러블 연동이 해제되었습니다.')));
      }
      return;
    }

    // 연동이 안 된 경우 WearablePage로 이동
    setState(() {
      _isLoadingStep = true; // 연동 시도 중 로딩 시작
    });
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const WearablePage()),
    );
    setState(() {
      _isLoadingStep = false; // 연동 시도 후 로딩 종료
    });

    if (result == true) {
      setState(() {
        _isHealthConnected = true;
        _stepCount = '...';
      });
      _fetchStepCount();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('헬스 서비스 연동이 취소되었습니다.')));
    }
  }

  Future<void> _fetchStepCount() async {
    setState(() {
      _isLoadingStep = true;
      _weeklyAverage = null;
      _stepCount = '...';
    });

    try {
      final steps = await HealthConnectService.getPast7DaysSteps();
      final nonZero = steps.where((e) => e > 0).toList();
      final average =
          nonZero.isNotEmpty
              ? (nonZero.reduce((a, b) => a + b) / nonZero.length).round()
              : 0;
      final today = steps.isNotEmpty ? steps.last : 0;

      setState(() {
        _stepCount = today.toString();
        _weeklyAverage = average;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('걸음 수 가져오기 실패: $e')));
      setState(() {
        _stepCount = '오류';
        _weeklyAverage = null;
      });
    } finally {
      setState(() => _isLoadingStep = false);
    }
  }

  Future<void> _fetchHeartRate() async {
    setState(() {
      _isLoadingHeartRate = true;
    });
    try {
      // TODO: HealthConnectService에서 심박수 데이터를 가져오는 로직 추가
      // 예: final heartRate = await HealthConnectService.getHeartRate();
      setState(() {
        // TODO: 심박수 데이터 업데이트
        // 예: _heartRate = heartRate.toString();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('심박수 가져오기 실패: $e')));
    } finally {
      setState(() => _isLoadingHeartRate = false);
    }
  }

  String _formattedDate() {
    final now = DateTime.now();
    final weekdayKor = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    final formatted = DateFormat('yy.MM.dd').format(now);
    return '$formatted ${weekdayKor[now.weekday - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                Row(
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
                        const Text(
                          '홍길동님의 건강 리포트',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: _tryConnectHealthService,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(40, 40),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/health/wearable.png',
                            width: 40,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isHealthConnected ? '연동 완료' : '웨어러블\n연동',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                            '예상 피로도',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          Text(
                            fatigueLevel,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: _healthCard(
                        iconPath: 'assets/images/health/chart.svg',
                        title: '걸음 수',
                        value: _isLoadingStep ? '...' : _stepCount,
                        sub:
                            _isHealthConnected
                                ? (_weeklyAverage != null
                                    ? '주간 평균 $_weeklyAverage보'
                                    : '평균 계산 중...')
                                : '연동 필요',
                        subColor:
                            _isHealthConnected ? null : const Color(0xFF61D5AB),
                        isLoading: _isLoadingStep,
                        onRefresh: _isHealthConnected ? _fetchStepCount : null,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 68,
                      color: const Color(0xFFE3E3E3),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    Expanded(
                      child: _healthCard(
                        iconPath: 'assets/images/health/heart.svg',
                        title: '심박수',
                        value: _isHealthConnected ? '미연동' : '연동 필요',
                        sub: '연동 필요',
                        subColor: const Color(0xFF61D5AB),
                        isLoading: _isLoadingHeartRate,
                        onRefresh: _isHealthConnected ? _fetchHeartRate : null,
                      ),
                    ),
                  ],
                ),
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

  Widget _healthCard({
    required String iconPath,
    required String title,
    required String value,
    required String sub,
    Color? subColor,
    bool isLoading = false,
    VoidCallback? onRefresh,
  }) {
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
            if (onRefresh != null)
              IconButton(
                icon: Image.asset('assets/images/health/reload.png', width: 15),
                onPressed: isLoading ? null : onRefresh,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
          ],
        ),
        const SizedBox(height: 11),
        const SizedBox(height: 11),
        isLoading
            ? const CircularProgressIndicator(color: Color(0xFF61D5AB))
            : Text(
              value,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
        const SizedBox(height: 11),
        Text(
          sub,
          style: TextStyle(fontSize: 17, color: subColor ?? Colors.grey),
        ),
      ],
    );
  }

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
