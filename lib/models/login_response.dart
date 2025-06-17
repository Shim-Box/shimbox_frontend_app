class LoginResponse {
  final UserData data;
  final String message;
  final int statusCode;

  LoginResponse({
    required this.data,
    required this.message,
    required this.statusCode,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      data: UserData.fromJson(json['data']),
      message: json['message'],
      statusCode: json['statusCode'],
    );
  }
}

class UserData {
  final String name;
  final bool approved;
  final String accessToken;
  final String refreshToken;
  final String residence;

  UserData({
    required this.name,
    required this.approved,
    required this.accessToken,
    required this.refreshToken,
    required this.residence,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      approved: json['approved'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      residence: json['residence'] ?? '',
    );
  }
}
