import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iov/model/EventHolder.dart';
import 'package:iov/model/factory.dart';
import 'package:iov/model/vehicle.dart';
import 'package:iov/page/home_realtime.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:image/image.dart' as IMG;

bool mapsPlay = false;
Duration? mapsDuration;
int mapsPosition = -1;

class MapPlaybackWidget extends StatefulWidget {
  const MapPlaybackWidget(
      {Key? key,
      required this.vid,
      required this.listRoute,
      this.position,
      this.positionChange})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final List listRoute;
  final String vid;
  final int? position;
  final ValueChanged? positionChange;

  @override
  _MapPlaybackWidgetPageState createState() => _MapPlaybackWidgetPageState();
}

class _MapPlaybackWidgetPageState extends State<MapPlaybackWidget> {
  final markers = <MarkerId, Marker>{};

  // final markersStart = <MarkerId, Marker>{};
  // final markersStop = <MarkerId, Marker>{};
  final controller = Completer<GoogleMapController>();

  var kSantoDomingo;
  var kMarkerId;

  var kMarkerIdStart;
  var kMarkerIdStop;

  // Marker? markerStart;
  // Marker? markerStop;
  // List<Marker> listMarker = [];
  List<EventHolder> kLocations = [];
  int duration = 1000;

  Timer? timer;
  int index = 0;

  bool isLoad = false;
  bool isForward = true;
  Set<Marker> markers2 = {};
  Vehicle? vehicle;
  ui.Image? imageOri;

  @override
  void initState() {
    if (widget.position != null) {
      index = widget.position!;
    }

    for (Vehicle v in listVehicle) {
      if (v.info!.vid.toString() == widget.vid) {
        vehicle = v;
        break;
      }
    }

    if (mapsDuration != null) {
      duration = mapsDuration!.inMilliseconds ~/ widget.listRoute.length;
      print("mapsDuration $duration");
    }

    var kStartPosition = const LatLng(0, 0);
    kSantoDomingo = CameraPosition(target: kStartPosition, zoom: 15);
    kMarkerId = const MarkerId('MarkerId1');
    kMarkerIdStart = const MarkerId('start');
    kMarkerIdStop = const MarkerId('stop');

    _createMarkerImageFromAsset(context);
    getImageFromPath(vehicle!).then((value) => {imageOri = value, loadPin()});

    // int i = 0;
    // for (Trip h in widget.list) {
    //   if (h.data[2] == 7 ||
    //       h.data[2] == 9 ||
    //       h.data[2] == 14 ||
    //       h.data[2] == 21 ||
    //       h.data[2] == 1010 ||
    //       h.data[2] == 1011) {
    //     print(h.data[2]);
    //     var m = MarkerId("event_" + i.toString());
    //     markers[m] = Marker(
    //         markerId: m,
    //         position: LatLng(h.data[15], h.data[16]),
    //         infoWindow: InfoWindow(title: Api.language=="th"?Utils.eventTitle(h.data[2]):Utils.eventTitleEn(h.data[2])),
    //         icon: BitmapDescriptor.defaultMarkerWithHue(
    //             BitmapDescriptor.hueOrange));
    //
    //     i++;
    //   }
    // }
    // setData(widget.listRoute);
    //  var stream = Stream.periodic(
    //         Duration(milliseconds: duration), (count) => kLocations[count])
    //     .take(kLocations.length);
    // stream.forEach((value){
    //   if(!isPlay){
    //     sleep(Duration(seconds:1000));
    //   }else{
    //     newLocationUpdate(value);
    //   }
    //
    // });

    super.initState();
  }

