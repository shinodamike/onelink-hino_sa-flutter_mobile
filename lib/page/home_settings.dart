import 'dart:convert';
//FIXME : Comment awesome_notifications and firebase_messaging.
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iov/api/api.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/localization/locale_constant.dart';
import 'package:iov/page/dashboard_filter.dart';
import 'package:iov/page/home_realtime.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'login.dart';

class HomeSettingsPage extends StatefulWidget {
  const HomeSettingsPage({Key? key}) : super(key: key);

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

class _PageState extends State<HomeSettingsPage> {
  @override
  void initState() {
    // getLanguage();
    // getLocale();
    getNoti();
    super.initState();
  }

  clearProfile() async {
    listVehicle = [];
    listNameGroup = [];
    listFactory = [];
    noti_count = 0;
    // FlutterAppBadger.removeBadge();
    // await flutterLocalNotificationsPlugin.cancelAll();
    // AwesomeNotifications().cancelAll();
    // AwesomeNotifications().resetGlobalBadge();
    setNoti(false);
    // listFactoryMarker.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile', "");
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const LoginPage(),
      ),
      (route) => false, //if you want to disable back feature set to false
    );
  }

  logout(BuildContext context) {
    var param = jsonEncode(<dynamic, dynamic>{
      "app_id": platform,
      "uuid": uuid,
      "token_id": token,
      "logoutScope": "0",
      'user_id': Api.profile!.userId.toString(),
      'redisKey': Api.profile!.redisKey
    });

    Api.post(context, Api.logout, param).then((value) => {clearProfile()});
  }

  // String? lang = Api.language;

  // setLanguage(var l) async {
  //   Api.language = l;
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('language', l);
  //   setState(() {});
  // }
  //
  // getLanguage() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   Api.language = prefs.getString('language')??"th";
  // }
  // FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  setNoti(bool l) async {
    isNotiSetting = l;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('noti', l);
    setState(() {});
    // if (l) {
    //   firebaseMessaging.getToken(vapidKey: Api.firebase_key).then((value) => {
    //         if (value != null) {token = value, postToken(context, token, l)}
    //       });
    // } else {
    //   firebaseMessaging.deleteToken();
    //   postToken(context, "", l);
    // }
  }

  getNoti() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotiSetting = prefs.getBool('noti') ?? false;
    });
    print(isNotiSetting);
  }

  postToken(BuildContext context, String tokens, bool noti) {
    var param = jsonEncode(<dynamic, dynamic>{
      "app_id": platform,
      "uuid": uuid,
      "token": tokens,
      "notify": noti,
    });

    Api.post(
            context,
            "${Api.token}/$platform/$uuid/$tokens?notify=$noti",
            param)
        .then((value) => {if (value != null) {} else {}});
  }

  setLang() {
    changeLanguage(context, Api.language);
  }

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
        child: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20, top: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorCustom.greyBG2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  padding:
                      const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  child: Row(
                    children: [
                      Api.profile!.avatarUrl != null
                          ? Image.asset(
                              "assets/images/profile_empty.png",
                              width: 60,
                              height: 60,
                            )
                          : Image.network(
                              Api.profile!.avatarUrl,
                              width: 60,
                              height: 60,
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Api.profile!.displayName,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              Api.profile!.email,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (Api.language == "en") {
                      Api.language = "th";
                      setLang();
                    // } else if (Api.language == "th") {
                    //   Api.language = "ja";
                    //   setLang();
                    } else {
                      Api.language = "en";
                      setLang();
                    }
                    setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorCustom.greyBG2),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.translate,
                          size: 30,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            Languages.of(context)!.select_lang,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Text(
                          Api.language == "th"
                              ? 'ไทย'
                              : Api.language == "ja"
                                  ? 'Japanese'
                                  : "Eng",
                          style: const TextStyle(
                            color: ColorCustom.primaryColor,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     noti = !noti;
                //     notiSetting(context, noti);
                //     setState(() {});
                //   },
                //   child: Container(
                //     margin: EdgeInsets.only(bottom: 10),
                //     decoration: BoxDecoration(
                //       border: Border.all(color: ColorCustom.greyBG2),
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(10.0),
                //       ),
                //     ),
                //     padding: EdgeInsets.only(
                //         top: 10, bottom: 10, left: 10, right: 10),
                //     child: Row(
                //       children: [
                //         Icon(
                //           Icons.notifications,
                //           size: 30,
                //           color: noti ? ColorCustom.blue : Colors.grey,
                //         ),
                //         SizedBox(
                //           width: 10,
                //         ),
                //         Expanded(
                //           child: Text(Languages.of(context)!.notification,
                //             style: TextStyle(
                //               color: Colors.grey,
                //               fontSize: 18,
                //             ),
                //           ),
                //         ),
                //         Text(
                //           noti ? Languages.of(context)!.on : Languages.of(context)!.off,
                //           style: TextStyle(
                //             color: ColorCustom.blue,
                //             fontSize: 18,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                InkWell(
                  onTap: () {
                    setNoti(!isNotiSetting);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorCustom.greyBG2),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          size: 30,
                          color: isNotiSetting ? ColorCustom.primaryColor : Colors.grey,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            Languages.of(context)!.notification,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Text(
                          isNotiSetting
                              ? Languages.of(context)!.on
                              : Languages.of(context)!.off,
                          style: const TextStyle(
                            color: ColorCustom.primaryColor,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    logout(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10, top: 40),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10),
                    child: Text(
                      Languages.of(context)!.sign_out,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
