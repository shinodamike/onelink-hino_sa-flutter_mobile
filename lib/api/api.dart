import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iov/model/profile.dart';
import 'package:iov/model/upload.dart';
import 'package:iov/page/home.dart';
import 'package:http/http.dart' as http;
import 'package:iov/utils/color_custom.dart';

class Api {
  static String BaseUrlBuilding =
      "https://60fixzr79l.execute-api.ap-southeast-1.amazonaws.com/prod/prod/";

  static String firebase_key =
      "AAAAwmmo4S8:APA91bFrpiUhVSV5orW6qBnwzUa2376P3t7pTvkY-cPjTn2U_a93n3hj03CgaJNNjqTFZcA_KqcWggwbPZoyvzGXglFj5SEZDBVIQ985JW896aOXybIN2N_nSnxJY9BxBqNakXImCJYt";

  static String login = "${BaseUrlBuilding}fleet/mobile/auth/login";
  static String forgot_password =
      "${BaseUrlBuilding}users/auth/forgot-password";
  static String forgot_password_confirm =
      "${BaseUrlBuilding}users/auth/confirm-forgot-password";

  // static String realtime = BaseUrlBuilding + "fleet/mobile/realtime";
  static String realtime = "${BaseUrlBuilding}fleet/mobile/V2/realtime";
  static String vid_detail = "${BaseUrlBuilding}fleet/mobile/information?vid=";
  static String factory = "${BaseUrlBuilding}fleet/mobile/V2/listgeofence";

  // static String factory = BaseUrlBuilding + "fleet/mobile/listgeofence";
  static String listmember = "${BaseUrlBuilding}fleet/mobile/listmember";
  static String listdriver = "${BaseUrlBuilding}fleet/mobile/V2/listdriver";
  static String driver_detail =
      "${BaseUrlBuilding}fleet/mobile/driverdetails?personal_id=";
  static String notify = "${BaseUrlBuilding}fleet/mobile/history/notify";
  static String history = "${BaseUrlBuilding}fleet/mobile/history";
  static String dashboard_summary =
      "${BaseUrlBuilding}fleet/mobile/V2/dashboard/summary";
  static String dashboard_realtime =
      "${BaseUrlBuilding}fleet/mobile/dashboard/realtime";
  static String dashboard_driver =
      "${BaseUrlBuilding}fleet/mobile/dashboard/driver";
  static String trip = "${BaseUrlBuilding}fleet/mobile/V2/trips";
  static String trip_detail = "${BaseUrlBuilding}fleet/mobile/V2/trips/detail";
  static String logout = "${BaseUrlBuilding}fleet/mobile/auth/logout";
  static String token = "${BaseUrlBuilding}fleet/mobile/token";
  static String cctv_vehicle = "${BaseUrlBuilding}fleet/mdvr/device?user_id=";
  static String cctv_date =
      "${BaseUrlBuilding}fleet/mdvr/playback/calendar/info?user_id=";
  static String cctv_live = "${BaseUrlBuilding}fleet/mdvr/playback?user_id=";
  static String cctv_live_channel =
      "${BaseUrlBuilding}fleet/mdvr/playback/info?user_id=";
  static String snapshot =
      "https://3tirkucu7j.execute-api.ap-southeast-1.amazonaws.com/prod/prod/fleet/mdvr/playback/images?";
  static String banner = "https://3tirkucu7j.execute-api.ap-southeast-1"
      ".amazonaws"
      ".com/prod/prod/fleet/banner/display";
  static String news =
      "https://3tirkucu7j.execute-api.ap-southeast-1.amazonaws.com/prod/prod/fleet/news/management/display";

  // fleet/mdvr/playback?user_id=11378&vehicle_id=33508&channel=1&start=2022-06-01%2018:48:24&end=2022-06-01%2018:49:03
  // fleet/mdvr/playback/calendar/info?user_id=6120&vehicle_id=31503&start=2022-11-01&st=1
  static String postFileUrl =
      "https://ru.71dev.com/etest-enrollment/api/upload/upload";


