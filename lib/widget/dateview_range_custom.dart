import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateViewRangeCustomView extends StatefulWidget {
  const DateViewRangeCustomView(
      {Key? key,
      this.title,
      this.value,
      required this.controller,
      required this.returnDate})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String? title;
  final String? value;
  final TextEditingController controller;
  final ValueChanged<DateTimeRange> returnDate;

  @override
  _TextFieldCustomViewState createState() => _TextFieldCustomViewState();
}

class _TextFieldCustomViewState extends State<DateViewRangeCustomView> {
  DateTime? start;

  _selectDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: start != null ? start! : DateTime(2000),
      lastDate: start != null ? start! : DateTime.now(),

    );
    start = picked!.start;
    widget.returnDate.call(picked);
    setState(() {
      // txt.text = selectedDate.toString();
      widget.controller.text = "${DateFormat('dd/MM/yyyy').format(picked.start)} - ${DateFormat('dd/MM/yyyy').format(picked.end)}";
    });
  }

  @override
  void initState() {
    widget.controller.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          //padding: EdgeInsets.symmetric(horizontal: 15),
          child: InkWell(
            onTap: () {
              _selectDate(context);
            },
            child: TextField(
              controller: widget.controller,
              enabled: false,
              decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  labelText: widget.value,
                  hintText: widget.value),
            ),
          ),
        ),
      ],
    );
  }
}
