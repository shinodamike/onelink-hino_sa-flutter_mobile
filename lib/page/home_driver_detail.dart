import 'dart:math';

// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iov/api/api.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/model/Eco.dart';
import 'package:iov/model/driver.dart';
import 'package:iov/model/driver_detail.dart';
import 'package:iov/model/safety.dart';
import 'package:iov/model/vehicle.dart';
import 'package:iov/provider/page_provider.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:iov/utils/utils.dart';
import 'package:iov/widget/back_ios.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:provider/src/provider.dart';
import 'package:radar_chart/radar_chart.dart';

// import 'package:radar_chart/radar_chart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_noti_event.dart';

class HomeDriverDetailPage extends StatefulWidget {
  const HomeDriverDetailPage({Key? key, required this.driver})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final Driver driver;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomeDriverDetailPage> {
  @override
  void initState() {
    getDataDriver(context);
    getDataGraph(context);
    super.initState();
  }

  double sumPoint = 0;
  double sumPoint2 = 0;

  DriverDetail? driverDetail;

  getDataDriver(BuildContext context) {
    Api.get(
            context,
            "${Api.driver_detail +
                widget.driver.personalId! +
                "&start_date=" +
                Utils.getDateCreate()}&stop_date=" +
                Utils.getDateCreate())
        .then((value) => {
              if (value != null)
                {
                  driverDetail = DriverDetail.fromJson(value["result"]),
                  // initChart(driverDetail!),
                  refresh(),
                }
              else
                {}
            });
  }

