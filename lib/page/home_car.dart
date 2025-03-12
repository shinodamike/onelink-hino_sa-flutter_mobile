import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iov/api/api.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/model/car_filter.dart';
import 'package:iov/model/member.dart';
import 'package:iov/model/member_group.dart';
import 'package:iov/model/vehicle.dart';
import 'package:iov/page/home_car_filter.dart';
import 'package:iov/page/home_realtime.dart';
import 'package:iov/page/info.dart';
import 'package:iov/provider/page_provider.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:iov/utils/utils.dart';
import 'package:iov/widget/back_ios.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/src/provider.dart';

import 'home_car_detail.dart';
import 'home_car_sort.dart';

class HomeCarPage extends StatefulWidget {
  const HomeCarPage({Key? key}) : super(key: key);

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

class _PageState extends State<HomeCarPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    tabController?.addListener(() {
      if (tabController?.index == 0) {
        searchFleet(searchText);
      } else {
        search(searchText);
      }

      refresh();
    });
    listSearchVehicle.addAll(listVehicle);
    if(listSearchVehicle.isNotEmpty){
      getDataCarList(context);
    }else{
      isError = true;
    }


    super.initState();
  }

  bool isLoading = true;
  bool isError = false;

  List<Member> listMember = [];
  List<Vehicle> listSearchVehicle = [];

  getDataCarList(BuildContext context) {
    Api.get(context, Api.listmember).then((value) => {
          if (value != null)
            {
              listMember = List.from(value['result'])
                  .map((a) => Member.fromJson(a))
                  .toList(),
              groupName(),
              isLoading = false,
              refresh()
            }
          else
            {isError = true, refresh()}
        });
  }

  List<MemberGroup> listNameGroup = [];
  List<MemberGroup> listSearchGroup = [];

  groupName() {
    var groupByDate = groupBy(listMember, (Member obj) => obj.fleet_name);
    groupByDate.forEach((date, list) {
      // Header
      print('$date:');
      var group = MemberGroup();
      group.name = date;

      // Group
      for (var listItem in list) {
        // List item
        group.members.add(listItem);
        // print('${listItem.gpsdate}, ${listItem.location!.admin_level3_name}');
      }
      listNameGroup.add(group);
      // day section divider
      // print('\n');
    });

    for (MemberGroup m in listNameGroup) {
      for (Vehicle v in listVehicle) {
        if (m.name == v.fleet!.fleet_name) {
          m.vehicle.add(v);
        }
      }
    }
    listSearchGroup.addAll(listNameGroup);
    listSearchGroup.sort((a, b) => a.name!.compareTo(b.name!));
  }

  refresh() {
    setState(() {});
  }

  // List<Vehicle> listSearchDetail = [];
  showCarList(MemberGroup group) {
    // listSearchDetail.addAll(group.vehicle);

    showBarModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => HomeCarDetailPage(
        group: group,
      ),
    );
  }

  showFilter() {
    List<Vehicle> list = [];
    showBarModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => HomeCarFilterPage(
        filter: (value) {
          for (Vehicle v in listVehicle) {
            if (value.isSpeed && value.isFuel) {
              // checkStatus(value, v, list);
              if (checkSpeed(value, v, list) && checkFuel(value, v, list)) {
                list.add(v);
              }
            } else if (value.isSpeed) {
              if (checkSpeed(value, v, list)) {
                list.add(v);
              }
            } else if (value.isFuel) {
              if (checkFuel(value, v, list)) {
                list.add(v);
              }
            } else {
              list.add(v);
            }
          }
          if (value.isStatus) {
            list = checkStatus(value, list);
          }
          // if (value.isSpeed) {
          //   for (Vehicle v in listVehicle) {
          //     if (v.gps!.speed >= value.minSpeed &&
          //         v.gps!.speed <= value.maxSpeed) {
          //       list.add(v);
          //     }
          //   }
          // }
          // if (value.isFuel) {
          //   for (Vehicle v in listVehicle) {
          //     if (v.gps!.fuel_per! >= value.fuel) {
          //       list.add(v);
          //     }
          //   }
          // }

          listSearchVehicle = list.toSet().toList();
          for (MemberGroup m in listSearchGroup) {
            m.vehicle.clear();
            for (Vehicle v in listSearchVehicle) {
              if (m.name == v.fleet!.fleet_name) {
                m.vehicle.add(v);
              }
            }
          }

          refresh();
        },
      ),
    );
  }

  bool checkSpeed(CarFilter value, Vehicle v, List list) {
    return (v.gps!.speed >= value.minSpeed && v.gps!.speed <= value.maxSpeed);
  }

  bool checkFuel(CarFilter value, Vehicle v, List list) {
    return (v.gps!.fuel_per! >= value.fuel);
  }

  List io_name = ["driving", "idling", "parking", "offline"];

  List<Vehicle> checkStatus(CarFilter value, List list) {
    // print(list.length);
    // print(value.status);
    List<Vehicle> aa = [];
    for (Vehicle v in list) {
      print(v.gps!.io_name!.toLowerCase());
      if (value.status[0] && v.gps!.io_name!.toLowerCase() == io_name[0]) {
        aa.add(v);
      } else if (value.status[1] && v.gps!.io_name!.toLowerCase() == io_name[1]) {
        aa.add(v);
      } else if (value.status[2] && v.gps!.io_name!.toLowerCase() == io_name[2]) {
        aa.add(v);
      } else if (value.status[3] &&
          v.gps!.io_name!.toLowerCase() == io_name[3]) {
        aa.add(v);
      }

      // for (int i = 0; i < value.status.length; i++) {
      //   bool a = value.status[i];
      //   if (a && v.gps!.io_name!.toLowerCase() == io_name[i]) {
      //     aa.add(v);
      //   } else {
      //     // list.remove(v);
      //   }
      // }

    }
    return aa;

    // for (int i = 0; i < value.status.length; i++) {
    //   var a = value.status[i];
    //   if (a && v.gps!.io_name!.toLowerCase() == io_name[i]) {
    //     list.add(v);
    //   }
    // }
    // if (value.status[0] && v.gps!.io_name!.toLowerCase() == "driving") {
    //   list.add(v);
    // }
    // if (value.status[1] && v.gps!.io_name!.toLowerCase() == "idling") {
    //   list.add(v);
    // }
    // if (value.status[2] && v.gps!.io_name!.toLowerCase() == "ign.off") {
    //   list.add(v);
    // }
    // if (value.status[3] && v.gps!.io_name!.toLowerCase() == "offline") {
    //   list.add(v);
    // }
  }

  showSort(BuildContext context) {
    showMaterialModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => HomeCarSortPage(
        select: (i) {
          switch (i) {
            case 0:
              listSearchGroup
                  .sort((a, b) => a.vehicle.length.compareTo(b.vehicle.length));
              break;
            case 1:
              listSearchGroup
                  .sort((a, b) => b.vehicle.length.compareTo(a.vehicle.length));
              break;
            case 2:
              listSearchGroup.sort((a, b) => a.name!.compareTo(b.name!));
              break;
            case 3:
              listSearchGroup.sort((a, b) => b.name!.compareTo(a.name!));
              break;
          }
          refresh();
        },
      ),
    );
  }

  search(String value) {
    listSearchVehicle.clear();
    if (value.isEmpty) {
      listSearchVehicle.addAll(listVehicle);
    } else {
      for (Vehicle v in listVehicle) {
        if (v.info!.vin_no!.contains(value)) {
          listSearchVehicle.add(v);
        }
        if (v.info!.licenseplate!.contains(value)) {
          listSearchVehicle.add(v);
        }
        if (v.info!.licenseprov!.contains(value)) {
          listSearchVehicle.add(v);
        }
        if (v.info!.vehicle_name!.contains(value)) {
          listSearchVehicle.add(v);
        }
      }
      List<Vehicle> result =
          LinkedHashSet<Vehicle>.from(listSearchVehicle).toList();
      listSearchVehicle.clear();
      listSearchVehicle.addAll(result);
    }

    refresh();
  }

  searchFleet(String value) {
    listSearchGroup.clear();
    if (value.isEmpty) {
      listSearchGroup.addAll(listNameGroup);
    } else {
      for (MemberGroup v in listNameGroup) {
        if (v.name!.toLowerCase().contains(value)) {
          listSearchGroup.add(v);
        }
      }
    }

    refresh();
  }

  TabController? tabController;

  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: TabBar(
              controller: tabController,
              tabs: [
                Tab(text: Languages.of(context)!.vehicle_group),
                Tab(text: Languages.of(context)!.vehicle_list),
              ],
              indicatorColor: ColorCustom.primaryAssentColor,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: GoogleFonts.kanit(),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              //Add this to give height
              // height: MediaQuery.of(context).size.height,
              child: TabBarView(
                controller: tabController,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Expanded(
                        child: !isLoading
                            ? isError
                                ? Center(
                                    child: Text(
                                      Languages.of(context)!.please_try_again,
                                      style: const TextStyle(
                                          color: ColorCustom.black,
                                          fontSize: 16),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(10),
                                    shrinkWrap: false,
                                    itemCount: listSearchGroup.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      MemberGroup? group;
                                      try {
                                        group = listSearchGroup[index];
                                      } catch (e) {
                                        return Container();
                                      }

                                      return GestureDetector(
                                        onTap: () {
                                          // Navigator.push(
                                          //     context, MaterialPageRoute(builder: (_) => MotorbikePage()));
                                          showCarList(group!);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: ColorCustom.greyBG2),
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          padding: const EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              left: 10,
                                              right: 10),
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
                                                '${group.vehicle.length} ${Languages.of(context)!.unit}',
                                                style: const TextStyle(
                                                    color: ColorCustom.primaryColor,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                            : Center(
                                child: Column(children: [
                                  Text(
                                    Languages.of(context)!.loading,
                                    style: const TextStyle(
                                        color: ColorCustom.black, fontSize: 16),
                                  ),
                                  const CircularProgressIndicator(color: ColorCustom.primaryColor)
                                ]),
                              )),
                  ]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(10),
                          shrinkWrap: false,
                          itemCount: listSearchVehicle.length,
                          itemBuilder: (BuildContext context, int index) {
                            Vehicle v = listSearchVehicle[index];
                            return GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //     context, MaterialPageRoute(builder: (_) => MotorbikePage()));
                                context.read<PageProvider>().selectVehicle(v);
                                // selectVehicle = v;
                                Navigator.of(context)
                                    .popUntil(ModalRoute.withName('/root'));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: ColorCustom.greyBG2),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 10, right: 10),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Utils.statusCarImage(
                                        v.gps!.io_name!, v.gps!.speed),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            v.info!.vehicle_name!,
                                            style: const TextStyle(
                                                color: ColorCustom.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${v!.gps!.location!.admin_level3_name!} ${v!.gps!.location!.admin_level2_name!} ${v!.gps!.location!.admin_level1_name!}",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorCustom.greyBG2),
                                      child: Column(
                                        children: [
                                          Text(
                                            v.gps!.speed.toStringAsFixed(0),
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
                                    // OutlinedButton(
                                    //   onPressed: () {},
                                    //   child:  Column(
                                    //     children: [
                                    //       Text(
                                    //         v.gps!.speed.toStringAsFixed(0),
                                    //         style: TextStyle(
                                    //             color: ColorCustom.black,
                                    //             fontSize: 16,
                                    //             fontWeight: FontWeight.bold),
                                    //       ),
                                    //       Text('กม/ชม',
                                    //           style: TextStyle(
                                    //             color: Colors.grey,
                                    //             fontSize: 12,
                                    //           )),
                                    //     ],
                                    //   ),
                                    //   style: OutlinedButton.styleFrom(
                                    //     side: BorderSide(width: 1.0, color: Colors.grey),
                                    //     shape: CircleBorder(),
                                    //     padding: EdgeInsets.all(5),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    isSpeed = true;
    isFuel = true;
    isStatus = true;
    select = 2;

    speed = "";
    filterlowerValue = 50;
    filterupperValue = 120;
    fuel = 25;

    statusSelect = [true, true, true, true];
    // groupController.unselectAll();
    groupController.selectIndexes([0, 1, 2, 3]);
    print("dispose");
    super.dispose();
  }

  showInfo() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const InfoPage(count: 0);
        });
  }

  var searchText = "";

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
                  child: SvgPicture.asset(
                    "assets/images/Fix Icon iov14.svg",
                    color: ColorCustom.primaryColor,
                  ),
                  onTap: () {
                    showInfo();
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  searchText = value;
                  if (tabController!.index == 1) {
                    search(value);
                  } else {
                    searchFleet(value);
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
                  fillColor: ColorCustom.greyBG2,
                  prefixIcon: const Icon(Icons.search),
                  hintText: Languages.of(context)!.search,
                  hintStyle: const TextStyle(fontSize: 16),
                  // fillColor: colorSearchBg,
                ),
              ),
            ),
            Row(
              children: [
                tabController!.index == 1
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          color: ColorCustom.greyBG,
                        ),
                        child: InkWell(
                          onTap: () {
                            showFilter();
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.filter_alt,
                                size: 15,
                                color: Colors.black,
                              ),
                              Text(
                                Languages.of(context)!.filter,
                                style: const TextStyle(
                                  color: ColorCustom.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                tabController!.index == 0
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          color: ColorCustom.greyBG,
                        ),
                        child: InkWell(
                          onTap: () {
                            showSort(context);
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.sort_by_alpha,
                                size: 15,
                                color: Colors.black,
                              ),
                              Text(
                                Languages.of(context)!.sort,
                                style: const TextStyle(
                                  color: ColorCustom.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                Expanded(child: Container()),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                  decoration: BoxDecoration(
                    color: ColorCustom.blueLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tabController!.index == 0
                        ? '${listSearchGroup.length} Fleet'
                        : '${listSearchVehicle.length} ${Languages.of(context)!.unit}',
                    style: const TextStyle(
                      color: ColorCustom.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
            Expanded(child: _tabSection(context))
          ],
        ),
      ),
    );
  }
}
