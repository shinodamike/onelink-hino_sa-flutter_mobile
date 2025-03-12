import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

PickerDateRange? selectDateRange;

class DateViewRangeCustom2View extends StatefulWidget {
  DateViewRangeCustom2View(
      {Key? key,
      this.title,
      this.value,
      this.dateSelect,
      required this.controller,
      required this.returnDate,
      this.limit,
      this.colors,
      this.disable})
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
  final int? limit;
  final Color? colors;
  bool? disable = false;
  DateTime? dateSelect;

  @override
  _TextFieldCustomViewState createState() => _TextFieldCustomViewState();
}

class _TextFieldCustomViewState extends State<DateViewRangeCustom2View> {
  // DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    widget.returnDate.call(picked!);
    setState(() {
      // txt.text = selectedDate.toString();
      widget.controller.text =
          "${DateFormat('dd MMM yy').format(picked.start)} - ${DateFormat('dd MMM yy').format(picked.end)}";
    });
  }

  // bool checkLimit(DateTime limitDay) {
  //   if(widget.limit!=null){
  //     if (limitDay.isAfter(rangeStartDate!.add(Duration(days: widget.limit!)))) {
  //       return true;
  //     }
  //     return false;
  //   }else{
  //     return true;
  //   }
  //
  // }

  // DateRangePickerController _datePickerController = DateRangePickerController();

  DateTime? rangeStartDate;

  DateTime? rangeEndDate;

  showDia(BuildContext context) {
    rangeStartDate = null;
    rangeEndDate = null;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: Container(
                color: Colors.white,
                height: 300.0,
                width: 300.0,
                child: SfDateRangePicker(
                  // showActionButtons: true,
                  onCancel: () {
                    Navigator.pop(context);
                  },
                  onSubmit: (p0) {
                    Navigator.pop(context);
                    widget.returnDate.call(DateTimeRange(
                        start: rangeStartDate!, end: rangeEndDate!));
                    rangeStartDate = null;
                    rangeEndDate = null;
                  },
                  onSelectionChanged: (args) {
                    if (args.value is PickerDateRange) {
                      selectDateRange = args.value;
                      rangeStartDate = args.value.startDate;
                      rangeEndDate = args.value.endDate;
                      if (rangeStartDate != null && rangeEndDate != null) {
                        widget.controller.text =
                            "${DateFormat('dd MMM yy').format(rangeStartDate!)} - ${DateFormat('dd MMM yy').format(rangeEndDate!)}";

                        Navigator.pop(context);
                        widget.returnDate.call(DateTimeRange(
                            start: rangeStartDate!, end: rangeEndDate!));
                        rangeStartDate = null;
                        rangeEndDate = null;
                      } else {
                        widget.controller.text =
                            DateFormat('dd MMM yy').format(rangeStartDate!);
                      }
                    } else if (args.value is DateTime) {
                      final DateTime selectedDate = args.value;
                    } else if (args.value is List<DateTime>) {
                      final List<DateTime> selectedDates = args.value;
                    } else {
                      final List<PickerDateRange> selectedRanges = args.value;
                    }
                    // widget.returnDate.call(dateRangePickerSelectionChangedArgs.value);
                    // setState(() {
                    //   // txt.text = selectedDate.toString();
                    //   widget.controller.text = DateFormat('dd/MM/yyyy').format(picked.start) +
                    //       " - " +
                    //       DateFormat('dd/MM/yyyy').format(picked.end);
                    // });
                    setState(() {});
                  },
                  maxDate: widget.limit != null
                      ? (rangeStartDate != null
                          ? rangeStartDate!.add(Duration(days: widget.limit!))
                          : null)
                      : null,
                  minDate: widget.limit != null
                      ? (rangeStartDate != null ? rangeStartDate! : null)
                      : null,
                  // selectableDayPredicate: rangeStartDate!=null?checkLimit:null,
                  // selectableDayPredicate: checkLimit,
                  // initialSelectedRange: rangeStartDate!=null?PickerDateRange(
                  //     rangeStartDate,
                  //     rangeStartDate?.add(const Duration(days: 7))):null,
                  // controller: _datePickerController,
                  selectionMode: DateRangePickerSelectionMode.range,
                  initialSelectedRange: selectDateRange,
                  selectionColor: ColorCustom.primaryColor,
                  startRangeSelectionColor: ColorCustom.primaryColor,
                  endRangeSelectionColor: ColorCustom.primaryColor,
                  rangeSelectionColor: ColorCustom.primaryColor,
                ),
              ),
            );
          },
        );
      },
    );

    // Dialog errorDialog = Dialog(
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    //   //this right here
    //   child: StatefulBuilder(builder: (context, setState) {
    //
    //     return  Container(
    //       height: 300.0,
    //       width: 300.0,
    //       child: SfDateRangePicker(
    //         onSelectionChanged: (args) {
    //           if (args.value is PickerDateRange) {
    //             rangeStartDate = args.value.startDate;
    //             rangeEndDate = args.value.endDate;
    //             print(rangeStartDate);
    //           } else if (args.value is DateTime) {
    //             final DateTime selectedDate = args.value;
    //           } else if (args.value is List<DateTime>) {
    //             final List<DateTime> selectedDates = args.value;
    //           } else {
    //             final List<PickerDateRange> selectedRanges = args.value;
    //           }
    //           // widget.returnDate.call(dateRangePickerSelectionChangedArgs.value);
    //           // setState(() {
    //           //   // txt.text = selectedDate.toString();
    //           //   widget.controller.text = DateFormat('dd/MM/yyyy').format(picked.start) +
    //           //       " - " +
    //           //       DateFormat('dd/MM/yyyy').format(picked.end);
    //           // });
    //           setState(() {
    //
    //           });
    //         },
    //         // maxDate: DateTime.now(),
    //         selectableDayPredicate: rangeStartDate!=null?checkLimit:null,
    //         // selectableDayPredicate: checkLimit,
    //         // initialSelectedRange: rangeStartDate!=null?PickerDateRange(
    //         //     rangeStartDate,
    //         //     rangeStartDate?.add(const Duration(days: 7))):null,
    //         // controller: _datePickerController,
    //         selectionMode: DateRangePickerSelectionMode.range,
    //       ),
    //     );
    //   })
    // );
    //
    // showDialog(
    //     context: context, builder: (BuildContext context) => errorDialog);
  }

  @override
  void initState() {
    widget.controller.text = DateFormat('dd MMM yy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: () {
          // _selectDate(context);
          if (widget.disable != null && widget.disable!) {
          } else {
            showDia(context);
          }
        },
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.calendar_today,
              size: 20,
              color: Colors.black,
            ),
            Expanded(
              child: TextField(
                controller: widget.controller,
                enabled: false,
                style: TextStyle(
                    color:
                        widget.colors != null ? widget.colors! : Colors.black),
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
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey,
              size: 25,
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
