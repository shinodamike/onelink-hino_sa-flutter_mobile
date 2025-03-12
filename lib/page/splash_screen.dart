import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iov/api/api.dart';
import 'package:iov/model/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {

    super.initState();
    goMainScreen();
  }

  // 5 seconds later -> onDoneControl
  Future<Timer> goMainScreen() async {
    return Timer(const Duration(seconds: 2), onDoneControl);
  }

  // route to MainScreen
  onDoneControl() {
    // Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => LandingPage()));
    var jsonResponse;
    Profile profile;
    SharedPreferences.getInstance().then((prefs) => {
          if (prefs.getString('profile') != null &&
              prefs.getString('profile')!.isNotEmpty)
            {
              jsonResponse = json.decode(prefs.getString('profile')!),
              profile = Profile.fromJson(jsonResponse),
              Api.setProfile(profile),
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: (context) => HomePage())),
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/root', (Route<dynamic> route) => false),
            }
          else
            {
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: (context) => LoginPage()))
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login', (Route<dynamic> route) => false),
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    var assetImage = const AssetImage('assets/images/logo_login.png');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Image(image: assetImage),
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
    );
  }
}
