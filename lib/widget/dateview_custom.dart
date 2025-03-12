import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateViewCustomView extends StatefulWidget {
  DateViewCustomView(
      {Key? key,
      this.title,
      this.value,
      required this.controller,
        required this.selectedDate, required this.returnDate})
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
   DateTime selectedDate;
  final ValueChanged returnDate;

  @override
  _TextFieldCustomViewState createState() => _TextFieldCustomViewState();
}

class _TextFieldCustomViewState extends State<DateViewCustomView> {
  // DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != widget.selectedDate) {
      widget.returnDate.call(picked);
    }
      setState(() {
        widget.selectedDate = picked!;
        // txt.text = selectedDate.toString();
        widget.controller.text = DateFormat('dd/MM/yyyy').format(widget.selectedDate);
      });
  }


  @override
  void initState() {

    widget.controller.text = DateFormat('dd/MM/yyyy').format(widget.selectedDate);
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
