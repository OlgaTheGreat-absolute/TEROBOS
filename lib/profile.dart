import 'package:flutter/material.dart';
import 'main.dart';
import 'statistic.dart';
import 'table.dart';

class TerobosProfile extends StatefulWidget {
  const TerobosProfile({super.key});

  @override
  State<TerobosProfile> createState() => _TerobosProfileState();
}

bool isFirstImage = true;

class _TerobosProfileState extends State<TerobosProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 300,
                  width: double.infinity, 
                  decoration: const BoxDecoration(
                    color: Color(0xFF0D5EA6), 
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(180),
                      bottomRight: Radius.circular(180),
                    ),
                  ),
                ),
                  Positioned(
                    top: 40,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Text('PROFILE IOT',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isFirstImage = !isFirstImage;
                              });
                            },
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: const Color(0xFF0D5EA6),
                              backgroundImage: AssetImage(
                                isFirstImage
                                    ? 'images/Terobos2.png'
                                    : 'images/Anomali.JPG',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            const Text(
              'TEROBOS',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Technopreneurship E-learning Robotik Skills',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),

            const SizedBox(height: 20),
            // About Me Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'About',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    textAlign: TextAlign.justify,
                    'TEROBOS merupakan sebuah perangkat Internet of Things (IoT) yang dirancang sebagai stasiun cuaca mini untuk melakukan pemantauan kondisi lingkungan secara real-time, terintegrasi, dan berbasis data. Sistem ini mengombinasikan beberapa sensor lingkungan utama, yaitu sensor cahaya, sensor hujan, sensor kelembapan, dan sensor jarak, yang bekerja secara simultan untuk menghasilkan informasi cuaca yang akurat dan relevan pada skala lokal.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            100,
          ), // Sesuaikan dengan kebutuhan Anda
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: const Color.fromARGB(255, 220, 220, 220),
              title: const Text(
                'CREDIT\nPAGE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  fontFamily: 'Arial',
                  letterSpacing: 4.0,
                  height: 0.0,
                ),
              ),
              content: Container(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 100, 100, 100),
                        blurRadius: 5,
                        offset: const Offset(3, 3),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20),

                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildContainerCredit(
                          'images/10.png',
                          'Asqi Syahrul A.',
                          'K3523020',
                        ),
                        _buildContainerCredit(
                          'images/28.png',
                          'Ananda Olga K.',
                          'K3523011',
                        ),
                        _buildContainerCredit(
                          'images/4.png',
                          'Ardika Muh I. R.',
                          'K3523017',
                        ),
                        _buildContainerCredit(
                          'images/7.png',
                          'Yusup C D.',
                          'K3523078',
                        ),
                        _buildContainerCredit(
                          'images/22.png',
                          'Reza Ahmad F.',
                          'K3523063',
                        ),
                        _buildContainerCredit(
                          'images/3.png',
                          'Widhi Sri B.',
                          'K3523075',
                        ),
                        _buildContainerCredit(
                          'images/26.png',
                          'Annisa Intan S.',
                          'K3523014',
                        ),
                        _buildContainerCredit(
                          'images/15.png',
                          'Ratna Anata Sari',
                          'K3523082',
                        ),
                        _buildContainerCredit(
                          'images/16.png',
                          'Nabila Kayla T. P.',
                          'K3523054',
                        ),
                        _buildContainerCredit(
                          'images/20.png',
                          'Vanesha Betha L.',
                          'K3523072',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'CLOSE',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: 'Arial',
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        backgroundColor: Colors.white,
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(
            Color.fromARGB(255, 100, 100, 100),
            BlendMode.srcIn,
          ),
          child: const Image(
            image: AssetImage('images/Terobos2.png'),
            width: 45,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF0D5EA6),
        shape: const CircularNotchedRectangle(),
        notchMargin: 2.0,
        child: SizedBox(
          height: 10.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TerobosMonitorScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.bar_chart, color: Colors.white),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => TerobosStatistic()),
                    (route) => false,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.table_rows, color: Colors.white),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Terobos()),
                    (route) => false,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => TerobosProfile()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildContainerCredit(String imagePath, String text, String subtext) {
  return Padding(
    padding: EdgeInsetsGeometry.only(bottom: 10),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    backgroundImage: AssetImage(imagePath),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  subtext,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
