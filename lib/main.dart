import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/controllers/theme_controller.dart';
import 'package:exif_helper/functions/cals.dart';
import 'package:exif_helper/i18n/en_us.dart';
import 'package:exif_helper/i18n/zh_cn.dart';
import 'package:exif_helper/i18n/zh_tw.dart';
import 'package:exif_helper/i18n/ja_jp.dart';
import 'package:exif_helper/i18n/ko_kr.dart';
import 'package:exif_helper/i18n/de_de.dart';
import 'package:exif_helper/i18n/ru_ru.dart';
import 'package:exif_helper/i18n/es_es.dart';
import 'package:exif_helper/i18n/pt_pt.dart';
import 'package:exif_helper/i18n/fr_fr.dart';
import 'package:exif_helper/main_window.dart';
import 'package:exif_helper/mobile/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller=Get.put(ThemeController());
  await controller.initLang();
  Get.put(ImageController());
  if(isDesktop()){
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      size: Size(900, 650),
      minimumSize: Size(900, 650),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      title: "EXIF Helper"
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class MainTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'zh_CN': zhCN,
    'zh_TW': zhTW,
    'ja_JP': jaJP,
    'ko_KR': koKR,
    'de_DE': deDE,
    'ru_RU': ruRU,
    'es_ES': esES,
    'pt_PT': ptPT,
    'fr_FR': frFR,
  };
}

class _MainAppState extends State<MainApp> {

  final ThemeController themeController=Get.find();

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    return Obx(
      ()=>GetMaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        translations: MainTranslations(),
        locale: themeController.lang.value.locale,
        fallbackLocale: Locale('en', 'US'),
        supportedLocales: supportedLocales.map((item)=>item.locale).toList(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: brightness,
          fontFamily: 'PuHui', 
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple,
            brightness: brightness,
          ),
          textTheme: brightness == Brightness.dark ? ThemeData.dark().textTheme.apply(
            fontFamily: 'PuHui',
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ) : ThemeData.light().textTheme.apply(
            fontFamily: 'PuHui',
          ),
        ),
        home: isDesktop() ? Scaffold(
          body: MainWindow()
        ) : MainView()
      ),
    );
  }
}
