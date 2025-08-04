import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../widgets/galactic_time_input_formatter.dart';
import '../services/galactic_time.service.dart';

class ConvertView extends StatefulWidget {
  const ConvertView({super.key});

  @override
  State<ConvertView> createState() => _ConvertViewState();
}

class _ConvertViewState extends State<ConvertView> {
  DateTime _selectedDateTime = DateTime.now().toUtc();
  late String formattedGT;

  //state variables for border colors
  Color _dateBorderColor = Colors.white; // Default border color
  Color _timeBorderColor = Colors.white;
  Color _galacticTimeBorderColor = Colors.white;

  // Flash configuration
  final Color _flashColor = Colors.green; // Or Theme.of(context).primaryColor
  final Duration _flashDuration = const Duration(milliseconds: 700);

  @override
  initState() {
    super.initState();
    setGT();
  }

  setGT() {
    String gtFullString =
        GalacticTimeService.convertToGalacticTime(_selectedDateTime); // Removed ! as _selectedDateTime is not nullable

    // Use setState to trigger a UI rebuild with the new time
    setState(() {
      formattedGT = GalacticTimeService.formatGalacticTime(gtFullString);
    });
  }

  void _flashBorder(
      void Function(Color) updateBorderColorState, Color defaultColor) {
    if (!mounted) return;
    setState(() {
      updateBorderColorState(_flashColor);
    });

    Future.delayed(_flashDuration, () {
      if (mounted) {
        setState(() {
          updateBorderColorState(defaultColor); // Revert to default
        });
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(1800),
      lastDate: DateTime(3000),
    );
    if (pickedDate != null) {
      bool changed = _selectedDateTime.year != pickedDate.year ||
                     _selectedDateTime.month != pickedDate.month ||
                     _selectedDateTime.day != pickedDate.day;

      if (changed) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            _selectedDateTime.hour,
            _selectedDateTime.minute,
            _selectedDateTime.second,
            _selectedDateTime.millisecond, // preserve milliseconds
            _selectedDateTime.microsecond, // preserve microseconds
          ).toUtc();
          setGT();
        });
        _flashBorder((color) => _dateBorderColor = color, Colors.white);
        _flashBorder((color) => _galacticTimeBorderColor = color, Colors.white); // Galactic time also changes
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
          _selectedDateTime.toLocal()), // Show local time in picker
    );
    if (pickedTime != null) {
      bool changed = _selectedDateTime.hour != pickedTime.hour ||
                     _selectedDateTime.minute != pickedTime.minute;

      if (changed) {
        setState(() {
          _selectedDateTime = DateTime(
            _selectedDateTime.year,
            _selectedDateTime.month,
            _selectedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
            _selectedDateTime.second, // preserve seconds
            _selectedDateTime.millisecond, // preserve milliseconds
            _selectedDateTime.microsecond, // preserve microseconds
          ).toUtc();
          setGT();
        });
        _flashBorder((color) => _timeBorderColor = color, Colors.white);
        _flashBorder((color) => _galacticTimeBorderColor = color, Colors.white); // Galactic time also changes
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date',
                        enabledBorder: OutlineInputBorder( // Use enabledBorder for default state
                          borderSide: BorderSide(color: _dateBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder( // Optional: for when the field is focused
                          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: _dateBorderColor),
                        ),
                      ),
                      child: Text(
                        "${_selectedDateTime.toLocal().year}-${_selectedDateTime.toLocal().month.toString().padLeft(2, '0')}-${_selectedDateTime.toLocal().day.toString().padLeft(2, '0')}",
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Time',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: _timeBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: _timeBorderColor),
                        ),
                      ),
                      child: Text(
                        DateFormat('HH:mm:ss')
                            .format(_selectedDateTime.toLocal())
                            .toString(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
                padding: EdgeInsets.all(20), child: Icon(Icons.swap_vert)),
            TextField(
              decoration: InputDecoration(
                labelText: 'Galactic Time',
                helperText: 'YY.M.DD H.MM.SS',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: _galacticTimeBorderColor),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: _galacticTimeBorderColor),
                ),
              ),
              keyboardType: TextInputType
                  .datetime,
              inputFormatters: [
                FilteringTextInputFormatter
                    .digitsOnly,
                GalacticTimeInputFormatter(),
              ],
              onChanged: (value) {
                final RegExp galacticTimePattern =
                    RegExp(r'^\d{2}\.\d{1}\.\d{2} \d{1}\.\d{2}\.\d{2}$');

                if (galacticTimePattern.hasMatch(value)) {
                  try {
                    final newEarthTime =
                        GalacticTimeService.convertFromGalacticTime(
                                value.replaceAll(".", "").replaceAll(" ", ""))
                            .toLocal();
                    
                    // Check if the newEarthTime is actually different before updating
                    if (_selectedDateTime.toUtc().millisecondsSinceEpoch != newEarthTime.toUtc().millisecondsSinceEpoch) {
                        setState(() {
                        _selectedDateTime = newEarthTime.toUtc(); // Ensure it's UTC for consistency
                        setGT(); // This will update formattedGT
                      });
                      _flashBorder((color) => _dateBorderColor = color, Colors.white);
                      _flashBorder((color) => _timeBorderColor = color, Colors.white);
                      // Do not flash _galacticTimeBorderColor here as the user is actively editing it.
                    }
                  } catch (e) {
                    print("Invalid Galactic Time: $e");
                  }
                }
              },
              controller: TextEditingController(text: formattedGT)..selection = TextSelection.fromPosition(TextPosition(offset: formattedGT.length)),
            ),
          ],
        ),
      ),
    );
  }
}
