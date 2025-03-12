import 'package:flutter/material.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/utils/color_custom.dart';

class InfoPage extends StatefulWidget {
   const InfoPage({Key? key, required this.count}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final int count;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<InfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.info,
                    size: 30,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(Languages.of(context)!.info_map,
                      style: const TextStyle(
                          color: ColorCustom.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                      widget.count!=0?"${Languages.of(context)!.total_vehicle} ${widget.count} ${Languages.of(context)!.unit}":"",
                    style: const TextStyle(
                        color: ColorCustom.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Colors.grey,
                height: 1,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.circle,
                    color: ColorCustom.run,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(Languages.of(context)!.driving,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  const Icon(
                    Icons.circle,
                    color: ColorCustom.parking,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(Languages.of(context)!.ignOff,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.circle,
                    color: ColorCustom.idle,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(Languages.of(context)!.idle,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  const Icon(
                    Icons.circle,
                    color: ColorCustom.offline,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(Languages.of(context)!.offline,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.circle,
                    color: ColorCustom.over_speed,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(Languages.of(context)!.overspeed_info,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  const Icon(
                    Icons.circle,
                    color: ColorCustom.primaryColor,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(Languages.of(context)!.vehicle_group,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.credit_card,
                    color: Colors.green,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(Languages.of(context)!.swipe_card,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  const Icon(
                    Icons.credit_card,
                    color: Colors.red,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(Languages.of(context)!.wrong_license,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.credit_card,
                    color: Colors.grey,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(Languages.of(context)!.no_swipe_card,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  const Icon(
                    Icons.circle,
                    color: Colors.lightGreen,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(Languages.of(context)!.rpm_green,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.circle,
                    color: Colors.red,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(Languages.of(context)!.rpm_red,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(10),
          ),
          child: const Icon(
            Icons.close,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
