import 'dart:io';

import 'package:exif_helper/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> with WindowListener {

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

 @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  final ThemeController themeController=Get.find();

  bool isMax=false;

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Container(
          color: Colors.transparent,
          height: 30,
          child: Row(
            children: [
              Expanded(child: DragToMoveArea(child: Container())),
              Platform.isMacOS ? Obx(
                ()=>Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WindowCaptionButton.minimize(
                      onPressed: () => windowManager.minimize(),
                      brightness: themeController.darkMode.value ? Brightness.dark : Brightness.light,
                    ),
                    isMax ? WindowCaptionButton.unmaximize(
                      onPressed: ()=>windowManager.unmaximize(),
                      brightness: themeController.darkMode.value ? Brightness.dark : Brightness.light,
                    ) : WindowCaptionButton.maximize(
                      onPressed: ()=>windowManager.maximize(),
                      brightness: themeController.darkMode.value ? Brightness.dark : Brightness.light,
                    ) ,
                    WindowCaptionButton.close(
                      onPressed: ()=>windowManager.close(),
                      brightness: themeController.darkMode.value ? Brightness.dark : Brightness.light,
                    )
                  ],
                ),
              ) : Container()
            ],
          ),
        )
      ],
    );
  }
}