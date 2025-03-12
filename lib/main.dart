import 'dart:convert';
//FIXME : Comment awesome_notifications and firebase_messaging.

// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:fijkplayer/fijkplayer.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iov/page/home.dart';
import 'package:iov/page/home_noti_map.dart';
import 'package:iov/page/login.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:iov/utils/utils.dart';
import 'package:iov/widget/notification_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/api.dart';
import 'localization/locale_constant.dart';
import 'localization/localizations_delegate.dart';
import 'model/profile.dart';
import 'provider/page_provider.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//
//   print("Handling a background message: ${message.messageId}");
//   alertNoti(message);
// }
//
// alertNoti(RemoteMessage message) {
//   String unix = "";
//   if (isNotiSetting) {
//     print("noti in");
//     if (message.notification != null && message.notification!.body != null) {
//
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // AwesomeNotifications().initialize(
  //   // set the icon to null if you want to use the default app icon
  //     'resource://mipmap/ic_stat_name',
  //     [
  //       NotificationChannel(
  //           channelGroupKey: 'basic_channel_group',
  //           channelKey: 'basic_channel',
  //           channelName: 'Basic notifications',
  //           channelDescription: 'Notification channel for basic tests',
  //           defaultColor: ColorCustom.primaryColor,
  //           ledColor: Colors.white)
  //     ],
  //     // Channel groups are only visual and are not required
  //     channelGroups: [
  //       NotificationChannelGroup(
  //           channelGroupKey: 'basic_channel_group',
  //           channelGroupName: 'Basic group')
  //     ],
  //     debug: true
  // );
  await NotificationController.initializeLocalNotifications();

  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   // await Firebase.initializeApp();
//   // Utils.sendNotification(message.data["title"], message.data["message"]);
//   // if(message.notification!=null){
//   //   noti_count++;
//   //   Utils.sendNotification(message.notification!.title!, message.notification!.body!);
//   // }
//   print("Handling a background message: ${message.messageId}");
//   if (message.notification != null) {
//     noti_count++;
//     FlutterAppBadger.updateBadgeCount(noti_count);
//     notiController.sink.add(noti_count);
//     // String unix = message.data["unix"];
//     // Utils.sendNotification(message.notification!.title!,
//     //     message.notification!.body!, message.notification!.title!);
//   }
// }

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<StatefulWidget> {
  // This widget is the root of your application.

  Locale _locale = Locale(Api.language);

  void setLocale(Locale locale) {
    print('setLocale locale = ${locale}');
    setState(() {
      _locale = locale;
    });
  }

  // static const String routeHome = '/', routeNotification = '/notification-page';
  //
  // List<Route<dynamic>> onGenerateInitialRoutes(String initialRouteName) {
  //   List<Route<dynamic>> pageStack = [];
  //   pageStack.add(MaterialPageRoute(builder: (_) => HomePage()));
  //   if (NotificationController.initialAction != null) {
  //     pageStack.add(MaterialPageRoute(
  //         builder: (_) => HomeNotiMapPage(
  //             unix: NotificationController.initialAction!.title)));
  //   }
  //   return pageStack;
  // }
  //
  // Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  //   switch (settings.name) {
  //     case routeHome:
  //       return MaterialPageRoute(builder: (_) => HomePage());
  //
  //     case routeNotification:
  //       ReceivedAction receivedAction = settings.arguments as ReceivedAction;
  //       return MaterialPageRoute(
  //           builder: (_) => HomeNotiMapPage(
  //               unix: NotificationController.initialAction!.title));
  //   }
  //   return null;
  // }
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    // RemoteMessage? initialMessage =
    //     await FirebaseMessaging.instance.getInitialMessage();

    // FirebaseMessaging.instance.getInitialMessage().then((value) => {
    //       if (value != null) {_handleMessage(value)}
    //     });

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    // FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  // void _handleMessage(RemoteMessage message) {
  //   MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
  //       '/noti', (route) => (route.settings.name != '/noti') || route.isFirst,
  //       arguments: message.notification!.title);
  // }

  @override
  void initState() {
    // AwesomeNotifications().resetGlobalBadge();
    // FijkLog.setLevel(FijkLogLevel.Error);
    NotificationController.startListeningNotificationEvents();
    var jsonResponse;
    Profile profile;
    SharedPreferences.getInstance().then((prefs) => {
          if (prefs.getString('profile') != null && prefs.getString('profile')!.isNotEmpty)
            {
              jsonResponse = json.decode(prefs.getString('profile')!),
              profile = Profile.fromJson(jsonResponse),
              Api.setProfile(profile),
            }
        });
    setupInteractedMessage();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    print("didChangeDependencies");
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });

      print('_locale = ${_locale}');
    });
    getLangCode().then((locale) {
      Api.language = locale;
    });
  }

  String appname = "HNZA";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      // onGenerateInitialRoutes: onGenerateInitialRoutes,
      supportedLocales: const [Locale('th', ''), Locale('en', ''), Locale('ja', '')],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      locale: _locale,
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(
        //default loading widget
        //FIXME : remove loadingBuilder: (String msg, Color background)
        loadingBuilder: (String msg) {
          return const CircularProgressIndicator(color: ColorCustom.primaryColor);
        },
      ),
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          textTheme: GoogleFonts.kanitTextTheme(
            Theme.of(context).textTheme,
          ),
          primaryColor: ColorCustom.primaryColor,
          primaryColorDark: ColorCustom.primaryDarkColor,
          focusColor: ColorCustom.focusColor,
      ),
      // home: HomePage(),
      initialRoute: '/root',
      routes: <String, WidgetBuilder>{
        '/root': (BuildContext context) => const HomePage(),
        '/login': (BuildContext context) => const LoginPage(),
        '/noti': (BuildContext context) => HomeNotiMapPage(license: ModalRoute.of(context)?.settings.arguments.toString()),
        // HomeNotiMapPage.routeName: (context) => const HomeNotiMapPage(),
      },
    );
  }
}
