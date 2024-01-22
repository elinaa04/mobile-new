import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Login.dart';

class TampilanAwal extends StatelessWidget {
  const TampilanAwal({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Container(
              height: 250,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Center(
                      child: Text(
                        "Welcome",
                        style: GoogleFonts.modak(
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "To",
                    style: GoogleFonts.modak(
                      fontSize: 40,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/image/logo.png',
                      height: 195,
                      width: 195,
                    ),
                  ),
                  SizedBox(height: 54),
                  Text(
                    "IslamiQ",
                    style: GoogleFonts.modak(
                      fontSize: 50,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 70,
              width: 70,
              decoration: const ShapeDecoration(
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_forward),
                iconSize: 29,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
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
