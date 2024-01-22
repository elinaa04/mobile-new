import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:mobile/latsol.dart';
import 'package:mobile/materi.dart';
import 'profil.dart';
import 'surah.dart';

class Home extends StatelessWidget {
  final String ni;
  const Home({Key? key, required this.ni}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(ni: ni),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String ni;
  const HomeScreen({super.key, required this.ni});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Color(0xFF79CD7B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100), // Sudut kiri bawah
                bottomRight: Radius.circular(100), // Sudut kanan bawah
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 8, bottom: 1),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/image/profil.png'),
                  ),
                ),
                SizedBox(height: 1),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0, left: 0, right: 8, bottom: 0),
                        child: Text(
                          "Halo, Anda",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0, left: 0, right: 8, bottom: 20),
                        child: Text(
                          "Mau Belajar Apa Hari Ini?",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 0),
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    itemCount: 3,
                    controller: PageController(viewportFraction: 0.9),
                    itemBuilder: (context, index) {
                      String imagePath = 'assets/image/poto1.jpg';

                      if (index == 1) {
                        imagePath = 'assets/image/poto2.jpg';
                      } else if (index == 2) {
                        imagePath = 'assets/image/poto3.jpg';
                      }

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 3, bottom: 5),
                  child: Divider(
                    thickness: 1.8,
                  ),
                ),
              ],
            ),
          ),
          // Menu
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: GridView.count(
                crossAxisCount: 2,
                children: <Widget>[
                  //Materi
                  Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 8,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Materi(
                                    ni: widget.ni,
                                  )),
                        );
                      },
                      splashColor: Colors.green,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              'assets/image/buku.png',
                              width: 40,
                              height: 40,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Materi",
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Latihan Soal
                  Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 5,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Latsol(
                                    ni: widget.ni,
                                  )),
                        );
                      },
                      splashColor: Colors.green,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              'assets/image/latsoal.png',
                              width: 50,
                              height: 50,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Latihan Soal",
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Doa Doa
                  Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 5,
                    child: InkWell(
                      onTap: () {},
                      splashColor: Colors.green,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              'assets/image/doa-doa.png',
                              width: 50,
                              height: 50,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Doa - Doa",
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Al-Qur'an
                  Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 5,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Alquran(
                                    ni: widget.ni,
                                  )),
                        );
                      },
                      splashColor: Colors.green,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              'assets/image/Al-Quran.png',
                              width: 50,
                              height: 50,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Al-Qur'an",
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profil(ni: widget.ni),
                ),
              );
            case 2:
              break;
          }
        },
      ),
    );
  }
}
