import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iov/api/api.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/localization/locale_constant.dart';
import 'package:iov/model/profile.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:iov/utils/constants.dart';
import 'package:iov/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:io' show Platform;
import 'package:iov/api/api.dart';

import 'home_realtime.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

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

class _PageState extends State<LoginPage> {
  // FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  var token = "";
  var isLoading = false;

  @override
  void initState() {
    // firebaseMessaging
    //     .getToken(
    //         vapidKey:
    //             Api.firebase_key)
    //     .then((value) => {
    //           if (value != null) {token = value}
    //         });
    super.initState();
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  loginApi(BuildContext context) {
    isLoading = true;
    refresh();
    var uuid = const Uuid();
    var platform = "";
    if (Platform.isAndroid) {
      // Android-specific code
      platform = "ANDROID";
    } else if (Platform.isIOS) {
      // iOS-specific code
      platform = "IOS";
    }

    var param = jsonEncode(<dynamic, dynamic>{
      "userName": usernameController.text,
      "password": passwordController.text,
      // "userName": "hc0853861806s",
      // "password": "hc0853861806solt",
      "applicationId": Api.applicationId,
      "app_id": "FLEET-$platform",
      "uuid": uuid.v1(),
      "token_id": token,
      // "student_code": "62000344",
      // "password": "123456",
    });

    Profile profile;
    Api.post(context, Api.login, param).then((value) => {
          isLoading = false,
          refresh(),
          if (value != null)
            {
              // postToken(context),
              profile = Profile.fromJson(value),
              if (profile.userId != null)
                {
                  isAdvertise = true,
                  Api.setProfile(profile),
                  storeProfile(json.encode(value)),
                  // Navigator.pushReplacement(
                  //     context, MaterialPageRoute(builder: (_) => HomePage()))
                  Navigator.of(context).pushNamedAndRemoveUntil('/root', (Route<dynamic> route) => false),
                }
              else
                {
                  Utils.showAlertDialog(
                      context, "Username or Password incorrect")
                }
            }
          else
            {Utils.showAlertDialog(context, "Username or Password incorrect")}
        });
  }

  postToken(BuildContext context) {
    var uuid = const Uuid();
    var platform = "";
    if (Platform.isAndroid) {
      // Android-specific code
      platform = "ANDROID";
    } else if (Platform.isIOS) {
      // iOS-specific code
      platform = "IOS";
    }

    var param = jsonEncode(<dynamic, dynamic>{
      "app_id": "FLEET-$platform",
      "uuid": uuid.v1(),
      "token_id": token,
      "notify": true,
    });

    Api.post(
            context,
            "${Api.token}/FLEET-$platform/${uuid.v1()}/$token?notify=true",
            param)
        .then((value) => {if (value != null) {} else {}});
  }

  refresh() {
    setState(() {});
  }

  storeProfile(var jsonString) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile', jsonString);
  }

  // Profile? profile;
  //
  // getProfile() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final jsonResponse = json.decode(prefs.getString('profile')!);
  //   profile = Profile.fromJson(jsonResponse);
  //   if (profile != null) {
  //     Api.setProfile(profile!);
  //     // Navigator.pushReplacement(
  //     //     context, MaterialPageRoute(builder: (_) => HomePage()));
  //     Navigator.of(context).pushNamedAndRemoveUntil(
  //         '/root', (Route<dynamic> route) => false);
  //   }
  // }
  setLang() {
    if (Api.language == "en") {
      Api.language = "th";
    // } else if (Api.language == "th") {
    //   Api.language = "ja";
    } else {
      Api.language = "en";
    }
    changeLanguage(context, Api.language);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    ColorCustom.greyBG2,
                    Colors.white,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 60, bottom: 40),
                            width: screenWidth * 0.7, // 70% of screen width
                            height: screenHeight * 0.35, // 35% of screen height
                            child: Column(
                              children: [
                                SizedBox(
                                  child: Image.asset(
                                    "assets/images/hino-connect.png",
                                  ),
                                ),
                                SizedBox(
                                  child: Image.asset(
                                    // "assets/images/logo_login.png",
                                    "assets/images/hnzaicon.png",
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: SizedBox(
                                  child: TextField(
                                    controller: usernameController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      suffixIcon: const Icon(Icons.person_outline),
                                      hintText: Languages.of(context)!.username,
                                      hintStyle: const TextStyle(fontSize: 16),
                                      // fillColor: colorSearchBg,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: TextField(
                                    controller: passwordController,
                                    obscureText: true,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      suffixIcon: const Icon(Icons.lock_outline),
                                      hintText: Languages.of(context)!.password,
                                      hintStyle: const TextStyle(fontSize: 16),
                                      // fillColor: colorSearchBg,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorCustom.primaryColor,
                                padding: const EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(5), // <-- Radius
                                ),
                              ),
                              onPressed: () {
                                loginApi(context);
                              },
                              child: Text(
                                Languages.of(context)!.signin,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          // Container(
                          //   margin: const EdgeInsets.only(top: 20),
                          //   alignment: Alignment.centerRight,
                          //   child: InkWell(
                          //     onTap: () {
                          //       Navigator.of(context).push(MaterialPageRoute(
                          //           builder: (context) =>
                          //               const ForgotPasswordPage()));
                          //     },
                          //     child: Text(
                          //       Languages.of(context)!.forgot_password,
                          //       style: const TextStyle(
                          //           color: Colors.black, fontSize: 16),
                          //     ),
                          //   ),
                          // )
                          Spacer(),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              // margin: const EdgeInsets.only(bottom: 10),
                              width: screenWidth * 0.3, // 30% of screen width
                              height: screenHeight * 0.12, // 12% of screen height
                              child: Image.asset(
                                // "assets/images/logo_login.png",
                                "assets/images/netstarpg.png",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: Constants.spaceScreenLeft),
                      const Text(
                        "All Rights Reserved. © Onelink Technology Co., Ltd.",
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: (){
                  setLang();
                },
                child: const Icon(
                  Icons.language,
                  size: 35,
                  color: ColorCustom.primaryColor,
                ),
              ),
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: ColorCustom.primaryColor),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
