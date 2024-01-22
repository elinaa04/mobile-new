import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MateriDetail extends StatelessWidget {
  final String pdfUrl;
  final String judulMateri; // Tambahkan parameter judulMateri

  MateriDetail({required this.pdfUrl, required this.judulMateri});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judulMateri),
        backgroundColor: Color(0xFF79CD7B),
      ),
      body: SfPdfViewer.network(
        pdfUrl,
      ),
    );
  }
}
