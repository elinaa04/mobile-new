import 'package:dio/dio.dart';
import 'Login_service.dart';

class Logout_service {
  static Future<void> logout() async {
    try {
      var response = await Dio().post("http://10.0.2.2:8000/api/logout",
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${Login_service.token}",
            },
          ));

      Map obj = response.data;
      if (obj.containsKey("message")) {
        print('Logout successful: ${obj["message"]}');
      } else {
        print('Error: Invalid response structure. Message not found.');
      }
    } catch (error) {
      print('Error during logout: $error');
    }
  }
}
