import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/controllers/theme_controller.dart';
import 'package:exif_helper/main_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  Get.put(ThemeController());
  Get.put(ImageController());
  WindowOptions windowOptions = WindowOptions(
    size: Size(900, 630),
    minimumSize: Size(900, 630),
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
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  final ThemeController themeController=Get.find();

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    themeController.darkMode.value=brightness == Brightness.dark;
    return Obx(
      ()=>GetMaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: [
          Locale('zh', 'CN'),
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: brightness,
          fontFamily: 'Noto', 
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple,
            brightness: brightness,
          ),
          textTheme: themeController.darkMode.value ? ThemeData.dark().textTheme.apply(
            fontFamily: 'Noto',
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ) : ThemeData.light().textTheme.apply(
            fontFamily: 'Noto',
          ),
        ),
        home: Scaffold(
          body: MainWindow()
        ),
      ),
    );
  }
}
