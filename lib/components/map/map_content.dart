import 'package:exif_helper/components/map/amap.dart';
import 'package:exif_helper/components/map/openstreetmap.dart';
import 'package:exif_helper/controllers/theme_controller.dart';
import 'package:exif_helper/controllers/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MapContent extends StatefulWidget {

  final bool select;
  final EXIFData data;
  final ValueChanged updateLocation;

  const MapContent({super.key, required this.select, required this.data, required this.updateLocation});

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {

  final ThemeController themeController=Get.find();

  double? latitude;
  double? longitude;

  void updateLocation(Location location){
    setState(() {
      latitude=location.latitude;
      longitude=location.longitude;
    });
  }

  String formatLocation() {
    if(!widget.select || latitude==null || longitude==null){
      return widget.data.formatCoordinates();
    }
    try {
      final latDirection = latitude! >= 0 ? 'N' : 'S';
      final lonDirection = longitude! >= 0 ? 'E' : 'W';

      return '${latitude!.abs().toStringAsFixed(4)}° $latDirection, '
          '${longitude!.abs().toStringAsFixed(4)}° $lonDirection';
    } catch (_) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Obx(
        ()=> Column(
          mainAxisSize: .min,
          children: [
            SizedBox(
              height: 50,
              child: Padding(
                padding: .symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: .center,
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Padding(
                      padding: .only(left: 10),
                      child: Text(
                        formatLocation(),
                      ),
                    ),
                    IconButton(
                      onPressed: ()=>Navigator.pop(context), 
                      icon: Icon(Icons.close_rounded)
                    ),
                  ],
                )
              ),
            ),
            TabBar(
              tabs: themeController.lang.value.locale.countryCode=="CN" ? [
                Tab(text: 'amap'.tr),
                Tab(text: 'openstreetmap'.tr),
              ] : [
                Tab(text: 'openstreetmap'.tr),
                Tab(text: 'amap'.tr),
              ],
            ),
            SizedBox(
              width: 400,
              height: 400,
              child: TabBarView(
                children: themeController.lang.value.locale.countryCode=="CN" ? [
                  Amap(select: widget.select, data: widget.data, locationUpdate: (value)=>updateLocation(value),),
                  Openstreetmap(select: widget.select, data: widget.data, locationUpdate: (value)=>updateLocation(value)),
                ] : [
                  Openstreetmap(select: widget.select, data: widget.data, locationUpdate: (value)=>updateLocation(value)),
                  Amap(select: widget.select, data: widget.data, locationUpdate: (value)=>updateLocation(value))
                ],
              ),
            ),
            if(widget.select) Padding(
              padding: .symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  TextButton(
                    child: Text("removeLocation".tr),
                    onPressed: (){
                      widget.updateLocation(null);
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    onPressed: (){
                      if(latitude==null || longitude==null){
                        if(widget.data.latitude==null || widget.data.longitude==null){
                          widget.updateLocation(null);
                        }
                      }else if(latitude!=null && longitude!=null){
                        widget.updateLocation(Location(latitude: latitude!, longitude: longitude!));
                      }
                      Navigator.pop(context);
                    }, 
                    child: Text("ok".tr)
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}