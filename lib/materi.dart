import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';
import 'service/materi_service/Materi_sercive.dart';
import 'materi_detail.dart';

class Materi extends StatelessWidget {
  final String ni;
  Materi({required this.ni});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MateriList(ni: ni),
    );
  }
}

class MateriList extends StatefulWidget {
  final String ni;
  MateriList({required this.ni});

  @override
  MateriController createState() => MateriController(ni: ni);
}

class MateriController extends State<MateriList> {
  final String ni;
  MateriController({required this.ni});

  List materiList = [];
  List filteredFiles = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    getMateriList();
    super.initState();
  }

  getMateriList() async {
    materiList = await Materi_service().getMateri();
    print(materiList);
    filteredFiles = List.from(materiList);
    setState(() {});
  }

  void filterMateriList(String query) {
    setState(() {
      filteredFiles = materiList
          .where((materi) =>
              materi["judulMateri"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
                  'Daftar Materi',
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
                onChanged: filterMateriList,
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
                itemBuilder: (BuildContext context, int index) {
                  var materis = filteredFiles[index];
                  return Card(
                    // color: Color(0xFFA3FFA5),
                    color: Color(0xFFD3FFD4),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        // color: Color(0xFF79CD7B),
                        color: Color.fromARGB(255, 163, 201, 163),
                        width: 2.0,
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
                                  materis["judulMateri"],
                                  style: GoogleFonts.sora(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              try {
                                // Panggil metode showPDF dari Materi_service untuk menampilkan PDF
                                await Materi_service().showPDF(
                                  context,
                                  materis["id_materi"].toString(),
                                  materis["judulMateri"]
                                      .toString(), // Pass judulMateri as a parameter
                                );
                              } catch (error) {
                                print('Error: $error');
                                // Tambahkan penanganan kesalahan sesuai kebutuhan
                              }
                            },
                          ),
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
