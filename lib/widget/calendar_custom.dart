import 'package:flutter/material.dart';
import 'package:iov/utils/color_custom.dart';

class CalendarCustom extends StatefulWidget {
  const CalendarCustom({Key? key, required this.title, required this.callBack})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;
  final ValueChanged<DateTime> callBack;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<CalendarCustom> {
  var start = DateTime.now();
  var to = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 40),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: ColorCustom.white),
        child: Column(
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: ColorCustom.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            DatePickerDialog(
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                initialDate: start,
                firstDate: DateTime(2000),
                lastDate: DateTime.now()),

            CalendarDatePicker(

                initialDate: start,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                onDateChanged: (picked) {
                  widget.callBack.call(picked);
                })
          ],
        ),
      ),
    );
  }
}
