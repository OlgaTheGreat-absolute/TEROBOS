import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'profile.dart';
import 'table.dart';

class TerobosStatistic extends StatefulWidget {
  const TerobosStatistic({super.key});

  @override
  State<TerobosStatistic> createState() => _TerobosStatisticState();
}

class _TerobosStatisticState extends State<TerobosStatistic> {
  final _db = FirebaseDatabase.instance.ref();

  // Menyimpan riwayat data
  final List<double> suhuData = [];
  final List<double> kelembabanData = [];
  final List<double> cahayaData = [];
  final List<double> hujanData = [];

  static const int maxPoints = 20;

  @override
  void initState() {
    super.initState();
    _listenSensor("sensor/suhu", suhuData);
    _listenSensor("sensor/kelembaban", kelembabanData);
    _listenSensorBinary("sensor/statusCahaya", cahayaData, "Terang");
    _listenSensorBinary("sensor/statusHujan", hujanData, "Hujan");
  }

  void _listenSensor(String path, List<double> list) {
    _db.child(path).onValue.listen((event) {
      final val = event.snapshot.value;
      if (val != null) {
        final numValue = double.tryParse(val.toString());
        if (numValue != null) {
          setState(() {
            list.add(numValue);
            if (list.length > maxPoints) list.removeAt(0);
          });
        }
      }
    });
  }

  void _listenSensorBinary(String path, List<double> list, String trueValue) {
    _db.child(path).onValue.listen((event) {
      final val = event.snapshot.value?.toString();
      if (val != null) {
        setState(() {
          list.add(val == trueValue ? 1.0 : 0.0);
          if (list.length > maxPoints) list.removeAt(0);
        });
      }
    });
  }

  LineChartData _buildChartData(List<double> data, Color color) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: Colors.white10, strokeWidth: 1),
      ),
      borderData: FlBorderData(show: false),
      titlesData: const FlTitlesData(show: false),
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          spots: [
            for (int i = 0; i < data.length; i++)
              FlSpot(i.toDouble(), data[i]),
          ],
          color: color,
          barWidth: 3,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [color.withOpacity(0.3), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          dotData: const FlDotData(show: false),
        ),
      ],
    );
  }

  Widget _buildSensorTile({
    required String title,
    required List<double> data,
    required Color color,
    required IconData icon,
    required String unit,
  }) {
    final latest = data.isNotEmpty ? data.last.toStringAsFixed(1) : "—";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.9), color.withOpacity(0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Icon besar di kiri
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Icon(icon, color: Colors.white, size: 50),
          ),
          const SizedBox(width: 16),

          // Info dan chart di kanan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Terbaru: $latest $unit",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 80,
                  child: LineChart(
                    _buildChartData(data, Colors.white),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      appBar: AppBar(
        leadingWidth: 50,
        leading: Container(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image(image: AssetImage('images/Terobos2.png')),
        ),
        title: const Text(
          'TEROBOS MONITOR',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: const Color(0xFF0D5EA6), // Transparan agar menyatu
        elevation: 0, // Hilangkan bayangan
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSensorTile(
              title: "Suhu",
              data: suhuData,
              color: Colors.redAccent,
              icon: Icons.thermostat,
              unit: "°C",
            ),
            _buildSensorTile(
              title: "Kelembapan",
              data: kelembabanData,
              color: Colors.lightBlueAccent,
              icon: Icons.opacity,
              unit: "%",
            ),
            _buildSensorTile(
              title: "Cahaya",
              data: cahayaData,
              color: Colors.amber,
              icon: Icons.wb_sunny,
              unit: "",
            ),
            _buildSensorTile(
              title: "Hujan",
              data: hujanData,
              color: Colors.blueAccent,
              icon: Icons.umbrella,
              unit: "",
            ),
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
                  Navigator.pushAndRemoveUntil(
                    context,
                      MaterialPageRoute(builder: (context) => TerobosMonitorScreen()),
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
                  Navigator.pushAndRemoveUntil(context,
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
