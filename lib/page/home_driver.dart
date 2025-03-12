import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:iov/api/api.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/model/driver.dart';
import 'package:iov/page/home_driver_detail.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:iov/utils/utils.dart';


import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'home_driver_sort.dart';

class HomeDriverPage extends StatefulWidget {
  const HomeDriverPage({Key? key}) : super(key: key);

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

class _PageState extends State<HomeDriverPage> {
  @override
  void initState() {
    getDataDriver(context);
    super.initState();
  }

  var dateSearch = "";
  List<Driver> listDriver = [];

  getDataDriver(BuildContext context) {
    listSearch.clear();
    Api.get(context, Api.listdriver).then((value) => {
          if (value != null)
            {
              dateSearch = Utils.getDateTimeCreate(),
              listDriver = List.from(value['result'])
                  .map((a) => Driver.fromJson(a))
                  .toList(),
              listSearch.addAll(listDriver),
              listSearch
                  .sort((a, b) => b.datetimeSwipe!.compareTo(a.datetimeSwipe!)),
              refresh(),
            }
          else
            {}
        });
  }

  @override
  void dispose() {
    select_driver = 5;
    super.dispose();
  }

  refresh() {
    setState(() {});
  }

  showSort(BuildContext context) {
    showMaterialModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => HomeDriverSortPage(
        select: (i) {
          switch (i) {
            case 0:
              List<Driver> listGreen = [];
              List<Driver> listRed = [];
              List<Driver> listYellow = [];
              List<Driver> listGrey = [];
              for (Driver d in listDriver) {
                if (d.statusSwipeCard == 0) {
                  listRed.add(d);
                  listRed.sort((a, b) => b.score!.compareTo(a.score!));
                } else if (d.statusSwipeCard == 1) {
                  listGreen.add(d);
                  listGreen.sort((a, b) => b.score!.compareTo(a.score!));
                } else if (d.statusSwipeCard == 2) {
                  print("wrong type");
                  listYellow.add(d);
                  listYellow.sort((a, b) => b.score!.compareTo(a.score!));
                } else {
                  print("expire");
                  listGrey.add(d);
                  listGrey.sort((a, b) => b.score!.compareTo(a.score!));
                }
              }
              listSearch.clear();
              listSearch.addAll(listGreen);
              listSearch.addAll(listRed);
              listSearch.addAll(listYellow);
              listSearch.addAll(listGrey);
              // listSearch.sort(
              //     (a, b) => a.statusSwipeCard!.compareTo(b.statusSwipeCard!));

              break;
            case 1:
              listSearch.sort((a, b) => a.firstname!.compareTo(b.firstname!));
              break;
            case 2:
              listSearch.sort((a, b) => b.score!.compareTo(a.score!));
              break;
            case 3:
              listSearch.sort((a, b) => a.score!.compareTo(b.score!));
              break;
            case 4:
              listSearch.sort((a, b) => b.firstname!.compareTo(a.firstname!));
              break;
            case 5:
              listSearch
                  .sort((a, b) => b.datetimeSwipe!.compareTo(a.datetimeSwipe!));
              break;
          }
          refresh();
        },
      ),
    );
  }

  showDetail(Driver driverClick) {
    showBarModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => HomeDriverDetailPage(
        driver: driverClick,
      ),
    );
  }

  List<Driver> listSearch = [];

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
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      getDataDriver(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 3, bottom: 3),
                      decoration: BoxDecoration(
                        color: ColorCustom.greyBG,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.centerRight,
                      width: 150,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.refresh,
                            size: 15,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${Languages.of(context)!.last_update} $dateSearch',
                            style: const TextStyle(
                              color: ColorCustom.black,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    onChanged: (value) {
                      listSearch.clear();
                      if (value.isEmpty) {
                        listSearch.addAll(listDriver);
                        listSearch.sort((a, b) =>
                            b.datetimeSwipe!.compareTo(a.datetimeSwipe!));
                      } else {
                        for (Driver v in listDriver) {
                          print("$value  ${v.firstname!}");
                          if (v.firstname!.toLowerCase().contains(value)) {
                            listSearch.add(v);
                          }
                          if (v.lastname!.toLowerCase().contains(value)) {
                            listSearch.add(v);
                          }
                          if (v.score!.toString().contains(value)) {
                            listSearch.add(v);
                          }
                          if (v.licensePlateNo!.contains(value)) {
                            listSearch.add(v);
                          }
                          if (v.vehicleName!.toLowerCase().contains(value)) {
                            listSearch.add(v);
                          }
                        }
                        List<Driver> result = LinkedHashSet<Driver>.from(listSearch).toList();
                        listSearch.clear();
                        listSearch.addAll(result);
                      }

                      refresh();
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
                ],
              ),
            ),
            Row(
              children: [
                // Container(
                //   padding: EdgeInsets.all(10),
                //   margin: EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.all(
                //       Radius.circular(20.0),
                //     ),
                //     color: ColorCustom.greyBG,
                //   ),
                //   child: InkWell(
                //     onTap: () {
                //       // showFilter();
                //     },
                //     child: Row(
                //       children: [
                //         Icon(
                //           Icons.filter_alt,
                //           size: 15,
                //           color: Colors.black,
                //         ),
                //         Text(
                //           'กลุ่มรถ A',
                //           style: TextStyle(
                //             color: ColorCustom.black,
                //             fontSize: 12,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Container(
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
                        Text(Languages.of(context)!.sort,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  padding:
                      const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  child: Row(
                    children: [
                      Text(Languages.of(context)!.total,
                        style: const TextStyle(
                          color: ColorCustom.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${listSearch.length} ${Languages.of(context)!.unit_driver}',
                        style: const TextStyle(
                          color: ColorCustom.primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                shrinkWrap: false,
                itemCount: listSearch.length,
                itemBuilder: (BuildContext context, int index) {
                  Driver driver = listSearch[index];

                  return GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context, MaterialPageRoute(builder: (_) => MotorbikePage()));
                      showDetail(driver);
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
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              driver.photoUrl!.isEmpty
                                  ? Image.asset(
                                      "assets/images/profile_empty.png",
                                      width: 60,
                                      height: 60,
                                    )
                                  : Image.network(
                                      driver.photoUrl!,
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
                                  "${driver.prefix!} ${driver.firstname!} ${driver.lastname!}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Utils.swipeCard(driver,context),
                                driver.display_datetime_swipe!.isNotEmpty
                                    ? Text(
                                        driver.display_datetime_swipe!,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      )
                                    : Container(),
                                Row(
                                  children: [
                                    driver.vehicleName!.isNotEmpty
                                        ? Text(
                                            driver.vehicleName!,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          )
                                        : Container(),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    driver.vehicle != null &&
                                            driver.vehicle!.info!.licenseprov!
                                                .isNotEmpty
                                        ? Text(
                                            driver.vehicle!.info!.licenseprov!,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
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
                                  Utils.numberFormatInt(driver.score!),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
