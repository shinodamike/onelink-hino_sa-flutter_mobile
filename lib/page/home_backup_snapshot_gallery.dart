import 'package:flutter/material.dart';
import 'package:iov/model/cctv_date.dart';
import 'package:iov/model/cctv_vehicle.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:iov/utils/utils.dart';

import '../api/api.dart';
import '../localization/language/languages.dart';
import '../model/cctv_date_channel.dart';
import '../widget/actionbar_back.dart';

class HomeBackupSnapshotGalleryPage extends StatefulWidget {
  const HomeBackupSnapshotGalleryPage(
      {Key? key,
      required this.date,
      required this.listChannel,
      required this.cctvVehicle})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String date;
  final List<CctvDateChannel> listChannel;
  final CctvVehicle cctvVehicle;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomeBackupSnapshotGalleryPage> {
  var date = "";
  CctvVehicle? vehicleID;
  bool isLoading = false;
  bool isLoading2 = false;
  double imageWidth = 0;

  @override
  void initState() {
    // getVehicle(context);

    super.initState();
  }

  refresh() {
    isLoading = false;
    isLoading2 = false;
    setState(() {});
  }

  List<CctvVehicle> list = [];

  getVehicle(BuildContext context) {
    // Api.get(context, Api.cctv_vehicle + Api.profile!.userId.toString())
    // https://3tirkucu7j.execute-api.ap-southeast-1.amazonaws.com/prod/prod/fleet/mdvr/playback/images?user_id=27&vid=23430&start=2022-11-24%2000%3A00%3A00&end=2022-11-24%2023%3A59%3A59
    String a = "${Api.snapshot}user_id=${Api.profile!.userId}&vid=${widget.cctvVehicle.vehicleId}&start=${widget.date}%2000%3A00%3A00&&end=${widget.date}%2023%3A59%3A59";
    setState(() {
      isLoading = true;
    });
    Api.get(context,
            "https://3tirkucu7j.execute-api.ap-southeast-1.amazonaws.com/prod/prod/fleet/mdvr/playback/images?user_id=27&vid=23430&start=2022-11-24%2000%3A00%3A00&end=2022-11-24%2023%3A59%3A59")
        .then((value) => {
              if (value != null)
                {
                  print(value.toString()),
                  list = List.from(value['result'])
                      .map((a) => CctvVehicle.fromJson(a))
                      .toList(),
                  refresh()
                }
              else
                {}
            });
  }

  CctvDate? cctvDate;

  getDate(BuildContext context) {
    setState(() {
      isLoading2 = true;
    });
    // https://api-center.onelink-iot.com/prod/fleet/mdvr/playback/calendar/info?user_id=6120&vehicle_id=31503&start=2022-11-01&st=1
    DateTime now = DateTime.now();
    Api.get(
            context,
            "${Api.cctv_date}${Api.profile!.userId}&vehicle_id=${vehicleID!.vehicleId}&start=${now.year}-${now.month}-01&st=$device")
        .then((value) => {
              if (value != null) {initGetDate(value)} else {}
            });
  }

  initGetDate(var value) {
    try {
      cctvDate = CctvDate.fromJson(value["result"]);
    } catch (e) {
      Utils.showAlertDialog(context, value["message"]);
    }

    refresh();
  }

  int select = -1;
  String device = "1";

  @override
  Widget build(BuildContext context) {
    imageWidth = MediaQuery.of(context).size.width;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              ActionBarBack(title: Languages.of(context)!.camera_playback),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: ListView.builder(
                    shrinkWrap: false,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      // CctvVehicle cctv = list[index];
                      // Vehicle v = widget.listVehicle[index];

                      return Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "วันนี้",
                              style: TextStyle(
                                color: ColorCustom.black,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: imageWidth / 2,
                              child: ListView.builder(
                                shrinkWrap: false,
                                itemCount: 10,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  // CctvVehicle cctv = list[index];
                                  // Vehicle v = widget.listVehicle[index];

                                  return Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorCustom.greyBG2),
                                      color: ColorCustom.greyBG2,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          "https://c8.alamy.com/comp/2BXA2AF/security-cctv-camera-or-surveillance-system-observes-vehicular-traffic-on-a-road-truck-drives-on-the-highway-2BXA2AF.jpg",
                                          height: imageWidth / 2.5,
                                          width: imageWidth / 2.5,
                                        ),
                                        const Text(
                                          "23/4/2022",
                                          style: TextStyle(
                                            color: ColorCustom.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
