import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math' as math;
import 'package:iov/api/api.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iov/model/history_work_vehicle.dart';
import 'package:iov/widget/back_ios.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:timetable_view/timetable_view.dart';

import '../../utils/color_custom.dart';

class TimeTable extends StatefulWidget {
  // late String dtstart;
  // late String dtstop;
  // late int vid;
  late dynamic dataVehicleData;
  late dynamic dataWorkingData;

  TimeTable(this.dataVehicleData, this.dataWorkingData, {Key? key})
      : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TimeTable> {
  ScrollController sc_controller = ScrollController();

  bool isLoading = true;
  var rng = math.Random();
  Widget h10 = const SizedBox(
    height: 10,
  );

  Widget w10 = const SizedBox(
    width: 10,
  );
  late TooltipBehavior _tooltip;
  List<_ChartData> data = [];

  @override
  initState() {
    getinfoReportWorking();
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  ModelDataHistoryWorkVehicle mdDataHistoryWorkVehicle =
      ModelDataHistoryWorkVehicle();

  getinfoReportWorking() async {
    mdDataHistoryWorkVehicle.mdVehicleData =
        await setMdVehicleData(widget.dataVehicleData);
    mdDataHistoryWorkVehicle.mdWorkingData =
        await setMdWorkingData(widget.dataWorkingData);
  }

  setMdVehicleData(dataVehicleData) {
    ModelVehicleData mdVehicleData = ModelVehicleData();
    mdVehicleData.vid = dataVehicleData['vid'] ??= 0;
    mdVehicleData.vehicleName = dataVehicleData['vehicle_name'] ??= "";
    mdVehicleData.vinNo = dataVehicleData['vin_no'] ??= "";
    mdVehicleData.modelCode = dataVehicleData['model_code'] ??= "";
    mdVehicleData.chassisNo = dataVehicleData['chassis_no'] ??= "";
    mdVehicleData.engineNo = dataVehicleData['engine_no'] ??= "";
    mdVehicleData.dealerName = dataVehicleData['dealer_name'] ??= "";
    mdVehicleData.customerName = dataVehicleData['customer_name'] ??= "";
    mdVehicleData.phone = dataVehicleData['phone'] ??= "";
    mdVehicleData.leasedNo = dataVehicleData['leased_no'] ??= "";
    mdVehicleData.deliveryDate = dataVehicleData['delivery_date'] ??= "";
    mdVehicleData.engineHour = dataVehicleData['engine_hour'] ??= 0.0;
    mdVehicleData.location = dataVehicleData['location'] ??= "";
    mdVehicleData.gpsDate = dataVehicleData['gps_date'] ??= "";
    mdVehicleData.workingHourStart =
        dataVehicleData['working_hour_start'] ??= 0;
    mdVehicleData.workingHourStop = dataVehicleData['working_hour_stop'] ??= 0;
    mdVehicleData.workingHour = dataVehicleData['working_hour'] ??= 0;
    setState(() {});
    return mdVehicleData;
  }

  List<ModelWorkingData> lmdWorkingData = [];

  ModelTimeChart mdTimeChart = ModelTimeChart(
      id: 0, sDate: '', sTime: '', listPointStartTime: [], listDiffTime: []);

  List<ModelTimeChart> listMdTimeChart = [];

  setMdWorkingData(dataWorkingData) {
    debugPrint('dataWorkingData.length: ${dataWorkingData.length}');
    for (var i = 0; i < dataWorkingData.length; i++) {
      debugPrint(
          'mdWorkingData: sData ${dataWorkingData[i]['date'].toString()}');
      List<ModelWorkDate> listMd = [];
      for (var j = 0; j < dataWorkingData[i]['working'].length; j++) {
        debugPrint(
            'dataWorkingData: ${dataWorkingData[i]['working'][j]['start']}');
        listMd.add(ModelWorkDate(
            start: dataWorkingData[i]['working'][j]['start'].toString(),
            stop: dataWorkingData[i]['working'][j]['stop'].toString()));
      }

//return ทุกอย่างลับมาที่นี่  listใหญ่จะต้องได้ listเดียว

      lmdWorkingData.add(ModelWorkingData(
          sData: dataWorkingData[i]['date'].toString(),
          totalWorkingInHour:
              dataWorkingData[i]['total_working_in_hour'].toString(),
          working: listMd));
    }

    // dev.log('lmdWorkingData1: $lmdWorkingData');

    //ถึงตรงนี้ใช้ได้

    for (var i = 0; i < lmdWorkingData.length; i++) {
      //  Map map =  calRankTime(lmdWorkingData[i].working);
      List<double> listPointStartTime = [];
      List<double> listDiffTime = [];
      for (var j = 0; j < lmdWorkingData[i].working.length; j++) {
        double hourPass = 0; // ชั่วโมงที่ผ่านมา
        double hourMod = 0; // เศษของชั่วโมงเริ่ม
        double barWidth = 60; // ความกว้างของช่อง
        double timeDiff = 0; //ความต่างช่วงเวลา
        int hourst = 0;
        int minutest = 0;
        int houren = 0;
        int minuteen = 0;

        List<List<String>> list2S = [];
        List<List<String>> list2E = [];
        String strS = lmdWorkingData[i].working[j].start.split(' ')[1];
        String strE = lmdWorkingData[i].working[j].stop.split(' ')[1];

        List<String> splitTime = strS.split(':');
        hourPass = double.parse(splitTime[0]);
        dev.log('hour_pass: $hourPass');
        hourMod = double.parse(splitTime[1]);
        dev.log('hour_mod: $hourMod');
        var format = DateFormat("HH:mm");
        var start = format.parse(strE);
        var end = format.parse(strS);

        if (start.isAfter(end)) {
          end = end.add(const Duration(days: 0));
          Duration diff = end.difference(start).abs();
          final hours = diff.inHours;
          final minutes = diff.inMinutes % 60;
          print('$hours hours $minutes minutes');
          if (hours > 0) {
            timeDiff = hours * 60 + timeDiff;
          }
          timeDiff = minutes + timeDiff;
        }
        setState(() {
          listPointStartTime.add((hourPass * barWidth) + hourMod);

          listDiffTime.add(timeDiff);
        });
      }

      dev.log('xa-id: $i');
      dev.log('xa-sDate: ${lmdWorkingData[i].sData.toString()}');
      dev.log('xa-sTime: ${lmdWorkingData[i].totalWorkingInHour.toString()}');
      dev.log('xa-listPointStartTime: $listPointStartTime');
      dev.log('xa-listDiffTime: $listDiffTime');

      // setState(() {
      listMdTimeChart.add(ModelTimeChart(
        id: i,
        sDate: lmdWorkingData[i].sData.toString(),
        sTime: lmdWorkingData[i].totalWorkingInHour.toString(),
        listPointStartTime: listPointStartTime,
        listDiffTime: listDiffTime,
      ));
      // });
    }
    dev.log('xa-res: ${listMdTimeChart.toString()}');
    setState(() {
      showDateSart = lmdWorkingData[0].sData;
      showDateEnd = lmdWorkingData[lmdWorkingData.length - 1].sData;
      chkData = true;
    });
  }

  String showDateSart = '';
  String showDateEnd = '';
  bool chkData = false;

  convertDate(String strDate, int length, String strTime) {
    String setDate = '';
    List<String> listDate = [];
    listDate = strDate.split('-');

    String year = '';
    if (length >= 5) {
      year =
          '${int.parse(listDate[0][2].toString())}${int.parse(listDate[0][3].toString())}';
      setDate =
          '${int.parse(listDate[2].toString())}/${int.parse(listDate[1].toString())}/$year\n\n $strTime ซม.';
    } else {
      year = '${int.parse(listDate[0].toString())}';
      setDate =
          '${int.parse(listDate[2].toString())}/${int.parse(listDate[1].toString())}/$year\n\n $strTime ซม.';
    }

    return setDate;
  }

  convertDateForShow(String strDate) {
    String setDate = '';
    List<String> listDate = [];
    listDate = strDate.split('-');
    String year = '';
    setDate =
        '${int.parse(listDate[2].toString())}/${int.parse(listDate[1].toString())}/${int.parse(listDate[0].toString())}';
    return setDate;
  }

  convertItem(List<ModelWorkDate> working, String name, int index) {
    debugPrint('convertItem working: ${working.length}');
    List<TableEvent> list = [];

    List<List<String>> list2S = [];
    List<List<String>> list2E = [];
    for (var i = 0; i < working.length; i++) {
      List<String> listS = [];
      List<String> listE = [];
      listS = working[i].start.split(' ');
      listE = working[i].stop.split(' ');
      list2S.add(listS);
      list2E.add(listE);
    }
    debugPrint('list2_s: $list2S');
    // debugPrint('list2_e: ${list2_e}');

    List<List<String>> list2TimeS = [];
    List<List<String>> list2TimeE = [];
    for (var i = 0; i < list2S.length; i++) {
      List<String> lTimeS = [];
      List<String> lTimeE = [];

      lTimeS = list2S[i][1].split(':');

      lTimeE = list2E[i][1].split(':');

      list2TimeS.add(lTimeS);

      list2TimeE.add(lTimeE);
    }

    // debugPrint('list2_time_s: ${list2_time_s}');
    // debugPrint('list2_time_e: ${list2_time_e}');
    var rng = math.Random();
    for (var i = 0; i < list2TimeS.length; i++) {
      debugPrint('list2_time_s ij : ${list2TimeS[i][0]} : ${list2TimeS[i][1]}');

      debugPrint('list2_time_e ij : ${list2TimeE[i][0]} : ${list2TimeE[i][1]}');

      TableEventTime startTime = TableEventTime(
          hour: int.parse(list2TimeS[i][0]),
          minute: int.parse(list2TimeS[i][1]));
      debugPrint('convertItem_startTime: $startTime');

      TableEventTime endTime = TableEventTime(
          hour: int.parse(list2TimeE[i][0]),
          minute: int.parse(list2TimeE[i][1]));

      list.add(
        TableEvent(
          title: '',
          laneIndex: i,
          eventId: rng.nextInt(100),
          startTime: startTime,
          endTime: endTime,
        ),
      );
    }

    debugPrint('endTime list : $list');

    // debugPrint('convertItem list: ${list}');
    return list;
  }

  setDataxxx(List<String> listS, List<String> listE, String s, String e) {
    debugPrint('setDataxxx listS: $listS');
    _ChartData dataCT = _ChartData('', 0);
    List<List<String>> list2TimeStart = [];
    List<List<String>> list2TimeEnd = [];
    DateTime dt1 = DateTime.parse(e);
    DateTime dt2 = DateTime.parse(s);

    Duration diff = dt1.difference(dt2);
    debugPrint('setDataxxx diff: $diff');

    List<String> listdiff = diff.toString().split(':');
    var rng = math.Random();

    for (var i = 0; i < listS.length; i++) {
      list2TimeStart.add(listS[i].split(':'));
      list2TimeEnd.add(listE[i].split(':'));
    }

    List<TableEvent> listTableEvent = [];

    if (list2TimeStart.isNotEmpty) {
      for (var i = 0; i < list2TimeStart[1].length; i++) {
        int hourst = int.parse(list2TimeStart[1][0]);
        debugPrint('hourst: $hourst');
        int minutest = int.parse(list2TimeStart[1][1]);
        debugPrint('minutest: $minutest');
        int houren = int.parse(list2TimeEnd[1][0]);
        debugPrint('houren: $houren');
        int minuteen = int.parse(list2TimeEnd[1][1]);
        debugPrint('minuteen: $minuteen');

        debugPrint(
            'setDataxxx timee: ${list2TimeStart[1][0]}:${list2TimeStart[1][1]} --${list2TimeEnd[1][0]}:${list2TimeEnd[1][1]} ');

        listTableEvent.add(
          TableEvent(
            backgroundColor: Colors.green,
            title: '',
            // แสดงช่วงเวลา
            eventId: i,
            startTime: TableEventTime(hour: hourst, minute: minutest),
            endTime: TableEventTime(hour: houren, minute: minuteen),
            laneIndex: 1,
          ),
        );

        // dataCT = _ChartData(
        //   '${list2TimeStart[1][0]}:${list2TimeStart[1][1]} --${list2TimeEnd[1][0]}:${list2TimeEnd[1][1]}',
        //   (double.parse('$hourst.$minutest') -
        //       double.parse('$houren.$minuteen')),
        // );
      }

//  LaneEvents(
//               lane: Lane(
//                 name: list2TimeStart[1].toString(),
//                 laneIndex: rng.nextInt(10),
//                 textStyle: TextStyle(fontSize: 8),
//               ),
//               events:listTableEvent,
//             );
    }

    return LaneEvents(
      lane: Lane(
        name: list2TimeStart[1].toString(),
        laneIndex: rng.nextInt(10),
        textStyle: const TextStyle(fontSize: 8),
      ),
      events: listTableEvent,
    );
  }

  Future<Map> getApiReportWorking(Map mapData, int id) async {
    try {
      // String url =
      //     "https://yanmar-qa.onelink-iot.com/prod/fleet/report/working/$id";
      // final http.Response response = await http.post(
      //   Uri.parse(url),
      //   body: jsonEncode(mapData),
      //   headers: {'Content-Type': 'application/json'},
      // );
      String url = "${Api.report_working}$id";
      // print(url);
      final http.Response response = await http.post(
        Uri.parse(url),
        body: jsonEncode(mapData),
        headers: {'Content-Type': 'application/json'},
      );

      dev.log('getApiReportWorking response--->${jsonDecode(response.body)}');
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

//-------------
  List<Widget> listWidget = [];

  List<String> listDate = [];

//เหลือหาmax
//หาผลรวม
//หาค่าเฉลี่ยระยะ

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 16);
    double mediaWidth = MediaQuery.of(context).size.width;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: chkData == false
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const BackIOS(),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: 35,
                            height: 35,
                            child: Image.asset(
                              "assets/images/car_status.png",
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            widget.dataVehicleData['vin_no'],
                            style: const TextStyle(
                              color: ColorCustom.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                        child: Row(
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
                              Languages.of(context)!.chart_vehicle_working,
                              style: TextStyle(
                                color: ColorCustom.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 151, 151, 151),
                              width: 0.2),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          children: [
                            _buildColTime(),
                            Expanded(
                              child: Scrollbar(
                                child: SingleChildScrollView(
                                  controller: sc_controller,
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Column(
                                        children: [
                                          _buildChart(),
                                          SizedBox(
                                            height: 30,
                                            child: _buildGrid(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 151, 151, 151),
                              width: 0.2),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Column(children: [
                          _buildHead(),
                          _buildBoxInfo(),
                        ]),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  double calWidth(int num) {
    debugPrint('calWidth: $num');
    double w = MediaQuery.of(context).size.width;
    double width = w - 90;
    if (num == 1) {
      return width;
    } else {
      return width / (num);
    }
  }

  void onEventTapCallBack(TableEvent event) {
    print(
        "Event Clicked!! LaneIndex ${event.laneIndex} Title: ${event.title} StartHour: ${event.startTime.hour} EndHour: ${event.endTime.hour}");
  }

  void onTimeSlotTappedCallBack(
      int laneIndex, TableEventTime start, TableEventTime end) {
    print(
        "Empty Slot Clicked !! LaneIndex: $laneIndex StartHour: ${start.hour} EndHour: ${end.hour}");
  }

  _buildHead() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 35,
              height: 35,
              child: Image.asset(
                "assets/images/car_status.png",
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              Languages.of(context)!.vehicle_title,
              style: TextStyle(
                color: ColorCustom.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  _buildRowTxt(String title, var val) {
    if (val == null) {
      val = '';
    } else {
      val = val.toString();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            title,
            // Languages.of(context)!.driver,
            style: const TextStyle(
              color: ColorCustom.black,
              fontSize: 14,
            ),
          ),
          w10,
          Text(
            val ?? '',
            // Languages.of(context)!.driver,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: ColorCustom.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  _buildBoxInfo() {
    return Row(
      children: [
        w10,
        w10,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildRowTxt(Languages.of(context)!.vehicle_model, widget.dataVehicleData['model_code']),
                  const SizedBox(
                    width: 10,
                  ),
                  _buildRowTxt(Languages.of(context)!.vin_no, widget.dataVehicleData['vin_no']),
                ],
              ),
              _buildRowTxt(Languages.of(context)!.period,
                  '${convertDateForShow(showDateSart)} - ${convertDateForShow(showDateEnd)}'),
              _buildRowTxt(
                  Languages.of(context)!.dealer, widget.dataVehicleData['dealer_name']),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Text(
                      Languages.of(context)!.current_location,
                      // Languages.of(context)!.driver,
                      style: TextStyle(
                        color: ColorCustom.black,
                        fontSize: 14,
                      ),
                    ),
                    w10,
                    Expanded(
                      child: Text(
                        widget.dataVehicleData['location'],
                        // Languages.of(context)!.driver,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: ColorCustom.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildRowTxt(Languages.of(context)!.mile, widget.dataVehicleData['working_hour']),
              _buildRowTxt(Languages.of(context)!.event_distance, widget.dataVehicleData['working_hour']),
              _buildRowTxt(Languages.of(context)!.event_fuel, widget.dataVehicleData['working_hour']),
              // _buildRowTxt(
              //     'ชื่อลูกค้า', widget.dataVehicleData['customer_name']),
              // _buildRowTxt('โทรศัพท์', widget.dataVehicleData['phone']),
              // _buildRowTxt(
              //     'วันที่ส่งมอบรถ', widget.dataVehicleData['delivery_date']),
              // _buildRowTxt(
              //     'เลขที่สัญญาไฟเบอร์', widget.dataVehicleData['leased_no']),
              // _buildRowTxt('ชั่วโมงการทำงานปัจุบัน',
              //     widget.dataVehicleData['engine_hour']),
              // _buildRowTxt('ชั่งโมงการทำงานเริ่มต้น',
              //     widget.dataVehicleData['working_hour_start']),
              // _buildRowTxt('ชั่วโมงการทำงานสิ้นสุด',
              //     widget.dataVehicleData['working_hour_stop']),
              _buildRowTxt(
                  Languages.of(context)!.driving_summary_time, widget.dataVehicleData['working_hour']),
            ],
          ),
        ),
      ],
    );
  }

  ///------------------
  ///

  _buildGrid() {
    List<Widget> list = [];

    list.add(
      Container(
        alignment: Alignment.center,
        width: 30,
        child: Column(
          children: [
            const Row(children: [
              SizedBox(
                width: 15,
                height: 10,
              ),
              SizedBox(
                width: 15,
                height: 5,
              ),
            ]),
            Container(
              width: 30,
            ),
          ],
        ),
      ),
    );
    list.add(
      Container(
        alignment: Alignment.center,
        width: 60,
        child: Column(
          children: [
            Row(children: [
              Container(
                width: 30,
                height: 5,
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      //                   <--- left side
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 30,
                height: 10,
              ),
            ]),
            Stack(
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                    ),
                    Container(
                      width: 30,
                      decoration: const BoxDecoration(
                          //  color: Color.fromARGB(255, 255, 255, 255),
                          border: Border(
                              top: BorderSide(
                        //                   <--- left side
                        color: Colors.black,
                        width: 1.0,
                      ))),
                    ),
                  ],
                ),
                const Center(
                  child: Text(
                    '00:00',
                    style: TextStyle(color: Colors.black, fontSize: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    for (var i = 1; i < 24; i++) {
      list.add(
        Container(
          alignment: Alignment.center,
          width: 60,
          child: Column(
            children: [
              Row(children: [
                Container(
                  width: 30,
                  height: 5,
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        //                   <--- left side
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 30,
                  height: 10,
                ),
              ]),
              Container(
                decoration: const BoxDecoration(
                    //  color: Color.fromARGB(255, 255, 255, 255),
                    border: Border(
                        top: BorderSide(
                  //                   <--- left side
                  color: Colors.black,
                  width: 1.0,
                ))),
                child: Center(
                  child: Text(
                    i < 10 ? '0$i:00' : '$i:00',
                    style: const TextStyle(color: Colors.black, fontSize: 8),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    list.add(
      Container(
        alignment: Alignment.center,
        width: 30,
        child: Column(
          children: [
            Row(children: [
              const SizedBox(
                width: 15,
                height: 10,
              ),
              Container(
                width: 15,
                height: 5,
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      //                   <--- left side
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ]),
            Stack(
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      decoration: const BoxDecoration(
                          //  color: Color.fromARGB(255, 255, 255, 255),
                          border: Border(
                              top: BorderSide(
                        //                   <--- left side
                        color: Colors.black,
                        width: 1.0,
                      ))),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: list,
    );
  }

  _buildDateRange() {
    return SizedBox(
      height: 30,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          controller: sc_controller,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 24,
          itemBuilder: (BuildContext context, int index) => Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 202, 202, 202),
                  //  border: Border.all(color: Colors.black),
                ),
                width: 60,
              )),
    );
  }

  _buildColTime() {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          ListView.builder(
              itemCount: listMdTimeChart.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: 30,
                    width: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(listMdTimeChart[index].sDate,
                            style: const TextStyle(fontSize: 10)),
                        Text('${listMdTimeChart[index].sTime} ชม.',
                            style: const TextStyle(
                                fontSize: 10,
                                color: ColorCustom.primaryColor,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  _buildChart() {
    List<Widget> list = [];
    for (var i = 0; i < listMdTimeChart.length; i++) {
      list.add(_buildChartItem(listMdTimeChart[i]));
    }
    return Column(
      children: list,
    );
  }

  _buildChartItem(ModelTimeChart mdTimeChart) {
    List<Widget> listWidget = [];

    listWidget.add(_buildDateRange());

    for (var i = 0; i < mdTimeChart.listPointStartTime.length; i++) {
      listWidget.add(
        Positioned(
          left: mdTimeChart.listPointStartTime[i],
          //(ชั่วโมงที่ผ่านมา * ความกว้าง) + เศษของชั่วโมงเริ่ม
          child: Container(
            height: 30,
            width: mdTimeChart.listDiffTime[i], //ส่วนต่างเวลา  00F700
            alignment: Alignment.center,
            decoration:
                const BoxDecoration(color: Color(0xFF00F700), boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 206, 206, 206),
                blurRadius: 4,
                offset: Offset(1, 2), // Shadow position
              ),
            ]),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Row(
          children: [
            Stack(children: listWidget),
          ],
        ),
        //   ],
        // ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.txt, this.num);

  final String txt;
  final double num;
}

class ModelTimeChart {
  int id;
  String sDate;
  String sTime;
  List<double> listPointStartTime;
  List<double> listDiffTime;

  ModelTimeChart({
    required this.id,
    required this.sDate,
    required this.sTime,
    required this.listPointStartTime,
    required this.listDiffTime,
  });

  factory ModelTimeChart.fromJson(Map<String, dynamic> json) {
    return ModelTimeChart(
      id: json['id'],
      sDate: json['sDate'],
      sTime: json['sTime'],
      listPointStartTime: json['listPointStartTime'],
      listDiffTime: json['listDiffTime'],
    );
  }

  @override
  String toString() {
    return 'ModelTimeChart{id:$id,sDate:$sDate,sTime:$sTime,listPointStartTime:$listPointStartTime,listDiffTime:$listDiffTime}';
  }
}
