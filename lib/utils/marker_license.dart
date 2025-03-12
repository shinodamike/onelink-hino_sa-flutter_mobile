import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iov/model/vehicle.dart';
import 'dart:ui' as ui;

import 'color_custom.dart';

class MarkerLicense {
  static BitmapDescriptor? iconTest;

  static Future<BitmapDescriptor> getMarkerIcon(
      Vehicle v, isLicense, Uint8List imageBytes) async {
    ui.Image imageOri = await getImageFromPath(imageBytes);
    ui.Image image = await rotatedImage(imageOri, v.gps!.course!);
    if (!isLicense) {
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List uint8List = byteData!.buffer.asUint8List();
      iconTest = BitmapDescriptor.fromBytes(uint8List);

      return iconTest!;
    }

    // Size size = Size(image.height.toDouble(), image.height.toDouble());
    Size size = Size(500, image.height.toDouble());
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // final Radius radius = Radius.circular(size.width / 2);
    //
    final Paint tagPaint = Paint()..color = ColorCustom.white;
    const double tagWidth = 120.0;
    // print(size.width);

    // canvas.drawRect(Rect.fromLTWH(size.width/4, 0.0, tagWidth, 50), tagPaint);

    // Add tag text
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      maxLines: 1,
    );
    textPainter.text = TextSpan(
      text: "  ${v.info!.vehicle_name!}  ",
      style: const TextStyle(
          fontSize: 40.0, color: Colors.black, backgroundColor: Colors.white),
    );

    textPainter.layout();
    // textPainter.paint(
    //     canvas,
    //     Offset(size.width - tagWidth / 2 - textPainter.width / 2,
    //         tagWidth / 2 - textPainter.height / 2));
    var pos = (size.width / 2) - (textPainter.width / 2);
    textPainter.paint(canvas, Offset(pos, 0.5));

    final pathGreen = Path();
    // pathGreen.moveTo(size.width/2, textPainter.height+15);
    pathGreen.moveTo(size.width / 2, textPainter.height + 15);
    pathGreen.lineTo(110, textPainter.height);
    pathGreen.lineTo(140, textPainter.height);
    pathGreen.close();
    // print(pos);
    // print(textPainter.width);

    canvas.drawPath(pathGreen, tagPaint);
    // Oval for the image
    Rect oval = Rect.fromLTWH(0, 0, size.width, size.height);

    // Add path for oval image
    // canvas.clipPath(Path()..addOval(oval));

    // Add image

    // print("GET MARKER ICON CUSTOMISE CALLED${image.height}");
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.none);
    // paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);
    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();
    // iconTest = BitmapDescriptor.fromBytes(uint8List);

    return BitmapDescriptor.fromBytes(uint8List);
  }

  static Future<ui.Image> rotatedImage(ui.Image image, double angle) {
    var pictureRecorder = ui.PictureRecorder();
    Canvas canvas = Canvas(pictureRecorder);
    double radians = angle * pi / 180;
    final translateX = image.height / 2;
    final translateY = image.height / 2;
    canvas.translate(translateX, translateY);
    canvas.rotate(radians);
    canvas.translate(-translateX, -translateY);
    canvas.drawImage(image, Offset.zero, Paint());

    return pictureRecorder.endRecording().toImage(image.height, image.height);
  }

  static Future<ui.Image> getImageFromPath(Uint8List imageBytes) async {
    //String fullPathOfImage = await getFileData(imagePath);

    //File imageFile = File(fullPathOfImage);
    // ByteData bytes = await rootBundle.load(imagePath);
    // Uint8List imageBytes = bytes.buffer.asUint8List();

    // Uint8List? imageBytes = getMapIconByte(v);
    //Uint8List imageBytes = imageFile.readAsBytesSync();

    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      return completer.complete(img);
    });
    //print("COMPLETERR DONE Full path of image is"+imagePath);
    return completer.future;
  }
}
