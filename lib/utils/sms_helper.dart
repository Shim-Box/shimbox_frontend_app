import 'package:url_launcher/url_launcher.dart';

Future<void> sendSms(String phoneNumber, String message) async {
  final smsUri = Uri.parse(
    'sms:$phoneNumber?body=${Uri.encodeComponent(message)}',
  );
  if (await canLaunchUrl(smsUri)) {
    await launchUrl(smsUri);
  } else {
    throw 'SMS 전송 실패';
  }
}
