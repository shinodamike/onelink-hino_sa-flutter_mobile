import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/model/member_group.dart';
import 'package:iov/model/vehicle.dart';
import 'package:iov/provider/page_provider.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:iov/utils/utils.dart';
import 'package:iov/widget/back_ios.dart';


import 'package:provider/src/provider.dart';


class HomeCarDetailPage extends StatefulWidget {
  const HomeCarDetailPage({Key? key,required this.group}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final MemberGroup group;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomeCarDetailPage> with SingleTickerProviderStateMixin{
  @override
  void initState() {
    listSearchDetail.addAll(widget.group.vehicle);
    super.initState();
  }



  refresh() {
    setState(() {});
  }

  List<Vehicle> listSearchDetail = [];




  searchDetail(String value,MemberGroup group) {
    listSearchDetail.clear();
    if (value.isEmpty) {
      listSearchDetail.addAll(group.vehicle);
    } else {
      for (Vehicle v in group.vehicle) {
        if (v.info!.vin_no!.contains(value)) {
          listSearchDetail.add(v);
        }
        if (v.info!.licenseplate!.contains(value)) {
          listSearchDetail.add(v);
        }
        if (v.info!.licenseprov!.contains(value)) {
          listSearchDetail.add(v);
        }
        if (v.info!.vehicle_name!.contains(value)) {
          listSearchDetail.add(v);
        }
      }
      List<Vehicle> result = LinkedHashSet<Vehicle>.from(listSearchDetail).toList();
      listSearchDetail.clear();
      listSearchDetail.addAll(result);
    }

    refresh();
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
              const BackIOS(),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  onChanged: (value){
                    searchDetail(value,widget.group);
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
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      widget.group.name!,
                      style: const TextStyle(
                          color: ColorCustom.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 3, bottom: 3),
                    decoration: BoxDecoration(
                      color: ColorCustom.blueLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text( '${listSearchDetail.length} ${Languages.of(context)!.unit}',
                      style: const TextStyle(
                        color: ColorCustom.primaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    shrinkWrap: true,
                    primary: false,
                    itemCount: listSearchDetail.length,
                    itemBuilder: (BuildContext context, int index) {
                      // Member m = group.members[index];
                      Vehicle v = listSearchDetail[index];

                      return GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context, MaterialPageRoute(builder: (_) => MotorbikePage()));
                          context.read<PageProvider>().selectVehicle(v);
                          // selectVehicle = v;
                          Navigator.of(context).popUntil(ModalRoute.withName('/root'));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
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
                              const SizedBox(
                                width: 10,
                              ),
                              Utils.statusCarImage(v.gps!.io_name!,v.gps!.speed),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      v.info!.vehicle_name != null
                                          ? v.info!.vehicle_name!
                                          : "",
                                      style: const TextStyle(
                                          color: ColorCustom.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(v.info!.licenseprov!,
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
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
            ],
          ),),
    );
  }
}
