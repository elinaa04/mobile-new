import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/latsol_detail.dart';
import 'package:mobile/service/latsol_service/Latsol_service.dart';
import 'home.dart';

class Latsol extends StatelessWidget {
  final String ni;
  Latsol({required this.ni});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LatsolList(ni: ni),
    );
  }
}

class LatsolList extends StatefulWidget {
  final String ni;
  LatsolList({required this.ni});
  @override
  LatsolController createState() => LatsolController(ni: ni);
}

class LatsolController extends State<LatsolList> {
  final String ni;
  LatsolController({required this.ni});

  List latsolList = [];
  List judulMateriUnik = [];
  List filteredFiles = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    getLatsolList();
    super.initState();
  }

  getLatsolList() async {
    latsolList = await Latsol_service().getLatsol();
    judulMateriUnik = getUniqueMateriTitles(latsolList);
    print(judulMateriUnik);
    filteredFiles = List.from(latsolList);
    setState(() {});
  }

  void filterLatsolList(String query) {
    setState(() {
      filteredFiles = latsolList
          .where((materi) =>
              materi["judulMateri"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  getUniqueMateriTitles(latihanSoalList) {
    Set<String> judulMateriUnik = Set<String>();
    for (var latihan in latihanSoalList) {
      judulMateriUnik.add(latihan['judulMateri']);
    }
    return judulMateriUnik.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(children: [
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
                'Daftar Latihan Soal',
                style: GoogleFonts.modak(
                  fontSize: 25,
                ),
              ),
            ]),
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
                onChanged: filterLatsolList,
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
                itemCount: judulMateriUnik.length,
                itemBuilder: (BuildContext context, int index) {
                  var judulMateri = judulMateriUnik[index];
                  return Card(
                    color: Color(0xFFD3FFD4),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Color.fromARGB(255, 163, 201, 163),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    judulMateri,
                                    style: GoogleFonts.sora(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LatsolView(
                                      ni: ni,
                                      judulMateri: judulMateri,
                                      latsolList: latsolList,
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
