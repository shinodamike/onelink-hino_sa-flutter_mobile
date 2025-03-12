import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

// import 'package:device_info_plus/device_info_plus.dart';

//FIXME : Comment awesome_notifications and firebase_messaging.
// import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iov/api/api.dart';
import 'package:iov/model/vehicle.dart';
import 'package:iov/page/home_backup.dart';
import 'package:iov/page/home_dashboard.dart';
import 'package:iov/page/home_driver.dart';
import 'package:iov/page/home_realtime.dart';
import 'package:iov/page/home_settings.dart';
import 'package:iov/page/working_report.dart';
import 'package:iov/provider/page_provider.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

import '../main.dart';
import '../model/banner.dart';
import '../model/marker_icon.dart';
import '../model/profile.dart';

var uuid = const Uuid().v1();
var platform = "";
var token = "";
var os = "";
List<BannerHino> listBanner = [];
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

var notiController = StreamController.broadcast();
int noti_count = 0;
List<MarkerIcon> listIcon = [];
var isNotiSetting = false;

void printApiStatus(http.Response response) {
  log(response.request!.headers.toString());
  log(response.request!.url.toString());
  log(response.statusCode.toString());
  log(response.body.toString());
}

void printApiStatusNoBody(http.Response response) {
  printLongString(response.request!.headers.toString());
  printLongString(response.request!.url.toString());
  printLongString(response.statusCode.toString());
}

void printLongString(String text) {
  final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern
      .allMatches(text)
      .forEach((RegExpMatch match) => print(match.group(0)));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<StatefulWidget> createState() => _PageState();
}

class _PageState extends State<HomePage> {
  // FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String message = "";

  // String channelId = "1000";
  // String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  // String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";

  // String messageTitle = "Empty";
  // String notificationAlert = "alert";

  @override
  void initState() {
    isActive = true;
    _createMarkerImageFromAsset(context);
    // FlutterAppBadger.removeBadge();
    // initPush();
    getBanner(context);
    checkNotiSetting();

    // String unix = "";
    // FirebaseMessaging.instance.getInitialMessage().then((value) => {
    //       if (value != null)
    //         {
    //           unix = value.data["unix"],
    //           print("FirebaseMessaging.getInitialMessage " +
    //               value.data.toString()),
    //           if (unix.isNotEmpty) {onClickNotiUnix(unix)}
    //         }
    //     });
    reqPermission();
    checkProfile();
    super.initState();
  }

  checkProfile() {
    var jsonResponse;
    Profile profile;
    SharedPreferences.getInstance().then((prefs) => {
          if (prefs.getString('profile') != null &&
              prefs.getString('profile')!.isNotEmpty)
            {
              jsonResponse = json.decode(prefs.getString('profile')!),
              profile = Profile.fromJson(jsonResponse),
              Api.setProfile(profile),
              refresh()
            }
          else
            {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login', (Route<dynamic> route) => false)
            }
        });
  }

  reqPermission() async {
    if (await Permission.notification.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    }
  }

  checkNotiSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isNotiSetting = prefs.getBool('noti') ?? false;

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print("isNoti $isNotiSetting");
    //   alertNoti(message);
    //   print('Got a message whilst in the foreground!');
    //   // print('Message data: ${message.notification?.title}');
    //   print('Message data: ${message.data}');
    //   // {event_id: 1001, unix: T015801242568005d717efaf0e40}
    // });
    // FirebaseMessaging.instance.getInitialMessage().then((value) => {
    //       if (value != null)
    //         {
    //           print('Got a message whilst in the getInitialMessage!'),
    //           // print('Message data: ${message.notification?.title}');
    //           print('Message data: ${value.data}'),
    //           MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/noti',
    //               (route) => (route.settings.name != '/noti') || route.isFirst,
    //               arguments: value.notification!.title)
    //         }
    //     });
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print("onMessageOpenedApp: " + message.data.toString());
    //   // String unix = message.data["unix"];
    //   // onClickNotiUnix(unix);
    // });
    // if (Platform.isAndroid) {
    //   DeviceInfoPlugin().androidInfo.then((androidInfo) => {
    //         os += "${androidInfo.version.release} ",
    //         os += "${androidInfo.version.sdkInt} ",
    //         os += "${androidInfo.manufacturer} ",
    //         os += "${androidInfo.model} ",
    //         // print('Android $release (SDK $sdkInt), $manufacturer $model');
    //       });
    //
    //   // Android-specific code
    //   platform = "FLEET-ANDROID";
    // } else if (Platform.isIOS) {
    //   DeviceInfoPlugin().iosInfo.then((iosInfo) => {
    //         os += "${iosInfo.systemName} ",
    //         os += "${iosInfo.systemVersion} ",
    //         os += "${iosInfo.name} ",
    //         os += "${iosInfo.model} ",
    //         // print('$systemName $version, $name $model');
    //       });
    //
    //   // iOS-specific code
    //   platform = "FLEET-IOS";
    // }
    // firebaseMessaging.getToken(vapidKey: Api.firebase_key).then((value) => {
    //       if (value != null)
    //         {
    //           token = value,
    //           if (isNotiSetting) {postToken(context)}
    //         }
    //     });
  }

  // alertNoti(RemoteMessage message) {
  //   String unix = "";
  //   if (isNotiSetting) {
  //     if (message.notification != null && message.notification!.body != null) {
  //       noti_count++;
  //       FlutterAppBadger.updateBadgeCount(noti_count);
  //       notiController.sink.add(noti_count);
  //       if (unix != message.data["unix"]) {
  //         Utils.sendNotification(message.notification!.title!,
  //             message.notification!.body!, message.notification!.title!);
  //       } else {
  //         unix = message.data["unix"];
  //       }
  //     }
  //   }
  // }

  Future _createMarkerImageFromAsset(BuildContext context) async {
    List<String> listname = [
      "GREEN",
      "RED",
      "RED",
      "YELLOW",
      "WHITE",
      "VIOLET"
    ];

    for (int i = 0; i < 7; i++) {
      for (String s in listname) {
        var path = 'assets/images/' + s + (i + 1).toString() + ".png";
        // print(path);
        getBytesFromAsset(path, 250).then((value) => {
              listIcon.add(
                  MarkerIcon(BitmapDescriptor.fromBytes(value), path, value))
            });
      }
    }

    // if (_markerIcon == null) {
    //   _markerIcon = BitmapDescriptor.fromBytes(
    //       await getBytesFromAsset('assets/images/truck_pin_green.png', 100));
    //   _markerIcon2 = BitmapDescriptor.fromBytes(
    //       await getBytesFromAsset('assets/images/truck_pin_red.png', 50));
    //   _markerIcon3 = BitmapDescriptor.fromBytes(
    //       await getBytesFromAsset('assets/images/truck_pin_yellow.png', 100));
    //   _markerIcon4 = BitmapDescriptor.fromBytes(
    //       await getBytesFromAsset('assets/images/truck_pin_offline.png', 100));
    //   _markerIconFactory = BitmapDescriptor.fromBytes(
    //       await getBytesFromAsset('assets/images/factory_pin.png', 100));
    //   setState(() {});
    // }
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

  // onClickNotiLicense(RemoteMessage message) {
  //   String unix = message.data["unix"];
  //   if (message.notification != null) {
  //     noti_count = 0;
  //     FlutterAppBadger.removeBadge();
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (_) => HomeNotiMapPage(
  //                   license: message.notification!.title!,
  //                 )));
  //   }
  // }

  // onClickNotiUnix(String unix) {
  //   noti_count = 0;
  //   FlutterAppBadger.removeBadge();
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (_) => HomeNotiMapPage(
  //                 unix: unix,
  //               )));
  // }

  @override
  void dispose() {
    isActive = false;
    super.dispose();
  }

  bool isActive = false;

  initPush() {
    // var initializationSettingsAndroid =
    //     AndroidInitializationSettings('ic_stat_name');
    //
    // var initializationSettingsIOS = IOSInitializationSettings(
    //     onDidReceiveLocalNotification: (id, title, body, payload) {
    //   print("onDidReceiveLocalNotification called.");
    // });
    // var initializationSettings = InitializationSettings(
    //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    //
    // flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: (payload) {
    //   // when user tap on notification.
    //   print("onSelectNotification " + payload!);
    //   noti_count = 0;
    //   FlutterAppBadger.removeBadge();
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (_) => HomeNotiMapPage(
    //                 license: payload,
    //               )));
    // });

    // try {
    //   AwesomeNotifications()
    //       .actionStream
    //       .listen((ReceivedNotification receivedNotification) {
    //     var payload = receivedNotification.payload;
    //     print(payload.toString());
    //     print(receivedNotification.toString());
    //     if (receivedNotification.title != null) {
    //       navigateTo(receivedNotification.title!);
    //     }
    //   });
    // } catch (e) {}
    // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    //   if (!isAllowed) {
    //     // This is just a basic example. For real apps, you must show some
    //     // friendly dialog box before call the request method.
    //     // This is very important to not harm the user experience
    //     AwesomeNotifications().requestPermissionToSendNotifications();
    //   }
    // });
  }

  getBanner(BuildContext context) {
    Api.get(context, Api.banner).then((value) => {
          if (value != null)
            {
              listBanner = List.from(value['result']['banner'])
                  .map((a) => BannerHino.fromJson(a))
                  .toList(),
              refresh()
            }
          else
            {}
        });
  }

  refresh() {
    setState(() {});
  }

  // getData(BuildContext context, String license) {
  //   Api.get(context, Api.realtime).then((value) => {
  //         if (value != null)
  //           {
  //             listVehicle = List.from(value['vehicles'])
  //                 .map((a) => Vehicle.fromJson(a))
  //                 .toList(),
  //             navigateTo(license),
  //           }
  //         else
  //           {}
  //       });
  // }
  //
  // navigateTo(String license) {
  //   noti_count = 0;
  //   FlutterAppBadger.removeBadge();
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (_) => HomeNotiMapPage(
  //                 license: license,
  //               )));
  // }

  postToken(BuildContext context) {
    var param = jsonEncode(<dynamic, dynamic>{
      "app_id": platform,
      "uuid": uuid,
      "token": token,
      "notify": true,
    });

    Api.post(context, "${Api.token}/$platform/$uuid/$token?notify=true", param)
        .then((value) => {if (value != null) {} else {}});
  }

  List page_menu = [
    const HomeRealtimePage(),
    const HomeDashboardPage(),
    const HomeBackupPage(),
    const HomeDriverPage(),
    // const WorkingReportPage(), //CreateChartTest(),//WebViewExample(),// WebViewExample(),// , //HomeDriverPage(),
    const HomeSettingsPage(),
  ];

  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  advertise() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        listBanner.isNotEmpty
            ? Image.network(
                listBanner.first.urlImage!,
                fit: BoxFit.cover,
              )
            : Container(),
        Container(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () {
              setState(() {
                isAdvertise = false;
              });
            },
            child: const Icon(
              Icons.close,
              size: 30,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Vehicle? v = context.watch<PageProvider>().is_select_vehicle;
    if (v != null) {
      onTabTapped(0);
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        backgroundColor: ColorCustom.black,
        // appBar: AppBar(
        //   elevation: 0,
        //   brightness: Brightness.light,
        //   // this makes status bar text color black
        //   backgroundColor: Colors.white,
        // ),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Api.profile != null
                  ? Column(
                      children: [
                        // isAdvertise && _currentIndex != 4 ? advertise() : Container(),
                        Expanded(child: page_menu[_currentIndex]),
                        // Container(
                        //   child: BottomBar(
                        //     onTabBottomBar: onTabBottomBar,
                        //   ),
                        // ),
                        BottomNavigationBar(
                          type: BottomNavigationBarType.fixed,
                          onTap: onTabTapped,
                          currentIndex: _currentIndex,
                          selectedLabelStyle: const TextStyle(
                            fontSize: 14,
                            color: ColorCustom.primaryColor,
                          ),
                          selectedItemColor: ColorCustom.primaryColor,
                          unselectedItemColor: ColorCustom.greyButton,
                          unselectedLabelStyle: const TextStyle(
                            fontSize: 14,
                            color: ColorCustom.greyButton,
                          ),
                          showSelectedLabels: false,
                          showUnselectedLabels: false,
                          items: [
                            BottomNavigationBarItem(
                              activeIcon: SvgPicture.asset(
                                "assets/images/Fix Icon iov25.svg",
                                color: ColorCustom.primaryColor,
                              ),
                              icon: Container(
                                child: SvgPicture.asset(
                                    "assets/images/Fix Icon iov25.svg"),
                              ),
                              label: "",
                            ),
                            BottomNavigationBarItem(
                              activeIcon: SvgPicture.asset(
                                "assets/images/icon_charts.svg",
                                color: ColorCustom.primaryColor,
                              ),
                              icon: Container(
                                child: SvgPicture.asset(
                                    "assets/images/icon_charts.svg"),
                              ),
                              label: "",
                            ),
                            BottomNavigationBarItem(
                              activeIcon: SvgPicture.asset(
                                "assets/images/icon_history.svg",
                                color: ColorCustom.primaryColor,
                              ),
                              icon: Container(
                                child: SvgPicture.asset(
                                    "assets/images/icon_history.svg"),
                              ),
                              label: "",
                            ),
                            // BottomNavigationBarItem(
                            //   icon: Container(
                            //     child: FaIcon(
                            //       FontAwesomeIcons.userCircle,
                            //       size: 30,
                            //     ),
                            //   ),
                            //   label: "ผลการสอบ",
                            // ),
                            BottomNavigationBarItem(
                              activeIcon: SvgPicture.asset(
                                "assets/images/Fix Icon iov33.svg",
                                color: ColorCustom.primaryColor,
                              ),
                              icon: Container(
                                child: SvgPicture.asset(
                                    "assets/images/Fix Icon iov33.svg"),
                              ),
                              label: "",
                            ),
                            // BottomNavigationBarItem(
                            //   activeIcon: SvgPicture.asset(
                            //     "assets/images/document.svg",
                            //     color: ColorCustom.primaryColor,
                            //   ),
                            //   icon: Container(
                            //     child: SvgPicture.asset(
                            //         "assets/images/document.svg"),
                            //   ),
                            //   label: "",
                            // ),
                            BottomNavigationBarItem(
                              activeIcon: SvgPicture.asset(
                                "assets/images/Fix Icon iov15.svg",
                                width: 30,
                                height: 30,
                                color: ColorCustom.primaryColor,
                              ),
                              icon: Container(
                                child: SvgPicture.asset(
                                  "assets/images/Fix Icon iov15.svg",
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              label: "",
                            ),
                          ],
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: const Image(
                                  image: AssetImage(
                                      'assets/images/logo_login.png')),
                            ),
                          ),
                          const Text(
                            "All Rights Reserved. © Onelink Technology Co., Ltd.",
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
