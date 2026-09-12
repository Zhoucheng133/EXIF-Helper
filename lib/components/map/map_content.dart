import 'package:exif_helper/components/map/amap.dart';
import 'package:exif_helper/components/map/openstreetmap.dart';
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'openstreetmap'.tr),
              Tab(text: 'amap'.tr),
            ],
          ),
        ),
        body: SizedBox(
          width: 500,
          height: 500,
          child: TabBarView(
            children: [
              Openstreetmap(select: widget.select, data: widget.data,),
              Amap(select: widget.select, data: widget.data,)
            ],
          ),
        ),
      ),
    );
  }
}