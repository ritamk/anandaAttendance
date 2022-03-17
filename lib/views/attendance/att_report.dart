import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AttReportPage extends StatefulWidget {
  const AttReportPage({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<AttReportPage> createState() => AttReportStatePage();
}

class AttReportStatePage extends State<AttReportPage> {
  late int currMonth;
  late int currYear;

  @override
  void initState() {
    super.initState();
    currMonth = DateTime.now().month;
    currYear = DateTime.now().year;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report")),
      body: SizedBox(
        height: 200.0,
        width: double.infinity,
        child: CupertinoDatePicker(
          initialDateTime: DateTime.now(),
          onDateTimeChanged: (dateTime) {},
          mode: CupertinoDatePickerMode.date,
          dateOrder: DatePickerDateOrder.dmy,
          minimumYear: currYear,
          maximumYear: currYear,
          maximumDate: DateTime.now(),
        ),
      ),
    );
  }
}
