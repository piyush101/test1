import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_news/route_generator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/provider/dark_theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  return runApp(ChangeNotifierProvider(
    child: MyApp(),
    create: (BuildContext context) =>
        DarkThemeProvider(sharedPreferences.getBool("isDarkTheme") ?? false),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DarkThemeProvider>(
        builder: (context, DarkThemeProvider darkThemeProvider, child) {
      return MaterialApp(
        theme: darkThemeProvider.getTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      );
    });
  }
}
