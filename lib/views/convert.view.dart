import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

import '../services/galactic_time.service.dart';

class ConvertView extends StatefulWidget {
  const ConvertView({super.key});

  @override
  State<ConvertView> createState() => _ConvertViewState();
}

class _ConvertViewState extends State<ConvertView> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  late String formattedGT;

  @override
  initState() {
    super.initState();
    _selectedDate = DateTime.now().toUtc();
    setGT();
  }

  setGT() {
    String gtFullString =
        GalacticTimeService.convertToGalacticTime(_selectedDate!);

    // Use setState to trigger a UI rebuild with the new time
    setState(() {
      formattedGT = GalacticTimeService.formatGalacticTime(gtFullString);
    });
  }

  // Getter to combine date and time into a single DateTime object
  DateTime? get _selectedDateTime {
    if (_selectedDate != null && _selectedTime != null) {
      return DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DateTimeFormField(
                decoration: const InputDecoration(
                  labelText: 'Enter Date & Time',
                ),
                firstDate: DateTime(1860),
                lastDate: DateTime(3000),
                initialPickerDateTime: DateTime.now(),
                onChanged: (DateTime? value) {
                  _selectedDate = value?.toUtc();
                  setGT();
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Text(
              formattedGT,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontFamily:
                'monospace', // Often good for displaying time
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
