import 'package:flutter/material.dart';
import 'package:mobile/home.dart';
import 'package:mobile/tampilanAwal.dart';
import 'editProfil.dart';
import 'service/auth_service/Logout_service.dart';
import 'service/profil_service/Profil_service.dart';
import 'updatePassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Profil extends StatefulWidget {
  final String ni;
  const Profil({super.key, required this.ni});

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  late TextEditingController namaLengkapController;
  late TextEditingController tanggalLahirController;
  late TextEditingController jenisKelaminController;
  late TextEditingController kelasController;

  late DateTime selectedDate;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    // Initialize the controllers
    namaLengkapController = TextEditingController();
    tanggalLahirController = TextEditingController();
    jenisKelaminController = TextEditingController();
    kelasController = TextEditingController();
    // Panggil _loadProfileData di initState untuk memuat data awal
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    print("Loading profile data...");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ni = widget.ni ?? prefs.getString('ni') ?? '';

    try {
      Map<String, dynamic> profileData = await Profil_service().getProfil();

      if (profileData.containsKey('error')) {
        // Handle the error case here
        print("Error from server: ${profileData['error']}");
      } else {
        print("Profile data from server: $profileData");

        print(
            "Before setState - namaLengkap: ${namaLengkapController.text}, tanggalLahir: ${tanggalLahirController.text}, jenisKelamin: ${jenisKelaminController.text}, kelas: ${kelasController.text}");

        setState(() {
          // Update the Text controllers to display the fetched data
          namaLengkapController.text = profileData['namaLengkap'] ?? '';
          // Format the date string
          String rawDate = profileData['tanggalLahir'] ?? '';
          if (rawDate.isNotEmpty) {
            try {
              DateTime parsedDate = DateTime.parse(rawDate);
              String formattedDate =
                  DateFormat('dd-MM-yyyy').format(parsedDate);
              tanggalLahirController.text = formattedDate;
            } catch (e) {
              print("Error parsing date: $e");
            }
          }
          jenisKelaminController.text = profileData['jenisKelamin'] ?? '';
          kelasController.text = profileData['kelas'] ?? '';
        });
        print("ni: ${widget.ni}");
        print(
            "After setState - namaLengkap: ${namaLengkapController.text}, tanggalLahir: ${tanggalLahirController.text}, jenisKelamin: ${jenisKelaminController.text}, kelas: ${kelasController.text}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  // Function to show date picker for tanggalLahir
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        tanggalLahirController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  // Function to format the date
  String _formatDate(String? dateStr) {
    if (dateStr != null) {
      DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Profil"),
          backgroundColor: Color(0xFF79CD7B),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfil(ni: widget.ni),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Text(
                      "Profil",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 100,
                      child: Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/image/gojo.jpg'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  height: 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bagian NISN
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "NISN",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800]!,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Bagian Border
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(text: widget.ni),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 20, right: 5),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.grey[300]!,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                      // Bagian Nama Lengkap
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Nama Lengkap",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800]!,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Bagian Border
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          readOnly: true,
                          controller: namaLengkapController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 20, right: 5),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.grey[300]!,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                      // Bagian Tanggal Lahir
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Tanggal Lahir",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800]!,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Bagian Border
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          readOnly: true,
                          controller: tanggalLahirController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 20, right: 5),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.grey[300]!,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                      // Bagian Jenis Kelamin
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Jenis Kelamin",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800]!,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Bagian Border
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          readOnly: true,
                          controller: jenisKelaminController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 20, right: 5),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.grey[300]!,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                      // Bagian Kelas
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Kelas",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800]!,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Bagian Border
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          readOnly: true,
                          controller: kelasController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 20, right: 5),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.grey[300]!,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                      // Bagian Ganti Password
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdatePassword(
                                  ni: '',
                                ),
                              ),
                            );
                          },
                          child: const Text("Ganti Password"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Color(0xFF79CD7B),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.exit_to_app),
              label: '',
            ),
          ],
          onTap: (index) async {
            setState(() {
              _currentIndex = index;
            });

            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(ni: widget.ni),
                  ),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profil(ni: widget.ni),
                  ),
                );
                break;
              case 2:
                await Logout_service.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TampilanAwal()),
                );
                break;
            }
          },
        ),
      ),
    );
  }
}
