import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'service/auth_service/Login_service.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String errorText = "";
  final TextEditingController niController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;
  bool showPassword = false;
  bool isLoading = false;

  // Fungsi untuk menampilkan dialog pesan error
  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Membuat instance dari LoginService
  final Login_service loginService = Login_service();

  @override
  void initState() {
    super.initState();
    _loadStoredValue();
  }

  // Load stored value from shared preferences
  _loadStoredValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedNi = prefs.getString('ni') ?? "";
    String storedPass = prefs.getString('password') ?? "";

    setState(() {
      niController.text = storedNi;
      passwordController.text = storedPass;
    });
  }

  // Save value to shared preferences
  _saveValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ni', niController.text);
    prefs.setString('password', passwordController.text);
    _loadStoredValue(); // Reload to update the displayed value
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
                      "Login",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 185,
                      child: Image.asset('assets/image/login.png'),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "NISN",
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
                        controller: niController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 30, right: 5),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              width: 2.0,
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
                        "Password",
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
                        controller: passwordController,
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 30, right: 5),
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey[300],
                            ),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
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
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value!;
                              });
                            },
                          ),
                          const Text("Remember me"),
                          const SizedBox(
                            width: 13,
                            height: 13,
                          ),
                          const Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35.0),
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });

                            String ni = niController.text;
                            String password = passwordController.text;
                            await Login_service.login(
                                ni: int.parse(ni), password: password);

                            setState(() {
                              isLoading = false;
                            });

                            // Memeriksa apakah login berhasil
                            if (Login_service.token != null) {
                              print('Login successful');
                              if (rememberMe == true) {
                                // Simpan nilai nisn dan password jika rememberMe aktif
                                _saveValue();
                              }
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home(ni: ni)),
                              );
                            } else {
                              // Panggil fungsi _showErrorDialog
                              _showErrorDialog(
                                context,
                                'Login Gagal. NISN atau Password salah',
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF333333),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          child: isLoading
                              ? CircularProgressIndicator()
                              : const Text("Login"),
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
