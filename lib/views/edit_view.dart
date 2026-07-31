import 'dart:io';

import 'package:exif_helper/components/edit_item.dart';
import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/controllers/libs.dart';
import 'package:exif_helper/functions/dialog_func.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

class EditView extends StatefulWidget {
  const EditView({super.key});

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {

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
                            EditItem(keyWord: "camMake".tr, initValue: imageController.exifData.value!.camMake, onChanged: (value) => imageController.exifData.value!.camMake=value,),
                            EditItem(keyWord: "camModel".tr, initValue: imageController.exifData.value!.camModel, onChanged: (value) => imageController.exifData.value!.camModel=value,),
                            EditItem(keyWord: "lenModel".tr, initValue: imageController.exifData.value!.lenModel, onChanged: (value) => imageController.exifData.value!.lenModel=value,),
                            EditItem(keyWord: "focal".tr, initValue: imageController.exifData.value!.focal, onChanged: (value) => imageController.exifData.value!.focal=value, endLabel: "mm", width: 100, numberOnly: true,),
                            EditItem(keyWord: "fNumber".tr, initValue: imageController.exifData.value!.fNum, onChanged: (value) => imageController.exifData.value!.fNum=value, preLabel: "F", width: 100, numberOnly: true,),
                            EditItem(keyWord: "exposureTime".tr, initValue: imageController.exifData.value!.exposureTime, onChanged: (value) => imageController.exifData.value!.exposureTime=value, endLabel: "s", width: 100, exposureTime: true,),
                            EditItem(keyWord: "ISO".tr, initValue: imageController.exifData.value!.iso, onChanged: (value) => imageController.exifData.value!.iso=value, numberOnly: true, width: 100,),
                            EditTime(),
                            const SizedBox(height: 20,),
                          ],
                        ),
                      ),
                      Padding(
                        padding: .only(top: 10),
                        child: FilledButton(
                          onPressed: saveLoad ? null : () async {
                            if(!imageController.checkExif(context)){
                              return;
                            }
                            String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
                            if(selectedDirectory!=null){
                              if(p.normalize(selectedDirectory)==p.normalize(p.dirname(imageController.filePath.value)) && context.mounted){
                                warnDialog(context, "saveFail".tr, "samePath".tr);
                                return;
                              }
                              setState(() {
                                saveLoad=true;
                              });
                              await compute(editExif, [
                                imageController.filePath.value, 
                                p.join(selectedDirectory, "${p.basenameWithoutExtension(imageController.filePath.value)}.jpg"),
                                imageController.exifData.value!.toJsonString(),
                              ]);
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