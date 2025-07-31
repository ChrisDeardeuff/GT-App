import 'package:flutter/material.dart';
import '../services/galactic_time.service.dart'; // Make sure this path is correct

class TimeView extends StatefulWidget {
  const TimeView({super.key});

  @override
  State<TimeView> createState() => _TimeViewState();
}

class _TimeViewState extends State<TimeView> {
  late String formattedGalacticTime;

  @override
  void initState() {
    super.initState();
    _updateGalacticTime();
  }

  void _updateGalacticTime() {
    String gtFullString = GalacticTimeService.getGT(); // Example: "4803328547.850486"

    // Find the decimal point to isolate the integer part
    int decimalPointIndex = gtFullString.indexOf('.');
    String integerPart = decimalPointIndex != -1
        ? gtFullString.substring(0, decimalPointIndex)
        : gtFullString;

    // --- Parsing from right to left as per your description ---

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
    String gtYear = integerPart.isNotEmpty ? integerPart : "0"; // Default to "0" if nothing is left

    // Format the string
    // Adding zero-padding for single-digit months, days, hours, minutes, seconds for consistency if desired
    // Example: If month is "0", day is "33", hour is "2", minute is "85", second is "47"
    // it will be ".0.33 2.85.47"
    // If you prefer "0.33 2.85.47", adjust accordingly (e.g. don't pad gtMonth if it's already "0")

    // The current parsing logic for single digits (hour, month) already extracts them as single digits.
    // If you need them to be two digits (e.g., "02" for hour), you would padLeft them:
    // gtHour = gtHour.padLeft(2, '0');
    // gtMonth = gtMonth.padLeft(2, '0'); // For month like ".00" - adjust if this isn't desired

    formattedGalacticTime = "$gtYear.$gtMonth.$gtDay $gtHour.$gtMinute.$gtSecond";

    // If you want to update the time periodically, you'd use a Timer here
    // For now, it just sets it once.
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column( // Using Column for better layout of multiple Text widgets
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Galactic Standard Time:', // A label
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8), // Some spacing
          Text(
            formattedGalacticTime,
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