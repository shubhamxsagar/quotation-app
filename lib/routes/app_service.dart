import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appServiceProvider = ChangeNotifierProvider<AppService>((ref) {
  return AppService();
});

class AppService with ChangeNotifier {
  bool _initialized = false;

  AppService();

  bool get initialized => _initialized;

  set initialized(bool value) {
    _initialized = value;
    // print('initialized value: $_initialized');
    notifyListeners();
  }

  Future<void> onAppStart() async {
    await Future.delayed(const Duration(seconds: 2));
    _initialized = true;
    if (kDebugMode) {
      print('initialized value 2: $_initialized');
    }
    notifyListeners();
  }
}
