import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iov/api/api.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/model/chart_data.dart';
import 'package:iov/model/dashboard.dart';
import 'package:iov/model/dashboard_data.dart';
import 'package:iov/model/dashboard_driver.dart';
import 'package:iov/model/dashboard_realtime.dart';
import 'package:iov/model/eco.dart';
import 'package:iov/model/safety.dart';
import 'package:iov/model/vehicle.dart';
import 'package:iov/page/dashboard_filter.dart';
import 'package:iov/page/home_backup_event.dart';
import 'package:iov/page/home_realtime.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:iov/utils/utils.dart';
import 'package:intl/intl.dart';

import 'package:radar_chart/radar_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'home_driver_detail.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({
    Key? key,
  }) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the S

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomeDashboardPage>
    with SingleTickerProviderStateMixin {
  Timer? timer;
  TextEditingController textGrey = TextEditingController();

  @override
  void initState() {
    getData(context);
    getDataRealtime(context);
    getDataDriver(context);
    timer = Timer.periodic(const Duration(seconds: 15), (Timer t) {
      getDataRealtime(context);
      getDataDriver(context);
    });
    tabController = TabController(vsync: this, length: 2);
    tabController?.addListener(() {
      indexTab = tabController!.index;
      refresh();
    });
    var s = DateFormat('dd MMM yy', Api.language).format(start);
    var e = DateFormat('dd MMM yy', Api.language).format(to);
    dateString = "$s - $e";
    textEditingController.text = dateString;
    textGrey.text =
        DateFormat('dd MMM yy', Api.language).format(DateTime.now());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    listNameGroup = [];
    isAll = true;
    for (Vehicle v in listVehicle) {
      v.isSelect = true;
    }

    super.dispose();
  }

  List listVid = [];

  Dashboard? dashboard;
  List<DashboardData> dashboardDatas = [];
  int drive = 0;
  int parking = 0;
  int idle = 0;
  int offline = 0;
  int sum = 0;

  TextEditingController dateEditController = TextEditingController();

  getData(BuildContext context) {
    setState(() {
      // Update the data source here
      dashboard = null;
      dashboardDatas = [];
      drive = 0;
      parking = 0;
      idle = 0;
      offline = 0;
      sum = 0;
    });


    var a = DateFormat('yyyy-MM-dd').format(start);
    var b = DateFormat('yyyy-MM-dd').format(to);
    // dateEditController.text = a + " - " + b;
    var param = jsonEncode(<dynamic, dynamic>{
      "start_date": a,
      "stop_date": b,
      "vid_list": listVid
    });
    print('start_date: $a stop_date: $b');
    Api.post(context, Api.dashboard_summary, param).then((value) => {
          if (value != null)
            {
              // dashboard = Dashboard.fromJson(value["result"]),
              // value['result'].forEach((v) {
              //   if (v is List<dynamic>) {
              //     print("List");
              //   } else {
              //     // Map<String, dynamic>
              //     print("Map");
              //   }
              //   dashboardDatas.add(DashboardData.fromJson(v));
              // }),

              dashboard = Dashboard.fromJson(value['result']["summary"]),
              initChart(dashboard!),
              dashboardDatas = List.from(value['result']["date"])
                  .map((a) => DashboardData.fromJson(a))
                  .toList(),
              dashboardDatas.removeRange(7, dashboardDatas.length),

              for (DashboardData data in dashboardDatas)
                {
                  // print(data.driv!.toString()),
                  drive += data.driv!,
                  parking += data.park!,
                  idle += data.idle!,
                  offline += data.offline!,
                },
              sum = drive + parking + idle + offline,
              // print(sum.toString()),

              refresh(),
            }
          else
            {}
        });
  }

  int calCarCount(int type, int car) {
    // print("type:"+type.toString());
    // print("car:"+car.toString());
    return ((24 * car * type) / 100).round();
  }

  List<ChartData> listCircle = [];
  DashboardRealtime? dashboardRealtime;
  int sumRealtime = 0;

  getDataRealtime(BuildContext context) {
    sumRealtime = 0;
    listCircle.clear();
    Api.get(context, Api.dashboard_realtime).then((value) => {
          if (value != null)
            {
              dashboardRealtime = DashboardRealtime.fromJson(value["result"]),
              listCircle.add(ChartData(
                  name: dashboardRealtime!.ioNameDriving,
                  value: dashboardRealtime!.unitDriving!,
                  color: hexToColor(dashboardRealtime!.ioColorDriving!))),
              listCircle.add(ChartData(
                  name: dashboardRealtime!.ioNameParking,
                  value: dashboardRealtime!.unitParking!,
                  color: hexToColor(dashboardRealtime!.ioColorParking!))),
              listCircle.add(ChartData(
                  name: dashboardRealtime!.ioNameIdling,
                  value: dashboardRealtime!.unitIdling!,
                  color: hexToColor(dashboardRealtime!.ioColorIdling!))),
              listCircle.add(ChartData(
                  name: dashboardRealtime!.ioNameOverspeed,
                  value: dashboardRealtime!.unitOverspeed!,
                  color: hexToColor(dashboardRealtime!.ioColorOverspeed!))),
              listCircle.add(ChartData(
                  name: dashboardRealtime!.ioNameOffline,
                  value: dashboardRealtime!.unitOffline!,
                  color: hexToColor(dashboardRealtime!.ioColorOffline!))),
              sumRealtime = dashboardRealtime!.unitDriving! +
                  dashboardRealtime!.unitParking! +
                  dashboardRealtime!.unitIdling! +
                  dashboardRealtime!.unitOverspeed! +
                  dashboardRealtime!.unitOffline!,
              refresh(),
            }
          else
            {}
        });
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  DashboardDriver? dashboardDriver;
  List<ChartData> listCircleDriver = [];
  int sumDriver = 0;

  getDataDriver(BuildContext context) {
    listCircleDriver.clear();
    Api.get(context, Api.dashboard_driver).then((value) => {
          if (value != null)
            {
              dashboardDriver = DashboardDriver.fromJson(value["result"]),
              listCircleDriver.add(ChartData(
                  name: dashboardDriver!.ioNameSwipecard,
                  value: dashboardDriver!.unitSwipecard,
                  color: hexToColor(dashboardDriver!.ioColorSwipecard!))),
              listCircleDriver.add(ChartData(
                  name: dashboardDriver!.ioNameNotSwipecard,
                  value: dashboardDriver!.unitNotSwipecard,
                  color: hexToColor(dashboardDriver!.ioColorNotSwipecard!))),
              listCircleDriver.add(ChartData(
                  name: dashboardDriver!.ioNameValidate,
                  value: dashboardDriver!.unitValidate,
                  color: hexToColor(dashboardDriver!.ioColorValidate!))),
              sumDriver = dashboardDriver!.unitValidate! +
                  dashboardDriver!.unitNotSwipecard! +
                  dashboardDriver!.unitSwipecard!,
              refresh(),
            }
          else
            {}
        });
  }

  refresh() {
    setState(() {});
  }

  List<String> features = [];
  List<double> avg = [];
  List<double> point = [];

  List<String> features2 = [];
  List<double> avg2 = [];
  List<double> point2 = [];

  var start = DateTime.now().subtract(const Duration(
    days: 6,
  ));
  var to = DateTime.now();

  double sumPoint = 0;
  double sumPoint2 = 0;

  initChart(Dashboard dashboard) {
    sumPoint = 0;
    sumPoint2 = 0;
    features = [];
    avg = [];
    point = [];

    features2 = [];
    avg2 = [];
    point2 = [];
    for (Eco eco in dashboard.eco) {
      features.add(Utils.mapEcoName(eco.arg!));
      avg.add(eco.avg! / 5);
      point.add(eco.point! / 5);
      sumPoint += eco.avg!;
    }

    for (Safety safe in dashboard.safety) {
      // features2.add(safe.arg!);
      features2.add(Utils.mapSafetyName(safe.arg!));
      avg2.add(safe.avg! / 5);
      point2.add(safe.point! / 5);
      sumPoint2 += safe.avg!;
    }

  }

  var ticksss = [7, 14, 21, 28, 35];
  var featuresss = ["AA", "BB", "CC", "DD", "EE", "FF", "GG", "HH"];
  var datass = [
    [10, 20, 28, 5, 16, 15, 17, 6],
    [15, 1, 4, 14, 23, 10, 6, 19]
  ];

  showDia(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 50, bottom: 50),
                color: Colors.white,
                child: DashboardFilter(
                  data: (List<Vehicle> value) {
                    listVid.clear();
                    for (Vehicle v in value) {
                      listVid.add(v.info!.vid!);
                    }
                    getData(context);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  int indexTab = 0;

  TabController? tabController;

  // int  selectedDataSetIndex = 0;
  //
  // List<RadarDataSet> showingDataSets() {
  //   return rawDataSets().asMap().entries.map((entry) {
  //     var index = entry.key;
  //     var rawDataSet = entry.value;
  //
  //     // final isSelected = index == selectedDataSetIndex
  //     //     ? true
  //     //     : selectedDataSetIndex == -1
  //     //     ? true
  //     //     : false;
  //
  //     return RadarDataSet(
  //       fillColor: rawDataSet.color.withOpacity(0.2),
  //       borderColor:rawDataSet.color,
  //       entryRadius: index==0?2:2,
  //       dataEntries:
  //       rawDataSet.values.map((e) => RadarEntry(value: e)).toList(),
  //       borderWidth: index==0?2:2,
  //     );
  //   }).toList();
  // }
  //
  // List<RawDataSet> rawDataSets() {
  //   return [
  //     RawDataSet(
  //       title: '',
  //       color: ColorCustom.dashboard_save2,
  //       values: point,
  //     ),
  //     RawDataSet(
  //       title: '',
  //       color: ColorCustom.dashboard_save,
  //       values: avg,
  //     ),
  //
  //   ];
  // }
  //
  // int  selectedDataSetIndex2 = 0;
  //
  // List<RadarDataSet> showingDataSets2() {
  //   return rawDataSets2().asMap().entries.map((entry) {
  //     var index = entry.key;
  //     var rawDataSet = entry.value;
  //
  //
  //     return RadarDataSet(
  //       fillColor:rawDataSet.color.withOpacity(0.2),
  //       borderColor:rawDataSet.color,
  //       entryRadius: index==0?2:2,
  //       dataEntries:
  //       rawDataSet.values.map((e) => RadarEntry(value: e)).toList(),
  //       borderWidth: index==0?2:2,
  //     );
  //   }).toList();
  // }
  //
  // List<RawDataSet> rawDataSets2() {
  //   return [
  //     RawDataSet(
  //       title: '',
  //       color: ColorCustom.dashboard_safe2,
  //       values: point2,
  //     ),
  //     RawDataSet(
  //       title: '',
  //       color: ColorCustom.dashboard_safe,
  //       values: avg2,
  //     ),
  //
  //   ];
  // }

  Widget _tabSection(BuildContext context) {
    // List<int> list = [];
    // for(double d in point){
    //   list.add(d.round());
    // }
    // List<int> list2 = [];
    // for(double d in avg){
    //   list2.add(d.round());
    // }
    // data = [list, list2];
    // features = features.sublist(0, features.length.floor());
    // data = data
    //     .map((graph) => graph.sublist(0, features.length.floor()))
    //     .toList();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: TabBar(
              controller: tabController,
              tabs: [
                Tab(text: Languages.of(context)?.dashboardTab1),
                Tab(text: Languages.of(context)?.dashboardTab2),
              ],
              indicatorColor: ColorCustom.primaryAssentColor,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: GoogleFonts.kanit(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      dashboard != null
                          ? Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorCustom.greyBG2),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.near_me,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        Languages.of(context)!.dashboardGraph1,
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
                                  SfCartesianChart(
                                      // primaryXAxis: CategoryAxis(),
                                      // Chart title
                                      // title: ChartTitle(text: 'Half yearly sales analysis'),
                                      // Enable legend
                                      legend: const Legend(isVisible: false),
                                      // Enable tooltip
                                      primaryXAxis: CategoryAxis(
                                        majorGridLines:
                                            const MajorGridLines(width: 0),
                                        axisLabelFormatter:
                                            (axisLabelRenderArgs) {
                                          var text = "";
                                          if (axisLabelRenderArgs.text == "primaryYAxis") {
                                            text = axisLabelRenderArgs.text;
                                            if (axisLabelRenderArgs.value == 0) {
                                              text = "0 ${Languages.of(context)!.h}";
                                            } else if (axisLabelRenderArgs.value == 20) {
                                              text = "4 ${Languages.of(context)!.h}";
                                            } else if (axisLabelRenderArgs.value == 40) {
                                              text = "8 ${Languages.of(context)!.h}";
                                            } else if (axisLabelRenderArgs.value == 60) {
                                              text ="12 ${Languages.of(context)!.h}";
                                            } else if (axisLabelRenderArgs.value ==80) {
                                              text ="18 ${Languages.of(context)!.h}";
                                            } else if (axisLabelRenderArgs.value ==100) {
                                              text ="24 ${Languages.of(context)!.h}";
                                            }
                                          } else {
                                            text = Utils.getDateGraph(axisLabelRenderArgs.text);
                                          }
                                          ChartAxisLabel a = ChartAxisLabel(
                                            text,
                                            const TextStyle(
                                              color: ColorCustom.black,
                                              fontSize: 8,
                                            ),
                                          );
                                          return a;
                                        },
                                      ),
                                      primaryYAxis: NumericAxis(
                                          rangePadding: ChartRangePadding.none,
                                          axisLine: const AxisLine(width: 0),
                                          majorTickLines:
                                              const MajorTickLines(size: 0)),
                                      // tooltipBehavior:
                                      //     TooltipBehavior(enable: true),
                                      tooltipBehavior: TooltipBehavior(
                                          enable: true,
                                          shouldAlwaysShow: true,
                                          // Templating the tooltip
                                          builder: (dynamic data,
                                              dynamic point,
                                              dynamic series,
                                              int pointIndex,
                                              int seriesIndex) {
                                            // print("data "+data);
                                            // print("series "+series);
                                            int s = data.driv +
                                                data.park +
                                                data.idle +
                                                data.offline;
                                            var a =
                                                "${" ${Languages.of(context)!.driving} ${Utils.numberFormatInt(calCarCount(data.driv, dashboard!.vehicle_count))} h : " + ((data.driv * 100) / s).toStringAsFixed(1)} %";
                                            // var a = " วิ่ง " +
                                            //     Utils.numberFormatInt(
                                            //         data.driv) +
                                            //     " h : " +
                                            //     (data.driv * 100 / s)
                                            //         .toStringAsFixed(1) +
                                            //     " % ";
                                            var b =
                                                "${" ${Languages.of(context)!.ignOff} ${Utils.numberFormatInt(calCarCount(data.park, dashboard!.vehicle_count))} h : " + ((data.park * 100) / s).toStringAsFixed(1)} %";
                                            // var b = " ดับเครื่อง " +
                                            //     Utils.numberFormatInt(
                                            //         data.park) +
                                            //     " h : " +
                                            //     (data.park * 100 / s)
                                            //         .toStringAsFixed(1) +
                                            //     " % ";
                                            var c =
                                                "${" ${Languages.of(context)!.idle} ${Utils.numberFormatInt(calCarCount(data.idle, dashboard!.vehicle_count))} h : " + ((data.idle * 100) / s).toStringAsFixed(1)} %";
                                            // var c = " จอดไม่ดับเครื่อง " +
                                            //     Utils.numberFormatInt(
                                            //         data.idle) +
                                            //     " h : " +
                                            //     (data.idle * 100 / s)
                                            //         .toStringAsFixed(1) +
                                            //     " % ";
                                            var d =
                                                "${" ${Languages.of(context)!.offline} ${Utils.numberFormatInt(calCarCount(data.offline, dashboard!.vehicle_count))} h : " + ((data.offline * 100) / s).toStringAsFixed(1)} %";
                                            // var d = " ไม่ส่งข้อมูล " +
                                            //     Utils.numberFormatInt(
                                            //         data.offline) +
                                            //     " h : " +
                                            //     (data.offline * 100 / s)
                                            //         .toStringAsFixed(1) +
                                            //     " % ";

                                            return Container(
                                              child: Text(
                                                "$a\n$b\n$c\n$d",
                                                style: const TextStyle(
                                                  color: ColorCustom.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            );
                                          }),
                                      series: <CartesianSeries<DashboardData,
                                          String>>[
                                        StackedColumn100Series<DashboardData,
                                                String>(
                                            color: ColorCustom.run,
                                            dataSource: dashboardDatas,
                                            xValueMapper:
                                                (DashboardData sales, _) =>
                                                    sales.display_datetime,
                                            yValueMapper:
                                                (DashboardData sales, _) =>
                                                    sales.driv,
                                            name:
                                                Languages.of(context)!.driving,
                                            // Enable data label
                                            dataLabelSettings:
                                                const DataLabelSettings(
                                                    isVisible: false)),
                                        StackedColumn100Series<DashboardData,
                                                String>(
                                            color: ColorCustom.parking,
                                            dataSource: dashboardDatas,
                                            xValueMapper:
                                                (DashboardData sales, _) =>
                                                    sales.display_datetime,
                                            yValueMapper:
                                                (DashboardData sales, _) =>
                                                    sales.park,
                                            name: Languages.of(context)!.ignOff,
                                            // Enable data label
                                            dataLabelSettings:
                                                const DataLabelSettings(
                                                    isVisible: false)),
                                        StackedColumn100Series<DashboardData,
                                                String>(
                                            color: ColorCustom.idle,
                                            dataSource: dashboardDatas,
                                            xValueMapper:
                                                (DashboardData sales, _) =>
                                                    sales.display_datetime,
                                            yValueMapper:
                                                (DashboardData sales, _) =>
                                                    sales.idle,
                                            name: Languages.of(context)!.idle,
                                            // Enable data label
                                            dataLabelSettings:
                                                const DataLabelSettings(
                                                    isVisible: false)),
                                        StackedColumn100Series<DashboardData,
                                                String>(
                                            color: ColorCustom.offline,
                                            dataSource: dashboardDatas,
                                            xValueMapper:
                                                (DashboardData sales, _) =>
                                                    sales.display_datetime,
                                            yValueMapper:
                                                (DashboardData sales, _) =>
                                                    sales.offline,
                                            name: Languages.of(context)!.offline,
                                            // Enable data label
                                            dataLabelSettings: const DataLabelSettings(isVisible: false))
                                      ]),
                                ],
                              ),
                            )
                          : Container(),
                      dashboard != null
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Icon(
                                      Icons.circle,
                                      size: 15,
                                      color: ColorCustom.run,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      Languages.of(context)!.driving,
                                      style: const TextStyle(
                                        color: ColorCustom.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Text(
                                      "${Utils.numberFormatInt(calCarCount(drive, dashboard!.vehicle_count))} h : ${((drive * 100) / sum).toStringAsFixed(1)} %",
                                      style: const TextStyle(
                                        color: ColorCustom.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    // Text(
                                    //   Utils.numberFormatInt(calCarCount(drive, dashboard!.vehicle_count)) +
                                    //       " h : " +
                                    //       (drive * 100 / sum).toStringAsFixed(1) +
                                    //       " %",
                                    //   style: TextStyle(
                                    //     color: ColorCustom.black,
                                    //     fontSize: 12,
                                    //   ),
                                    // ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Icon(
                                      Icons.circle,
                                      size: 15,
                                      color: ColorCustom.parking,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      Languages.of(context)!.ignOff,
                                      style: const TextStyle(
                                        color: ColorCustom.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Text(
                                      "${Utils.numberFormatInt(calCarCount(parking, dashboard!.vehicle_count))} h : ${((parking * 100) / sum).toStringAsFixed(1)} %",
                                      style: const TextStyle(
                                        color: ColorCustom.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Icon(
                                      Icons.circle,
                                      size: 15,
                                      color: ColorCustom.idle,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      Languages.of(context)!.idle,
                                      style: const TextStyle(
                                        color: ColorCustom.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Text(
                                      "${Utils.numberFormatInt(calCarCount(idle, dashboard!.vehicle_count))} h : ${((idle * 100) / sum).toStringAsFixed(1)} %",
                                      style: const TextStyle(
                                        color: ColorCustom.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Icon(
                                      Icons.circle,
                                      size: 15,
                                      color: ColorCustom.offline,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      Languages.of(context)!.offline,
                                      style: const TextStyle(
                                        color: ColorCustom.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Text(
                                      "${Utils.numberFormatInt(calCarCount(offline, dashboard!.vehicle_count))} h : ${((offline * 100) / sum).toStringAsFixed(1)} %",
                                      style: const TextStyle(
                                        color: ColorCustom.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorCustom.greyBG2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/images/Fix Icon iov29.svg",
                                  width: 40,
                                  height: 40,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "${Languages.of(context)!.dashboardGraph2} (${((sumPoint * 100) / 30).toStringAsFixed(0)}/100)",
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
                            // avg.isEmpty?Container():AspectRatio(
                            //   aspectRatio: 1.3,
                            //   child: RadarChart(
                            //     RadarChartData(
                            //       radarTouchData: RadarTouchData(
                            //           touchCallback: (FlTouchEvent event, response) {
                            //             if (!event.isInterestedForInteractions) {
                            //               setState(() {
                            //                 selectedDataSetIndex = -1;
                            //               });
                            //               return;
                            //             }
                            //             setState(() {
                            //               selectedDataSetIndex =
                            //                   response?.touchedSpot?.touchedDataSetIndex ?? -1;
                            //             });
                            //           }),
                            //       dataSets: showingDataSets(),
                            //       radarBackgroundColor: Colors.transparent,
                            //       borderData: FlBorderData(show: false),
                            //       radarBorderData: const BorderSide(color: Colors.grey),
                            //       titlePositionPercentageOffset: 0.2,
                            //       titleTextStyle:
                            //       const TextStyle(color: Colors.black, fontSize: 10),
                            //       getTitle: (index) {
                            //         return features[index];
                            //       },
                            //       tickCount: 1,
                            //       ticksTextStyle:
                            //       const TextStyle(color: Colors.transparent, fontSize: 8),
                            //       tickBorderData: const BorderSide(color: Colors.grey),
                            //       gridBorderData: const BorderSide(color: Colors.grey, width: 1),
                            //     ),
                            //     swapAnimationDuration: const Duration(milliseconds: 400),
                            //   ),
                            // ),

                            avg.isEmpty
                                ? Container()
                                : RadarChart(
                                    length: avg.length,
                                    radius: 100,
                                    backgroundColor: Colors.white,
                                    initialAngle: -(pi / 2),
                                    borderStroke: 2,
                                    borderColor: Colors.grey.shade300,
                                    radialStroke: 1,
                                    radialColor: Colors.grey.shade300,
                                    vertices: [
                                      for (int i = 0; i < features.length; i++)
                                        RadarVertex(
                                          textOffset: const Offset(0.5, 0.5),
                                          radius: 20,
                                          text: Text(
                                            Utils.mapEcoName(features[i]),
                                            style: const TextStyle(
                                              color: ColorCustom.black,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                    ],
                                    radars: [
                                      RadarTile(
                                        values: point,
                                        // borderStroke: 2,
                                        // borderColor:
                                        //     ColorCustom.dashboard_save_point,
                                        backgroundColor: ColorCustom
                                            .dashboard_save_point
                                            .withOpacity(0.5),
                                      ),
                                      RadarTile(
                                        values: avg,
                                        borderStroke: 2,
                                        borderColor:
                                            ColorCustom.dashboard_save_avg,
                                        backgroundColor: Colors.transparent,
                                        // backgroundColor: ColorCustom
                                        //     .dashboard_save
                                        //     .withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.fiber_manual_record,
                                  size: 15,
                                  color: ColorCustom.dashboard_save_avg,
                                ),
                                Text(
                                  Languages.of(context)!.avg,
                                  style: const TextStyle(
                                    color: ColorCustom.black,
                                    fontSize: 12,
                                  ),
                                ),
                                const Icon(
                                  Icons.fiber_manual_record,
                                  size: 15,
                                  color: ColorCustom.dashboard_save_point,
                                ),
                                Text(
                                  Languages.of(context)!.score,
                                  style: const TextStyle(
                                    color: ColorCustom.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            // Image.asset("assets/images/driver_graph.png"),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorCustom.greyBG2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/images/Fix Icon iov30.svg",
                                  width: 40,
                                  height: 40,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "${Languages.of(context)!.dashboardGraph3} (${((sumPoint2 * 100) / 30).toStringAsFixed(0)}/100)",
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
                            // avg2.isEmpty?Container():AspectRatio(
                            //   aspectRatio: 1.3,
                            //   child: RadarChart(
                            //     RadarChartData(
                            //       radarTouchData: RadarTouchData(
                            //           touchCallback: (FlTouchEvent event, response) {
                            //             if (!event.isInterestedForInteractions) {
                            //               setState(() {
                            //                 selectedDataSetIndex = -1;
                            //               });
                            //               return;
                            //             }
                            //             setState(() {
                            //               selectedDataSetIndex =
                            //                   response?.touchedSpot?.touchedDataSetIndex ?? -1;
                            //             });
                            //           }),
                            //       dataSets: showingDataSets2(),
                            //       radarBackgroundColor: Colors.transparent,
                            //       borderData: FlBorderData(show: false),
                            //       radarBorderData: const BorderSide(color: Colors.grey),
                            //       titlePositionPercentageOffset: 0.2,
                            //       titleTextStyle:
                            //       const TextStyle(color: Colors.black, fontSize: 10),
                            //       getTitle: (index) {
                            //         return features2[index];
                            //       },
                            //       tickCount: 1,
                            //       ticksTextStyle:
                            //       const TextStyle(color: Colors.transparent, fontSize: 8),
                            //       tickBorderData: const BorderSide(color: Colors.grey),
                            //       gridBorderData: const BorderSide(color: Colors.grey, width: 1),
                            //     ),
                            //     swapAnimationDuration: const Duration(milliseconds: 400),
                            //   ),
                            // ),
                            avg2.isEmpty
                                ? Container()
                                : RadarChart(
                                    length: avg2.length,
                                    radius: 100,
                                    initialAngle: -(pi / 2),
                                    backgroundColor: Colors.white,
                                    borderStroke: 2,
                                    borderColor: Colors.grey.shade300,
                                    radialStroke: 1,
                                    radialColor: Colors.grey.shade300,
                                    vertices: [
                                      for (int i = 0; i < features2.length; i++)
                                        RadarVertex(
                                          radius: 15,
                                          textOffset: const Offset(0.5, 0.5),
                                          text: Text(
                                            Utils.mapSafetyName(features2[i]),
                                            style: const TextStyle(
                                              color: ColorCustom.black,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                    ],
                                    radars: [
                                      RadarTile(
                                        values: point2,
                                        // borderStroke: 2,
                                        // borderColor: ColorCustom.dashboard_safe_point,
                                        backgroundColor: ColorCustom
                                            .dashboard_safe_point
                                            .withOpacity(0.5),
                                      ),
                                      RadarTile(
                                        values: avg2,
                                        borderStroke: 2,
                                        borderColor:
                                            ColorCustom.dashboard_safe_avg,
                                        // backgroundColor: ColorCustom
                                        //     .dashboard_safe_avg
                                        //     .withOpacity(0.5),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.fiber_manual_record,
                                  size: 15,
                                  color: ColorCustom.dashboard_safe_avg,
                                ),
                                Text(
                                  Languages.of(context)!.avg,
                                  style: const TextStyle(
                                    color: ColorCustom.black,
                                    fontSize: 12,
                                  ),
                                ),
                                const Icon(
                                  Icons.fiber_manual_record,
                                  size: 15,
                                  color: ColorCustom.dashboard_safe_point,
                                ),
                                Text(
                                  Languages.of(context)!.score,
                                  style: const TextStyle(
                                    color: ColorCustom.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      dashboardRealtime != null
                          ? Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorCustom.greyBG2),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.near_me,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        Languages.of(context)!.status_last,
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
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SfCircularChart(
                                                // primaryXAxis: CategoryAxis(),
                                                // Chart title
                                                // title: ChartTitle(text: 'Half yearly sales analysis'),
                                                // Enable legend
                                                legend: const Legend(
                                                    isVisible: false),
                                                tooltipBehavior:
                                                    TooltipBehavior(
                                                        enable: true),
                                                series: <DoughnutSeries<
                                                    ChartData, String>>[
                                                  DoughnutSeries<ChartData,
                                                          String>(
                                                      radius: '80%',
                                                      pointColorMapper:
                                                          (ChartData data, _) =>
                                                              data.color,
                                                      innerRadius: '80%',
                                                      explode: true,
                                                      explodeOffset: '10%',
                                                      dataSource: listCircle,
                                                      xValueMapper:
                                                          (ChartData data,
                                                                  _) =>
                                                              "${((data.value! * 100) / sumRealtime).toStringAsFixed(1)}%",
                                                      yValueMapper:
                                                          (ChartData data, _) =>
                                                              data.value,
                                                      dataLabelMapper:
                                                          (ChartData data, _) =>
                                                              data.value
                                                                  .toString(),
                                                      dataLabelSettings:
                                                          const DataLabelSettings(
                                                              isVisible: true))
                                                ]),
                                            Column(
                                              children: [
                                                Text(
                                                  Languages.of(context)!
                                                      .my_vehicle,
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  '${sumRealtime.toStringAsFixed(0)} ${Languages.of(context)!.unit}',
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  size: 15,
                                                  color: hexToColor(
                                                      dashboardRealtime!
                                                          .ioColorDriving!),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  Languages.of(context)!
                                                      .driving,
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                Text(
                                                  "${Utils.numberFormatInt(dashboardRealtime!.unitDriving!)} ${Languages.of(context)!.unit}",
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  size: 15,
                                                  color: hexToColor(
                                                      dashboardRealtime!
                                                          .ioColorParking!),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  Languages.of(context)!.ignOff,
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                Text(
                                                  "${Utils.numberFormatInt(dashboardRealtime!.unitParking!)} ${Languages.of(context)!.unit}",
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  size: 15,
                                                  color: hexToColor(
                                                      dashboardRealtime!
                                                          .ioColorIdling!),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  Languages.of(context)!.idle,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                Text(
                                                  "${Utils.numberFormatInt(dashboardRealtime!.unitIdling!)} ${Languages.of(context)!.unit}",
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  size: 15,
                                                  color: hexToColor(
                                                      dashboardRealtime!
                                                          .ioColorOverspeed!),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  Languages.of(context)!
                                                      .over_speed,
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                Text(
                                                  "${Utils.numberFormatInt(dashboardRealtime!.unitOverspeed!)} ${Languages.of(context)!.unit}",
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  size: 15,
                                                  color: hexToColor(
                                                      dashboardRealtime!
                                                          .ioColorOffline!),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  Languages.of(context)!
                                                      .offline,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                Text(
                                                  "${Utils.numberFormatInt(dashboardRealtime!.unitOffline!)} ${Languages.of(context)!.unit}",
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      dashboardDriver != null
                          ? Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorCustom.greyBG2),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.near_me,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        Languages.of(context)!.my_driver,
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
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SfCircularChart(
                                                // primaryXAxis: CategoryAxis(),
                                                // Chart title
                                                // title: ChartTitle(text: 'Half yearly sales analysis'),
                                                // Enable legend
                                                legend: const Legend(
                                                    isVisible: false),
                                                tooltipBehavior:
                                                    TooltipBehavior(
                                                        enable: true),
                                                series: <DoughnutSeries<
                                                    ChartData, String>>[
                                                  DoughnutSeries<ChartData,
                                                          String>(
                                                      radius: '80%',
                                                      pointColorMapper:
                                                          (ChartData data, _) =>
                                                              data.color,
                                                      innerRadius: '80%',
                                                      explode: true,
                                                      explodeOffset: '10%',
                                                      dataSource:
                                                          listCircleDriver,
                                                      xValueMapper:
                                                          (ChartData data,
                                                                  _) =>
                                                              "${((data.value! * 100) / sumDriver).toStringAsFixed(1)}%",
                                                      yValueMapper:
                                                          (ChartData data, _) =>
                                                              data.value,
                                                      dataLabelMapper:
                                                          (ChartData data, _) =>
                                                              data.value
                                                                  .toString(),
                                                      dataLabelSettings:
                                                          const DataLabelSettings(
                                                              isVisible: true))
                                                ]),
                                            Column(
                                              children: [
                                                Text(
                                                  Languages.of(context)!
                                                      .my_driver_total,
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  '${sumDriver.toStringAsFixed(0)} ${Languages.of(context)!.unit_driver}',
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  size: 15,
                                                  color: hexToColor(
                                                      dashboardDriver!
                                                          .ioColorSwipecard!),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  Languages.of(context)!
                                                      .swipe_card,
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                Text(
                                                  "${Utils.numberFormatInt(dashboardDriver!.unitSwipecard!)} ${Languages.of(context)!.unit_driver}",
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  size: 15,
                                                  color: hexToColor(
                                                      dashboardDriver!
                                                          .ioColorNotSwipecard!),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  Languages.of(context)!
                                                      .no_swipe_card,
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                Text(
                                                  "${Utils.numberFormatInt(dashboardDriver!.unitNotSwipecard!)} ${Languages.of(context)!.unit_driver}",
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  size: 15,
                                                  color: hexToColor(
                                                      dashboardDriver!
                                                          .ioColorValidate!),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  Languages.of(context)!
                                                      .wrong_license,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                Text(
                                                  "${Utils.numberFormatInt(dashboardDriver!.unitValidate!)} ${Languages.of(context)!.unit_driver}",
                                                  style: const TextStyle(
                                                    color: ColorCustom.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  String dateString = "";
  TextEditingController textEditingController = TextEditingController();

  pickDateStart() async {
    // final DateTime? picked = await showDatePicker(
    //     locale: Locale(Api.language, Api.language.toUpperCase()),
    //     context: context,
    //     initialDate: start,
    //     firstDate: DateTime(2000),
    //     lastDate: DateTime.now(),
    //     initialEntryMode: DatePickerEntryMode.calendarOnly,
    //     helpText: "");
    // if (picked != null) {
    //   start = picked;
    //   to = picked;
    //
    //   var s = DateFormat('dd MMM yy',Api.language).format(start);
    //   var e = DateFormat('dd MMM yy',Api.language).format(to);
    //   if (start.isBefore(to) && !start.isSameDate(to)) {
    //     dateString = s + " - " + e;
    //   } else {
    //     dateString = s;
    //   }
    //
    //   textEditingController.text = dateString;
    //   setState(() {});
    //   getData(context);
    //   pickDateEnd();
    // }

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
                        // getData(context);
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

                          textEditingController.text = dateString;
                          setState(() {});
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
    // final DateTime? picked = await showDatePicker(
    //     locale: Locale(Api.language, Api.language.toUpperCase()),
    //     context: context,
    //     initialDate: to,
    //     firstDate: start,
    //     lastDate: maxTimeEnd(),
    //     initialEntryMode: DatePickerEntryMode.calendarOnly,
    //     helpText: "");
    // if (picked != null) {
    //   to = picked;
    //   var s = DateFormat('dd MMM yy',Api.language).format(start);
    //   var e = DateFormat('dd MMM yy',Api.language).format(to);
    //   if (start.isBefore(to) && !start.isSameDate(to)) {
    //     dateString = s + " - " + e;
    //   } else {
    //     dateString = s;
    //   }
    //   textEditingController.text = dateString;
    //   setState(() {});
    //   getData(context);
    // }

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
                      initialDisplayDate: to,
                      showActionButtons: true,
                      showNavigationArrow: true,
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onSubmit: (p0) {
                        Navigator.pop(context);
                        getData(context);
                      },
                      onSelectionChanged: (args) {
                        if (args.value is DateTime) {
                          final DateTime selectedDate = args.value;
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
                          textEditingController.text = dateString;
                          setState(() {});
                        }
                      },
                      initialSelectedDate: to,
                      maxDate: maxTimeEnd(),
                      minDate: start,
                      selectionMode: DateRangePickerSelectionMode.single,
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
    var end = start.add(const Duration(days: 6));
    if (start.isSameDate(DateTime.now())) {
      return DateTime.now();
    } else if (end.isAfter(DateTime.now())) {
      return DateTime.now();
    } else {
      return start.add(const Duration(days: 6));
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.white,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToMe,
      //   label: Text('My location'),
      //   icon: Icon(Icons.near_me),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: indexTab == 1
                      ? Container(
                          margin: const EdgeInsets.only(top: 20, left: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorCustom.greyBG2),
                            color: ColorCustom.greyBG2,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: Colors.grey,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: textGrey,
                                  enabled: false,
                                  style: const TextStyle(color: Colors.grey),
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
                        )
                      : Container(
                          margin: const EdgeInsets.only(top: 20, left: 20),
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
                          //   limit: 7,
                          //   controller: dateEditController,
                          //   returnDate: (value) {
                          //     // start = DateFormat('yyyy-MM-dd')
                          //     //     .format(value.start);
                          //     // to = DateFormat('yyyy-MM-dd')
                          //     //     .format(value.end);
                          //
                          //     start = value.start;
                          //     to = value.end;
                          //     getData(context);
                          //   },
                          // ),
                        ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => DashboardFilter(
                      //               data: (value) {
                      //                 for (Vehicle v in value) {
                      //                   listVid.add(v.info!.vid!);
                      //                 }
                      //                 getData(context);
                      //               },
                      //             )));.
                      if (indexTab == 0) {
                        showDia(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: indexTab == 0
                          ? ColorCustom.primaryColor
                          : Colors.grey,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(5),
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(child: _tabSection(context))
          ],
        ),
      ),
    );
  }
}
