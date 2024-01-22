import 'package:dio/dio.dart';
import '../auth_service/Login_service.dart';

class Nilai_service {
  saveNilai(int idLatihan, double nilai, String ni) async {
    try {
      var response = await Dio().post(
        "http://10.0.2.2:8000/api/savenilai",
        data: {
          "id_latihan": idLatihan,
          "nilai": nilai,
          "ni": ni,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${Login_service.token}",
          },
        ),
      );

      // Handle the response as needed
      print(response.data);
    } catch (error) {
      // Handle errors
      print("Error saving nilai: $error");
    }
  }
}
