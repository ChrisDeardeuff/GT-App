import 'package:flutter/material.dart';

import '../services/galactic_time.service.dart';

class TimeView extends StatefulWidget {
  const TimeView({super.key});

  @override
  State<TimeView> createState() => _TimeViewState();
}

class _TimeViewState extends State<TimeView> {

  late String gt;
  late String gtYear;
  late String gtMonth;
  late String gtDay;
  late String gtHour;
  late String gtMinute;
  late String gtSecond;

  @override
  void initState() {
    super.initState();
    gt = GalacticTimeService.getGT();
    gtYear = gt.substring(0, 2);

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '$gt',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            '$gt',
          ),
        ],
      ),
    );
  }
}
