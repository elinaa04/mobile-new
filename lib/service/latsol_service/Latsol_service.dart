import 'package:dio/dio.dart';
import '../auth_service/Login_service.dart';

class Latsol_service {
  getLatsol() async {
    var response = await Dio().get(
      "http://10.0.2.2:8000/api/daftarlatsol",
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${Login_service.token}",
        },
      ),
    );
    Map obj = response.data;
    return obj["latsol"];
  }
}
