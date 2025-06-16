// survey_module.dart

import 'package:flutter/material.dart';

class SurveyModule extends StatefulWidget {
  final void Function(String route) onClose;
  final void Function(String finish1, String finish2, String finish3) onSubmit;

  const SurveyModule({required this.onClose, required this.onSubmit});

  @override
  State<SurveyModule> createState() => _SurveyModuleState();
}

class _SurveyModuleState extends State<SurveyModule> {
  int? q1, q2, q3;

  final List<String> options1 = ['적었다', '비슷했다', '많았다'];
  final List<String> options2 = ['전혀 아니다', '약간 그렇다', '매우 그렇다'];
  final List<String> options3 = ['적게', '평소대로', '더 많이'];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.5),
      child: Align(
        alignment: Alignment(0, 0.4),
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
                ),
                SizedBox(height: 16),
                _buildQuestion(
                  'Q. 오늘 배송 물량은 평소보다 어땠나요?',
                  options1,
                  q1,
                  (val) => setState(() => q1 = val),
                ),
                _buildDivider(),
                _buildQuestion(
                  'Q. 오늘 배송 중 몸에 무리가 갔다고 느끼셨나요?',
                  options2,
                  q2,
                  (val) => setState(() => q2 = val),
                ),
                _buildDivider(),
                _buildQuestion(
                  'Q. 내일 물량 배정을 어떻게 받고 싶으신가요?',
                  options3,
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
                      if (q1 == null || q2 == null || q3 == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('모든 문항에 응답해주세요.')),
                        );
                        return;
                      }
                      widget.onSubmit(
                        options1[q1!],
                        options2[q2!],
                        options3[q3!],
                      );
                    },
                    child: Text(
                      '제출',
                      style: TextStyle(
                        fontSize: 15,
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
    );
  }

  Widget _buildDivider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Divider(thickness: 1, color: Color(0xFFEDEDED)),
  );

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
                width: 95,
                height: 35,
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
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  ),
                  child: Text(
                    options[index],
                    style: TextStyle(fontSize: 12),
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
