import 'package:dio/dio.dart';
import 'Login_service.dart';

class UpdatePass_service {
  updatePass({
    required String ni,
    required String passwordLama,
    required String passwordBaru,
    required String repeatPassword,
  }) async {
    var response = await Dio().put(
      "http://localhost:8000/api/updatePassword",
      options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Login_service.token}",
      }),
      data: {
        "passwordLama": passwordLama,
        "passwordBaru": passwordBaru,
        "repeatPassword": repeatPassword,
      },
    );
    Map obj = response.data;
    return obj["data"];
  }
}
