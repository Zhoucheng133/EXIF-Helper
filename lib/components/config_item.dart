import 'package:exif_helper/components/map/map_content.dart';
import 'package:exif_helper/controllers/theme_controller.dart';
import 'package:exif_helper/controllers/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigItem extends StatefulWidget {
  final String keyWord;
  final String value;
  final bool enable;

  const ConfigItem({super.key, required this.keyWord, required this.value, required this.enable});

  @override
  State<ConfigItem> createState() => _ConfigItemState();
}

class _ConfigItemState extends State<ConfigItem> {

  final ThemeController themeController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.keyWord,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness==Brightness.dark ? Colors.white : Colors.black
            ),
          ),
          Text(
            widget.value,
            style: TextStyle(
              color: Colors.grey,
            ),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}

class LocationConfig extends StatefulWidget {

  final EXIFData data;

  const LocationConfig({super.key, required this.data});

  @override
  State<LocationConfig> createState() => _LocationConfigState();
}

class _LocationConfigState extends State<LocationConfig> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "location".tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness==Brightness.dark ? Colors.white : Colors.black
            ),
          ),
          TextButton(
            onPressed: (){
              showDialog(
                context: context, 
                builder: (context)=>Dialog(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 400,
                      child: MapContent(
                        select: false,
                        data: widget.data,
                      )
                    )
                  ),
                )
              );
            }, 
            child: Text(
              widget.data.formatCoordinates()
            )
          )
        ],
      ),
    );
  }
}