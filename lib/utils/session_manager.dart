import 'package:FinXpress/models/user_response_model.dart';
import 'package:localstorage/localstorage.dart';

class SessionManager {
  final String user = "user";
  final String bookmarks = "bookmarks";
  final LocalStorage storage = new LocalStorage('user');

  Future<void> setUser(UserResponseModel user) async {
    final LocalStorage storage = new LocalStorage('user');
    storage.setItem(this.user, user);
  }

  Future<UserResponseModel> getUser() async {
    final LocalStorage storage = new LocalStorage('user');
    var data = storage.getItem(this.user);
    if (data == null) {
      return null;
    }
    return UserResponseModel.fromJson(data);
  }
}
