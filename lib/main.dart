import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const VividStyleCounter());
}

class VividStyleCounter extends StatelessWidget {
  const VividStyleCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'カウンター',
      theme: ThemeData(fontFamily: 'Arial'),
      debugShowCheckedModeBanner: false,
      home: const CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _count = 0;

  void _decrement() {
    setState(() {
      _count--;
    });
    _saveCount(); // ←ここで保存！
  }

  //グラデーション候補たち
  final List<List<Color>> gradientColors = [
    [Colors.orange, Colors.deepOrange],
    [Colors.teal, Colors.cyan],
    [Colors.purple, Colors.indigo],
    [Colors.redAccent, Colors.orangeAccent],
    [Colors.green, Colors.lightGreen],
  ];
  late List<Color> currentGradient;

  @override
  void initState() {
    super.initState();
    currentGradient = gradientColors[0]; // 最初の背景
    _loadCount(); //セーブロード為のコード
  }

  void _increment() {
    setState(() {
      _count++;
      currentGradient = (gradientColors..shuffle()).first;
    });
    _saveCount(); // ←ここで保存！
  }

  //保存処理：
  Future<void> _saveCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('count', _count);
  }

  //読み込み処理：
  Future<void> _loadCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _count = prefs.getInt('count') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _increment,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: currentGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  '$_count',
                  style: const TextStyle(
                    fontSize: 100,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: IconButton(
                icon: const Icon(Icons.remove),
                color: Colors.white,
                iconSize: 40,
                onPressed: _decrement,
              ),
            ),
          ],
        ),
      ),
    ); //
  }
}
