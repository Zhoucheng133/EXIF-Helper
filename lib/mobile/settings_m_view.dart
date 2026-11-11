import 'dart:io';

import 'package:exif_helper/controllers/theme_controller.dart';
import 'package:exif_helper/functions/dialog_func.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class SettingsMView extends StatefulWidget {
  const SettingsMView({super.key});

  @override
  State<SettingsMView> createState() => _SettingsMViewState();
}

Future<void> clearController() async {
  final supportDir = await getApplicationDocumentsDirectory();
  final String tempDir = p.join(supportDir.path, "temp_image");
  final Directory dir = Directory(tempDir);

  if (await dir.exists()) {
    await for (final entity in dir.list()) {
      try {
        await entity.delete(recursive: true);
      } catch (_) {}
    }
  }

  if(Platform.isIOS){
    final temp = Directory.systemTemp;
    if (await temp.exists()) {
      await for (final entity in temp.list()) {
        try {
          await entity.delete(recursive: true);
        } catch (_) {}
      }
    }
  }
}

class _SettingsMViewState extends State<SettingsMView> {
  String version="";

  final ThemeController themeController = Get.find();

  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version=packageInfo.version;
    });
  }

  @override
  void initState() {
    super.initState();
    getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Obx(
          () => ListTile(
            leading: Icon(Icons.language_rounded),
            onTap: ()=>showLanguageDialog(context),
            title: Text("language".tr),
            subtitle: Text(
              themeController.lang.value.name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary.withAlpha(120)
              ),
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.info_rounded),
          onTap: ()=>showAbout(context),
          title: Text("about".tr),
          subtitle: Text(
            "v$version",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary.withAlpha(120)
            ),
          ),
        )
      ],
    );
  }
}