
import 'package:flutter/material.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/utils/color_custom.dart';

class BackIOS extends StatefulWidget {
  const BackIOS({Key? key, }) : super(key: key);

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

class _PageState extends State<BackIOS> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return  Container(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: (){
          Navigator.pop(context);
        },
        child: Row(
          children: [
            const Icon(
              Icons.arrow_back_ios,
              size: 30,
              color: ColorCustom.primaryColor,
            ),
            Text(Languages.of(context)!.backBtn,
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
  }
}
