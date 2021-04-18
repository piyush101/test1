import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Notification extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  final _firebaseMessaging=FirebaseMessaging.instance;
  final _message="Generating message";
  final _token="Generating token";

  @override
  void initState() {
    _firebaseMessaging.requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
