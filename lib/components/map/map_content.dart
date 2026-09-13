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
  late String selectedMap;

  @override
  void initState() {
    super.initState();
    selectedMap = themeController.lang.value.locale.countryCode=="CN" ? 'amap' : 'openstreetmap';
  }

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

    return Column(
      mainAxisSize: .min,
      children: [
        SizedBox(
          height: 55,
          child: Padding(
            padding: .symmetric(horizontal: 15),
            child: Row(
              crossAxisAlignment: .center,
              mainAxisAlignment: .spaceBetween,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    focusColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    padding: .symmetric(horizontal: 10),
                    value: selectedMap,
                    items: [
                      DropdownMenuItem(
                        value: 'amap',
                        child: Text('amap'.tr),
                      ),
                      DropdownMenuItem(
                        value: 'openstreetmap',
                        child: Text('openstreetmap'.tr),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedMap = value;
                        });
                      }
                    },
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
        SizedBox(
          width: 400,
          height: 400,
          child: selectedMap == 'amap'
              ? Amap(select: widget.select, data: widget.data, locationUpdate: (value)=>updateLocation(value))
              : Openstreetmap(select: widget.select, data: widget.data, locationUpdate: (value)=>updateLocation(value)),
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
    );
  }
}