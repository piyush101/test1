import 'dart:convert';

import 'package:FinXpress/constants.dart';
import 'package:FinXpress/models/update_user_model.dart';
import 'package:FinXpress/models/user_response_model.dart';
import 'package:FinXpress/models/users_model.dart';
import 'package:FinXpress/utils/session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class UserService {
  SessionManager sessionManager = SessionManager();
  UsersModel user;
  var logger = Logger();

  Future<void> createUser(UsersModel users) async {
    try {
      var response = await http.post(
          Uri.parse(Constants.apiUrl + "/user/onboard"),
          body: json.encode(users),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json'
          });
      sessionManager.setUser(userResponseModelFromJson(response.body));
      logger.i(response.body);
    } catch (error) {
      logger.e(error);
    }
  }

  Future<void> updateUser(UpdateUserModel updateUser) async {
    try {
      var response = await http.post(
          Uri.parse(Constants.apiUrl + "/user/verify"),
          body: json.encode(updateUser),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json'
          });
      logger.i(response.body);
    } catch (error) {
      logger.e(error);
    }
  }
}
