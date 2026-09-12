import 'package:exif_helper/components/map/amap.dart';
import 'package:exif_helper/components/map/openstreetmap.dart';
import 'package:exif_helper/controllers/theme_controller.dart';
import 'package:exif_helper/controllers/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MapContent extends StatefulWidget {

  final bool select;
  final EXIFData data;

  const MapContent({super.key, required this.select, required this.data});

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {

  final ThemeController themeController=Get.find();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: themeController.lang.value.locale.countryCode=="CN" ? [
                Tab(text: 'amap'.tr),
                Tab(text: 'openstreetmap'.tr),
              ] : [
                Tab(text: 'openstreetmap'.tr),
                Tab(text: 'amap'.tr),
              ],
            ),
          ),
          body: SizedBox(
            width: 500,
            height: 500,
            child: TabBarView(
              children: themeController.lang.value.locale.countryCode=="CN" ? [
                Amap(select: widget.select, data: widget.data,),
                Openstreetmap(select: widget.select, data: widget.data,),
              ] : [
                Openstreetmap(select: widget.select, data: widget.data,),
                Amap(select: widget.select, data: widget.data,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}