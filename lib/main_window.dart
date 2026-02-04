import 'dart:io';

import 'package:exif_helper/components/loading.dart';
import 'package:exif_helper/functions/dialog_func.dart';
import 'package:exif_helper/views/add_image.dart';
import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/controllers/theme_controller.dart';
import 'package:exif_helper/views/image_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final ImageController imageController=Get.find();

  bool isMax=false;

  void maxWindow(){
    windowManager.maximize();
    setState(() {
      isMax=true;
    });
  }

  void unMaxWindow(){
    windowManager.unmaximize();
    setState(() {
      isMax=false;
    });
  }

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
              Platform.isWindows ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WindowCaptionButton.minimize(
                    onPressed: windowManager.minimize,
                    brightness: Theme.of(context).brightness==Brightness.dark ? Brightness.dark : Brightness.light,
                  ),
                  isMax ? WindowCaptionButton.unmaximize(
                    onPressed: unMaxWindow,
                    brightness: Theme.of(context).brightness==Brightness.dark ? Brightness.dark : Brightness.light,
                  ) : WindowCaptionButton.maximize(
                    onPressed: maxWindow,
                    brightness: Theme.of(context).brightness==Brightness.dark ? Brightness.dark : Brightness.light,
                  ) ,
                  WindowCaptionButton.close(
                    onPressed: windowManager.close,
                    brightness: Theme.of(context).brightness==Brightness.dark ? Brightness.dark : Brightness.light,
                  )
                ],
              ) : Container()
            ],
          ),
        ),
        Obx(()=>
          imageController.item.value==null ? imageController.load.value ? Loading() : AddImage() : ImageConfig()
        ),
        Platform.isMacOS ? PlatformMenuBar(
            menus: [
              PlatformMenu(
                label: "FFmpeg GUI",
                menus: [
                  PlatformMenuItemGroup(
                    members: [
                      PlatformMenuItem(
                        label: "aboutEXIFHelper".tr,
                        onSelected: (){
                          showAbout(context);
                        }
                      )
                    ]
                  ),
                  const PlatformMenuItemGroup(
                    members: [
                      PlatformProvidedMenuItem(
                        enabled: true,
                        type: PlatformProvidedMenuItemType.hide,
                      ),
                      PlatformProvidedMenuItem(
                        enabled: true,
                        type: PlatformProvidedMenuItemType.quit,
                      ),
                    ]
                  ),
                ]
              ),
              PlatformMenu(
                label: "edit".tr,
                menus: [
                  PlatformMenuItem(
                    label: "copy".tr,
                    shortcut: const SingleActivator(
                      LogicalKeyboardKey.keyC,
                      meta: true
                    ),
                    onSelected: (){}
                  ),
                  PlatformMenuItem(
                    label: "paste".tr,
                    shortcut: const SingleActivator(
                      LogicalKeyboardKey.keyV,
                      meta: true
                    ),
                    onSelected: (){}
                  ),
                  PlatformMenuItem(
                    label: "selectAll".tr,
                    shortcut: const SingleActivator(
                      LogicalKeyboardKey.keyA,
                      meta: true
                    ),
                    onSelected: (){}
                  )
                ]
              ),
              PlatformMenu(
                label: "window".tr, 
                menus: [
                  PlatformMenuItemGroup(
                    members: [
                      PlatformProvidedMenuItem(
                        enabled: true,
                        type: PlatformProvidedMenuItemType.minimizeWindow,
                      ),
                      PlatformProvidedMenuItem(
                        enabled: true,
                        type: PlatformProvidedMenuItemType.toggleFullScreen,
                      )
                    ]
                  )
                ]
              )
            ]
        ):Container()
      ],
    );
  }
}