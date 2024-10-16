import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quotation/core/localstorage/localstorage.dart';
import 'package:quotation/routes/app_service.dart';
import 'package:quotation/routes/route_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final lc = GetIt.instance;

Future<void> initializeDependencies() async {
  lc.registerLazySingletonAsync<SharedPreferences>(() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  });
  await lc.isReady<SharedPreferences>();
  lc.registerSingletonAsync<LocalStorageRepository>(() async {
    final repository = LocalStorageRepository(lc());
    return repository;
  });
  await lc.isReady<LocalStorageRepository>();
  final uid = await lc<LocalStorageRepository>().getUid();
  lc.registerSingleton<String>(uid);
  lc.registerLazySingleton(() => http.Client());
  
  lc.registerLazySingleton(() => FirebaseAuth.instance);
  // lc.registerLazySingleton(() => FirebaseStorage.instance);
  lc.registerLazySingleton(() => FirebaseFirestore.instance);
  lc.registerLazySingleton(() => GoogleSignIn());
  lc.registerLazySingleton<AppService>(() => AppService());

  lc.registerLazySingleton<MyAppRouter>(() => MyAppRouter(lc<AppService>()));
}
