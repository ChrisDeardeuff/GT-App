import 'dart:async';
import 'package:flutter/material.dart';
import '../services/galactic_time.service.dart';

class TimeView extends StatefulWidget {
  const TimeView({super.key});

  @override
  State<TimeView> createState() => _TimeViewState();
}

class _TimeViewState extends State<TimeView> {
  late String formattedGalacticTime;
  late String formattedGalacticDate;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateGalacticTime(); // Initial update
    // Start a periodic timer that fires every 330 milliseconds
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      _updateGalacticTime();
    });
  }

  void _updateGalacticTime() {
    String gtFullString = GalacticTimeService.getGT();

    // Find the decimal point to isolate the integer part
    int decimalPointIndex = gtFullString.indexOf('.');
    String integerPart = decimalPointIndex != -1
        ? gtFullString.substring(0, decimalPointIndex)
        : gtFullString;

    // --- Parsing from right to left

    // Seconds (last two digits of the integer part)
    String gtSecond = "";
    if (integerPart.length >= 2) {
      gtSecond = integerPart.substring(integerPart.length - 2);
      integerPart = integerPart.substring(0, integerPart.length - 2);
    } else {
      gtSecond = integerPart.padLeft(2, '0'); // Handle cases like "5.xxx" -> "05" seconds
      integerPart = "";
    }

    // Minutes (next two digits)
    String gtMinute = "";
    if (integerPart.length >= 2) {
      gtMinute = integerPart.substring(integerPart.length - 2);
      integerPart = integerPart.substring(0, integerPart.length - 2);
    } else {
      gtMinute = integerPart.padLeft(2, '0');
      integerPart = "";
    }

    // Hour (next single digit)
    String gtHour = "";
    if (integerPart.length >= 1) {
      gtHour = integerPart.substring(integerPart.length - 1);
      integerPart = integerPart.substring(0, integerPart.length - 1);
    } else {
      gtHour = integerPart.padLeft(1, '0');
      integerPart = "";
    }

    // Days (next two digits)
    String gtDay = "";
    if (integerPart.length >= 2) {
      gtDay = integerPart.substring(integerPart.length - 2);
      integerPart = integerPart.substring(0, integerPart.length - 2);
    } else {
      gtDay = integerPart.padLeft(2, '0');
      integerPart = "";
    }

    // Month (next single digit)
    String gtMonth = "";
    if (integerPart.length >= 1) {
      gtMonth = integerPart.substring(integerPart.length - 1);
      integerPart = integerPart.substring(0, integerPart.length - 1);
    } else {
      gtMonth = integerPart.padLeft(1, '0');
      integerPart = "";
    }

    // Year (the rest)
    String gtYear = integerPart.isNotEmpty ? integerPart : "0";

    // Use setState to trigger a UI rebuild with the new time
    setState(() {
      formattedGalacticTime = "$gtHour.$gtMinute.$gtSecond";
      formattedGalacticDate = "$gtYear.$gtMonth.$gtDay";
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column( // Using Column for better layout of multiple Text widgets
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            formattedGalacticTime,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 60,
              fontFamily: 'monospace', // Often good for displaying time
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            formattedGalacticDate,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontFamily: 'monospace', // Often good for displaying time
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
