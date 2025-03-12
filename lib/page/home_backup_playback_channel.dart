import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:iov/model/cctv_vehicle.dart';
import 'package:iov/page/home_backup_playback_video_flk2.dart';
import 'package:iov/utils/color_custom.dart';

import '../api/api.dart';
import '../localization/language/languages.dart';
import '../model/cctv_date_channel.dart';
import '../model/channel_check.dart';
import '../widget/back_ios.dart';

class HomeBackupPlaybackChannelPage extends StatefulWidget {
  const HomeBackupPlaybackChannelPage(
      {Key? key,
      required this.listChannel,
      required this.date,
      required this.cctvVehicle,
      required this.device})
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
  final String device;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomeBackupPlaybackChannelPage> {
  bool isLoading = false;

  @override
  void initState() {
    getLiveChannel(context);

    super.initState();
  }

  getLiveChannel(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    String ch = "";
    for (var element in widget.listChannel) {
      ch += "${element.channel_id},";
    }
    ch = ch.substring(0, ch.length - 1);
    Api.get(
            context,
            "${Api.cctv_live_channel}${Api.profile!.userId}&vehicle_id=${widget.cctvVehicle.vehicleId}&channel=$ch&start=${widget.date}%2000:00:00&end=${widget.date}%2023:59:59&ft=0&st=${widget.device}")
        .then((value) => {
              if (value != null) {initChannel(value)} else {}
            });
  }

  List<CctvDateChannel> listChannelLive = [];
  List<ChannelCheck> listChannel = [];
  Map<String, List<ChannelCheck>>? listChannelGroup;

  initChannel(value) {
    var a = value["result"];
    listChannel = List.from(a).map((a) => ChannelCheck.fromJson(a)).toList();
    listChannel.sort((a, b) => a.starttime!.compareTo(b.starttime!));
    setState(() {
      listChannelGroup = groupBy(
          listChannel,
          (ChannelCheck obj) =>
              "${obj.starttime!.substring(11, 16)}-${obj.endtime!.substring(11, 16)}");


      isLoading = false;
    });
  }

  refresh() {
    isLoading = false;
    setState(() {});
  }

  genWidget(String key) {
    String ch = "";
    String start = "";
    String end = "";
    for (int i = 0; i < listChannelGroup![key]!.length; i++) {
      listChannelGroup![key]!.sort((a, b) => a.chn!.compareTo(b
          .chn!));
      ch += "${listChannelGroup![key]![i].chn},";
      start = listChannelGroup![key]![i].starttime!;
      end = listChannelGroup![key]![i].endtime!;
    }

    ch = ch.substring(0, ch.length - 1);
    return Text(
      "Channel $ch",
      style: const TextStyle(color: Colors.black, fontSize: 14),
    );
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              const BackIOS(),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.restore,
                      size: 30,
                      color: Colors.grey,
                    ),
                    Text(
                      "${Languages.of(context)!.cctv_playback} ${widget.date}",
                      style: const TextStyle(
                        color: ColorCustom.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Expanded(
                child: Stack(children: [
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: ColorCustom.primaryColor),
                        )
                      : Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorCustom.greyBG2),
                            color: ColorCustom.greyBG2,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          child: GridView.count(
                            // Create a grid with 2 columns. If you change the scrollDirection to
                            // horizontal, this would produce 2 rows.
                            childAspectRatio: 16 / 9,
                            crossAxisCount: 2,
                            // Generate 100 Widgets that display their index in the List
                            children: List.generate(listChannelGroup!.length,
                                (index) {
                              return Card(
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  child: InkWell(
                                    onTap: () {
                                      String key = listChannelGroup!.keys
                                          .elementAt(index);
                                      String start = "";
                                      String end = "";
                                      for (int i = 0;
                                          i < listChannelGroup![key]!.length;
                                          i++) {
                                        start = listChannelGroup![key]![i]
                                            .starttime!;
                                        end =
                                            listChannelGroup![key]![i].endtime!;
                                        for (int j = 0;
                                            j < widget.listChannel.length;
                                            j++) {
                                          if (widget
                                                  .listChannel[j].channel_id ==
                                              listChannelGroup![key]![i].chn) {
                                            listChannelLive
                                                .add(widget.listChannel[j]);
                                            break;
                                          }
                                        }
                                      }
                                      listChannelLive =
                                          listChannelLive.toSet().toList();
                                      // Navigator.of(context).push(
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             HomeBackupPlaybackVideoPageFlk2(
                                      //                 start: start,
                                      //                 end: end,
                                      //                 listChannel:
                                      //                     listChannelLive,
                                      //                 date: widget.date,
                                      //                 cctvVehicle:
                                      //                     widget.cctvVehicle,
                                      //                 device: widget.device)));
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          listChannelGroup!.keys
                                              .elementAt(index),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                        genWidget(listChannelGroup!.keys
                                            .elementAt(index)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        )
                  /*SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorCustom.greyBG2),
                                color: ColorCustom.greyBG2,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                              margin:
                                  EdgeInsets.only(left: 20, right: 20, top: 10),
                              child: Column(
                                children: [
                                  for (int i=0;i<listChannelGroup!.length;i++)
                                    Column(
                                      children: [
                                        Text(
                                          listChannelGroup!.keys.elementAt(i),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        ),
                                        genWidget(listChannelGroup!.keys.elementAt(i)),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),*/
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