  static String vehicle_by_dealer = "${BaseUrlBuilding}fleet/mobile/vehicle";
  static String report_working = "${BaseUrlBuilding}fleet/mobile/working/";

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  static Profile? profile;

  static String language = "en";

  static String get Language => language;  // Getter for language

  static setProfile(Profile p) {
    profile = p;
  }

  static Map<String, String> requestHeaders = {
    'Accept-Language': language == "ja" || language == "en" ? "en" : "th",
    'Accept': 'application/json',
    'user_id': profile!.userId.toString(),
    "applicationId": "2",
    "app_id": platform,
    "uuid": uuid,
    "token_id": token,
    "os": os,
    // 'user_id': "38"
  };

  static Future<dynamic> get(BuildContext context, String url) async {
    try {
      http.Response response;
      if (profile != null) {
        print("userID = ${profile!.userId}");
        print(url);
        Map<String, String> requestHeaders = {
          'Accept-Language': language == "ja" || language == "en" ? "en" : "th",
          'Accept': 'application/json',
          'user_id': profile!.userId.toString(),
          "applicationId": "2",
          "app_id": platform,
          "uuid": uuid,
          "token_id": token,
          "os": os,
          // 'user_id': "38"
        };
        print(requestHeaders.toString());
        response = await http.get(Uri.parse(url), headers: requestHeaders);
      } else {
        response = await http.get(Uri.parse(url));
      }
      // final jsonResponse = json.decode(response.body);

      // print( 'Accept-Language   '+ language);
      // print('Accept-Language   ' + url + "////" + response.statusCode.toString());
      // print(jsonResponse);
      // log(response.body);
      print('response.statusCode = ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        print('jsonResponse = ${jsonResponse}');
        return jsonResponse;
      } else if (response.statusCode == 404) {
        showAlertDialog(context, "Not found");
      } else {
        showAlertDialog(context, response.body);
        try {
          final jsonResponse = json.decode(response.body);
          print(response.body);
          return jsonResponse;
        } catch (a) {
          print(a);
        }
      }
    } catch (e) {
      print(e);
      // showAlertDialog(context, e.toString());
    }
  }

  static Future<dynamic> post(
      BuildContext context, String url, String jsonParam) async {
    print(url);
    try {
      print(jsonParam);

      // http.Response response = await http.post(
      //   Uri.parse(url),
      //   body: jsonParam,
      //   headers: <String, String>{
      //     HttpHeaders.contentTypeHeader: "application/json"
      //   },
      // );

      http.Response response;
      if (profile != null) {
        print("userID = ${profile!.userId}");
        Map<String, String> requestHeaders = {
          'Accept-Language': language == "ja" ? "en" : "th",
          'Accept': 'application/json',
          'user_id': profile!.userId.toString(),
          "applicationId": "2",
          "app_id": platform,
          "uuid": uuid,
          "token_id": token,
          "os": os,
          HttpHeaders.contentTypeHeader: "application/json"
          // 'user_id': "38"
        };
        response = await http.post(Uri.parse(url),
            body: jsonParam, headers: requestHeaders);
      } else {
        Map<String, String> requestHeaders = {
          HttpHeaders.contentTypeHeader: "application/json"
          // 'user_id': "38"
        };
        response = await http.post(Uri.parse(url),
            body: jsonParam, headers: requestHeaders);
      }

      print('Accept-Language   ' +
          language +
          url +
          "////" +
          response.statusCode.toString());
      // print('print respon status code = ' + response.statusCode.toString());
      // print(response.body);
      printApiStatus(response);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else if (response.statusCode == 404) {
        // showAlertDialog(context, "Not found");
      } else {
        final jsonResponse = json.decode(response.body);
        var code = jsonResponse["Error"]["Code"];
        if (code == 112) {
          showAlertDialog(context, jsonResponse["Error"]["Message"]);
        } else if (code == 111) {
          showAlertDialog(context, jsonResponse["Error"]["Message"]);
        } else if (code == 113) {
          showAlertDialog(context, jsonResponse["Error"]["Message"]);
        }
      }
    } catch (e) {
      print(e);
      // showAlertDialog(context, e.toString());
    }
  }

