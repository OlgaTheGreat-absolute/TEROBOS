import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'table.dart';
import 'statistic.dart';
import 'profile.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan const agar lebih efisien

    const Color mainBackgroundColor = Color.fromARGB(255, 230, 230, 230);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mainBackgroundColor,
      ),
      home: const TerobosMonitorScreen(),
    );
  }
}

class TerobosMonitorScreen extends StatefulWidget {
  const TerobosMonitorScreen({super.key});

  @override
  State<TerobosMonitorScreen> createState() => _TerobosMonitorScreenState();
}

class _TerobosMonitorScreenState extends State<TerobosMonitorScreen> {
  String? selectedSensor;

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
        child: Column(
          children: [
            // === Container detail abu-abu ===
            Container(
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: selectedSensor == null
                  ? const Center(
                      child: Text(
                        "Pilih salah satu sensor untuk melihat detailnya",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : _buildSensorDetail(selectedSensor!),
            ),
            const SizedBox(height: 20),

            // === Grid sensor ===
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildAnimatedSensorCard(
                    onTap: () => setState(() => selectedSensor = 'suhu'),
                    child: const RealtimeSensorCard(
                      path: 'sensor/suhu',
                      title: 'Suhu',
                      icon: Icons.thermostat,
                      unit: '°C',
                      color: Color(0xFFD9534F),
                    ),
                  ),
                  _buildAnimatedSensorCard(
                    onTap: () => setState(() => selectedSensor = 'kelembaban'),
                    child: const RealtimeSensorCard(
                      path: 'sensor/kelembaban',
                      title: 'Kelembaban',
                      icon: Icons.opacity,
                      unit: '%',
                      color: Color(0xFF5CB85C),
                    ),
                  ),
                  _buildAnimatedSensorCard(
                    onTap: () => setState(() => selectedSensor = 'cahaya'),
                    child: const BinarySensorCard(
                      title: 'Cahaya',
                      dbPath: 'sensor/statusCahaya',
                      trueLabel: 'Terang',
                      falseLabel: 'Redup',
                      trueIcon: Icons.wb_sunny,
                      falseIcon: Icons.nights_stay,
                      trueColor: Color(0xFFF0AD4E),
                      falseColor: Color(0xFF6C5B7B),
                      isStringComparison: true,
                      stringTrueValue: "Terang",
                    ),
                  ),
                  _buildAnimatedSensorCard(
                    onTap: () => setState(() => selectedSensor = 'hujan'),
                    child: const BinarySensorCard(
                      title: 'Hujan',
                      dbPath: 'sensor/statusHujan',
                      trueLabel: 'Hujan',
                      falseLabel: 'Tidak',
                      trueIcon: Icons.umbrella,
                      falseIcon: Icons.wb_cloudy,
                      trueColor: Color(0xFF5BC0DE),
                      falseColor: Color(0xFFB0BEC5),
                      isStringComparison: true,
                      stringTrueValue: "Hujan",
                    ),
                  ),
                ],
              ),
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
                        color: const Color.fromARGB(255, 255, 255, 255),
                        blurRadius: 15,
                        offset: const Offset(-6, -6),
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: const Color.fromARGB(255, 100, 100, 100),
                        blurRadius: 15,
                        offset: const Offset(6, 6),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20), 

                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildContainerCredit(
                        'images/Terobos2.png',
                        'Asqi Syahrul A.', 
                        'K3523020'),
                        _buildContainerCredit(
                        'images/Terobos2.png',
                        'Ananda Olga K.', 
                        'K3523011'),
                        _buildContainerCredit(
                        'images/Terobos2.png',
                        'Ardika Muh I. R.', 
                        'K3523017'),
                        _buildContainerCredit(
                        'images/Terobos2.png',
                        'Yusup C D.', 
                        'K3523078'),
                        _buildContainerCredit(
                        'images/Terobos2.png',
                        'Reza Ahmad F.', 
                        'K3523063'),
                        _buildContainerCredit(
                        'images/Terobos2.png',
                        'Widhi Sri B.', 
                        'K3523075'),
                        _buildContainerCredit(
                        'images/Terobos2.png',
                        'Annisa Intan S.', 
                        'K3523014'),
                        _buildContainerCredit(
                        'images/Terobos2.png',
                        'Ratna Anata Sari', 
                        'K3523082'),
                        _buildContainerCredit(
                        'images/Terobos2.png',
                        'Nabila Kayla T. P.', 
                        'K3523054'),
                        _buildContainerCredit(
                        'images/Terobos2.png',
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
                  Navigator.pushAndRemoveUntil(
                    context,
                      MaterialPageRoute(builder: (context) => Terobos()),
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

  // === Widget detail sensor di container abu-abu ===
  Widget _buildSensorDetail(String sensor) {
    switch (sensor) {
      case 'suhu':
        return const _DetailFromFirebase(
          title: 'Suhu',
          path: 'sensor/suhu',
          unit: '°C',
          icon: Icons.thermostat,
          color: Color(0xFFD9534F),
        );
      case 'kelembaban':
        return const _DetailFromFirebase(
          title: 'Kelembaban',
          path: 'sensor/kelembaban',
          unit: '%',
          icon: Icons.opacity,
          color: Color(0xFF5CB85C),
        );
      case 'cahaya':
        return const _BinaryDetailFromFirebase(
          title: 'Cahaya',
          dbPath: 'sensor/statusCahaya',
          trueLabel: 'Terang',
          falseLabel: 'Redup',
          trueIcon: Icons.wb_sunny,
          falseIcon: Icons.nights_stay,
          trueColor: Color(0xFFF0AD4E),
          falseColor: Color(0xFF6C5B7B),
          stringTrueValue: "Terang",
        );
      case 'hujan':
        return const _BinaryDetailFromFirebase(
          title: 'Hujan',
          dbPath: 'sensor/statusHujan',
          trueLabel: 'Hujan',
          falseLabel: 'Tidak Hujan',
          trueIcon: Icons.umbrella,
          falseIcon: Icons.wb_cloudy,
          trueColor: Color(0xFF5BC0DE),
          falseColor: Color(0xFFB0BEC5),
          stringTrueValue: "Hujan",
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // === Widget pressable wrapper ===
  Widget _buildAnimatedSensorCard({
    required VoidCallback onTap,
    required Widget child,
  }) {
    return _PressableCard(onTap: onTap, child: child);
  }
}

class _PressableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _PressableCard({required this.child, required this.onTap});

  @override
  State<_PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<_PressableCard> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: (details) {
        _onTapUp(details);
        widget.onTap();
      },
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class RealtimeSensorCard extends StatelessWidget {
  final String path;
  final String title;
  final IconData icon;
  final String unit;
  final Color color;

  const RealtimeSensorCard({
    super.key,
    required this.path,
    required this.title,
    required this.icon,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final dbRef = FirebaseDatabase.instance.ref(path);

    return StreamBuilder(
      stream: dbRef.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            (snapshot.data! as DatabaseEvent).snapshot.value != null) {
          var value = (snapshot.data! as DatabaseEvent).snapshot.value.toString();
          return _buildCardContent(context, value);
        } else {
          return _buildCardContent(context, "--");
        }
      },
    );
  }

  Widget _buildCardContent(BuildContext context, String value) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70, size: 40),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 6),
          Text("$value $unit",
              style: TextStyle(color: Colors.white70, fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}


class BinarySensorCard extends StatelessWidget {
  final String title;
  final String dbPath;
  final String trueLabel;
  final String falseLabel;
  final IconData trueIcon;
  final IconData falseIcon;
  final Color trueColor;
  final Color falseColor;
  final bool isStringComparison;
  final String stringTrueValue;

  const BinarySensorCard({
    super.key,
    required this.title,
    required this.dbPath,
    required this.trueLabel,
    required this.falseLabel,
    required this.trueIcon,
    required this.falseIcon,
    required this.trueColor,
    required this.falseColor,
    this.isStringComparison = false,
    this.stringTrueValue = "true",
  });

  @override
  Widget build(BuildContext context) {
    final dbRef = FirebaseDatabase.instance.ref(dbPath);

    return StreamBuilder(
      stream: dbRef.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            (snapshot.data! as DatabaseEvent).snapshot.value != null) {
          var value = (snapshot.data! as DatabaseEvent).snapshot.value;
          bool isTrue = isStringComparison
              ? value.toString() == stringTrueValue
              : value == true;

          return _buildCardContent(context, isTrue);
        } else {
          return _buildCardContent(context, false);
        }
      },
    );
  }

  Widget _buildCardContent(BuildContext context, bool isTrue) {
    Color color = isTrue ? trueColor : falseColor;
    IconData icon = isTrue ? trueIcon : falseIcon;
    String label = isTrue ? trueLabel : falseLabel;

    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70, size: 40),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 6),
          Text(label,
              style: TextStyle(color: Colors.white70, fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _DetailFromFirebase extends StatelessWidget {
  final String title;
  final String path;
  final String unit;
  final IconData icon;
  final Color color;

  const _DetailFromFirebase({
    required this.title,
    required this.path,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final dbRef = FirebaseDatabase.instance.ref(path);

    return StreamBuilder(
      stream: dbRef.onValue,
      builder: (context, snapshot) {
        String value = "--";
        if (snapshot.hasData &&
            snapshot.data != null &&
            (snapshot.data! as DatabaseEvent).snapshot.value != null) {
          value = (snapshot.data! as DatabaseEvent).snapshot.value.toString();
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Icon(icon, color: color, size: 60),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
            Text(
              "$value $unit",
              style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }
}

class _BinaryDetailFromFirebase extends StatelessWidget {
  final String title;
  final String dbPath;
  final String trueLabel;
  final String falseLabel;
  final IconData trueIcon;
  final IconData falseIcon;
  final Color trueColor;
  final Color falseColor;
  final String stringTrueValue;

  const _BinaryDetailFromFirebase({
    required this.title,
    required this.dbPath,
    required this.trueLabel,
    required this.falseLabel,
    required this.trueIcon,
    required this.falseIcon,
    required this.trueColor,
    required this.falseColor,
    required this.stringTrueValue,
  });

  @override
  Widget build(BuildContext context) {
    final dbRef = FirebaseDatabase.instance.ref(dbPath);

    return StreamBuilder(
      stream: dbRef.onValue,
      builder: (context, snapshot) {
        bool isTrue = false;
        if (snapshot.hasData &&
            snapshot.data != null &&
            (snapshot.data! as DatabaseEvent).snapshot.value != null) {
          var value = (snapshot.data! as DatabaseEvent).snapshot.value.toString();
          isTrue = value == stringTrueValue;
        }
        Color color = isTrue ? trueColor : falseColor;
        IconData icon = isTrue ? trueIcon : falseIcon;
        String label = isTrue ? trueLabel : falseLabel;

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Icon(icon, color: color, size: 60),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
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

