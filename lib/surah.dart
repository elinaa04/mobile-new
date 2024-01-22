import 'package:flutter/material.dart';
import 'package:mobile/home.dart';
import 'surah_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class Surah {
  int nomor;
  String nama;
  String namaLatin;
  int jumlahAyat;
  String tempatTurun;
  String arti;
  String deskripsi;
  Map<String, String> audioFull;

  Surah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audioFull,
  });

  factory Surah.fromJson(Map<String, dynamic> json) => Surah(
        nomor: json["nomor"],
        nama: json["nama"],
        namaLatin: json["namaLatin"],
        jumlahAyat: json["jumlahAyat"],
        tempatTurun: json["tempatTurun"],
        arti: json["arti"],
        deskripsi: json["deskripsi"],
        audioFull: Map<String, String>.from(json["audioFull"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "nomor": nomor,
        "nama": nama,
        "namaLatin": namaLatin,
        "jumlahAyat": jumlahAyat,
        "tempatTurun": tempatTurun,
        "arti": arti,
        "deskripsi": deskripsi,
        "audioFull":
            Map.from(audioFull).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

class Alquran extends StatelessWidget {
  final String ni;
  Alquran({required this.ni});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AlquranHomePage(ni: ni), // mengganti kelas yang diinisiasi
    );
  }
}

class AlquranHomePage extends StatefulWidget {
  final String ni;
  AlquranHomePage({required this.ni});

  @override
  _AlquranHomePageState createState() => _AlquranHomePageState(ni: ni);
}

class _AlquranHomePageState extends State<AlquranHomePage> {
  final String ni;
  _AlquranHomePageState({required this.ni});

  List<Surah> surahList = [];
  List filteredFiles = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      sendApiRequest();
    });
  }

  void filterSurahList(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredFiles = List.from(surahList);
      } else {
        filteredFiles = surahList
            .where((surah) =>
                surah.nama.toLowerCase().contains(query.toLowerCase()) ||
                surah.namaLatin.toLowerCase().contains(query.toLowerCase()) ||
                surah.nama
                    .replaceAll('-', '')
                    .toLowerCase()
                    .contains(query.replaceAll('-', '').toLowerCase()) ||
                surah.namaLatin
                    .replaceAll('-', '')
                    .toLowerCase()
                    .contains(query.replaceAll('-', '').toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> sendApiRequest() async {
    try {
      final response =
          await http.get(Uri.parse('https://equran.id/api/v2/surat'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final surahs = data['data'] as List<dynamic>;

        setState(() {
          surahList =
              surahs.map<Surah>((surah) => Surah.fromJson(surah)).toList();
          filteredFiles = List.from(surahList);
        });
      } else {
        setState(() {
          surahList = [];
          filteredFiles = [];
        });
      }
    } catch (error) {
      print('Error in sendApiRequest: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2.0),
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
                          builder: (context) => Home(ni: widget.ni)),
                    );
                  },
                ),
                Text(
                  'Al-Quran',
                  style: GoogleFonts.modak(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              width: 500, // Tentukan lebar sesuai kebutuhan Anda
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Colors.white,
              ),
              child: TextField(
                controller: searchController,
                onChanged: filterSurahList,
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Search for files...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Color(0xFF79CD7B)),
                  ),
                  hintStyle: TextStyle(color: Colors.grey),
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: filteredFiles.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color.fromARGB(255, 212, 214, 212),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(0xFF79CD7B),
                            child: Text(
                              '${surahList[index].nomor}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${filteredFiles[index].namaLatin}',
                                style: GoogleFonts.sora(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                '${filteredFiles[index].nama}',
                                style: GoogleFonts.amiri(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 68, 84, 61),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${filteredFiles[index].tempatTurun}',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                '${filteredFiles[index].jumlahAyat} Ayat ',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SurahDetail(
                                  ni: ni,
                                  surah: filteredFiles[index],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
