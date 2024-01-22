import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'latsol.dart';
import 'service/latsol_service/Latsol_service.dart';

class LatsolView extends StatelessWidget {
  final String ni;
  final String judulMateri;
  final List latsolList;
  LatsolView(
      {required this.ni, required this.judulMateri, required this.latsolList});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LatsolDetail(
        ni: ni,
        judulMateri: judulMateri,
        latsolList: latsolList,
      ),
    );
  }
}

class LatsolDetail extends StatefulWidget {
  final String ni;
  final String judulMateri;
  final List latsolList;

  LatsolDetail(
      {required this.ni, required this.judulMateri, required this.latsolList});

  @override
  LatsolController createState() =>
      LatsolController(ni: ni, judulMateri: judulMateri);
}

class LatsolController extends State<LatsolDetail> {
  final String ni;
  final String judulMateri;
  LatsolController({required this.ni, required this.judulMateri});

  List latsolList = [];
  int indeksSoalSaatIni = 0;
  Map<int, String?> selectedValue = {};
  Color selectedColor = const Color(0xFF5B42F7);
  Color unselectedColor1 = const Color(0xFF79CD7B);
  Color unselectedColor2 = const Color(0xFF78E77A);
  Color unselectedColor3 = const Color(0xFFA3FFA5);
  Color unselectedColor4 = const Color(0xFFD3FFD4);
  double totalNilai = 0;
  List filteredQuestions = [];

  void onRadioChanged(String? nilai, String kolom) {
    print("Pilihan diubah menjadi: $nilai");
    setState(() {
      selectedValue[indeksSoalSaatIni] = kolom;
    });
    print("Selected Value: $selectedValue");
  }

  @override
  void initState() {
    super.initState();
    getLatsolList();
  }

  getSoalByJudul(String judul) {
    return widget.latsolList
        .where((latihanSoal) => latihanSoal['judulMateri'] == judul)
        .toList();
  }

  getLatsolList() async {
    latsolList = await Latsol_service().getLatsol();
    setState(() {
      filteredQuestions = getSoalByJudul(widget.judulMateri);
      print(filteredQuestions);
    });
  }

  void nextQuestion() {
    setState(() {
      if (indeksSoalSaatIni < filteredQuestions.length - 1) {
        hitungNilai(); // Memanggil hitungNilai sebelum meningkatkan indeksSoalSaatIni
        indeksSoalSaatIni++;
      } else {
        hitungNilai(); // Memanggil hitungNilai untuk pertanyaan terakhir
        print("Latihan selesai!");
        _showDialog(
          context,
          'Latihan Telah Selesai! Terimakasih...',
        );
        return;
      }
    });
  }

  hitungNilai() {
    if (selectedValue[indeksSoalSaatIni] != null) {
      String? jawabanBenar = filteredQuestions[indeksSoalSaatIni]['jawaban'];
      String? jawabanUser = selectedValue[indeksSoalSaatIni];
      if (jawabanBenar == jawabanUser) {
        totalNilai += double.parse(
            filteredQuestions[indeksSoalSaatIni]['nilai'].toString());
      }
    }
  }

