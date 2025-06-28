import 'package:exif_helper/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
          Obx(()=>
            Text(
              widget.keyWord,
              style: GoogleFonts.notoSansSc(
                fontWeight: FontWeight.bold,
                color: themeController.darkMode.value ? Colors.white : Colors.black
              ),
            ),
          ),
          Text(
            widget.value,
            style: GoogleFonts.notoSansSc(
              color: Colors.grey,
            ),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}