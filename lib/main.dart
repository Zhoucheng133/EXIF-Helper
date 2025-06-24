import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/controllers/theme_controller.dart';
import 'package:exif_helper/main_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  Get.put(ThemeController());
  Get.put(ImageController());
  WindowOptions windowOptions = WindowOptions(
    size: Size(800, 700),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple,
            brightness: themeController.darkMode.value ? Brightness.dark : Brightness.light
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.notoSansScTextTheme(),
        ),
        home: Scaffold(
          body: MainWindow()
        ),
      ),
    );
  }
}
