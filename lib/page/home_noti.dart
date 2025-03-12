import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iov/api/api.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/model/last_key.dart';
import 'package:iov/model/noti.dart';
import 'package:iov/model/noti_group.dart';
import 'package:iov/model/vehicle.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:iov/widget/back_ios.dart';


import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'home.dart';
import 'home_noti_event.dart';
import 'home_realtime.dart';

class HomeNotiPage extends StatefulWidget {
  const HomeNotiPage({Key? key}) : super(key: key);

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

class _PageState extends State<HomeNotiPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // noti_count = 0;
    notiController.sink.add(noti_count);

    tabController = TabController(vsync: this, length: 3);
    tabController!.addListener(() {
      // if (tabController!.index == 0) {
      //   isSearch = false;
      // }
      searchEdit.text = "";
      listCarGroupSearch.clear();
      listCarGroupSearch.addAll(listCarGroup);
      listDriverGroupSearch.clear();
      listDriverGroupSearch.addAll(listDriverGroup);
      refresh();
    });
    getData(context, []);
    super.initState();
  }

  // List data1 = [
  //   "ความเร็วเกินกำหนด",
  //   "เข้าพื้นที่เสี่ยง",
  //   "ออกพื้นที่เสี่ยง",
  //   "แจ้งเตือนเข้าศูนย์บริการ",
  //   "ไฟเครื่องยนต์เตือน"
  // ];

  List<Noti> listData = [];
  List<NotiGroup> ListValue = [
    NotiGroup(
        name: Api.language == "th" ? "ความเร็วเกินกำหนด" : "Over Speed"),
    // new NotiGroup(name: "เข้าพื้นที่เสี่ยง"),
    // new NotiGroup(name: "ออกพื้นที่เสี่ยง"),
    NotiGroup(
        name: Api.language == "th"
            ? "แจ้งเตือนเข้าศูนย์บริการ"
            : "Maintenance Remind"),
    NotiGroup(
        name: Api.language == "th" ? "ไฟเครื่องยนต์เตือน" : "Engine Lamp")
  ];
  bool isLoading = false;

  getData(BuildContext context, List<LastEvaluatedKey> listLast) {
    isLoading = true;
    refresh();
    String param;
    if (listLast.isNotEmpty) {
      param = jsonEncode(<dynamic, dynamic>{
        "user_id": Api.profile?.userId,
        "per_page": 500,
        "event_list": [1001, 10000, 10001],
        "LastEvaluatedKey": listLast,
      });
    } else {
      param = jsonEncode(<dynamic, dynamic>{
        "user_id": Api.profile?.userId,
        "per_page": 500,
        "event_list": [1001, 10000, 10001],
      });
    }

    Api.post(context, Api.notify, param).then((value) => {

          if (value != null)
            {
              // listData = List.from(value['result'])
              //     .map((a) => Noti.fromJson(a))
              //     .toList(),
              loadMore(value),
              listData.addAll(List.from(value['result'])
                  .map((a) => Noti.fromJson(a))
                  .toList())
            }
          else
            {},

        });
  }

  loadMore(dynamic value) {
    List<LastEvaluatedKey> listLast = List.from(value['LastEvaluatedKey'])
        .map((a) => LastEvaluatedKey.fromJson(a))
        .toList();
    if (listLast.isNotEmpty) {
      getData(context, listLast);
    } else {
      isLoading = false;
      groupEvent(listData);
      groupLicense();
      groupDriver();
      refresh();
    }
  }

  // List<NotiGroup> listEventGroup = [];

  groupEvent(List<Noti> listData) {
    for (Noti no in listData) {
      if (no.event_id == 1001) {
        ListValue[0].notifications.add(no);
      } else if (no.event_id == 10000) {
        ListValue[1].notifications.add(no);
      } else if (no.event_id == 10001) {
        ListValue[2].notifications.add(no);
      }
      // else if (no.event_id == 1004) {
      //   ListValue[3].notifications.add(no);
      // }
      // else if (no.event_id == 1007) {
      //   ListValue[4].notifications.add(no);
      // }
    }
    for (NotiGroup m in ListValue) {
      for (Vehicle v in listVehicle) {
        if (m.name == v.info!.licenseplate) {
          m.vehicle.add(v);
        }
      }
    }
  }

  List<NotiGroup> listCarGroup = [];

  groupLicense() {
    var groupByDate = groupBy(listData, (Noti obj) => obj.license!);
    groupByDate.forEach((date, list) {
      // Header
      // print('${date}:');
      var group = NotiGroup();
      group.name = date;

      // Group
      for (var listItem in list) {
        // List item
        group.notifications.add(listItem);
        // print('${listItem.gpsdate}, ${listItem.location!.admin_level3_name}');
      }
      listCarGroup.add(group);
      // day section divider
      // print('\n');
    });

    for (NotiGroup m in listCarGroup) {
      for (Vehicle v in listVehicle) {
        if (m.name == v.info!.licenseplate) {
          m.vehicle.add(v);
        }
      }
    }
    listCarGroupSearch.addAll(listCarGroup);
  }

  List<NotiGroup> listDriverGroup = [];

  groupDriver() {
    var groupByDate = groupBy(listData, (Noti obj) => obj.driver_name!);
    groupByDate.forEach((date, list) {
      // Header
      // print('${date}:');
      var group = NotiGroup();
      group.name = date;

      // Group
      for (var listItem in list) {
        // List item
        group.notifications.add(listItem);
        // print('${listItem.gpsdate}, ${listItem.location!.admin_level3_name}');
      }
      listDriverGroup.add(group);
      // day section divider
      // print('\n');
    });

    for (NotiGroup m in listDriverGroup) {
      for (Vehicle v in listVehicle) {
        if (m.name == v.driverCard!.name!) {
          m.vehicle.add(v);
        }
      }
    }
    listDriverGroupSearch.addAll(listDriverGroup);
  }

  refresh() {
    try {
      setState(() {});
    } catch (e) {}
  }

  showDetail(List<Noti> list, List<Vehicle> listVehicle) {
    showBarModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => HomeNotiEventPage(
        listData: list,
      ),
    );
  }

  TabController? tabController;

  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: TabBar(
              controller: tabController,
              tabs: [
                Tab(text: Languages.of(context)!.noti_event),
                Tab(text: Languages.of(context)!.noti_vehicle),
                Tab(text: Languages.of(context)!.noti_driver),
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
                Container(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    shrinkWrap: false,
                    itemCount: ListValue.length,
                    itemBuilder: (BuildContext context, int index) {
                      NotiGroup group = ListValue[index];

                      return GestureDetector(
                        onTap: () {
                          showDetail(group.notifications, group.vehicle);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorCustom.greyBG2),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  group.name!,
                                  style: const TextStyle(
                                    color: ColorCustom.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Text(
                                '${group.notifications.length} ${Languages.of(context)!.unit_times}',
                                style: const TextStyle(
                                    color: ColorCustom.primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    shrinkWrap: false,
                    itemCount: listCarGroupSearch.length,
                    itemBuilder: (BuildContext context, int index) {
                      NotiGroup carGroup = listCarGroupSearch[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context, MaterialPageRoute(builder: (_) => MotorbikePage()));
                          showDetail(carGroup.notifications, carGroup.vehicle);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorCustom.greyBG2),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 10),
                          child: Row(
                            children: [
                              Text(
                                carGroup.name!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  carGroup.vehicle.isNotEmpty
                                      ? carGroup.vehicle[0].info!.licenseprov!
                                      : "",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Text(
                                "${carGroup.notifications.length} ${Languages.of(context)!.unit_times}",
                                style: const TextStyle(
                                  color: ColorCustom.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    shrinkWrap: false,
                    itemCount: listDriverGroupSearch.length,
                    itemBuilder: (BuildContext context, int index) {
                      NotiGroup driverGroup = listDriverGroupSearch[index];

                      return GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context, MaterialPageRoute(builder: (_) => MotorbikePage()));
                          showDetail(
                              driverGroup.notifications, driverGroup.vehicle);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorCustom.greyBG2),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  driverGroup.name!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Text(
                                "${driverGroup.notifications.length} ${Languages.of(context)!.unit_times}",
                                style: const TextStyle(
                                  color: ColorCustom.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isSearch = false;
  List<NotiGroup> listDriverGroupSearch = [];

  searchDriver(String value) {
    listDriverGroupSearch.clear();
    if (value.isEmpty) {
      listDriverGroupSearch.addAll(listDriverGroup);
    } else {
      for (NotiGroup v in listDriverGroup) {
        if (v.name!.toLowerCase().contains(value)) {
          listDriverGroupSearch.add(v);
        }
      }
    }

    refresh();
  }

  List<NotiGroup> listCarGroupSearch = [];

  searchCar(String value) {
    listCarGroupSearch.clear();
    if (value.isEmpty) {
      listCarGroupSearch.addAll(listCarGroup);
    } else {
      for (NotiGroup v in listCarGroup) {
        if (v.name!.contains(value)) {
          listCarGroupSearch.add(v);
        }
      }
    }

    refresh();
  }

  TextEditingController searchEdit = TextEditingController();

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
                const BackIOS(),
                Expanded(child: Container()),
                InkWell(
                  child: Icon(
                    Icons.search,
                    size: 30,
                    color: tabController!.index == 0
                        ? Colors.grey
                        : ColorCustom.primaryColor,
                  ),
                  onTap: () {
                    if (tabController!.index != 0) {
                      isSearch = !isSearch;
                      searchEdit.text = "";
                      listCarGroupSearch.clear();
                      listCarGroupSearch.addAll(listCarGroup);
                      listDriverGroupSearch.clear();
                      listDriverGroupSearch.addAll(listDriverGroup);
                      refresh();
                    }
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            isSearch
                ? Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: searchEdit,
                      onChanged: (value) {
                        if (tabController!.index == 1) {
                          searchCar(value);
                        } else if (tabController!.index == 2) {
                          searchDriver(value);
                        }
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        enabled: tabController!.index != 0,
                        fillColor: ColorCustom.greyBG2,
                        prefixIcon: const Icon(Icons.search),
                        hintText: Languages.of(context)!.search,
                        hintStyle: const TextStyle(fontSize: 16),
                        // fillColor: colorSearchBg,
                      ),
                    ),
                  )
                : Container(),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: ColorCustom.primaryColor),
                  )
                : Expanded(child: _tabSection(context))
          ],
        ),
      ),
    );
  }
}
