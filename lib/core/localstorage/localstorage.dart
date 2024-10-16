import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotation/lc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localStorageProvider =
    ChangeNotifierProvider<LocalStorageRepository>((ref) {
  return LocalStorageRepository(lc());
});

class LocalStorageRepository with ChangeNotifier {
  static const _token = "'x-auth-token'";
  static const _uid = "uid_User";
  static const uid = _uid;
  static const _onbordId = "Onboard_Id";
  static const _groupId = "group_Id";
  bool _initialized = false;
  final SharedPreferences preferences;
  LocalStorageRepository(this.preferences);

  bool get initialized => _initialized;

  set initialized(bool value) {
    _initialized = value;
    notifyListeners();
  }

  Future<void> removeUid() async {
    await preferences.remove(_uid);
    notifyListeners();
  }

  Future<void> clearAllData() async {
    await preferences.clear(); // Removes everything stored
    notifyListeners();
  }

  void setToken(String token) async {
    await preferences.setString(LocalStorageRepository._token, token);
  }

  void setUid(String uid) async {
    await preferences.setString(LocalStorageRepository._uid, uid);
  }

  void setGroupID(String groupId) async {
    await preferences.setString(LocalStorageRepository._groupId, groupId);
  }

  void deleteUser() async {
    await preferences.remove(LocalStorageRepository._uid);
    await preferences.remove(LocalStorageRepository._token);
    await preferences.remove(LocalStorageRepository._groupId);
    notifyListeners();
  }

  String getUid() {
    String uid = preferences.getString(LocalStorageRepository._uid) ?? '';
    return uid;
  }

  Future<String> getUidFuture() async {
    String uid = preferences.getString(LocalStorageRepository._uid) ?? '';
    return uid;
  }

  void setOnbaord(String uid) async {
    await preferences.setString(LocalStorageRepository._onbordId, uid);
  }

  Future<String> getOnbaord() async {
    String uid = preferences.getString(LocalStorageRepository._onbordId) ?? '';
    return uid;
  }

  Future<String> getToken() async {
    String token = preferences.getString(LocalStorageRepository._token) ?? '';
    return token;
  }

  Future<void> onAppStart() async {
    _initialized = true;
    notifyListeners();
  }
}
