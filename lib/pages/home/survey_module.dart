import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shimbox_app/controllers/bottom_nav_controller.dart';

class SurveyModule extends StatefulWidget {
  final void Function(String route) onClose;
  const SurveyModule({required this.onClose});

  @override
  State<SurveyModule> createState() => _SurveyModuleState();
}

class _SurveyModuleState extends State<SurveyModule> {
  int? q1, q2, q3;

  // 버튼 사이즈 및 텍스트 설정
  final double choiceButtonWidth = 95;
  final double choiceButtonHeight = 35;
  final double choiceButtonFontSize = 12;
  final EdgeInsets choiceButtonPadding = EdgeInsets.symmetric(
    vertical: 4,
    horizontal: 6,
  );

  final double submitFontSize = 15;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.5),
      // child: Center(
      child: Align(
        alignment: Alignment(0, 0.4), // 0.0 = 정중앙, 1.0 = 맨 아래
        child: Container(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 26, vertical: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '[ 배송 마무리 ]',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  _buildQuestion(
                    'Q. 오늘 배송 물량은 평소보다 어땠나요?',
                    ['적었다', '비슷했다', '많았다'],
                    q1,
                    (val) => setState(() => q1 = val),
                  ),
                  _buildDivider(),
                  _buildQuestion(
                    'Q. 오늘 배송 중 몸에 무리가 갔다고 느끼셨나요?',
                    ['전혀 아니다', '약간 그렇다', '매우 그렇다'],
                    q2,
                    (val) => setState(() => q2 = val),
                  ),
                  _buildDivider(),
                  _buildQuestion(
                    'Q. 내일 물량 배정을 어떻게 받고 싶으신가요?',
                    ['적게', '평소대로', '더 많이'],
                    q3,
                    (val) => setState(() => q3 = val),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 302,
                    height: 42,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF61D5AB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        // Get.find<BottomNavController>().changeBottomNav(0);
                        widget.onClose('');
                      },

                      child: Text(
                        '제출',
                        style: TextStyle(
                          fontSize: submitFontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Divider(thickness: 1, color: Color(0xFFEDEDED)),
    );
  }

  Widget _buildQuestion(
    String question,
    List<String> options,
    int? groupVal,
    void Function(int) onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Q. ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF61D5AB),
                  ),
                ),
                TextSpan(
                  text: question.replaceFirst('Q. ', ''),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(options.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: SizedBox(
                width: choiceButtonWidth,
                height: choiceButtonHeight,
                child: OutlinedButton(
                  onPressed: () => onSelected(index),
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        groupVal == index ? Color(0xFF61D5AB) : Colors.white,
                    foregroundColor:
                        groupVal == index ? Colors.white : Colors.black,
                    side: BorderSide(color: Color(0xFFDFE0DF)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: choiceButtonPadding,
                  ),
                  child: Text(
                    options[index],
                    style: TextStyle(fontSize: choiceButtonFontSize),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 4),
      ],
    );
  }
}