  Future<BitmapDescriptor> _bitmapDescriptorFromSvgAsset(
      BuildContext context, String assetName) async {
    // Read SVG file as String
    String svgString =
        await DefaultAssetBundle.of(context).loadString(assetName);
    // Create DrawableRoot from SVG String
    //FIXME : change DrawableRoot to PictureInfo.
    // DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, "");
    PictureInfo svgDrawableRoot = await vg.loadPicture(SvgStringLoader(svgString), null);

    // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width =
        35 * devicePixelRatio; // where 32 is your SVG's original width
    double height = 35 * devicePixelRatio; // same thing
    // double width = 80; // where 32 is your SVG's original width
    // double height = 80; // same thing

    // Convert to ui.Picture
    //FIXME
    // ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));
    ui.Picture picture = svgDrawableRoot.picture;

    // Convert to ui.Image. toImage() takes width and height as parameters
    // you need to find the best size to suit your needs and take into account the
    // screen DPI
    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  refresh() {
    try {
      setState(() {});
    } catch (e) {}
  }

  BitmapDescriptor? pinStart;
  BitmapDescriptor? pinStop;

  loadPin() async {
    pinStart = await _bitmapDescriptorFromSvgAsset(
        context, "assets/images/pin_start.svg");
    pinStop = await _bitmapDescriptorFromSvgAsset(
        context, "assets/images/pin_stop.svg");
    print("load pin $pinStart");
    setData(widget.listRoute);
  }

  setData(List list) {
    for (var a in list) {
      kLocations.add(EventHolder(l: LatLng(a[2], a[3]), c: a[6], d: a[0]));
    }
    displayDateEnd = list[list.length - 1][0];
    _add();
    markers[kMarkerIdStart] = Marker(
        markerId: kMarkerIdStart,
        position: kLocations[0].latlng,
        icon: pinStart!);
    markers[kMarkerIdStop] = Marker(
        markerId: kMarkerIdStop,
        position: kLocations[kLocations.length - 1].latlng,
        icon: pinStop!);
    newLocationUpdate(kLocations[index]);
    setTimer();

    controller.future.then((value) => {
          value.moveCamera(CameraUpdate.newLatLngBounds(
              boundsFromLatLngList(kLocations), 50))
        });

    setState(() {});
  }

  setTimer() {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer.periodic(Duration(milliseconds: duration), (Timer t) {
      print("mapsPlay $mapsPlay");
      if (mapsPlay) {
        if (index <= kLocations.length - 1) {
          newLocationUpdate(kLocations[index]);
          index++;
          widget.positionChange?.call(index);
        } else {
          reset();
        }
      }
    });
  }

  reset() {
    mapsPlay = false;
    // index = 0;
    refresh();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  bool isFocus = false;
  String displayDateStart = "";
  String displayDateEnd = "";

  void newLocationUpdate(EventHolder e) async {
    if (duration == 1000) {
      speed = 1;
    }
    if (isFocus) {
      controller.future.then((value) =>
          {value.moveCamera(CameraUpdate.newLatLngZoom(e.latlng, 16))});
    }
    displayDateStart = e.date;

    var marker = Marker(
        markerId: kMarkerId,
        position: e.latlng,
        // ripple: true,
        // rotation: e.course,
        anchor: const Offset(0.5, 0.5),
        // icon: _markerIcon!,
        icon: await getMarkerIcon(vehicle!, e.course),
        // infoWindow: InfoWindow(
        //     title: vehicle?.info!.licenseplate, anchor: Offset(0.5, 0.5)),
        onTap: () {
          controller.future.then((value) =>
              {value.moveCamera(CameraUpdate.newLatLngZoom(e.latlng, 16))});
          Timer(const Duration(milliseconds: 200), () {
            isFocus = true;
          });

          _mapPolylines[polylineId] =
              Polyline(polylineId: polylineId, visible: false);
          circles = null;
          refresh();
        });

    // if (isLicense) {
    //   controller.future
    //       .then((value) => {value.showMarkerInfoWindow(kMarkerId)});
    // } else {
    //   controller.future
    //       .then((value) => {value.hideMarkerInfoWindow(kMarkerId)});
    // }

    setState(() => markers[kMarkerId] = marker);
  }

  Future<BitmapDescriptor> getMarkerIcon(Vehicle v, double crose) async {
    ui.Image image = await rotatedImage(imageOri!, crose);
    if (!isLicense) {
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List uint8List = byteData!.buffer.asUint8List();
      // iconTest = BitmapDescriptor.fromBytes(uint8List);

      return BitmapDescriptor.fromBytes(uint8List);
    }

    Size size = Size(image.height.toDouble(), image.height.toDouble());
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // final Radius radius = Radius.circular(size.width / 2);
    //
    final Paint tagPaint = Paint()..color = ColorCustom.white;
    const double tagWidth = 120.0;
    print(size.width);

    // canvas.drawRect(Rect.fromLTWH(size.width/4, 0.0, tagWidth, 50), tagPaint);

    // Add tag text
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
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
    pathGreen.moveTo(size.width / 2, textPainter.height + 15);
    pathGreen.lineTo(110, textPainter.height);
    pathGreen.lineTo(140, textPainter.height);
    pathGreen.close();
    print(pos);
    print(textPainter.width);

    canvas.drawPath(pathGreen, tagPaint);
    // Oval for the image
    Rect oval = Rect.fromLTWH(0, 0, size.width, size.height);

    // Add path for oval image
    // canvas.clipPath(Path()..addOval(oval));

    // Add image

    print("GET MARKER ICON CUSTOMISE CALLED${image.height}");
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.none);
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

  Future<ui.Image> rotatedImage(ui.Image image, double angle) {
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

  Future<ui.Image> getImageFromPath(Vehicle v) async {
    //String fullPathOfImage = await getFileData(imagePath);

    //File imageFile = File(fullPathOfImage);
    // ByteData bytes = await rootBundle.load(imagePath);
    // Uint8List imageBytes = bytes.buffer.asUint8List();

    Uint8List? imageBytes =
        await getBytesFromAsset('assets/images/GREEN4.png', 250);
    //Uint8List imageBytes = imageFile.readAsBytesSync();

    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      return completer.complete(img);
    });
    //print("COMPLETERR DONE Full path of image is"+imagePath);
    return completer.future;
  }

  BitmapDescriptor? _markerIcon;

  Future _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcon == null) {
      _markerIcon = BitmapDescriptor.fromBytes(
          await getBytesFromAsset('assets/images/truck_pin_green.png', 100));
      setState(() {});
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  final Map<PolylineId, Polyline> _mapPolylines = {};
  int _polylineIdCounter = 1;

  void _add() {
    List<LatLng> listLatlng = [];
    for (EventHolder e in kLocations) {
      listLatlng.add(e.latlng);
    }
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: ColorCustom.primaryColor,
      width: 5,
      points: listLatlng,
    );

    setState(() {
      _mapPolylines[polylineId] = polyline;
    });
  }

