class UserData {
  static String? name;
  static String? email;
  static String? token;
  static String? residence;

  static int? stepCount;
  static int? heartRate;
  static String conditionStatus = '좋음';

  static void clear() {
    name = null;
    email = null;
    token = null;
    residence = null;

    // 건강 데이터도 초기화
    stepCount = null;
    heartRate = null;
    conditionStatus = '좋음';
  }
}
