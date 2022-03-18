import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AttReportPage extends StatefulWidget {
  const AttReportPage({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<AttReportPage> createState() => AttReportStatePage();
}

class AttReportStatePage extends State<AttReportPage> {
  late DateTime today;
  late int currMonth;
  late int currYear;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    currMonth = today.month;
    currYear = today.year;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 300.0,
              width: double.infinity,
              child: CalendarDatePicker(
                initialDate: today,
                firstDate: DateTime(currYear, currMonth - 1, 1),
                lastDate: today,
                onDateChanged: (date) {},
              ),
            ),
            const SizedBox(height: 40.0, width: 0.0),
          ],
        ),
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
      ),
    );
  }
}


// CupertinoDatePicker(
//   initialDateTime: DateTime.now(),
//   onDateTimeChanged: (dateTime) {},
//   mode: CupertinoDatePickerMode.date,
//   dateOrder: DatePickerDateOrder.dmy,
//   minimumYear: currYear - 1,
//   maximumYear: currYear,
//   maximumDate: DateTime.now(),
//   minimumDate: DateTime(currYear, currMonth - 1, 1),
// ),