import 'package:dio/dio.dart';

class Login_service {
  static String? token;
  static login({required int ni, required String password}) async {
    var response = await Dio().post("http://10.0.2.2:8000/api/loginSiswa",
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        data: {
          "ni": ni,
          "password": password,
        });
    Map obj = response.data;
    if (obj.containsKey("status") && obj["status"] == true) {
      Map<String, dynamic> accessToken = obj["access_token"];
      if (accessToken.containsKey("plainTextToken")) {
        token = accessToken["plainTextToken"];
      } else {
        print('Error: Invalid response structure. Token not found.');
      }
    } else {
      print('Error: Login failed. ${obj["message"]}');
    }
  }
}
