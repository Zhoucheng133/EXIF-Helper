import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:exif/exif.dart';
import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/functions/dialog_func.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {

  final ImageController imageController=Get.find();

  Future<void> fileChecker(BuildContext context,String filePath) async {
    if(filePath.toLowerCase().endsWith(".jpg") || filePath.toLowerCase().endsWith(".jpeg")){
      final fileBytes = File(filePath).readAsBytesSync();
      final data = await readExifFromBytes(fileBytes);
      if (data.isEmpty) {
        if(context.mounted){
          warnDialog(context, "导入图片错误", "没有EXIF信息");
        }
        return;
      }
      if (data.containsKey('JPEGThumbnail')) {
        data.remove('JPEGThumbnail');
      }
      if (data.containsKey('TIFFThumbnail')) {
        data.remove('TIFFThumbnail');
      }

      imageController.item.value=ImageItem(
        fileBytes,
        p.basename(filePath),
        // filePath,
        (Map.fromEntries(data.entries))['Image Make']?.printable ?? "",
        (Map.fromEntries(data.entries))['Image Model']?.printable ?? "", 
        (Map.fromEntries(data.entries))['EXIF DateTimeOriginal']?.printable ?? "", 
        (Map.fromEntries(data.entries))['EXIF ExposureTime']?.printable ?? "", 
        (Map.fromEntries(data.entries))['EXIF FNumber']?.printable ?? "", 
        (Map.fromEntries(data.entries))['EXIF ISOSpeedRatings']?.printable ?? "", 
        (Map.fromEntries(data.entries))['EXIF FocalLength']?.printable ?? "", 
        (Map.fromEntries(data.entries))['EXIF FocalLengthIn35mmFilm']?.printable ?? "", 
        (Map.fromEntries(data.entries))['EXIF LensMake']?.printable ?? "", 
        (Map.fromEntries(data.entries))['EXIF LensModel']?.printable ?? "", 
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
          final filePath=detail.files[0].path;
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
                Text("添加一个照片，你也可以拖拽照片文件到这里")
              ],
            ),
          ),
        ),
      ),
    );
  }
}