  getDataGraph(BuildContext context) {
    DriverDetail detailChart;
    Api.get(
            context,
            "${Api.driver_detail +
                widget.driver.personalId! +
                "&start_date=" +
                Utils.getDateBackYear()}&stop_date=" +
                    Utils.getDateCreate())
        .then((value) => {
              if (value != null)
                {
                  detailChart = DriverDetail.fromJson(value["result"]),
                  initChart(detailChart),
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

  initChart(DriverDetail driverDetail) {
    sumPoint = 0;
    sumPoint2 = 0;
    for (Eco eco in driverDetail.eco) {
      features.add(eco.arg!);
      avg.add(eco.avg! / 5);
      point.add(eco.point! / 5);
      sumPoint += eco.avg!;
    }
    // print(sumPoint.toString());

    for (Safety safe in driverDetail.safety) {
      features2.add(safe.arg!);
      avg2.add(safe.avg! / 5);
      point2.add(safe.point! / 5);
      sumPoint2 += safe.avg!;
    }
    // print(sumPoint2.toString());
    refresh();
  }

  launchShare(String info, double lat, double long) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    Share.share('$info\n$googleUrl');
  }

  showDetail(String name) {
    showBarModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => HomeNotiEventPage(
        name: name,
      ),
    );
  }

  bool getPhone() {
    if (widget.driver.driver_phone_no != null &&
        widget.driver.driver_phone_no!.isNotEmpty) {
      return true;
    } else if (widget.driver.box_phone_no != null &&
        widget.driver.box_phone_no!.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  dialPhone(String phone) {
    if (phone.isNotEmpty) {
      launch("tel://$phone");
    }
  }

  sms() {
    var url = "";
    if (widget.driver.driver_phone_no != null &&
        widget.driver.driver_phone_no!.isNotEmpty) {
      url = "sms:${widget.driver.driver_phone_no!}?body=message";
    } else {
      launch("tel://${widget.driver.box_phone_no!}");
      url = "sms:${widget.driver.box_phone_no!}?body=message";
    }
    launch(url);
  }

  // int  selectedDataSetIndex = 0;
  //
  // List<RadarDataSet> showingDataSets() {
  //   return rawDataSets().asMap().entries.map((entry) {
  //     var index = entry.key;
  //     var rawDataSet = entry.value;
  //
  //     return RadarDataSet(
  //       fillColor: rawDataSet.color.withOpacity(0.2),
  //       borderColor:rawDataSet.color,
  //       // isSelected ? rawDataSet.color : rawDataSet.color.withOpacity(0.25),
  //       entryRadius: 2,
  //       dataEntries:
  //       rawDataSet.values.map((e) => RadarEntry(value: e)).toList(),
  //       borderWidth: 2,
  //     );
  //   }).toList();
  // }
  //
  // List<RawDataSet> rawDataSets() {
  //   return [
  //     RawDataSet(
  //       title: '',
  //       color: ColorCustom.dashboard_save,
  //       values: avg,
  //     ),
  //     RawDataSet(
  //       title: '',
  //       color: ColorCustom.dashboard_save2,
  //       values: point,
  //     ),
  //
  //
  //   ];
  // }
  //
  // List<RadarDataSet> showingDataSets2() {
  //   return rawDataSets2().asMap().entries.map((entry) {
  //     var index = entry.key;
  //     var rawDataSet = entry.value;
  //
  //     return RadarDataSet(
  //       fillColor: rawDataSet.color.withOpacity(0.2),
  //       borderColor:rawDataSet.color,
  //       // isSelected ? rawDataSet.color : rawDataSet.color.withOpacity(0.25),
  //       entryRadius: 2,
  //       dataEntries:
  //       rawDataSet.values.map((e) => RadarEntry(value: e)).toList(),
  //       borderWidth: 2,
  //     );
  //   }).toList();
  // }
  //
  // List<RawDataSet> rawDataSets2() {
  //   return [
  //     RawDataSet(
  //       title: '',
  //       color: ColorCustom.dashboard_safe,
  //       values: avg2,
  //     ),
  //     RawDataSet(
  //       title: '',
  //       color: ColorCustom.dashboard_safe2,
  //       values: point2,
  //     ),
  //
  //
  //   ];
  // }

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const BackIOS(),
              Container(
                margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorCustom.greyBG2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                padding:
                    const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        widget.driver.photoUrl!.isEmpty
                            ? Image.asset(
                                "assets/images/profile_empty.png",
                                width: 60,
                                height: 60,
                              )
                            : Image.network(
                                widget.driver.photoUrl!,
                                width: 60,
                                height: 60,
                              ),
                        // Icon(
                        //   Icons.fiber_manual_record,
                        //   size: 15,
                        //   color: Colors.greenAccent,
                        // )
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.driver.prefix!} ${widget.driver.firstname!} ${widget.driver.lastname!}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Utils.swipeCard(widget.driver,context),
                          widget.driver.display_datetime_swipe!.isNotEmpty
                              ? Text(
                                  widget.driver.display_datetime_swipe!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: ColorCustom.greyBG,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            Utils.numberFormatInt(widget.driver.score!),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(Languages.of(context)!.score,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
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
                        // Icon(
                        //   Icons.account_circle,
                        //   size: 40,
                        //   color: Colors.grey,
                        // ),
                        SvgPicture.asset(
                          "assets/images/icon_profile.svg",
                          color: Colors.grey,
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(Languages.of(context)!.driver_title,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(child: Container()),
                        Container(
                          decoration: BoxDecoration(
                              color: ColorCustom.primaryColor,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  width: 8, color: ColorCustom.primaryColor)),
                          child: InkWell(
                            child: const Icon(
                              Icons.notifications,
                              color: Colors.white,
                            ),
                            onTap: () {
                              showDetail("${widget.driver.firstname!} ${widget.driver.lastname!}");
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            dialPhone(widget.driver.box_phone_no!);
                          },
                          child: widget.driver.box_phone_no!.isEmpty
                              ? SvgPicture.asset(
                                  "assets/images/Fix Icon iov7.svg",
                                  color: Colors.grey,
                                  width: 40,
                                  height: 40,
                                )
                              : SvgPicture.asset(
                                  "assets/images/Fix Icon iov7.svg",
                                  width: 40,
                                  height: 40,
                                ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                color: widget.driver.driver_phone_no!.isEmpty
                                    ? Colors.grey
                                    : ColorCustom.primaryColor,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                    width: 8,
                                    color:
                                        widget.driver.driver_phone_no!.isEmpty
                                            ? Colors.grey
                                            : ColorCustom.primaryColor)),
                            child: const Icon(
                              Icons.call,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            dialPhone(widget.driver.driver_phone_no!);
                          },
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(Languages.of(context)!.driver_distance,
                                style: const TextStyle(
                                  color: ColorCustom.black,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                driverDetail != null
                                    ? '${Utils.numberFormat(
                                            driverDetail!.distance!)} ${Languages.of(context)!.km}'
                                    : "",
                                style: const TextStyle(
                                  color: ColorCustom.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(Languages.of(context)!.driver_duration,
                                style: const TextStyle(
                                  color: ColorCustom.black,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                driverDetail != null
                                    ? '${driverDetail!.total_time!} ${Languages.of(context)!.h}'
                                    : "",
                                style: const TextStyle(
                                  color: ColorCustom.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              // Row(
                              //   children: [
                              //     Icon(
                              //       Icons.credit_card,
                              //       size: 20,
                              //       color: Colors.green,
                              //     ),
                              //     Text(
                              //       'รูดบัตรแล้ว',
                              //       style: TextStyle(
                              //         color: ColorCustom.black,
                              //         fontSize: 12,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                        // Image.asset(
                        //   "assets/images/profile_empty.png",
                        //   width: 100,
                        //   height: 100,
                        // )
                      ],
                    ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Icon(
                        //   Icons.travel_explore,
                        //   size: 40,
                        //   color: Colors.grey,
                        // ),
                        SvgPicture.asset(
                          "assets/images/icon_gps.svg",
                          color: Colors.grey,
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(Languages.of(context)!.location_title,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Expanded(child: Container()),
                        widget.driver.licensePlateNo!.isNotEmpty
                            ? InkWell(
                                onTap: () {
                                  Vehicle? v = Utils.getVehicleByLicense(
                                      widget.driver.licensePlateNo!);
                                  if (v != null) {
                                    context
                                        .read<PageProvider>()
                                        .selectVehicle(v);
                                    // selectVehicle = v;
                                    Navigator.of(context)
                                        .popUntil(ModalRoute.withName('/root'));
                                  }
                                },
                                child: Image.asset(
                                  "assets/images/google-maps.png",
                                  height: 40,
                                  width: 40,
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: widget.driver.lat is double?ColorCustom.primaryColor:Colors.grey,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  width: 8, color:widget.driver.lat is double?ColorCustom.primaryColor:Colors.grey,)),
                          child: InkWell(
                            child: const Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                            onTap: () {
                              launchShare(
                                  "${Languages.of(context)!.plate_no} ${widget.driver.licensePlateNo!}",
                                  widget.driver.lat!,
                                  widget.driver.lng!);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Languages.of(context)!.plate_no,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            widget.driver.licensePlateNo!.isNotEmpty
                                ? Text(
                                    widget.driver.licensePlateNo!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Container(),
                            const SizedBox(
                              width: 10,
                            ),
                            widget.driver.vehicle != null &&
                                    widget.driver.vehicle!.info!.licenseprov!
                                        .isNotEmpty
                                ? Text(
                                    widget.driver.vehicle!.info!.licenseprov!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        Text(Languages.of(context)!.last_update,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          widget.driver.vehicle != null
                              ? widget.driver.vehicle!.gps!.display_gpsdate!
                              : "",
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(Languages.of(context)!.location,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "${widget.driver.adminLevel3Name!} ${widget.driver.adminLevel2Name!} ${widget.driver.adminLevel1Name!}",
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
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
                        // Icon(
                        //   Icons.spa,
                        //   size: 40,
                        //   color: Colors.grey,
                        // ),
                        SvgPicture.asset(
                          "assets/images/Fix Icon iov29.svg",
                          width: 40,
                          height: 40,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text("${Languages.of(context)!.dashboardGraph2} (${((sumPoint * 100) / 30).toStringAsFixed(0)}/100)",
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
                    // Container(
                    //   width: 200,
                    //   height: 200,
                    //   child: RadarChart.light(
                    //     ticks: ticks,
                    //     features: features,
                    //     data: data,
                    //     reverseAxis: true,
                    //     useSides: true,
                    //   ),
                    // ),
                    // avg.isEmpty?Container():AspectRatio(
                    //   aspectRatio: 1.3,
                    //   child: RadarChart(
                    //     RadarChartData(
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
                    //
                    //   ),
                    // ),
                    avg.isEmpty
                        ? Container()
                        : RadarChart(
                            length: avg.length,
                            radius: 100,
                            initialAngle: -(pi / 2),
                            backgroundColor: Colors.white,
                            borderStroke: 2,
                            borderColor: Colors.grey.shade300,
                            radialStroke: 1,
                            radialColor: Colors.grey.shade300,
                            vertices: [
                              for (int i = 0; i < features.length; i++)
                                RadarVertex(
                                  radius: 15,
                                  textOffset: const Offset(0, 0),
                                  text: Text(
                                    features[i],
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
                                // borderColor: ColorCustom.dashboard_save_point,
                                backgroundColor: ColorCustom
                                    .dashboard_save_point
                                    .withOpacity(0.5),
                              ),
                              RadarTile(
                                values: avg,
                                borderStroke: 2,
                                borderColor: ColorCustom.dashboard_save_avg,
                                // backgroundColor:
                                //     ColorCustom.dashboard_save.withOpacity(0.5),
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
                        Text(Languages.of(context)!.avg,
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
                        Text(Languages.of(context)!.score,
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
                        Text("${Languages.of(context)!.dashboardGraph3} (${((sumPoint2 * 100) / 30).toStringAsFixed(0)}/100)",
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
                                  textOffset: const Offset(0, 0),
                                  text: Text(
                                    features2[i],
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
                                borderColor: ColorCustom.dashboard_safe_avg,
                                // backgroundColor: ColorCustom.dashboard_safe2
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
                          color: ColorCustom.dashboard_safe_avg,
                        ),
                        Text(Languages.of(context)!.avg,
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
                        Text(Languages.of(context)!.score,
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
      ),
    );
  }
}

class RadarVertex extends StatelessWidget implements PreferredSizeWidget {
  const RadarVertex({super.key, 
    required this.radius,
    this.text,
    this.textOffset,
  });

  final double radius;
  final Widget? text;
  final Offset? textOffset;

  @override
  Size get preferredSize => Size.fromRadius(radius);

  @override
  Widget build(BuildContext context) {
    Widget tree = CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
    );
    // if (text != null) {
    //   // Center(
    //   //   child: text,
    //   // );
    //   tree = Stack(
    //     children: [
    //       tree,
    //       Center(
    //         child: text,
    //       )
    //     ],
    //   );
    // }
    return Center(
      child: text,
    );
  }
}
