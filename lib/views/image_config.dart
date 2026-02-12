import 'dart:convert';
import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:exif_helper/components/checkbox_item.dart';
import 'package:exif_helper/components/config_item.dart';
import 'package:exif_helper/components/loading.dart';
import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/controllers/theme_controller.dart';
import 'package:exif_helper/functions/dialog_func.dart';
import 'package:expressions/expressions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        title: Text("changeImage".tr),
        content: Text("changeImageTip".tr),
        actions: [
          TextButton(
            onPressed: ()=>Navigator.pop(context), 
            child: Text("cancel".tr)
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
                warnDialog(context, "importErr".tr, "unsupportFormat".tr);
                return;
              }
            }, 
            child: Text("continue".tr)
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
          padding: .all(10.0),
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
                        top: 30,
                        right: 10,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withAlpha(100)
                          ),
                          onPressed: (){
                            imageController.item.value?.raw = Uint8List(0);
                            imageController.item.value=null;
                          }, 
                          icon: Icon(Icons.close_rounded)
                        )
                      )
                    ],
                  )
                ),
              ),
              SizedBox(width: 10,),
              Container(
                width: 270,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).brightness==Brightness.dark ? Colors.grey[800] : Colors.white
                ),
                child: Padding(
                  padding: .all(15.0),
                  child: Obx(()=>
                    Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              Text(
                                imageController.item.value!.filePath,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).brightness==Brightness.dark ? Colors.white : Colors.black
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5,),
                              Transform.translate(
                                offset: Offset(-10, 0),
                                child: CheckboxItem(
                                  val: imageController.showLogo.value, 
                                  onChanged: (val){
                                    imageController.showLogo.value=val;
                                    imageController.reloadImage();
                                  }, 
                                  label: 'showBrandLogo'.tr
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(-10, 0),
                                child: Column(
                                  children: [
                                    CheckboxItem(
                                      val: imageController.showExposureTime.value, 
                                      onChanged: !imageController.showF.value && !imageController.showISO.value ? null : (val){
                                        imageController.showExposureTime.value=val;
                                        imageController.reloadImage();
                                      }, 
                                      label: "exposureTime".tr
                                    ),
                                    CheckboxItem(
                                      val: imageController.showF.value, 
                                      onChanged: !imageController.showExposureTime.value && !imageController.showISO.value ? null : (val){
                                        imageController.showF.value=val;
                                        imageController.reloadImage();
                                      }, 
                                      label: "fNumber".tr
                                    ),
                                    CheckboxItem(
                                      val: imageController.showISO.value, 
                                      onChanged: !imageController.showExposureTime.value && !imageController.showF.value ? null : (val){
                                        imageController.showISO.value=val;
                                        imageController.reloadImage();
                                      }, 
                                      label: "ISO"
                                    ),
                                  ],
                                ),
                              ),
                              ConfigItem(keyWord: "camMake".tr, value: imageController.item.value!.make, enable: true),
                              ConfigItem(keyWord: "camModel".tr, value: imageController.item.value!.model, enable: true),
                              if(imageController.item.value!.lenModel.isNotEmpty) ConfigItem(keyWord: "lenModel".tr, value: imageController.item.value!.lenModel, enable: true),
                              ConfigItem(keyWord: "forcal".tr, value: "${imageController.item.value!.forcal}mm", enable: true),
                              ConfigItem(keyWord: "fNumber".tr, value: calFnum(imageController.item.value!.fNum), enable: true),
                              ConfigItem(keyWord: "exposureTime".tr, value: "${imageController.item.value!.exposureTime}s", enable: true),
                              ConfigItem(keyWord: "ISO", value: imageController.item.value!.iso, enable: true),
                              ConfigItem(keyWord: "captureTime".tr, value: calDatatime(imageController.item.value!.dateTime), enable: true),
                              const SizedBox(height: 20,),
                            ],
                          ),
                        ),
                        Padding(
                          padding: .only(top: 10),
                          child: FilledButton(
                            onPressed: () async {
                              String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
                              if(selectedDirectory!=null){
                                final String newName=p.basenameWithoutExtension(imageController.item.value!.filePath);
                                final String ext=p.extension(imageController.item.value!.filePath);
                                final String outputPath=p.join(selectedDirectory, "${newName}_output$ext");
                                imageController.imageSave(
                                  imageController.item.value!.filePath.toNativeUtf8(), 
                                  outputPath.toNativeUtf8(), 
                                  imageController.showLogo.value?1:0,
                                  imageController.showF.value?1:0,
                                  imageController.showExposureTime.value?1:0,
                                  imageController.showISO.value?1:0
                                );
                              }
                            }, 
                            child: Text("downloadImage".tr)
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}