  _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ujian Selesai'),
          content: Text(message),
          actions: <Widget>[
            Column(
              children: [
                Center(
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFF79CD7B),
                        width: 2.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$totalNilai',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Latsol(ni: ni)),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(2.0),
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
                        MaterialPageRoute(builder: (context) => Latsol(ni: ni)),
                      );
                    },
                  ),
                  Text(
                    'Latihan Soal',
                    style: GoogleFonts.modak(
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  Text(
                    'Nomor: ${indeksSoalSaatIni + 1}/${filteredQuestions.length}',
                    style: GoogleFonts.sora(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 50.0, left: 35.0, right: 35.0, bottom: 3.0),
              child: Column(
                children: [
                  Text(
                    filteredQuestions.isNotEmpty &&
                            indeksSoalSaatIni < filteredQuestions.length
                        ? filteredQuestions[indeksSoalSaatIni]['isiLatihanSoal']
                        : 'No question available',
                    style: GoogleFonts.miriamLibre(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 80),
                  const SizedBox(height: 80),
                  GestureDetector(
                    key: UniqueKey(),
                    onTap: () {
                      onRadioChanged(
                        filteredQuestions.isNotEmpty &&
                                indeksSoalSaatIni < filteredQuestions.length
                            ? filteredQuestions[indeksSoalSaatIni]['pilihan1']
                            : 'No question available',
                        // widget.latsolList[indeksSoalSaatIni]['pilihan1'],
                        'pilihan1',
                      );
                    },
                    child: Container(
                      width: screenWidth * 0.8,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: selectedValue[indeksSoalSaatIni] == 'pilihan1'
                            ? selectedColor
                            : unselectedColor1,
                      ),
                      child: Text(
                        filteredQuestions.isNotEmpty &&
                                indeksSoalSaatIni < filteredQuestions.length
                            ? filteredQuestions[indeksSoalSaatIni]['pilihan1']
                            : 'No question available',
                        // widget.latsolList[indeksSoalSaatIni]['pilihan1'],
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    key: UniqueKey(),
                    onTap: () {
                      onRadioChanged(
                        filteredQuestions.isNotEmpty &&
                                indeksSoalSaatIni < filteredQuestions.length
                            ? filteredQuestions[indeksSoalSaatIni]['pilihan2']
                            : 'No question available',
                        // widget.latsolList[indeksSoalSaatIni]['pilihan2'],
                        'pilihan2',
                      );
                    },
                    child: Container(
                      width: screenWidth * 0.8,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: selectedValue[indeksSoalSaatIni] == 'pilihan2'
                            ? selectedColor
                            : unselectedColor2,
                      ),
                      child: Text(
                        filteredQuestions.isNotEmpty &&
                                indeksSoalSaatIni < filteredQuestions.length
                            ? filteredQuestions[indeksSoalSaatIni]['pilihan2']
                            : 'No question available',
                        // widget.latsolList[indeksSoalSaatIni]['pilihan2'],
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    key: UniqueKey(),
                    onTap: () {
                      onRadioChanged(
                        filteredQuestions.isNotEmpty &&
                                indeksSoalSaatIni < filteredQuestions.length
                            ? filteredQuestions[indeksSoalSaatIni]['pilihan3']
                            : 'No question available',
                        // widget.latsolList[indeksSoalSaatIni]['pilihan3'],
                        'pilihan3',
                      );
                    },
                    child: Container(
                      width: screenWidth * 0.8,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: selectedValue[indeksSoalSaatIni] == 'pilihan3'
                            ? selectedColor
                            : unselectedColor3,
                      ),
                      child: Text(
                        filteredQuestions.isNotEmpty &&
                                indeksSoalSaatIni < filteredQuestions.length
                            ? filteredQuestions[indeksSoalSaatIni]['pilihan3']
                            : 'No question available',
                        // widget.latsolList[indeksSoalSaatIni]['pilihan3'],
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    key: UniqueKey(),
                    onTap: () {
                      onRadioChanged(
                        filteredQuestions.isNotEmpty &&
                                indeksSoalSaatIni < filteredQuestions.length
                            ? filteredQuestions[indeksSoalSaatIni]['pilihan4']
                            : 'No question available',
                        // widget.latsolList[indeksSoalSaatIni]['pilihan4'],
                        'pilihan4',
                      );
                    },
                    child: Container(
                      width: screenWidth * 0.8,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: selectedValue[indeksSoalSaatIni] == 'pilihan4'
                            ? selectedColor
                            : unselectedColor4,
                      ),
                      child: Text(
                        filteredQuestions.isNotEmpty &&
                                indeksSoalSaatIni < filteredQuestions.length
                            ? filteredQuestions[indeksSoalSaatIni]['pilihan4']
                            : 'No question available',
                        // widget.latsolList[indeksSoalSaatIni]['pilihan4'],
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              nextQuestion();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF79CD7B),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                            child: const Text("Selanjutnya"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
