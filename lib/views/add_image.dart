import 'dart:convert';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/controllers/theme_controller.dart';
import 'package:exif_helper/functions/dialog_func.dart';
import 'package:ffi/ffi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {

  final ImageController imageController=Get.find();
  final ThemeController themeController=Get.find();


  Future<void> fileChecker(BuildContext context,String filePath) async {
    if(filePath.toLowerCase().endsWith(".jpg") || filePath.toLowerCase().endsWith(".jpeg")){
      
      final exifString=imageController.getEXIF(filePath.toNativeUtf8()).toDartString();
      final exifJson=jsonDecode(exifString);

      imageController.item.value=ImageItem(
        imageController.convertImage(filePath) ?? Uint8List(0), 
        filePath, 
        exifJson["camMake"].replaceAll("\"", ""), 
        exifJson["camModel"].replaceAll("\"", ""), 
        exifJson["captureTime"].replaceAll("\"", ""), 
        exifJson["exposureTime"].replaceAll("\"", ""), 
        exifJson["fNum"].replaceAll("\"", ""), 
        exifJson["iso"].replaceAll("\"", ""), 
        exifJson["focal"].replaceAll("\"", ""), 
        exifJson["focal35"].replaceAll("\"", ""), 
        exifJson["lenMake"].replaceAll("\"", ""), 
        exifJson["lenModel"].replaceAll("\"", ""), 
      );
    }else{
      warnDialog(context, "导入图片错误", "不支持的格式");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DropTarget(
        onDragDone: (detail) async {
          final filePath=detail.files[0].path.replaceAll("\\", "/");
          fileChecker(context, filePath);
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                    if (result != null && context.mounted) {
                      fileChecker(context, result.files.single.path!);
                    }
                  }, 
                  icon: const Icon(
                    Icons.add_rounded,
                    size: 30,
                  )
                ),
                const SizedBox(height: 10,),
                Text(
                  "添加一个照片，你也可以拖拽照片文件到这里",
                  style: GoogleFonts.notoSansSc(
                    color: Theme.of(context).colorScheme.onSurface
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}