import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'berhasil.dart';
import 'gagal.dart';
import 'service/auth_service/UpdatePass_service.dart';

class UpdatePassword extends StatefulWidget {
  final String ni;
  UpdatePassword({Key? key, required this.ni}) : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController repeatPassController = TextEditingController();
  bool isOldPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isRepeatPassVisible = false;

  Future<void> updatePassword(
      String oldPassword, String newPassword, String repeatPass) async {
    try {
      Map<String, dynamic> response = await UpdatePass_service().updatePass(
        ni: widget.ni,
        passwordLama: oldPassword,
        passwordBaru: newPassword,
        repeatPassword: repeatPass,
      );

      // Pastikan bahwa respons memiliki kunci 'status'
      if (response["status"] == false) {
        print("Update password failed: ${response["message"]}");

        // Navigasi ke halaman gagal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Gagal(ni: widget.ni),
          ),
        );
      } else {
        // Update password berhasil, diarahkan ke halman berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateBerhasil(ni: widget.ni),
          ),
        );
      }
    } catch (e) {
      // Pembaruan password gagal
      print("Error updating password: $e");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Gagal(ni: widget.ni),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    Text(
                      "Update Password",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 185,
                      child: Image.asset('assets/image/update.png'),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        "Password Lama",
                        style: TextStyle(
                          fontSize: 12,
                          decorationColor: Colors.grey[400],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: oldPasswordController,
                        obscureText: !isOldPasswordVisible,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 30, right: 5),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isOldPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: (Colors.grey[300])!,
                            ),
                            onPressed: () {
                              setState(() {
                                isOldPasswordVisible = !isOldPasswordVisible;
                              });
                            },
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              width: 3,
                              color: (Colors.grey[300])!,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: (Colors.grey[300])!,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        "Password Baru",
                        style: TextStyle(
                          fontSize: 12,
                          decorationColor: Colors.grey[400],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: newPasswordController,
                        obscureText: !isNewPasswordVisible,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 30, right: 5),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isNewPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: (Colors.grey[300])!,
                            ),
                            onPressed: () {
                              setState(() {
                                isNewPasswordVisible = !isNewPasswordVisible;
                              });
                            },
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              width: 3,
                              color: (Colors.grey[300])!,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: (Colors.grey[300])!,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        "Konfirmasi Password Baru",
                        style: TextStyle(
                          fontSize: 12,
                          decorationColor: Colors.grey[400],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: repeatPassController,
                        obscureText: !isRepeatPassVisible,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 30, right: 5),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isRepeatPassVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: (Colors.grey[300])!,
                            ),
                            onPressed: () {
                              setState(() {
                                isRepeatPassVisible = !isRepeatPassVisible;
                              });
                            },
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              width: 3,
                              color: (Colors.grey[300])!,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: (Colors.grey[300])!,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35.0),
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: ElevatedButton(
                          onPressed: () async {
                            String oldPassword = oldPasswordController.text;
                            String newPassword = newPasswordController.text;
                            String repeatPass = repeatPassController.text;

                            await updatePassword(
                                oldPassword, newPassword, repeatPass);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF333333),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          child: const Text("Update"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
