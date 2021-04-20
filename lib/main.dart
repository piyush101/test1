import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/route_generator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/provider/dark_theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return runApp(ChangeNotifierProvider(
    child: MyApp(),
    create: (BuildContext context) =>
        DarkThemeProvider(sharedPreferences.getBool("isDarkTheme") ?? false),
  ));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("message is "+ message.data['url']);

}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // flutterLocalNotificationsPlugin.initialize(InitializationSettings(),onSelectNotification: Uri.parse(message));

    //   // a terminated state.
    //   RemoteMessage initialMessage =
    //       await FirebaseMessaging.instance.getInitialMessage();
    //

    //   // If the message also contains a data property with a "type" of "chat",
    //   // navigate to a chat screen
    //   if (initialMessage?.data['type'] == 'chat') {
    //     Navigator.pushNamed(context, '/chat',
    //         arguments: ChatArguments(initialMessage));
    //   }
    //
    //   // Also handle any interaction when the app is in the background via a
    //   // Stream listener
    //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //     if (message.data['type'] == 'chat') {
    //       Navigator.pushNamed(context, '/chat',
    //           arguments: ChatArguments(message));
    //     }
    //   });
    // }

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
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
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
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      );
    });
  }
}
