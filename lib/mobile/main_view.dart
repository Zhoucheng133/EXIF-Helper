import 'dart:io';

import 'package:exif_helper/mobile/add_view.dart';
import 'package:exif_helper/mobile/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  int pageIndex=0;

  Future<void> initTempDir() async {
    final supportDir = await getApplicationDocumentsDirectory();
    final tempImageDir = Directory(p.join(supportDir.path, "temp_image"));

    if (!await tempImageDir.exists()) {
      await tempImageDir.create(recursive: true);
    }
  }

  @override
  void initState() {
    super.initState();
    initTempDir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(pageIndex==0?"home".tr:"settings".tr),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_rounded),
            label: "home".tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_rounded),
            label: "settings".tr,
          ),
        ],
        onDestinationSelected: (val){
          setState(() {
            pageIndex=val;
          });
        },
        selectedIndex: pageIndex,
      ),
      body: IndexedStack(
        index: pageIndex,
        children: [
          AddView(),
          SettingsView(),
        ],
      )
    );
  }
}