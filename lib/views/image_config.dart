import 'dart:convert';
import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:exif_helper/components/config_item.dart';
import 'package:exif_helper/components/loading.dart';
import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/controllers/theme_controller.dart';
import 'package:exif_helper/functions/dialog_func.dart';
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

  void changeFile(BuildContext context, String filePath){
    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: const Text("更换图片"),
        content: const Text("确定要更换图片吗? 此操作会关闭当前图片"),
        actions: [
          TextButton(
            onPressed: ()=>Navigator.pop(context), 
            child: const Text("取消")
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              if(filePath.toLowerCase().endsWith(".jpg") || filePath.toLowerCase().endsWith(".jpeg")){
                final exifString=imageController.getEXIF(filePath.toNativeUtf8()).toDartString();
                final exifJson=jsonDecode(exifString);

                imageController.item.value=ImageItem(
                  await imageController.convertImage(filePath) ?? Uint8List(0), 
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
            }, 
            child: const Text("继续")
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DropTarget(
        onDragDone: (detail) async {
          final filePath=detail.files[0].path.replaceAll("\\", "/");
          changeFile(context, filePath);
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Obx(
                ()=> imageController.load.value ? Loading() :  Expanded(
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
                          const SizedBox(height: 5,),
                          Transform.translate(
                            offset: Offset(-10, 0),
                            child: Row(
                              children: [
                                Transform.scale(
                                  scale: 0.7,
                                  child: Switch(
                                    splashRadius: 0,
                                    value: imageController.showLogo.value, 
                                    onChanged: (val){
                                      imageController.showLogo.value=val;
                                      imageController.reloadImage();
                                    }
                                  ),
                                ),
                                Text('显示品牌logo')
                              ],
                            ),
                          ),
                          // const SizedBox(height: 10,),
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
                                imageController.imageSave(imageController.item.value!.filePath.toNativeUtf8(), outputPath.toNativeUtf8(), imageController.showLogo.value?1:0);
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
      ),
    );
  }
}