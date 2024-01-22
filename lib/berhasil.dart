import 'package:flutter/material.dart';
import 'login.dart';

class UpdateBerhasil extends StatelessWidget {
  const UpdateBerhasil({Key? key, required String ni}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(),
            ),
            SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Text(
                      "Password Berhasil di Perbarui",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                    Image.asset(
                      "assets/image/ceklist.png",
                      width: 100,
                      height: 150,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Login(), // Replace with your login page
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0x33333),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                      ),
                      child: Text("Selesai"),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