  static Future<dynamic> put(
      BuildContext context, String url, String jsonParam) async {
    print(url);
    try {
      print(jsonParam);

      // http.Response response = await http.post(
      //   Uri.parse(url),
      //   body: jsonParam,
      //   headers: <String, String>{
      //     HttpHeaders.contentTypeHeader: "application/json"
      //   },
      // );

      http.Response response;
      if (profile != null) {
        print("userID = ${profile!.userId}");
        Map<String, String> requestHeaders = {
          'Accept-Language': language,
          'Accept': 'application/json',
          'user_id': profile!.userId.toString(),
          "applicationId": "2",
          "app_id": platform,
          "uuid": uuid,
          "token_id": token,
          "os": os,
          HttpHeaders.contentTypeHeader: "application/json"
          // 'user_id': "38"
        };
        response = await http.put(Uri.parse(url),
            body: jsonParam, headers: requestHeaders);
      } else {
        Map<String, String> requestHeaders = {
          HttpHeaders.contentTypeHeader: "application/json"
          // 'user_id': "38"
        };
        response = await http.post(Uri.parse(url),
            body: jsonParam, headers: requestHeaders);
      }

      print('print respon status code = ${response.statusCode}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        if (response.body != null) {
          print(response.body);
          final jsonResponse = json.decode(response.body);
          return jsonResponse;
        } else {}
      } else if (response.statusCode == 404) {
        // showAlertDialog(context, "Not found");
      } else {
        final jsonResponse = json.decode(response.body);
        var code = jsonResponse["Error"]["Code"];
        if (code == 112) {
          showAlertDialog(context, jsonResponse["Error"]["Message"]);
        } else if (code == 111) {
          showAlertDialog(context, jsonResponse["Error"]["Message"]);
        } else if (code == 113) {
          showAlertDialog(context, jsonResponse["Error"]["Message"]);
        }
      }
    } catch (e) {
      print(e);
      // showAlertDialog(context, e.toString());
    }
  }

  static Future<List<Upload>?> postFile(
      BuildContext context, String path) async {
    try {
      print(path);

      var request = http.MultipartRequest("POST", Uri.parse(postFileUrl));
      //add text fields
      // request.fields["text_field"] = text;
      //create multipart using filepath, string or bytes

      var pic = await http.MultipartFile.fromPath("path", path);
      //add multipart to request
      request.files.add(pic);

      var res = await request.send();
      final response = await http.Response.fromStream(res);

      print('print respon status code = ${response.statusCode}');
      print(response.body);

      final List<dynamic> responseData1 = json.decode(response.body);
      if (response.statusCode == 200) {
        List<Upload> upload =
            List.from(responseData1).map((a) => Upload.fromJson(a)).toList();
        return upload;
        // for (int i = 0; i < upload.length; i++) {
        //   _img.add(Img(upload[i].fileName));
        // }
        // print(_img.toList());
      } else if (response.statusCode == 404) {
        showAlertDialog(context, "Not found");
      } else {
        showAlertDialog(context, response.body);
      }
    } catch (e) {
      print(e);
      showAlertDialog(context, e.toString());
    }
    return null;
  }

  static showAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = ElevatedButton(
      child: const Text("OK"),
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorCustom.primaryColor, // Set the background color here
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
            color: ColorCustom.primaryColor,
          ),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Function to manually build the URI query string
  static String buildQueryString(Map parameters) {
    List<String> pairs = [];

    parameters.forEach((key, value) {
      // Encode key and value
      String encodedKey = Uri.encodeComponent(key);
      String encodedValue = Uri.encodeComponent(value.toString());

      pairs.add('$encodedKey=$encodedValue');
    });

    // Join the pairs with '&'
    return pairs.join('&');
  }
}
