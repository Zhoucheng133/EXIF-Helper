import 'dart:io';

import 'package:exif_helper/components/config_item.dart';
import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/controllers/libs.dart';
import 'package:exif_helper/functions/cals.dart';
import 'package:exif_helper/functions/dialog_func.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

class RemoveView extends StatefulWidget {
  const RemoveView({super.key});

  @override
  State<RemoveView> createState() => _RemoveViewState();
}

class _RemoveViewState extends State<RemoveView> {
  final ImageController imageController = Get.find();

  bool saveLoad = false;

  @override
  void dispose() {
    super.dispose();
    imageController.filePath.value="";
    imageController.exifData.value=null;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: .all(10.0),
        child: Row(
          children: [
            Obx(
              ()=> Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: .all(10.0),
                        child: Image.file(
                          File(imageController.filePath.value),
                          cacheHeight: 800,
                          fit: BoxFit.contain,
                          gaplessPlayback: false,
                        ),
                      )
                    ),
                    Positioned(
                      top: 30,
                      right: 10,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withAlpha(100)
                        ),
                        onPressed: (){
                          Get.back(id: 1);
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
                              imageController.filePath.value,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).brightness==Brightness.dark ? Colors.white : Colors.black
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            ConfigItem(keyWord: "camMake".tr, value: imageController.exifData.value!.camMake, enable: true),
                            ConfigItem(keyWord: "camModel".tr, value: imageController.exifData.value!.camModel, enable: true),
                            if(imageController.exifData.value!.lenModel.isNotEmpty) ConfigItem(keyWord: "lenModel".tr, value: imageController.exifData.value!.lenModel, enable: true),
                            ConfigItem(keyWord: "forcal".tr, value: "${imageController.exifData.value!.focal}mm", enable: true),
                            ConfigItem(keyWord: "fNumber".tr, value: calFnum(imageController.exifData.value!.fNum), enable: true),
                            ConfigItem(keyWord: "exposureTime".tr, value: "${imageController.exifData.value!.exposureTime}s", enable: true),
                            ConfigItem(keyWord: "ISO", value: imageController.exifData.value!.iso, enable: true),
                            ConfigItem(keyWord: "captureTime".tr, value: calDatatime(imageController.exifData.value!.exposureTime), enable: true),
                            const SizedBox(height: 20,),
                          ],
                        ),
                      ),
                      Padding(
                        padding: .only(top: 10),
                        child: FilledButton(
                          onPressed: saveLoad ? null : () async {
                            String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
                            if(selectedDirectory!=null){
                              if(p.normalize(selectedDirectory)==p.normalize(p.dirname(imageController.filePath.value)) && context.mounted){
                                warnDialog(context, "saveFail".tr, "samePath".tr);
                                return;
                              }
                              setState(() {
                                saveLoad=true;
                              });
                              await compute(removeExif, [imageController.filePath.value, p.join(selectedDirectory, "${p.basenameWithoutExtension(imageController.filePath.value)}.jpg")]);
                              if(context.mounted){
                                warnDialog(
                                  context, 
                                  "saveSuccess".tr, 
                                  "${'saveTo'.tr}: \n${p.join(selectedDirectory, '${p.basenameWithoutExtension(imageController.filePath.value)}.jpg')}"
                                );
                              }
                              setState(() {
                                saveLoad=false;
                              });
                            }
                          }, 
                          child: saveLoad ? SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            )
                          ) : Text('saveImage'.tr)
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
    );
  }
}