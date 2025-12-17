import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart'; 
import 'main.dart';
import 'profile.dart';
import 'statistic.dart';

class Terobos extends StatefulWidget {
  const Terobos({super.key});

  @override
  State<Terobos> createState() => _TerobosState();
}

class _TerobosState extends State<Terobos> {
  final _db = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> sensorRecords = [];
  Timer? _timer;

  String lokasiSekarang = "Mengambil lokasi...";

  @override
  void initState() {
    super.initState();
    _startAutoRecording();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Jalankan perekaman otomatis tiap 1 menit
  void _startAutoRecording() {
    _recordSensorData(); // langsung jalankan sekali di awal
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _recordSensorData();
    });
  }

  /// Ambil lokasi pengguna dengan Geolocator
  Future<String> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return "Lokasi tidak aktif";

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return "Izin lokasi ditolak";
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return "Akses lokasi ditolak permanen";
    }

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return "Lat: ${pos.latitude.toStringAsFixed(4)}, Lon: ${pos.longitude.toStringAsFixed(4)}";
  }

  /// Rekam data sensor dari Firebase + lokasi terbaru
  Future<void> _recordSensorData() async {
    try {
      // Ambil lokasi terbaru
      String lokasiBaru = await _getCurrentLocation();

      // Ambil data sensor dari Firebase
      final snapshot = await _db.child("sensor").get();
      final data = snapshot.value as Map?;

      if (data != null) {
        final now = DateTime.now();
        final record = {
          "time": DateFormat("dd/MM/yyyy HH:mm").format(now),
          "lokasi": lokasiBaru,
          "suhu": double.tryParse(data["suhu"].toString()) ?? 0,
          "kelembapan": double.tryParse(data["kelembaban"].toString()) ?? 0,
          "cahaya": data["statusCahaya"] ?? "-",
          "hujan": data["statusHujan"] ?? "-",
        };

        setState(() {
          lokasiSekarang = lokasiBaru;
          sensorRecords.insert(0, record);
          if (sensorRecords.length > 30) sensorRecords.removeLast();
        });
      }
    } catch (e) {
      debugPrint("Error merekam data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'TEROBOS MONITOR',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF0D5EA6),
        elevation: 4,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF0D5EA6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tabel Data Sensor",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Icon(Icons.location_on, color: Colors.white),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Lokasi saat ini: $lokasiSekarang",
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[800]),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      border: TableBorder.symmetric(
                        inside: BorderSide(color: Colors.grey.shade300),
                      ),
                      headingRowColor:
                          WidgetStateProperty.all(Colors.grey.shade200),
                      headingTextStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      dataTextStyle: GoogleFonts.poppins(fontSize: 14,color: Colors.black87),
                      columns: const [
                        DataColumn(label: Text("Waktu")),
                        DataColumn(label: Text("Lokasi")),
                        DataColumn(label: Text("Suhu (°C)")),
                        DataColumn(label: Text("Kelembapan (%)")),
                        DataColumn(label: Text("Cahaya")),
                        DataColumn(label: Text("Hujan")),
                      ],
                      rows: sensorRecords.map((record) {
                        return DataRow(
                          color: WidgetStatePropertyAll(
                            record["hujan"] == "Hujan"
                                ? Colors.lightBlue.withOpacity(0.1)
                                : Colors.white,
                          ),
                          cells: [
                            DataCell(Text(record["time"] ?? "-")),
                            DataCell(Text(record["lokasi"] ?? "-")),
                            DataCell(Text(
                              record["suhu"].toStringAsFixed(1),
                              style: TextStyle(
                                  color: record["suhu"] > 35
                                      ? Colors.redAccent
                                      : Colors.black),
                            )),
                            DataCell(Text(
                              record["kelembapan"].toStringAsFixed(1),
                              style: TextStyle(
                                  color: record["kelembapan"] < 40
                                      ? Colors.orange
                                      : Colors.green),
                            )),
                            DataCell(Row(
                              children: [
                                Icon(
                                  record["cahaya"] == "Terang"
                                      ? Icons.wb_sunny
                                      : Icons.nightlight_round,
                                  color: record["cahaya"] == "Terang"
                                      ? Colors.amber
                                      : Colors.grey,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(record["cahaya"]),
                              ],
                            )),
                            DataCell(Row(
                              children: [
                                Icon(
                                  record["hujan"] == "Hujan"
                                      ? Icons.umbrella
                                      : Icons.cloud_queue,
                                  color: record["hujan"] == "Hujan"
                                      ? Colors.blueAccent
                                      : Colors.grey,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(record["hujan"]),
                              ],
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                        'K3523020'),
                        _buildContainerCredit(
                        'images/28.png',
                        'Ananda Olga K.', 
                        'K3523011'),
                        _buildContainerCredit(
                        'images/4.png',
                        'Ardika Muh I. R.', 
                        'K3523017'),
                        _buildContainerCredit(
                        'images/7.png',
                        'Yusup C D.', 
                        'K3523078'),
                        _buildContainerCredit(
                        'images/22.png',
                        'Reza Ahmad F.', 
                        'K3523063'),
                        _buildContainerCredit(
                        'images/3.png',
                        'Widhi Sri B.', 
                        'K3523075'),
                        _buildContainerCredit(
                        'images/26.png',
                        'Annisa Intan S.', 
                        'K3523014'),
                        _buildContainerCredit(
                        'images/15.png',
                        'Ratna Anata Sari', 
                        'K3523082'),
                        _buildContainerCredit(
                        'images/16.png',
                        'Nabila Kayla T. P.', 
                        'K3523054'),
                        _buildContainerCredit(
                        'images/20.png',
                        'Vanesha Betha L.', 
                        'K3523072'),
                  ],
                )),
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
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) => const TerobosMonitorScreen()),
                    (route) => false,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.bar_chart, color: Colors.white),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) => const TerobosStatistic()),
                    (route) => false,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.table_rows, color: Colors.white),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) => const Terobos()),
                    (route) => false,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) => const TerobosProfile()),
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
                children: [Text(text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ), Text(subtext,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }