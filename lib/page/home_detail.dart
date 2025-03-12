import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iov/api/api.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/model/behavior.dart';
import 'package:iov/model/option_snapshot.dart';
import 'package:iov/model/vehicle.dart';
import 'package:iov/model/vehicle_detail.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:iov/utils/timeago.dart';
import 'package:iov/utils/utils.dart';
import 'package:iov/widget/back_ios.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_detail_cctv_flk.dart';
import 'home_detail_option_gallery.dart';
import 'home_noti_event.dart';

class HomeDetailPage extends StatefulWidget {
  const HomeDetailPage({Key? key, required this.vehicle}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final Vehicle vehicle;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomeDetailPage> {
  Vehicle? vehicle;
  VehicleDetail? vehicleDetail;
  bool isLoading = false;

  Timer? timer;

  @override
  void initState() {
    vehicle = widget.vehicle;

    if (!isLoading) {
      getData(context);
    }

    timer = Timer.periodic(const Duration(seconds: 15), (Timer t) {
      getData(context);
    });

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  launchMap(double lat, double long) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  launchShare(String info, double lat, double long) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    Share.share('$info\n$googleUrl');
  }

  _launchCaller(String phone) async {
    var url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  getData(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    Api.get(context, Api.vid_detail + widget.vehicle.info!.vid.toString())
        .then((value) => {
              if (value != null)
                {vehicleDetail = VehicleDetail.fromJson(value), refresh()}
              else
                {}
            });
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

  refresh() {
    isLoading = false;
    setState(() {});
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const BackIOS(),
              Container(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Utils.statusCarImage(widget.vehicle.gps!.io_name!,
                        widget.vehicle.gps!.speed),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle!.info!.vehicle_name!,
                            style: const TextStyle(
                                color: ColorCustom.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                              vehicle!.info!.licenseprov ?? "",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              )),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: ColorCustom.greyBG2),
                      child: Column(
                        children: [
                          Text(
                            vehicle!.gps!.speed.toStringAsFixed(0),
                            style: const TextStyle(
                                color: ColorCustom.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(Languages.of(context)!.km_h,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
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
                        //   size: 50,
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
                        Text(
                          Languages.of(context)!.driver_title,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(child: Container()),
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                color: ColorCustom.primaryColor,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                    width: 8, color: ColorCustom.primaryColor)),
                            child: const Icon(
                              Icons.notifications,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            showDetail(vehicle!.driverCard!.name!);
                          },
                        ),

                        const SizedBox(
                          width: 5,
                        ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //       color: Colors.grey,
                        //       borderRadius: BorderRadius.circular(100),
                        //       border: Border.all(
                        //           width: 8, color: Colors.grey)),
                        //   child: Icon(
                        //     Icons.chat,
                        //     color: Colors.white,
                        //   ),
                        // ),
                        InkWell(
                          onTap: () {
                            if (widget.vehicle.info!.box_phone != null &&
                                widget.vehicle.info!.box_phone!.isNotEmpty) {
                              _launchCaller(widget.vehicle.info!.box_phone!);
                            }
                          },
                          child: SvgPicture.asset(
                            widget.vehicle.info!.box_phone!.isEmpty
                                ? "assets/images/Fix Icon iov7_1.svg"
                                : "assets/images/Fix Icon iov7.svg",
                            // color:Colors.grey,
                            width: 40,
                            height: 40,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: widget
                                      .vehicle.driverCard!.driver_phone!.isEmpty
                                  ? Colors.grey
                                  : ColorCustom.primaryColor,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(width: 8, color: Colors.grey)),
                          child: InkWell(
                            child: const Icon(
                              Icons.call,
                              color: Colors.white,
                            ),
                            onTap: () {
                              if (widget.vehicle.driverCard!.driver_phone !=
                                      null &&
                                  widget.vehicle.driverCard!.driver_phone!
                                      .isNotEmpty) {
                                _launchCaller(
                                    widget.vehicle.driverCard!.driver_phone!);
                              }
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
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Languages.of(context)!.driver,
                                style: const TextStyle(
                                  color: ColorCustom.black,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                vehicle!.driverCard!.name!.isEmpty
                                    ? Languages.of(context)!.unidentified_driver
                                    : vehicle!.driverCard!.name!,
                                style: const TextStyle(
                                  color: ColorCustom.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.credit_card,
                                    size: 20,
                                    color: vehicle!.driverCard!
                                                .status_swipe_card !=
                                            0
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  Text(
                                    vehicle!.driverCard!.status_swipe_card != 0
                                        ? Languages.of(context)!.swipe_card
                                        : Languages.of(context)!.no_swipe_card,
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
              Stack(
                children: [
                  vehicleDetail != null
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
                                  // Icon(
                                  //   Icons.travel_explore,
                                  //   size: 50,
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
                                  Text(
                                    Languages.of(context)!.location_title,
                                    style: const TextStyle(
                                      color: ColorCustom.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: ColorCustom.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 8,
                                            color: ColorCustom.primaryColor)),
                                    child: InkWell(
                                      child: const Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        getData(context);
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    child: Image.asset(
                                      "assets/images/google-maps.png",
                                      height: 40,
                                      width: 40,
                                    ),
                                    onTap: () {
                                      launchMap(vehicleDetail!.gps!.lat!,
                                          vehicleDetail!.gps!.lng!);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: ColorCustom.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 8,
                                            color: ColorCustom.primaryColor)),
                                    child: InkWell(
                                      child: const Icon(
                                        Icons.share,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        launchShare(
                                            "${Languages.of(context)!.license} ${vehicle!.info!.licenseplate!} ${vehicle!.info!.licenseprov!}",
                                            vehicleDetail!.gps!.lat!,
                                            vehicleDetail!.gps!.lng!);
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
                                  Text(
                                    Languages.of(context)!.last_update,
                                    style: const TextStyle(
                                      color: ColorCustom.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    vehicleDetail!.gps!.display_gpsdate!,
                                    style: const TextStyle(
                                      color: ColorCustom.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    Languages.of(context)!.location,
                                    style: const TextStyle(
                                      color: ColorCustom.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "${vehicleDetail!.gps!.location!.admin_level3_name!} ${vehicleDetail!.gps!.location!.admin_level2_name!} ${vehicleDetail!.gps!.location!.admin_level1_name!}",
                                    style: const TextStyle(
                                      color: ColorCustom.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    Languages.of(context)!.station,
                                    style: const TextStyle(
                                      color: ColorCustom.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          vehicleDetail!.info!.geofence_name!,
                                          style: const TextStyle(
                                            color: ColorCustom.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 3,
                                            bottom: 3),
                                        decoration: BoxDecoration(
                                          color: ColorCustom.blueLight,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          TimeAgo.timeAgoSinceDate(
                                              vehicleDetail!.gps!.gpsdate!),
                                          style: const TextStyle(
                                            color: ColorCustom.primaryColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: ColorCustom.primaryColor),
                        )
                      : Container()
                ],
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
                        Image.asset(
                          "assets/images/car_status.png",
                          height: 40,
                          width: 40,
                        ),
                        Text(
                          Languages.of(context)!.status_vehicle,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Expanded(child: Container()),
                        // InkWell(
                        //   onTap: () {
                        //     if (vehicleDetail!.optionMvr!.channel!.isNotEmpty) {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (_) => HomeDetailCCTVPageFlk(
                        //                     vd: vehicleDetail!,
                        //                   )));
                        //     }
                        //   },
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         color: vehicleDetail != null &&
                        //                 vehicleDetail!.optionMvr != null &&
                        //                 vehicleDetail!
                        //                     .optionMvr!.channel!.isNotEmpty
                        //             ? ColorCustom.primaryColor
                        //             : Colors.grey,
                        //         borderRadius: BorderRadius.circular(100),
                        //         border: Border.all(
                        //             width: 8,
                        //             color: vehicleDetail != null &&
                        //                     vehicleDetail!.optionMvr != null &&
                        //                     vehicleDetail!
                        //                         .optionMvr!.channel!.isNotEmpty
                        //                 ? ColorCustom.primaryColor
                        //                 : Colors.grey)),
                        //     child: const Icon(
                        //       Icons.videocam,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
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
                        Text(
                          Languages.of(context)!.mile,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${Utils.numberFormat(double.parse(vehicle!.info!.odo!))} ${Languages.of(context)!.km}',
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          Languages.of(context)!.distance,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${Utils.numberFormat(vehicle!.gps!.course!)} ${Languages.of(context)!.km}',
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          Languages.of(context)!.fuel,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${vehicle!.gps!.fuel_per}%',
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          Languages.of(context)!.fuel_km,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "${vehicle!.gps!.fuel_rate} ${Languages.of(context)!.km_l}",
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          Languages.of(context)!.gps,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${vehicle!.gps!.sattellite_per} %',
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          Languages.of(context)!.gsm,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${vehicle!.gps!.gsm_per} %',
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          Languages.of(context)!.dtc_engine,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          vehicleDetail?.sensor?.canbus?.dtcEngine == "0"
                              ? Languages.of(context)!.off
                              : Languages.of(context)!.on,
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
              vehicleDetail != null && vehicleDetail!.optionSnapshots.isNotEmpty
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.info,
                                size: 50,
                                color: Colors.grey,
                              ),
                              Text(
                                Languages.of(context)!.option,
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      Languages.of(context)!.snapshot,
                                      style: const TextStyle(
                                        color: ColorCustom.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  HomeDetailOptionGalleryPage(
                                                    optionSnapshots:
                                                        vehicleDetail!
                                                            .optionSnapshots,
                                                  )));
                                    },
                                    child: Text(
                                      "${Languages.of(context)!.option_total} >",
                                      style: const TextStyle(
                                        color: ColorCustom.primaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // Container(
                              //   height: 80,
                              //   child:  ListView(
                              //     padding: EdgeInsets.all(5),
                              //     scrollDirection: Axis.horizontal,
                              //     children:  List.generate(vehicleDetail!.optionSnapshots.length, (int index) {
                              //
                              //       OptionSnapshot s = vehicleDetail!.optionSnapshots[index];
                              //
                              //       return   Container(
                              //         width: 80,
                              //         height: 80,
                              //         color: ColorCustom.greyBG,
                              //         child: Image.network(s.url!),
                              //       );
                              //     }),),
                              // ),
                              Container(
                                child: GridView.count(
                                  crossAxisCount: 4,
                                  childAspectRatio: (4 / 3),
                                  controller:
                                      ScrollController(keepScrollOffset: false),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  children: vehicleDetail!.optionSnapshots
                                      .map((OptionSnapshot value) {
                                    return Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      width: 80,
                                      height: 80,
                                      color: ColorCustom.greyBG,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      HomeDetailOptionGalleryPage(
                                                        optionSnapshots:
                                                            vehicleDetail!
                                                                .optionSnapshots,
                                                      )));
                                        },
                                        child: Image.network(value.url!),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              // Row(
                              //   children: [
                              //     for(OptionSnapshot s in vehicleDetail!.optionSnapshots )
                              //     Container(
                              //       width: 80,
                              //       height: 80,
                              //       color: ColorCustom.greyBG,
                              //       child: Image.network(s.url!),
                              //     ),
                              //     SizedBox(
                              //       width: 10,
                              //     ),
                              //
                              //   ],
                              // ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      Languages.of(context)!.mvdr,
                                      style: const TextStyle(
                                        color: ColorCustom.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              /* Container(
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  childAspectRatio: (21 / 9),
                                  controller: new ScrollController(
                                      keepScrollOffset: false),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  children: vehicleDetail!.optionMvr!.channel!
                                      .map((Channel value) {
                                    return Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                          right: 10, bottom: 10),
                                      width: 80,
                                      height: 80,
                                      color: ColorCustom.greyBG,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      VideoPlayerView(
                                                        url: value.url!,
                                                      )));
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.videocam),
                                            Text(
                                              value.labelName!,
                                              style: TextStyle(
                                                color: ColorCustom.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),*/
                              Text(
                                Languages.of(context)!.temperatures,
                                style: const TextStyle(
                                  color: ColorCustom.black,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                vehicleDetail != null
                                    ? "${vehicleDetail!.sensor!.temperature!.sensor1!}°C ,${vehicleDetail!.sensor!.temperature!.sensor2!}°C ,${vehicleDetail!.sensor!.temperature!.sensor3!}°C ,${vehicleDetail!.sensor!.temperature!.sensor4!}°C ,"
                                    : "",
                                style: const TextStyle(
                                  color: ColorCustom.primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                              const Text(
                                'PTO',
                                style: TextStyle(
                                  color: ColorCustom.black,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                vehicleDetail != null
                                    ? vehicleDetail!.sensor!.option!.pto!
                                    : "",
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                Languages.of(context)!.door,
                                style: const TextStyle(
                                  color: ColorCustom.black,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                vehicleDetail != null
                                    ? vehicleDetail!
                                        .sensor!.option!.door_sensor!
                                    : "",
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                Languages.of(context)!.safety_belt,
                                style: const TextStyle(
                                  color: ColorCustom.black,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                vehicleDetail != null
                                    ? vehicleDetail!
                                        .sensor!.option!.safety_belt!
                                    : "",
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(),
              vehicleDetail != null
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.local_police,
                                size: 30,
                                color: Colors.grey,
                              ),
                              Text(
                                Languages.of(context)!.dlt_regulation,
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
                              for (Behavior b in vehicleDetail!.listDlt)
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        Utils.mapDltName(b.name),
                                        style: const TextStyle(
                                          color: ColorCustom.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      Utils.numberFormatInt(b.value),
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
                        ],
                      ),
                    )
                  : Container(),
              vehicleDetail != null
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.speed,
                                size: 30,
                                color: Colors.grey,
                              ),
                              Text(
                                Languages.of(context)!.driving_behavior,
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
                              for (Behavior b in vehicleDetail!.listBehavior)
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        Utils.mapDrivingName(b.name),
                                        style: const TextStyle(
                                          color: ColorCustom.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      Utils.numberFormatInt(b.value),
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
                        ],
                      ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/car_status.png",
                          height: 40,
                          width: 40,
                        ),
                        Text(
                          Languages.of(context)!.vehicle_title,
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
                          Languages.of(context)!.plate_no,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          vehicle!.info!.licenseplate!,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          Languages.of(context)!.vin_no,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          vehicle!.info!.vin_no.toString(),
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        // Text(
                        //   'เลขแชสซี',
                        //   style: TextStyle(
                        //     color: ColorCustom.black,
                        //     fontSize: 16,
                        //   ),
                        // ),
                        // Text(
                        //   '-',
                        //   style: TextStyle(
                        //     color: ColorCustom.black,
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 16,
                        //   ),
                        // ),
                        Text(
                          Languages.of(context)!.model,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          vehicleDetail != null
                              ? vehicleDetail!.info!.model_code!
                              : "",
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        // Text(
                        //   'รุ่น',
                        //   style: TextStyle(
                        //     color: ColorCustom.black,
                        //     fontSize: 16,
                        //   ),
                        // ),
                        // Text(
                        //   vehicleDetail!=null?vehicleDetail!.info!.vehicle_name!:"",
                        //   style: TextStyle(
                        //     color: ColorCustom.black,
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 16,
                        //   ),
                        // ),
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
                        const Icon(
                          Icons.handyman,
                          size: 40,
                          color: Colors.grey,
                        ),
                        Text(
                          Languages.of(context)!.maintenance,
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
                          Languages.of(context)!.insurance,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          vehicleDetail != null
                              ? vehicleDetail!.maintenance!.Insurance!
                              : "-",
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          Languages.of(context)!.tires_service,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          vehicleDetail != null
                              ? vehicleDetail!.maintenance!.Tires_Service!
                              : "-",
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          Languages.of(context)!.next_service,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          vehicleDetail != null
                              ? "${Utils.numberFormat(vehicleDetail!.maintenance!.Next_service!.toDouble())} ${Languages.of(context)!.km}"
                              : "",
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
            ],
          ),
        ),
      ),
    );
  }
}
