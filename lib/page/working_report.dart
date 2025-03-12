import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:iov/api/api.dart';
import 'package:iov/localization/language/language_en.dart';
import 'package:iov/localization/language/language_jp.dart';
import 'package:iov/localization/language/language_th.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/model/dropdown.dart';
import 'package:iov/model/vehicle_info.dart';
import 'package:iov/page/time_table.dart';

import 'package:iov/utils/color_custom.dart';
import 'package:iov/utils/utils.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class WorkingReportPage extends StatefulWidget {
  const WorkingReportPage({Key? key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<WorkingReportPage> {
  List<Dropdown> listDropdown = [];
  bool checkSucceed = false;

  bool checkNewSearch = false;

  @override
  initState() {
    setData();
    super.initState();
  }

//----new dom
  String vidVehicle = '';
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  setData() async {
    timeStart = dateTime.subtract(Duration(
        hours: dateTime.hour,
        minutes: dateTime.minute,
        seconds: dateTime.second,
        milliseconds: dateTime.millisecond,
        microseconds: dateTime.microsecond));
    timeEnd = DateTime.now();
    timeString =
        "${DateFormat('HH:mm').format(timeStart)} - ${DateFormat('HH:mm').format(DateTime.now())}";
    strTime =
        "${DateFormat('HH:mm:ss').format(timeStart)}/${DateFormat('HH:mm:ss').format(DateTime.now())}";
    textEditingController.text = dateString;
    if (Api.language == "en") {
      listDropdown.add(Dropdown("1", LanguageEn().plate_no));
      listDropdown.add(Dropdown("2", LanguageEn().vehicle_name));
      listDropdown.add(Dropdown("3", LanguageEn().vin_no));
    } else if (Api.language == "ja") {
      listDropdown.add(Dropdown("1", LanguageJp().plate_no));
      listDropdown.add(Dropdown("2", LanguageJp().vehicle_name));
      listDropdown.add(Dropdown("3", LanguageJp().vin_no));
    } else {
      listDropdown.add(Dropdown("1", LanguageTh().plate_no));
      listDropdown.add(Dropdown("2", LanguageTh().vehicle_name));
      listDropdown.add(Dropdown("3", LanguageTh().vin_no));
    }

    await getVehicleByDealer();

    if (listInfoVehicleByDealer.isNotEmpty) {
      isLoading = false;
      refresh();
    }
  }

  selectInfoVehicle(String id) {
    debugPrint('selectInfoVehicle: $id');
    setState(() {
      vidVehicle = id;
    });
  }

//ชุดข้อมูลค้นหา
  String dtstart = '';
  String dtstop = '';

//------------------------

  bool isLoading = true;

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

  var timeString = "00:00 - 23:59";
  var strTime = "00:00:00/23:59:59";
  var dateString = DateFormat('dd MMM yy', Api.language).format(DateTime.now());
  var strDate = DateFormat.yMd().format(DateTime.now());

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
                          var inputFormat = DateFormat('dd/MM/yyyy HH:mm');

                          start = selectedDate;
                          to = selectedDate;
                          var s = DateFormat('dd MMM yy', Api.language)
                              .format(start);
                          var e =
                              DateFormat('dd MMM yy', Api.language).format(to);
                          var ss = DateFormat.yMd().format(start);
                          var ee = DateFormat.yMd().format(to);
                          if (start.isBefore(to) && !start.isSameDate(to)) {
                            dateString = "$s - $e";
                            strDate = "$ss/$ee";
                          } else {
                            dateString = s;
                            strDate = ss;
                          }

                          if (start.isSameDate(DateTime.now()) ||
                              start.isAfter(DateTime.now())) {
                            timeStart = DateFormat("HH:mm").parse("00:00");
                            timeEnd = DateTime.now();
                            var s = DateFormat('HH:mm').format(timeStart);
                            var e = DateFormat('HH:mm').format(timeEnd);
                            timeString = "$s - $e";
                            var st = DateFormat('HH:mm:ss').format(timeStart);
                            var et = DateFormat('HH:mm:ss').format(timeEnd);

                            strTime = "$st/$et";
                          } else {
                            timeStart = DateFormat("HH:mm").parse("00:00");
                            timeEnd = DateFormat("HH:mm").parse("23:59");
                            var s = DateFormat('HH:mm').format(timeStart);
                            var e = DateFormat('HH:mm').format(timeEnd);
                            timeString = "$s - $e";
                            var st = DateFormat('HH:mm:ss').format(timeStart);
                            var et = DateFormat('HH:mm:ss').format(timeEnd);
                            strTime = "$st/$et";
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
                          var ss = DateFormat.yMd().format(start);
                          var ee = DateFormat.yMd().format(to);
                          if (start.isBefore(to) && !start.isSameDate(to)) {
                            dateString = "$s - $e";
                            strDate = "$ss/$ee";
                          } else {
                            dateString = s;
                            strDate = ss;
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
      return start.add(const Duration(days: 6));
    }
  }

  submit() async {
    if (dtstart != '' || dtstop != '' || vidVehicle != '') {
      setState(() {
        isLoading = true;
      });
      refresh();

      // debugPrint('submitx34 strDate: $strDate');
      // debugPrint('submitx34 strTime: $strTime');
      String dtstart = '';
      String dtstop = '';
      List<String> listDate = [];
      List<String> listTime = [];
      listDate = strDate.split('/');
      listTime = strTime.split('/');
      // debugPrint('submitx34 listTime: $listTime');
      // debugPrint('submitx34 listDateS: $listDate');

      for (var i = 0; i < listDate.length; i++) {
        if (listDate[i].length == 1) {
          listDate[i] = '0${listDate[i]}';
        }
      }

      if (listDate.length > 3) {
        dtstart = "${listDate[2]}-${listDate[0]}-${listDate[1]} ${listTime[0]}";
        dtstop = "${listDate[5]}-${listDate[3]}-${listDate[4]} ${listTime[1]}";
      } else {
        dtstart = "${listDate[2]}-${listDate[0]}-${listDate[1]} ${listTime[0]}";
        dtstop = "${listDate[2]}-${listDate[0]}-${listDate[1]} ${listTime[1]}";
      }

      // debugPrint('submitx34 vidVehicle: $vidVehicle');
      // debugPrint('submitx34 dtstart: $dtstart');
      // debugPrint('submitx34 dtstop: $dtstop');

      showNoti(dtstart, dtstop, int.parse(vidVehicle));
    } else {
      Utils.showAlertDialog(context, 'ข้อมูลไม่ถูกต้อง');
    }
  }

  Future<Map> getApiReportWorking(Map mapData, int id) async {
    debugPrint('getApiReportWorking: mapData $mapData id $id');
    try {
      String url = "${Api.report_working}$id";
      // print(url);
      final http.Response response = await http.post(
        Uri.parse(url),
        body: jsonEncode(mapData),
        headers: {'Content-Type': 'application/json'},
      );
      log('getApiReportWorking response--->${jsonDecode(response.body)}');
      Map data = {};
      if (response.body.isNotEmpty) {
        data = {
          "code": 1,
          "body": jsonDecode(response.body),
        };
        return data;
      } else {
        data = {
          "code": 0,
          "body": 'error',
        };
        return data;
      }
    } on Exception {
      Map data = {
        "code": 0,
        "body": "error",
      };
      return data;
    } catch (error) {
      Map data = {
        "code": 0,
        "body": "error",
      };
      return data;
    }
  }

  showNoti(String sdate, edate, int vid) async {
    try {
      Map param = {"dtstart": sdate, "dtstop": edate};
      final Map dataRespon = await getApiReportWorking(param, vid);

      var data = dataRespon['body'];
      debugPrint('getinfoReportWorking-data: $data');
      var dataVehicleData = data['vehicle_data'];
      var dataWorkingData = data['working_data'];

      if (dataWorkingData.length > 0) {
        isDialOpen.value = false;
        // showBarModalBottomSheet(
        //   expand: true,
        //   context: context,
        //   backgroundColor: Colors.transparent,
        //   builder: (context) => HistoryWorkVehicle(dataVehicleData, dataWorkingData),
        // );
        setState(() {
          isLoading = false;
        });

        showBarModalBottomSheet(
          expand: true,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => TimeTable(dataVehicleData, dataWorkingData),
        ).whenComplete(() {
          setState(() {
            dtstart = '';
            dtstop = '';
            vidVehicle = '';

            textEditingController.text =
                DateFormat('dd MMM yy', Api.language).format(DateTime.now());
          });
          refresh();
        });

        //TestTimeTable
      } else {
        Utils.showAlertDialog(context, 'Data Not Found');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      Utils.showAlertDialog(context, 'Data Not Found');
      setState(() {
        isLoading = false;
      });
    }
  }

  // String imei = "";
  Dropdown? dropdown;

//----------------
//getVehicleByDealer
  Future<Map> getApiVehicleByDealer(Map mapData) async {
    try {
      // Encode parameters to the query string
      String queryString = Api.buildQueryString(mapData);

      String url = "${Api.vehicle_by_dealer}?$queryString";

      final http.Response response =
          await http.get(Uri.parse(url), headers: Api.requestHeaders);
      debugPrint('getApiVehicle response--->${jsonDecode(response.body)}');
      Map data = {};
      if (response.body.isNotEmpty) {
        data = {
          "code": 1,
          "body": jsonDecode(response.body),
        };
        return data;
      } else {
        data = {
          "code": 0,
          "body": 'error',
        };
        return data;
      }
    } on Exception {
      Map data = {
        "code": 0,
        "body": "error",
      };
      return data;
    } catch (error) {
      Map data = {
        "code": 0,
        "body": "error",
      };
      return data;
    }
  }

  List<InfoVehicle> listInfoVehicleByDealer = [];

  getVehicleByDealer() async {
    listInfoVehicleByDealer = [];
    Map param = {"user_id": Api.profile!.userId, "dealer_id": "all"};
    final Map dataRespon = await getApiVehicleByDealer(param);
    for (var i = 0; i < dataRespon['body'].length; i++) {
      var dataVid = dataRespon['body'][i]['vid'];
      var dataChassisNo = dataRespon['body'][i]['chassis_no'];
      var dataEngineNo = dataRespon['body'][i]['engine_no'];
      print("$dataVid , $dataChassisNo , $dataEngineNo");
      listInfoVehicleByDealer.add(InfoVehicle(
        vid: dataVid ??= 0,
        fleetId: 0,
        modelCode: "",
        chassisNo: dataChassisNo ??= "",
        customerId: 0,
        engineNo: dataEngineNo ??= "",
      ));
    }
  }

//--------------

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 20, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(),
                      const SizedBox(
                        height: 10,
                      ),
                      //   _buildSearchIDVehicle(context),
                      _buildSearchDD(context),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildDateRange(),
                      const SizedBox(
                        height: 10,
                      ),
                      // _buildTimeRange(),
                      Expanded(child: Container()),
                      _buildSave()
                    ],
                  ),
                ),
        ),
      ),
    );
  }

