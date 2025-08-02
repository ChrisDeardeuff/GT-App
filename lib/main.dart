import 'package:flutter/material.dart';
import 'package:galactic_time/services/galactic_time.service.dart';
import 'package:galactic_time/views/convert.view.dart';
import 'package:galactic_time/views/time.view.dart';

import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.blue,
          surface: Colors.black,
          onPrimary: Colors.white,
          // Text/icons on black background
          onSurface: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  var _selectedIndex = 0;

  // Define an AnimationController and Tween for the rotation
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300), // Adjust duration as needed
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 0.5)
        .animate(_controller); // 1.0 means a full 360-degree rotation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == 2 && index != 2) {
      // If timers was selected and now it's not, reset rotation
      _controller.reverse();
    }
    setState(() {
      _selectedIndex = index;
    });
    if (index == 2) {
      // "Timers" is the 3rd item (index 2)
      _controller.forward(from: 0.0); // Start the rotation animation
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget timersIcon = const Icon(Icons.hourglass_bottom);
    if (_selectedIndex == 2) {
      timersIcon = RotationTransition(
        turns: _animation,
        child: const Icon(Icons.hourglass_bottom),
      );
    }

    return Scaffold(
      body: switch (_selectedIndex) {
        0 => const TimeView(),
        1 => const Center(child: Text('Alarm')),
        2 => const Center(child: Text('Timers')),
        3 => const Center(child: Text('Calendar')),
        4 => const ConvertView(),
        // TODO: Handle this case.
        int() => throw UnimplementedError(),
      },
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
              icon: Icon(Icons.timelapse), label: 'Clock'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.alarm), label: 'Alarm'),
          BottomNavigationBarItem(
            icon: timersIcon,
            label: 'Timers',
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'Calendar'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows), label: 'Convert'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.onSurface,
        unselectedItemColor: Theme.of(context).colorScheme.onPrimary,
        onTap: _onItemTapped, // Updated onTap handler
      ),
    );
  }
}
