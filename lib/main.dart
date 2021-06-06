import 'dart:async';

import 'package:FinXpress/route_generator.dart';
import 'package:FinXpress/screens/home/home.dart';
import 'package:FinXpress/service/dynamic_link_service/dynamic_link_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/provider/dark_theme_provider.dart';

const bool kReleaseMode =
    bool.fromEnvironment('dart.vm.product', defaultValue: false);
int initScreen;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  initScreen = await sharedPreferences.getInt("initScreen");
  await sharedPreferences.setInt("initScreen", 1);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // if (kReleaseMode) {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(alert: true, badge: true);
  return runApp(ChangeNotifierProvider(
    child: MyApp(),
    create: (BuildContext context) =>
        DarkThemeProvider(sharedPreferences.getBool("isDarkTheme") ?? false),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  Timer _timerLink;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(
        const Duration(milliseconds: 1000),
        () {
          _dynamicLinkService.retrieveDynamicLink(context);
        },
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        Navigator.pushNamed(context, Home.home);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        if (message.data['url'] != null) {
          flutterLocalNotificationsPlugin.initialize(InitializationSettings(),
              onSelectNotification: await message.data['url']);
        }
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: '@drawable/ic_launcher_foreground',
              ),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkThemeProvider>(
        builder: (context, DarkThemeProvider darkThemeProvider, child) {
      return MultiProvider(
        providers: [
          StreamProvider.value(value: FirebaseAuth.instance.authStateChanges())
        ],
        child: MaterialApp(
          theme: darkThemeProvider.getTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: initScreen == 0 || initScreen == null ? "Intro" : '/',
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      );
    });
  }
}
