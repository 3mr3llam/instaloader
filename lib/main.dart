import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:instaloader/pages/splash_page.dart';
import 'package:instaloader/utils/app_theme.dart';
import 'package:instaloader/utils/constants.dart';
import 'package:instaloader/utils/languages.dart';
import 'package:instaloader/widgets/rate_app_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Plugin must be initialized before using
  await FlutterDownloader.initialize(
    debug: false, // optional: set to false to disable printing logs to console (default: true)
    ignoreSsl: true, // option: set to false to disable working with http links (default: false)
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RateAppInit(
      builder: (rateMyApp) {
        return GetMaterialApp(
          title: appName,
          translations: Languages(),
          locale: Get.deviceLocale,
          fallbackLocale: const Locale('en'),
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          home: SplashPage(
            rateMyApp: rateMyApp,
          ),
        );
      },
    );
  }
}
