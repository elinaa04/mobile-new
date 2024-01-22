import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'service/profil_service/Profil_service.dart';

class EditProfil extends StatefulWidget {
  final String ni;

  EditProfil({required this.ni});

  @override
  _EditProfilState createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  late TextEditingController namaLengkapController;
  late TextEditingController tanggalLahirController;
  late TextEditingController jenisKelaminController;
  late TextEditingController kelasController;

  late bool isNamaLengkapValid;
  late DateTime selectedDate;

  Future<void> editProfile(String namaLengkap, String tanggalLahir,
      String jenisKelamin, String kelas) async {
    try {
      Map<String, dynamic> profileData = await Profil_service().editProfil(
        ni: widget.ni,
        namaLengkap: namaLengkap,
        tanggalLahir: tanggalLahir,
        jenisKelamin: jenisKelamin,
      );
      if (profileData.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update profile. ${profileData['error']}"),
          ),
        );
      } else {
        print(
            "Before setState - namaLengkap: ${namaLengkapController.text}, tanggalLahir: ${tanggalLahirController.text}, jenisKelamin: ${jenisKelaminController.text}, kelas: ${kelasController.text}");

        await fetchDataAndUpdateView();

        // Kembali ke halaman profil dengan memberikan nilai true
        Navigator.pop(context, true);
      }
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error during profile update."),
        ),
      );
    }
  }

  // Function to validate namaLengkap
  bool isValidNamaLengkap(String input) {
    RegExp regex = RegExp(r"^[a-zA-Z\s]+$");
    return regex.hasMatch(input) && !input.contains(RegExp(r'\d'));
  }

  @override
  void initState() {
    super.initState();
    // Initialize the controllers and set the selected date to the current date
    selectedDate = DateTime.now();
    namaLengkapController = TextEditingController();
    tanggalLahirController = TextEditingController();
    jenisKelaminController = TextEditingController();
    kelasController = TextEditingController();
    isNamaLengkapValid = true;
    fetchDataAndUpdateView();

    // Format tanggal lahir sebelum menetapkannya ke controller
    tanggalLahirController.text = _formatDate(selectedDate.toString()) ?? '';
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

  Future<void> fetchDataAndUpdateView() async {
    try {
      Map<String, dynamic> profilData = await Profil_service().getProfil();

      setState(() {
        namaLengkapController.text = profilData['namaLengkap'] ?? '';
        tanggalLahirController.text =
            _formatDate(profilData['tanggalLahir']) ?? '';
        jenisKelaminController.text = profilData['jenisKelamin'] ?? '';
        kelasController.text = profilData['kelas'] ?? '';
      });
      print("ni: ${widget.ni}");
      print(
          "After setState - namaLengkap: ${namaLengkapController.text}, tanggalLahir: ${tanggalLahirController.text}, jenisKelamin: ${jenisKelaminController.text}, kelas: ${kelasController.text}");
    } catch (error) {
      print("Error during data fetch: $error");
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr != null) {
      DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
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
                            backgroundImage:
                                AssetImage('assets/image/gojo.jpg'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  height: 520,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          controller: TextEditingController(text: widget.ni),
                          readOnly: true, // Set readOnly to true
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
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          controller: namaLengkapController,
                          readOnly: false,
                          onChanged: (value) {
                            setState(() {
                              isNamaLengkapValid = isValidNamaLengkap(value);
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                              top: 5,
                              bottom: 5,
                              left: 20,
                              right: 5,
                            ),
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
                      // Area untuk menampilkan pesan kesalahan
                      if (!isNamaLengkapValid)
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Nama lengkap hanya boleh berisi huruf dan spasi.",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
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
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          controller: tanggalLahirController,
                          readOnly: false,
                          onTap: () {
                            _selectDate(context);
                          },
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
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: DropdownButtonFormField<String>(
                          value: jenisKelaminController.text.isNotEmpty
                              ? jenisKelaminController.text
                              : null,
                          items: ["Laki-laki", "Perempuan"]
                              .map((label) => DropdownMenuItem(
                                    child: Text(label),
                                    value: label,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              jenisKelaminController.text = value!;
                            });
                          },
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
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: DropdownButtonFormField<String>(
                          value: kelasController.text.isNotEmpty
                              ? kelasController.text
                              : null,
                          items: ["1", "2", "3", "4", "5", "6"]
                              .map((label) => DropdownMenuItem(
                                    child: Text(label),
                                    value: label,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              kelasController.text = value!;
                            });
                          },
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
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            String namaLengkap = namaLengkapController.text;
                            String tanggalLahir = tanggalLahirController.text;
                            String jenisKelamin = jenisKelaminController.text;
                            String kelas = kelasController.text;

                            // Periksa nama lengkap apakah sudah benar sebelum menyimpan
                            if (!isNamaLengkapValid) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Nama lengkap hanya boleh berisi huruf dan spasi."),
                                ),
                              );
                              return;
                            }

                            await editProfile(
                              namaLengkap,
                              tanggalLahir,
                              jenisKelamin,
                              kelas,
                            );
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF79CD7B),
                            minimumSize: Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