//-----------------
  _buildLabel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.history_rounded,
          color: Colors.grey,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          Languages.of(context)!.start_date,
          style: TextStyle(
            color: ColorCustom.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Dropdown? dropdown;
  _buildSearchDD(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'เลขรถ',
          style: TextStyle(
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
            child: Container(
              //FIXME : DropdownSearch options[hint,mode,dropdownSearchDecoration,showAsSuffixIcons,dropdownButtonBuilder,showSelectedItems,searchFieldProps,showSearchBox].
              child: DropdownSearch<InfoVehicle>(
                // validator: (v) => v == null ? "required field" : null,
                validator: (value) {
                  value == null ? "required field" : null;
                  return null;
                },
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    controller: textEditingController,
                  ),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'เลือกเลขรถ',
                    hintText: 'เลือกเลขรถ',
                    suffixIcon: IconButton(
                      padding: EdgeInsets.all(8.0),
                      icon: Icon(Icons.keyboard_arrow_down),
                      color: Colors.grey,
                      onPressed: () {},
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                // hint: 'เลือกเลขรถ',
                // mode: Mode.MENU,
                // dropdownSearchDecoration: const InputDecoration(
                //     border: OutlineInputBorder(
                //   borderSide: BorderSide.none,
                // )),
                // showAsSuffixIcons: true,
                // dropdownButtonBuilder: (_) => const Padding(
                //   padding: EdgeInsets.all(8.0),
                //   child: Icon(
                //     Icons.keyboard_arrow_down,
                //     color: Colors.grey,
                //   ),
                // ),
                filterFn: (item, filter) {
                  if (item.chassisNo.contains(filter)) {
                    return true;
                  } else {
                    return false;
                  }
                },
                // showSelectedItems: true,
                items: listInfoVehicleByDealer,
                onChanged: (value) {
                  // widget.onChanged.call(value!);
                  selectInfoVehicle(value!.vid.toString());
                },
                itemAsString: (item) {
                  return item.chassisNo;
                },
                // selectedItem: defDropdownGeneral(widget.selectItem),
                // searchFieldProps: TextFieldProps(
                //   controller: textEditingController,
                // ),
                compareFn: (item, selectedItem) {
                  if (item.chassisNo.contains(selectedItem.chassisNo)) {
                    return true;
                  } else {
                    return false;
                  }
                },
                // showSearchBox: true,
              ),
            )),
      ],
    );
  }

  String _displayStringForOption(InfoVehicle option) => option.chassisNo;

  _buildSearchIDVehicle(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    TextEditingController textControllerBackUp = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'เลือกเลขรถ',
          style: TextStyle(
            overflow: TextOverflow.fade,
            fontSize: 16,
            color: Colors.black,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w300,
            height: 1.5,
            textBaseline: TextBaseline.alphabetic,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          // height: 40,
          margin: const EdgeInsets.only(top: 0),
          decoration: BoxDecoration(
            border: Border.all(color: ColorCustom.greyBG2),
            color: ColorCustom.greyBG2,
            borderRadius: const BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Autocomplete<InfoVehicle>(
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController fieldTextEditingController,
                      FocusNode fieldFocusNode,
                      VoidCallback onFieldSubmitted) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        onTap: () {
                          if (fieldTextEditingController.text != '') {
                            setState(() {
                              fieldTextEditingController.text = '';
                            });
                          }
                        },
                        cursorColor: const Color.fromARGB(255, 121, 121, 121),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'เลือกเลขรถ';
                          }

                          return null;
                        },
                        //  autofocus: true,
                        decoration: const InputDecoration(
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.black),
                          hintText: 'เลือกเลขรถ',
                        ),
                        style: const TextStyle(
                          overflow: TextOverflow.fade,
                          fontSize: 16,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w300,
                          height: 1.5,
                          textBaseline: TextBaseline.alphabetic,
                        ),
                        textAlign: TextAlign.start,

                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                      ),
                    );
                  },
                  displayStringForOption: _displayStringForOption,
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    return listInfoVehicleByDealer.where((InfoVehicle option) {
                      return option.chassisNo
                          .toString()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  // optionsBuilder: (TextEditingValue textValue) {
                  //    return listInfoVehicleByDealer.where(
                  //       (InfoVehicle element) => element.chassisNo
                  //           .toLowerCase()
                  //           .startsWith(textValue.text.toLowerCase()));
                  // },
                  onSelected: (selectedValue) {
                    setState(() {
                      textControllerBackUp.text = selectedValue.chassisNo;
                      debugPrint(
                          'textControllerBackUp2: ${textControllerBackUp.text}');
                    });
                    selectInfoVehicle(selectedValue.vid.toString());
                    //  onClickSelectionDealer(selectedValue.chassisNo);
                  },
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
                size: 25,
              )
            ],
          ),
        ),
      ],
    );
  }

  _buildDateRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        ),
      ],
    );
  }

  _buildSave() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorCustom.primaryColor,
          padding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
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
    );
  }

//------------------
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
