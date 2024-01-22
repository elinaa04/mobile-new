import 'dart:convert';
import 'package:dio/dio.dart';
import '../auth_service/Login_service.dart';

class Profil_service {
  getProfil() async {
    var response = await Dio().get(
      "http://10.0.2.2:8000/api/profil",
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${Login_service.token}",
        },
      ),
    );
    Map obj = response.data;
    return obj["data"];
  }

  editProfil({
    required String ni,
    String? namaLengkap,
    String? tanggalLahir,
    String? jenisKelamin,
  }) async {
    var response = await Dio().put(
      "http://10.0.2.2:8000/api/update/$ni",
      options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Login_service.token}",
      }),
      data: {
        "namaLengkap": namaLengkap,
        "tanggalLahir": tanggalLahir,
        "jenisKelamin": jenisKelamin,
      },
    );
    print('test: ${response.statusCode}');
    Map obj = response.data;
    return obj["data"];
  }
}
