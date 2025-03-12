
import 'package:flutter/material.dart';
import 'package:iov/utils/color_custom.dart';

class ActionBar extends StatefulWidget {
  const ActionBar({Key? key, required this.title}) : super(key: key);

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

class _PageState extends State<ActionBar> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: ColorCustom.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // InkWell(
          //   onTap: () {},
          //   child: Container(
          //     margin: EdgeInsets.only(left: 10),
          //     child: Icon(
          //       Icons.menu,
          //       color: Colors.white,
          //       size: 30,
          //     ),
          //   ),
          // ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(widget.title,
                style: const TextStyle(
                    color: ColorCustom.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ),
          // InkWell(
          //   child: Container(
          //     margin: EdgeInsets.only(right: 10),
          //     width: 30,
          //     height: 30,
          //     decoration: BoxDecoration(
          //       image: DecorationImage(
          //           fit: BoxFit.cover,
          //           image: NetworkImage(
          //               'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBwgu1A5zgPSvfE83nurkuzNEoXs9DMNr8Ww&usqp=CAU')),
          //       borderRadius: BorderRadius.all(Radius.circular(15.0)),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
