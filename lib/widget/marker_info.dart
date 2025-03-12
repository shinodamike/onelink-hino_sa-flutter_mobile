import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class MarkerInfo extends StatefulWidget {
  final Function getBitmapImage;
  final String text;
  const MarkerInfo({Key? key, required this.getBitmapImage, required this.text}) : super(key: key);

  @override
  _MarkerInfoState createState() => _MarkerInfoState();
}

class _MarkerInfoState extends State<MarkerInfo> {
  final markerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getUint8List(markerKey)
        .then((markerBitmap) => widget.getBitmapImage(markerBitmap)));
  }

  Future<Uint8List> getUint8List(GlobalKey markerKey) async {
    RenderRepaintBoundary? boundary =
    markerKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    var image = await boundary!.toImage(pixelRatio: 2.0);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: markerKey,
      child: Container(
        padding: const EdgeInsets.only(bottom: 29),
        child: Container(
          width: 100,
          height: 100,
          color: const Color(0xFF000000),
          child: Text(
            widget.text,
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }
}