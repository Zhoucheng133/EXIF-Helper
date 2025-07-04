import 'dart:typed_data';

import 'package:exif_helper/components/config_item.dart';
import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/controllers/theme_controller.dart';
import 'package:expressions/expressions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as p;
import 'package:ffi/ffi.dart';

class ImageConfig extends StatefulWidget {
  const ImageConfig({super.key});

  @override
  State<ImageConfig> createState() => _ImageConfigState();
}

class _ImageConfigState extends State<ImageConfig> {

  final ImageController imageController=Get.find();
  final ThemeController themeController=Get.find();

  String calFnum(String input){
    final expression = Expression.parse(input);
    final evaluator = const ExpressionEvaluator();

    return "F${evaluator.eval(expression, {})}";
  }

  String calDatatime(String input){
    input=input.replaceFirst(":", "-");
    input=input.replaceFirst(":", "-");
    return input;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Obx(()=>
                      Image.memory(
                        imageController.item.value!.raw,
                        fit: BoxFit.contain,
                        gaplessPlayback: false,
                      )
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: (){
                        imageController.item.value?.raw = Uint8List(0);
                        imageController.item.value=null;
                      }, 
                      icon: const Icon(Icons.close_rounded)
                    )
                  )
                ],
              )
            ),
            SizedBox(width: 10,),
            Obx(()=>
              Container(
                width: 270,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: themeController.darkMode.value ? Colors.grey[800] : Colors.white
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(()=>
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          imageController.item.value!.filePath,
                          style: GoogleFonts.notoSansSc(
                            fontSize: 18,
                            color: themeController.darkMode.value ? Colors.white : Colors.black
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10,),
                        ConfigItem(keyWord: "相机制造商", value: imageController.item.value!.make, enable: true),
                        ConfigItem(keyWord: "相机型号", value: imageController.item.value!.model, enable: true),
                        ConfigItem(keyWord: "镜头型号", value: imageController.item.value!.lenModel, enable: true),
                        ConfigItem(keyWord: "焦距", value: "${imageController.item.value!.forcal}mm", enable: true),
                        ConfigItem(keyWord: "光圈", value: calFnum(imageController.item.value!.fNum), enable: true),
                        ConfigItem(keyWord: "曝光时间", value: "${imageController.item.value!.exposureTime}s", enable: true),
                        ConfigItem(keyWord: "ISO", value: imageController.item.value!.iso, enable: true),
                        ConfigItem(keyWord: "拍摄时间", value: calDatatime(imageController.item.value!.dateTime), enable: true),
                        const SizedBox(height: 20,),
                        TextButton(
                          onPressed: () async {
                            String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
                            if(selectedDirectory!=null){
                              final String newName=p.basenameWithoutExtension(imageController.item.value!.filePath);
                              final String ext=p.extension(imageController.item.value!.filePath);
                              final String outputPath=p.join(selectedDirectory, "${newName}_output$ext");
                              // await file.writeAsBytes(imageController.item.value!.raw);
                              imageController.imageSave(imageController.item.value!.filePath.toNativeUtf8(), outputPath.toNativeUtf8());
                            }
                          }, 
                          child: const Text("下载图片")
                        )
                      ],
                    ),
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}