  LatLngBounds boundsFromLatLngList(List<EventHolder> list) {
    assert(list.isNotEmpty);
    double? x0, x1 = 0, y0 = 0, y1 = 0;
    for (int i = 0; i < list.length; i++) {
      LatLng latLng = list[i].latlng;
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  final PolylineId polylineId = const PolylineId("polyline_id_factory");

  Set<Circle>? circles;
  Set<Circle> circlesDef = {
    const Circle(
      circleId: CircleId(""),
      center: LatLng(0, 0),
      radius: 0,
    )
  };

  setRadius(LatLng latLng, String id, double radiusA) {
    circles = {
      Circle(
        fillColor: ColorCustom.primaryColor.withOpacity(0.3),
        strokeWidth: 0,
        circleId: CircleId(id),
        center: latLng,
        radius: radiusA,
      )
    };
  }

  Future<BitmapDescriptor> getPinFactory(Factory f) async {
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(f.url!)).load(f.url!))
        .buffer
        .asUint8List();

    return BitmapDescriptor.fromBytes(resizeImage(bytes));
    // for (MarkerIconFactory f in listIconFac) {
    //   print(id.toString() +" "+ f.name.toString());
    //   if (id == f.name) {
    //     return BitmapDescriptor.fromBytes(f.icon!);
    //   }
    // }
    // return _markerIconFactory!;
  }

  Uint8List resizeImage(Uint8List data) {
    Uint8List resizedData = data;
    IMG.Image img = IMG.decodeImage(data)!;
    IMG.Image resized =
        IMG.copyResize(img, width: img.width * 2, height: img.height * 2);
    resizedData = IMG.encodePng(resized);
    return resizedData;
  }

  Set<Marker> addMarker() {
    return markers.values.toSet();
  }

  // bool isPlay = false;

  Set<Marker> markersSet = {};
  int speed = 1;
  double zoom = 0;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  bool traffic = false;
  MapType mode = MapType.normal;
  bool isPinFactory = false;
  bool isLicense = true;
  LatLng? _lastMapPosition;

  bool isDrag = false;

  @override
  Widget build(BuildContext context) {
    if (mapsPosition >= 0) {
      print("slider $mapsPosition");
      index = mapsPosition;
      mapsPosition = -1;
    }
    // isPlay = mapsPlay;
    return GoogleMap(
      onTap: (v) {
        isDrag = true;
      },
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      mapType: mode,
      initialCameraPosition: kSantoDomingo,
      trafficEnabled: traffic,
      circles: circles != null ? circles! : circlesDef,
      polylines: Set<Polyline>.of(_mapPolylines.values),
      // onMapCreated: (gController) => controller.complete(
      //     gController),
      onMapCreated: (gController) {
        controller.complete(gController);
      },
      onCameraMove: (v) {
        _lastMapPosition = v.target;
        // if (isDrag) {
        //   isFocus = false;
        // }
        // print(isFocus);

        if (zoom != v.zoom) {
          zoom = v.zoom;
          isFocus = false;
          refresh();
        }
      },
      markers: addMarker(),
      // Complete the future GoogleMapController
    );
  }
}
