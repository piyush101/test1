import 'dart:async';

import 'package:FinXpress/notifiers/article_id_notifier.dart';
import 'package:FinXpress/route_generator.dart';
import 'package:FinXpress/screens/home/home.dart';
import 'package:FinXpress/screens/intro/intro_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/provider/dark_theme_provider.dart';

// const bool kReleaseMode = bool.fromEnvironment('dart.vm.product', defaultValue: false);

int initScreen;
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("onBackgroundMessage: $message");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.subscribeToTopic("all");
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  initScreen = await sharedPreferences.getInt("initScreen");
  await sharedPreferences.setInt("initScreen", 1);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(alert: true, badge: true);

  return runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => ArticleIdNotifier(),
    ),
    ChangeNotifierProvider(
        create: (_) => DarkThemeProvider(
            sharedPreferences.getBool("isDarkTheme") ?? false))
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      navigateToPage(message);
    });

    initDynamicLinks();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
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

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp: $message");
      navigateToPage(message);
    });
  }

  void navigateToPage(RemoteMessage message) {
    if (message != null) {
      if (message.data != null) {
        if (message.data["page"] == "/news") {
          String _articleId = message.data['articleId'];
          context.read<ArticleIdNotifier>().updateId(_articleId);
          Navigator.pushAndRemoveUntil(
              navigatorKey.currentState.context,
              MaterialPageRoute(builder: (context) => Home(pageIndex: 0)),
              (route) => false);
        } else if (message.data["page"] == "/learnings") {
          Navigator.pushAndRemoveUntil(
              navigatorKey.currentState.context,
              MaterialPageRoute(builder: (context) => Home(pageIndex: 1)),
              (route) => false);
        } else if (message.data["page"] == "/insights") {
          Navigator.pushAndRemoveUntil(
              navigatorKey.currentState.context,
              MaterialPageRoute(builder: (context) => Home(pageIndex: 2)),
              (route) => false);
        } else if (message.data["page"] == "/advice") {
          Navigator.pushAndRemoveUntil(
              navigatorKey.currentState.context,
              MaterialPageRoute(builder: (context) => Home(pageIndex: 3)),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              navigatorKey.currentState.context,
              MaterialPageRoute(builder: (context) => Home(pageIndex: 0)),
              (route) => false);
        }
      }
    } else {
      Navigator.pushAndRemoveUntil(
          navigatorKey.currentState.context,
          MaterialPageRoute(builder: (context) => Home(pageIndex: 0)),
          (route) => false);
    }
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      final queryParams = deepLink.queryParameters;
      if (queryParams.length > 0) {
        String page = queryParams["page"];
        String articleId = queryParams["articleId"];
        if (page == "news") {
          context.read<ArticleIdNotifier>().updateId(articleId);
          Navigator.pushAndRemoveUntil(
              navigatorKey.currentState.context,
              MaterialPageRoute(builder: (context) => Home(pageIndex: 0)),
              (route) => false);
        } else if (page == "insights") {
          Navigator.pushAndRemoveUntil(
              navigatorKey.currentState.context,
              MaterialPageRoute(builder: (context) => Home(pageIndex: 2)),
              (route) => false);
        }
      }
    } else {
      if (initScreen == 0 || initScreen == null) {
        Navigator.push(navigatorKey.currentState.context,
            MaterialPageRoute(builder: (context) => IntroScreen()));
      } else {
        Navigator.push(navigatorKey.currentState.context,
            MaterialPageRoute(builder: (context) => Home(pageIndex: 0)));
      }
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkThemeProvider>(
        builder: (context, DarkThemeProvider darkThemeProvider, child) {
      return MultiProvider(
        providers: [
          // ChangeNotifierProvider.value(value: ArticleTitleProvider()),
          StreamProvider.value(value: FirebaseAuth.instance.authStateChanges())
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          theme: darkThemeProvider.getTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: initScreen == 0 || initScreen == null ? "Intro" : '/',
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      );
    });
  }
}
