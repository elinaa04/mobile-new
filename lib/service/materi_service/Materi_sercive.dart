import 'package:dio/dio.dart';
import 'package:mobile/materi_detail.dart';
import '../auth_service/Login_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Materi_service {
  // Metode untuk mendapatkan daftar materi
  Future<List<dynamic>> getMateri() async {
    var response = await Dio().get(
      "http://10.0.2.2:8000/api/daftarmateri",
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${Login_service.token}",
        },
      ),
    );
    Map<String, dynamic> obj = response.data;
    return obj["materis"];
  }

  // Metode untuk menampilkan atau mengakses file PDF sesuai dengan id_materi
  Future<void> showPDF(
      BuildContext context, String id_materi, String judulMateri) async {
    try {
      var response = await Dio().get(
        "http://10.0.2.2:8000/api/showmateri/$id_materi",
        options: Options(
          headers: {
            // "Content-Type": "text/html",
            "Authorization": "Bearer ${Login_service.token}",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "get,post,put,",
            "Access-Control-Allow-Headers":
                "Origin,X-Requested-With,Content-Type,Accept",
          },
        ),
      );

      Map<String, dynamic> materi = response.data?["materi"];
      String pdfUrl = materi?["pdf_url"];

      if (pdfUrl != null) {
        // Menunggu PDF selesai dibaca
        Completer<void> completer = Completer<void>();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MateriDetail(pdfUrl: pdfUrl, judulMateri: judulMateri),
          ),
        );
        completer.complete();
        await completer.future;
      } else {
        throw Exception("PDF URL is null");
      }
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menampilkan materi PDF."),
        ),
      );
    }
  }
}
