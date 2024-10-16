import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotation/firebase_options.dart';
import 'package:quotation/lc.dart';
import 'package:quotation/routes/app_service.dart';
import 'package:quotation/routes/route_constants.dart';
import 'package:quotation/themes/app_pallete.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDependencies();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightThemeMode,
      title: 'Pooja Quotation',
      themeMode: ThemeMode.light,
      routerConfig: MyAppRouter(
              ProviderScope.containerOf(context).read(appServiceProvider))
          .router,
    );
  }
}
