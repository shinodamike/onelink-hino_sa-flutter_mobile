
import 'package:flutter/material.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/utils/color_custom.dart';




int select = 2;

class HomeCarSortPage extends StatefulWidget {
  const HomeCarSortPage(
      {Key? key,
      this.title,
      required this.select})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final ValueChanged<int> select;
  final String? title;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomeCarSortPage> {
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
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(Languages.of(context)!.sort_by,
              style: const TextStyle(
                color: ColorCustom.black,
                fontSize: 20,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          InkWell(
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    widget.title != null ? widget.title! : Languages.of(context)!.unit_ascending,
                    style: const TextStyle(
                      color: ColorCustom.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                Radio(
                  value: 0,
                  onChanged: (va) {
                    // isSwitched = va;
                    setState(() {
                      select = va as int;
                    });
                    widget.select.call(select);
                  },
                  groupValue: select,
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            onTap: () {
              setState(() {
                select = 0;
              });
              widget.select.call(select);
            },
          ),
          InkWell(
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(Languages.of(context)!.unit_descending,
                    style: const TextStyle(
                      color: ColorCustom.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                Radio(
                  value: 1,
                  onChanged: (va) {
                    // isSwitched = va;
                    setState(() {
                      select = va as int;
                    });
                    widget.select.call(select);
                  },
                  groupValue: select,
                ),
                // Switch(
                //   value: isSwitched2,
                //   onChanged: (value) {
                //     setState(() {
                //       isSwitched2 = value;
                //       widget.alphabet.call(value);
                //     });
                //   },
                // ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            onTap: () {
              setState(() {
                select = 1;
              });
              widget.select.call(select);
            },
          ),
          InkWell(
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    widget.title != null ? widget.title! : Languages.of(context)!.alphabet_a_z,
                    style: const TextStyle(
                      color: ColorCustom.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                Radio(
                  value: 2,
                  onChanged: (va) {
                    // isSwitched = va;
                    setState(() {
                      select = va as int;
                    });
                    widget.select.call(select);
                  },
                  groupValue: select,
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            onTap: () {
              setState(() {
                select = 2;
              });
              widget.select.call(select);
            },
          ),
          InkWell(
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    widget.title != null ? widget.title! : Languages.of(context)!.alphabet_z_a,
                    style: const TextStyle(
                      color: ColorCustom.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                Radio(
                  value: 3,
                  onChanged: (va) {
                    // isSwitched = va;
                    setState(() {
                      select = va as int;
                    });
                    widget.select.call(select);
                  },
                  groupValue: select,
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            onTap: () {
              setState(() {
                select = 3;
              });
              widget.select.call(select);
            },
          ),
        ],
      ),
    ));
  }
}
