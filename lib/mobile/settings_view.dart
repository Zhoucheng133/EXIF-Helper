import 'dart:io';

import 'package:exif_helper/controllers/theme_controller.dart';
import 'package:exif_helper/functions/dialog_func.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  int cacheSize=0;
  String version="";

  final ThemeController themeController = Get.find();

  String sizeConvert(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1048576) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1073741824) {
      return '${(bytes / 1048576).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / 1073741824).toStringAsFixed(2)} GB';
    }
  }

  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version=packageInfo.version;
    });
  }

  @override
  void initState() {
    super.initState();
    getCacheSize();
    getVersion();
  }

  Future<int> getDirectorySize(Directory path) async {
    int size = 0;
    for (var entity in path.listSync(recursive: true)) {
      if (entity is File) {
        size += entity.lengthSync();
      }
    }
    return size;
  }

  Future<void> getCacheSize() async {
    try {
      final supportDir=await getApplicationDocumentsDirectory();
      final String tempDir = p.join(supportDir.path, "temp_image");
      int size = await getDirectorySize(Directory(tempDir));
      setState(() {
        cacheSize=size;
      });
    } catch (_) {
      setState(() {
        cacheSize=0;
      });
    }
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
    getCacheSize();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.cached_rounded),
          onTap: ()=>clearController(),
          title: Text("clearCache".tr),
          subtitle: Text(
            sizeConvert(cacheSize),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary.withAlpha(120)
            ),
          ),
        ),
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