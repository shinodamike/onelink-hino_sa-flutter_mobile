import 'package:flutter/material.dart';
import 'package:iov/model/cctv_vehicle.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:iov/utils/utils.dart';

import '../api/api.dart';
import '../localization/language/languages.dart';
import '../model/option_snapshot.dart';
import '../widget/actionbar_back.dart';
import 'home_detail_option_gallery.dart';

class HomeBackupSnapshotGalleryPage2 extends StatefulWidget {
  const HomeBackupSnapshotGalleryPage2(
      {Key? key, required this.date, required this.cctvVehicle})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String date;
  final CctvVehicle cctvVehicle;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomeBackupSnapshotGalleryPage2> {
  var date = "";
  CctvVehicle? vehicleID;
  bool isLoading = false;
  bool isLoading2 = false;
  double imageWidth = 0;

  @override
  void initState() {
    getVehicle(context);

    super.initState();
  }

  refresh() {
    isLoading = false;
    isLoading2 = false;
    setState(() {});
  }

  List<OptionSnapshot> list = [];

  getVehicle(BuildContext context) {
    // Api.get(context, Api.cctv_vehicle + Api.profile!.userId.toString())
    // https://3tirkucu7j.execute-api.ap-southeast-1.amazonaws.com/prod/prod/fleet/mdvr/playback/images?user_id=27&vid=23430&start=2022-11-24%2000%3A00%3A00&end=2022-11-24%2023%3A59%3A59
    String url = "${Api.snapshot}user_id=${Api.profile!.userId}&vid=${widget.cctvVehicle.vehicleId}&start=${widget.date}%2000%3A00%3A00&&end=${widget.date}%2023%3A59%3A59";
    setState(() {
      isLoading = true;
    });
    Api.get(context, url).then((value) => {
          if (value != null) {initData(value)} else {}
        });
  }

  initData(var value) {
    print(value.toString());
    if (value["code"] == 500) {
      Utils.showAlertDialog(context, value['result']);
    } else {
      list = List.from(value['result'])
          .map((a) => OptionSnapshot.fromJson(a))
          .toList();
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
              Text(
                widget.date,
                style: const TextStyle(
                  color: ColorCustom.black,
                  fontSize: 16,
                ),
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: ColorCustom.primaryColor),
                    )
                  : Container(),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(10),
                child: GridView.count(
                  shrinkWrap: false,
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  //physics:BouncingScrollPhysics(),
                  children: list
                      .map(
                        (data) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          HomeDetailOptionGalleryPage(
                                            optionSnapshots: list,
                                          )));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorCustom.greyBG2),
                                color: ColorCustom.greyBG2,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    data.url!,
                                    fit: BoxFit.fitWidth,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      data.take_photo_time!,
                                      style: const TextStyle(
                                        color: ColorCustom.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )),
                      )
                      .toList(),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
