import 'package:face_rec/services/database.dart';
import 'package:face_rec/shared/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    currMonth = today.month;
    currYear = today.year;
    selectedDate = today;
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
                onDateChanged: (date) {
                  setState(() => selectedDate = date);
                },
              ),
            ),
            const SizedBox(height: 20.0, width: 0.0),
            FutureBuilder<List?>(
                future: DatabaseService(uid: widget.uid)
                    .attendanceSummary(selectedDate),
                initialData: null,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? snapshot.data!.isNotEmpty
                          ? ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                try {
                                  return !snapshot.data![index]["leave"]
                                      ? ListTile(
                                          title: Text(
                                              DateFormat.Hms()
                                                  .format(snapshot.data![index]
                                                          ["time"]
                                                      .toDate())
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold)),
                                          leading: snapshot.data![index]
                                                  ["reporting"]
                                              ? Icon(Icons.login_rounded,
                                                  color: Colors.green.shade800)
                                              : Icon(Icons.logout_rounded,
                                                  color: Colors.red.shade800),
                                        )
                                      : const ListTile(
                                          title: Text("On leave."),
                                          leading: Icon(Icons.check));
                                } catch (e) {
                                  return ListTile(
                                    title: Text(
                                        DateFormat.Hms()
                                            .format(snapshot.data![index]
                                                    ["time"]
                                                .toDate())
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                    leading: snapshot.data![index]["reporting"]
                                        ? Icon(Icons.login_rounded,
                                            color: Colors.green.shade800)
                                        : Icon(Icons.logout_rounded,
                                            color: Colors.red.shade800),
                                  );
                                }
                              },
                              padding: const EdgeInsets.all(16.0),
                              shrinkWrap: true,
                              clipBehavior: Clip.none,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Icon(Icons.error, color: Colors.red),
                                SizedBox(height: 0.0, width: 20.0),
                                Text(
                                  "No data for the selected date",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                      : const Loading(white: false);
                }),
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