
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/model/car_filter.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:iov/widget/back_ios.dart';


import 'package:syncfusion_flutter_sliders/sliders.dart';

bool isSpeed = true;
bool isFuel = true;
bool isStatus = true;

var speed = "";
double filterlowerValue = 50;
double filterupperValue = 120;
double fuel = 25;

var statusSelect = [true, true, true, true];
final groupController = GroupButtonController();

class HomeCarFilterPage extends StatefulWidget {
  const HomeCarFilterPage({Key? key, required this.filter}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final ValueChanged<CarFilter> filter;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomeCarFilterPage> {
  // List<int> listTemp = [];
  SfRangeValues _values = SfRangeValues(filterlowerValue, filterupperValue);

  @override
  void initState() {
    setSelect();

    super.initState();
  }

  setSelect() {
    for (int i = 0; i < statusSelect.length; i++) {
      if (statusSelect[i]) {
        // listTemp.add(i);
        groupController.selectIndex(i);
      }
    }
  }

  toggleBtn(String text, bool active) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(20.0),
        ),
        color: active ? ColorCustom.blue : ColorCustom.greyBG,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : ColorCustom.black,
          fontSize: 14,
        ),
      ),
    );
  }

  bool clear = false;


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
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              side: BorderSide(color: Colors.grey)))),
                  onPressed: () {
                    isSpeed = true;
                    isFuel = true;
                    isStatus = true;
                    speed = "";
                    filterlowerValue = 50;
                    filterupperValue = 120;
                    fuel = 25;
                    statusSelect = [true, true, true, true];
                    groupController.selectIndexes([0,1,2,3]);
                    // groupController.unselectAll();
                    SfRangeValues values = SfRangeValues(filterlowerValue, filterupperValue);
                    _values = values;


                    clear = true;
                    setState(() {});
                  },
                  child: Text(Languages.of(context)!.reset_filter,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Switch(
                        value: isSpeed,
                        onChanged: (value) {
                          setState(() {
                            isSpeed = value;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(Languages.of(context)!.speed,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        "${filterlowerValue.toStringAsFixed(0)}-${filterupperValue.toStringAsFixed(0)} ${Languages.of(context)!.km_h}",
                        style: const TextStyle(
                          color: ColorCustom.primaryColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SfRangeSlider(
                    min: 40.0,
                    max: 160.0,
                    values: _values,
                    interval: 1,
                    showTicks: false,
                    showLabels: false,
                    enableTooltip: false,
                    minorTicksPerInterval: 1,
                    onChanged: (SfRangeValues values) {
                      setState(() {
                        filterlowerValue = values.start;
                        filterupperValue = values.end;
                        _values = values;
                      });
                    },
                  ),
                  // FlutterSlider(
                  //   values: [_lowerValue, _upperValue],
                  //   rangeSlider: true,
                  //   lockHandlers: false,
                  //   max: 160,
                  //   min: 40,
                  //   disabled: !isSpeed,
                  //   onDragging: (handlerIndex, lowerValue, upperValue) {
                  //     _lowerValue = lowerValue;
                  //     _upperValue = upperValue;
                  //     setState(() {});
                  //   },
                  // ),
                  Row(
                    children: [
                      Switch(
                        value: isFuel,
                        onChanged: (value) {
                          setState(() {
                            isFuel = value;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          '${Languages.of(context)!.fuel} (%)',
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        "${fuel.toStringAsFixed(0)}%",
                        style: const TextStyle(
                          color: ColorCustom.blue,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SfSlider(
                    min: 0.0,
                    max: 100.0,
                    value: fuel,
                    interval: 1,
                    showTicks: false,
                    showLabels: false,
                    enableTooltip: false,
                    minorTicksPerInterval: 1,
                    onChanged: (dynamic value) {
                      setState(() {
                        fuel = value;
                      });
                    },
                  ),
                  // FlutterSlider(
                  //   values: [fuel],
                  //   max: 100,
                  //   min: 0,
                  //   disabled: !isFuel,
                  //   rangeSlider: false,
                  //   onDragging: (handlerIndex, lowerValue, upperValue) {
                  //     fuel = lowerValue;
                  //     setState(() {});
                  //   },
                  // ),
                  Row(
                    children: [
                      Switch(
                        value: isStatus,
                        onChanged: (value) {
                          setState(() {
                            isStatus = value;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(Languages.of(context)!.status,
                          style: const TextStyle(
                            color: ColorCustom.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //FIXME : GroupButton comment option [disabledButtons,crossGroupAlignment,mainGroupAlignment,unselectedColor].
                  GroupButton(
                    controller: groupController,
                    // disabledButtons: isStatus == false ? [0, 1, 2, 3] : [],
                    // crossGroupAlignment: CrossGroupAlignment.start,
                    // mainGroupAlignment: MainGroupAlignment.start,
                    // unselectedColor: ColorCustom.greyBG2,
                    isRadio: false,
                    // spacing: 10,
                    onSelected: (str, i, value) {
                      statusSelect[i] = value;
                    },
                    // selectedButtons: listTemp,

                    buttons: [
                      Languages.of(context)!.driving,
                      Languages.of(context)!.idle,
                      Languages.of(context)!.ignOff,
                      Languages.of(context)!.offline
                    ],
                    // borderRadius: BorderRadius.circular(20.0),
                  ),
                  // Row(
                  //   children: [
                  //     Switch(
                  //       value: false,
                  //       onChanged: (value) {},
                  //     ),
                  //     Expanded(
                  //       child: Text(
                  //         'อุปกรณ์เสริม',
                  //         style: TextStyle(
                  //           color: ColorCustom.black,
                  //           fontSize: 14,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // GroupButton(
                  //   disabledButtons: [0, 1, 2],
                  //   unselectedColor: ColorCustom.greyBG2,
                  //   isRadio: false,
                  //   spacing: 10,
                  //   onSelected: (index, isSelected) =>
                  //       print('$index button is selected'),
                  //   buttons: ["กล้องถ่ายรูป", "กล้องวิดีโอ", "เซนเซอร์ A"],
                  //   borderRadius: BorderRadius.circular(20.0),
                  // ),
                  // Row(
                  //   children: [
                  //     Switch(
                  //       value: false,
                  //       onChanged: (value) {},
                  //     ),
                  //     Expanded(
                  //       child: Text(
                  //         'พฤติกรรมการขับขี่',
                  //         style: TextStyle(
                  //           color: ColorCustom.black,
                  //           fontSize: 14,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // GroupButton(
                  //   unselectedColor: ColorCustom.greyBG2,
                  //   isRadio: false,
                  //   spacing: 10,
                  //   disabledButtons: [0, 1],
                  //   onSelected: (index, isSelected) =>
                  //       print('$index button is selected'),
                  //   buttons: ["ออกตัวกะทันหัน (2)", "เร่งความเร็วกะทันหัน"],
                  //   borderRadius: BorderRadius.circular(20.0),
                  // ),
                  // Row(
                  //   children: [
                  //     Switch(
                  //       value: false,
                  //       onChanged: (value) {},
                  //     ),
                  //     Expanded(
                  //       child: Text(
                  //         'สถานะการซ่อมบำรุง',
                  //         style: TextStyle(
                  //           color: ColorCustom.black,
                  //           fontSize: 14,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // GroupButton(
                  //   unselectedColor: ColorCustom.greyBG2,
                  //   isRadio: false,
                  //   spacing: 10,
                  //   disabledButtons: [0, 1, 2, 3],
                  //   onSelected: (index, isSelected) =>
                  //       print('$index button is selected'),
                  //   buttons: [
                  //     "ไฟเครื่องยนต์เตือน (1)",
                  //     "เลยระยะเวลาซ่อมบำรุง",
                  //     "ถึงระยะเวลาซ่อมบำรุง",
                  //     "ถูกลดกำลังเครื่องยนต์"
                  //   ],
                  //   borderRadius: BorderRadius.circular(20.0),
                  // ),
                ],
              ),
            )),
            Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorCustom.primaryColor,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // <-- Radius
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  var filter = CarFilter();
                  filter.isSpeed = isSpeed;
                  filter.minSpeed = filterlowerValue.toInt();
                  filter.maxSpeed = filterupperValue.toInt();
                  filter.isFuel = isFuel;
                  filter.fuel = fuel.toInt();
                  filter.isStatus = isStatus;
                  filter.status = statusSelect;

                  widget.filter.call(filter);
                },
                child: Text(Languages.of(context)!.confirm,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
