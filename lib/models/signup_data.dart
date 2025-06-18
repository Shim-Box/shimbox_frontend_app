// lib/models/signup_data.dart

class SignupData {
  String? email;
  String? password;
  String? name;
  String? birth;
  String? phoneNumber;
  String? residence;
  int? height;
  int? weight;
  String? licenseImage;
  String? career;
  String? averageWorking;
  String? averageDelivery;
  String? bloodPressure;

  Map<String, dynamic> toJson() {
    final json = {
      "email": email,
      "password": password,
      "name": name,
      "birth": birth,
      "phoneNumber": phoneNumber,
      "residence": residence,
      "height": height,
      "weight": weight,
      "licenseImage": licenseImage,
      "career": career,
      "averageWorking": averageWorking,
      "averageDelivery": averageDelivery,
      "bloodPressure": bloodPressure,
    };

    if (career == '초보자') {
      json.remove('averageWorking');
      json.remove('averageDelivery');
    }

    return json;
  }

  // fromJson 메서드 추가
  void fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    name = json['name'];
    birth = json['birth'];
    phoneNumber = json['phoneNumber'];
    residence = json['residence'];
    height = json['height'];
    weight = json['weight'];
    licenseImage = json['licenseImage'];
    career = json['career'];
    averageWorking = json['averageWorking'];
    averageDelivery = json['averageDelivery'];
    bloodPressure = json['bloodPressure'];
  }
}

final SignupData signupData = SignupData(); // 전역에서 import해서 쓸 수 있도록
