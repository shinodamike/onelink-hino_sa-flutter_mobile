import 'package:flutter/material.dart';
import 'package:iov/utils/color_custom.dart';

class ActionBarBack extends StatefulWidget {
  const ActionBarBack({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<ActionBarBack> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Container(
      width: double.infinity,
      color: ColorCustom.greyBG,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.centerLeft,
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: Text(widget.title,
                style: const TextStyle(
                    color: ColorCustom.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: const Opacity(
              opacity: 0.0,
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
