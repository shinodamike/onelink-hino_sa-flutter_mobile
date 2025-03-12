
import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:iov/api/api.dart';
import 'package:iov/localization/language/language_en.dart';
import 'package:iov/localization/language/language_jp.dart';
import 'package:iov/localization/language/language_th.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/model/dropdown.dart';
import 'package:iov/model/vehicle.dart';
import 'package:iov/page/home_backup_event_search.dart';
import 'package:iov/page/home_realtime.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:iov/utils/utils.dart';
import 'package:iov/widget/CustomPicker.dart';
import 'package:iov/widget/back_ios.dart';
import 'package:iov/widget/dropbox_general_search.dart';
import 'package:iov/widget/dropbox_general_search_trip.dart';
import 'package:intl/intl.dart';


import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class HomeBackupEventPage extends StatefulWidget {
  const HomeBackupEventPage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomeBackupEventPage> {
  List<Dropdown> listDropdown = [];

  @override
  void initState() {
    timeStart = dateTime.subtract(Duration(
        hours: dateTime.hour,
        minutes: dateTime.minute,
        seconds: dateTime.second,
        milliseconds: dateTime.millisecond,
        microseconds: dateTime.microsecond));
    timeEnd = DateTime.now();
    timeString = "${DateFormat('HH:mm').format(timeStart)} - ${DateFormat('HH:mm').format(DateTime.now())}";
    textEditingController.text = dateString;
    if (Api.language == "en") {
      listDropdown.add(Dropdown("1", LanguageEn().plate_no));
      listDropdown.add(Dropdown("2", LanguageEn().vehicle_name));
      listDropdown.add(Dropdown("3", LanguageEn().vin_no));
    }else  if (Api.language == "ja") {
      listDropdown.add(Dropdown("1", LanguageJp().plate_no));
      listDropdown.add(Dropdown("2", LanguageJp().vehicle_name));
      listDropdown.add(Dropdown("3", LanguageJp().vin_no));
    }else{
      listDropdown.add(Dropdown("1", LanguageTh().plate_no));
      listDropdown.add(Dropdown("2", LanguageTh().vehicle_name));
      listDropdown.add(Dropdown("3", LanguageTh().vin_no));
    }

    super.initState();
  }

  var start = DateTime.now();
  var to = DateTime.now();
  var timeStart = DateTime.now().subtract(const Duration(hours: 0, minutes: 0));
  var timeEnd = DateTime.now();
  DateTime dateTime = DateTime.now();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  refresh() {
    setState(() {});
  }

  var timeString = "00:00 - ${DateFormat('HH:mm').format(DateTime.now())}";
  var dateString = DateFormat('dd MMM yy', Api.language).format(DateTime.now());

  //FIXME : Comment datetime picker.
  // pickTimeStart() async {
  //   DatePicker.showPicker(context,
  //       showTitleActions: true,
  //       // minTime: DateTime(2018, 3, 5),
  //       // maxTime: DateTime(2019, 6, 7),
  //       pickerModel: CustomPicker(currentTime: timeStart), onChanged: (date) {
  //     print('change $date');
  //     timeStart = date;
  //     var s = DateFormat('HH:mm').format(timeStart);
  //     var e = DateFormat('HH:mm').format(timeEnd);
  //     timeString = "$s - $e";
  //     setState(() {});
  //   }, onConfirm: (date) {
  //     print('confirm $date');
  //     timeStart = date;
  //     var s = DateFormat('HH:mm').format(timeStart);
  //     var e = DateFormat('HH:mm').format(timeEnd);
  //     timeString = "$s - $e";
  //     setState(() {});
  //     pickTimeEnd();
  //   });
  // }
  //FIXME : Comment datetime picker.
  // pickTimeEnd() async {
  //   DatePicker.showPicker(
  //     context,
  //     showTitleActions: true,
  //     // minTime: DateTime(2018, 3, 5),
  //     // maxTime: DateTime(2019, 6, 7),
  //     pickerModel: CustomPicker(currentTime: timeEnd),
  //     onChanged: (date) {
  //       print('change $date');
  //       timeEnd = date;
  //       var s = DateFormat('HH:mm').format(timeStart);
  //       var e = DateFormat('HH:mm').format(timeEnd);
  //       timeString = "$s - $e";
  //       setState(() {});
  //     },
  //     onConfirm: (date) {
  //       print('confirm $date');
  //       timeEnd = date;
  //       var s = DateFormat('HH:mm').format(timeStart);
  //       var e = DateFormat('HH:mm').format(timeEnd);
  //       timeString = "$s - $e";
  //       setState(() {});
  //     },
  //   );
  // }

  pickDateStart() async {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: Container(
                color: Colors.white,
                // height: 320.0,
                width: 300.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Languages.of(context)!.start_date,
                      style: const TextStyle(
                        color: ColorCustom.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SfDateRangePicker(
                      initialDisplayDate: start,
                      showActionButtons: true,
                      showNavigationArrow: true,
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onSubmit: (p0) {
                        Navigator.pop(context);
                        pickDateEnd();
                      },
                      onSelectionChanged: (args) {
                        if (args.value is DateTime) {
                          final DateTime selectedDate = args.value;
                          start = selectedDate;
                          to = selectedDate;
                          var s = DateFormat('dd MMM yy', Api.language)
                              .format(start);
                          var e =
                              DateFormat('dd MMM yy', Api.language).format(to);
                          if (start.isBefore(to) && !start.isSameDate(to)) {
                            dateString = "$s - $e";
                          } else {
                            dateString = s;
                          }

                          if (start.isSameDate(DateTime.now()) ||
                              start.isAfter(DateTime.now())) {
                            timeStart = DateFormat("HH:mm").parse("00:00");
                            timeEnd = DateTime.now();
                            var s = DateFormat('HH:mm').format(timeStart);
                            var e = DateFormat('HH:mm').format(timeEnd);
                            timeString = "$s - $e";
                          } else {
                            timeStart = DateFormat("HH:mm").parse("00:00");
                            timeEnd = DateFormat("HH:mm").parse("23:59");
                            var s = DateFormat('HH:mm').format(timeStart);
                            var e = DateFormat('HH:mm').format(timeEnd);
                            timeString = "$s - $e";
                          }

                          textEditingController.text = dateString;
                          refresh();
                        }
                      },
                      initialSelectedDate: start,
                      maxDate: DateTime.now(),
                      minDate: DateTime(2000),
                      selectionMode: DateRangePickerSelectionMode.single,
                      selectionColor: ColorCustom.primaryColor,
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  pickDateEnd() async {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: Container(
                color: Colors.white,
                // height: 320.0,
                width: 300.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Languages.of(context)!.end_date,
                      style: const TextStyle(
                        color: ColorCustom.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SfDateRangePicker(
                      initialDisplayDate: start,
                      showActionButtons: true,
                      showNavigationArrow: true,
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onSubmit: (p0) {
                        Navigator.pop(context);
                      },
                      onSelectionChanged: (args) {
                        if (args.value is DateTime) {
                          to = args.value;
                          var s = DateFormat('dd MMM yy', Api.language)
                              .format(start);
                          var e =
                              DateFormat('dd MMM yy', Api.language).format(to);
                          if (start.isBefore(to) && !start.isSameDate(to)) {
                            dateString = "$s - $e";
                          } else {
                            dateString = s;
                          }
                          textEditingController.text = dateString;
                          setState(() {});
                        }
                      },
                      initialSelectedDate: start,
                      maxDate: maxTimeEnd(),
                      minDate: start,
                      selectionMode: DateRangePickerSelectionMode.single,
                      selectionColor: ColorCustom.primaryColor,
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  DateTime maxTimeEnd() {
    if (start.isSameDate(DateTime.now())) {
      return DateTime.now();
    } else {
      return start.add(const Duration(days: 1));
    }
  }

  Vehicle? selectVehicle;

  submit() {
    if (selectVehicle == null) {
      if (dropdown != null) {
        Utils.showAlertDialog(
            context, Languages.of(context)!.please_select + dropdown!.name);
      } else {
        Utils.showAlertDialog(
            context,
            Languages.of(context)!.please_select +
                Languages.of(context)!.plate_no);
      }

      return;
    }

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomeBackupEventSearchPage(
              imei: selectVehicle!.gps!.imei!,
              start: start,
              end: to,
              timeEnd: timeEnd,
              timeStart: timeStart,
              license: selectVehicle!.info!.licenseplate!,
            )));
  }

  // String imei = "";
  Dropdown? dropdown;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToMe,
      //   label: Text('My location'),
      //   icon: Icon(Icons.near_me),
      // ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              const BackIOS(),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.restore,
                            size: 30,
                            color: Colors.grey,
                          ),
                          Text(
                            Languages.of(context)!.event_log,
                            style: const TextStyle(
                              color: ColorCustom.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Languages.of(context)!.search_by,
                            style: const TextStyle(
                              color: ColorCustom.black,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: ColorCustom.greyBG2),
                              color: ColorCustom.greyBG2,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            child: DropboxGeneralSearchViewTrip(
                              name: "",
                              onChanged: (value) {
                                dropdown = value;
                                refresh();
                              },
                              listData: listDropdown,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dropdown != null
                                ? dropdown!.name
                                : Languages.of(context)!.plate_no,
                            style: const TextStyle(
                              color: ColorCustom.black,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: ColorCustom.greyBG2),
                              color: ColorCustom.greyBG2,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            child: DropboxGeneralSearchView(
                              name: dropdown != null
                                  ? Languages.of(context)!.please_select +
                                      dropdown!.name
                                  : Languages.of(context)!.please_select +
                                      Languages.of(context)!.plate_no,
                              onChanged: (value) {
                                // imei = value.gps!.imei!;
                                // license = value.info!.licenseplate!;
                                selectVehicle = value;
                              },
                              listData: listVehicle,
                              dropdownID: dropdown?.id,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      // Text(
                      //   'ช่วงวัน',
                      //   style: TextStyle(
                      //     color: ColorCustom.black,
                      //     fontSize: 16,
                      //   ),
                      //   textAlign: TextAlign.start,
                      // ),
                      // GroupButton(
                      //   unselectedColor: ColorCustom.greyBG2,
                      //   isRadio: true,
                      //   spacing: 10,
                      //   onSelected: (index, isSelected) {
                      //     if (index == 2) {
                      //       dateTime.subtract(Duration(days: 7));
                      //     } else if (index == 3) {
                      //       dateTime.subtract(Duration(days: 30));
                      //     } else {
                      //       dateTime.subtract(Duration(days: index));
                      //     }
                      //      to = DateFormat('dd/MM/yyyy').format(dateTime);
                      //
                      //     textEditingController.text =
                      //         start + " - " + to;
                      //     setState(() {});
                      //   },
                      //   buttons: ["วันนี้", "เมื่อวาน", "7 วัน", "30 วัน"],
                      //   borderRadius: BorderRadius.circular(20.0),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Text(
                        Languages.of(context)!.date_range,
                        style: const TextStyle(
                          color: ColorCustom.black,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorCustom.greyBG2),
                          color: ColorCustom.greyBG2,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            pickDateStart();
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
                                  controller: textEditingController,
                                  enabled: false,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
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
                        // child: DateViewRangeCustom2View(
                        //   controller: textEditingController,
                        //   limit: 1,
                        //   dateSelect: start,
                        //   returnDate: (value) {
                        //     // start = DateFormat('yyyy-MM-dd')
                        //     //     .format(value.start);
                        //     // to = DateFormat('yyyy-MM-dd')
                        //     //     .format(value.end);
                        //     if (value.start.isSameDate(DateTime.now()) ||
                        //         value.start.isAfter(DateTime.now())) {
                        //       timeStart =
                        //           DateFormat("HH:mm").parse("00:00");
                        //       timeEnd = DateTime.now();
                        //       var s = DateFormat('HH:mm').format(timeStart);
                        //       var e = DateFormat('HH:mm').format(timeEnd);
                        //       timeString = s + " - " + e;
                        //     } else {
                        //       timeStart =
                        //           DateFormat("HH:mm").parse("00:00");
                        //       timeEnd = DateFormat("HH:mm").parse("23:59");
                        //       var s = DateFormat('HH:mm').format(timeStart);
                        //       var e = DateFormat('HH:mm').format(timeEnd);
                        //       timeString = s + " - " + e;
                        //     }
                        //     setState(() {});
                        //     start = value.start;
                        //     to = value.end;
                        //   },
                        // ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        Languages.of(context)!.time_range,
                        style: const TextStyle(
                          color: ColorCustom.black,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorCustom.greyBG2),
                          color: ColorCustom.greyBG2,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            // pickTimeStart();
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
                                // child: TimeViewCustom(
                                //   returnDate: (value) {
                                //     DateTime formatedDate = DateFormat('HH:mm').parseLoose(value.startTime.hour.toString()+":"+value.startTime.minute.toString());
                                //     DateTime formatedDate2 = DateFormat('HH:mm').parseLoose(value.endTime.hour.toString()+":"+value.endTime.minute.toString());
                                //     // timeStart = value.startTime.hour.toString() +
                                //     //     ":" +
                                //     //     value.startTime.minute.toString();
                                //     // timeEnd = value.endTime.hour.toString() +
                                //     //     ":" +
                                //     //     value.endTime.minute.toString();
                                //
                                //     timeStart = formatedDate;
                                //     timeEnd = formatedDate2;
                                //   },
                                //   controller: timeController,
                                // ),
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    timeString,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
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
                      ),
                      Expanded(child: Container()),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorCustom.primaryColor,
                            padding: const EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            submit();
                          },
                          child: Text(
                            Languages.of(context)!.search,
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
