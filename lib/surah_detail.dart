import 'package:flutter/material.dart';
import 'surah.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class Ayat {
  int nomorAyat;
  String teksArab;
  String teksLatin;
  String teksIndonesia;
  Map<String, String> audio;

  Ayat({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
    required this.audio,
  });

  factory Ayat.fromJson(Map<String, dynamic> json) => Ayat(
        nomorAyat: json["nomorAyat"],
        teksArab: json["teksArab"],
        teksLatin: json["teksLatin"],
        teksIndonesia: json["teksIndonesia"],
        audio: Map<String, String>.from(json["audio"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "nomorAyat": nomorAyat,
        "teksArab": teksArab,
        "teksLatin": teksLatin,
        "teksIndonesia": teksIndonesia,
        "audio": Map.from(audio).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

class SurahDetail extends StatefulWidget {
  final Surah surah;
  final String ni;

  SurahDetail({required this.surah, required this.ni});

  @override
  _SurahDetailState createState() => _SurahDetailState(ni: ni);
}

class _SurahDetailState extends State<SurahDetail> {
  final String ni;
  _SurahDetailState({required this.ni});

  List<Ayat> ayahsList = [];

  Future<void> sendApiRequest(int surahNomor) async {
    final response =
        await http.get(Uri.parse('https://equran.id/api/v2/surat/$surahNomor'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final ayats = data['data']['ayat'] as List<dynamic>;

      List<Ayat> ayatList = ayats.map<Ayat>((ayat) {
        return Ayat.fromJson(ayat);
      }).toList();

      setState(() {
        ayahsList = ayatList;
      });
    } else {
      setState(() {
        ayahsList = [];
      });
      print('Error: ${response.statusCode}');
      print('Message: ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
    sendApiRequest(widget.surah.nomor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 15.0,
                      color: Color(0xFF333333),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AlquranHomePage(ni: ni)),
                      );
                    },
                  ),
                  Text(
                    'Surah ${widget.surah.nomor} - ${widget.surah.namaLatin}',
                    style: GoogleFonts.modak(
                      fontSize: 20,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: ayahsList.length,
                itemBuilder: (context, index) {
                  Ayat ayat = ayahsList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color.fromARGB(255, 212, 214, 212),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${ayat.nomorAyat}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color:
                                        const Color.fromARGB(255, 57, 56, 56)),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${ayat.teksArab}',
                                      style: GoogleFonts.amiri(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${ayat.teksLatin}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 102, 108, 99),
                                ),
                              ),
                              Container(
                                height: 1, // Tinggi garis
                                color: Color.fromARGB(
                                    255, 121, 155, 94), // Warna garis
                                margin: EdgeInsets.symmetric(
                                    vertical: 8), // Jarak vertikal dari teks
                              ),
                              Text(
                                '${ayat.teksIndonesia}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
