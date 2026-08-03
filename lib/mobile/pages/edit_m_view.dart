import 'dart:io';

import 'package:exif_helper/components/edit_item.dart';
import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/controllers/libs.dart';
import 'package:exif_helper/functions/dialog_func.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';

class EditMView extends StatefulWidget {
  const EditMView({super.key});

  @override
  State<EditMView> createState() => _EditMViewState();
}

class _EditMViewState extends State<EditMView> {

  final imageController=Get.find<ImageController>();

  bool saveLoad=false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0.0,
        title: Text('editExif'.tr),
      ),
      body: Obx(
        ()=>NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled){
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                toolbarHeight: 0,
                floating: true,
                snap: true,
                pinned: false,
                expandedHeight: 400,
                flexibleSpace: FlexibleSpaceBar(
                  background: SizedBox.expand(
                    child: Image.file(
                      File(imageController.filePath.value),
                      fit: BoxFit.contain,
                      gaplessPlayback: false,
                      cacheHeight: 800,
                    ),
                  ),
                ),
              )
            ];
          }, 
          body: ListView(
            padding: .only(left: 15, right: 15, top: 15, bottom: 10),
            children: [
              EditItem(keyWord: "camMake".tr, initValue: imageController.exifData.value!.camMake, onChanged: (value) => imageController.exifData.value!.camMake=value,),
              EditItem(keyWord: "camModel".tr, initValue: imageController.exifData.value!.camModel, onChanged: (value) => imageController.exifData.value!.camModel=value,),
              EditItem(keyWord: "lenModel".tr, initValue: imageController.exifData.value!.lenModel, onChanged: (value) => imageController.exifData.value!.lenModel=value,),
              EditItem(keyWord: "focal".tr, initValue: imageController.exifData.value!.focal, onChanged: (value) => imageController.exifData.value!.focal=value, endLabel: "mm", width: 100, numberOnly: true,),
              EditItem(keyWord: "fNumber".tr, initValue: imageController.exifData.value!.fNum, onChanged: (value) => imageController.exifData.value!.fNum=value, preLabel: "F", width: 100, numberOnly: true,),
              EditItem(keyWord: "exposureTime".tr, initValue: imageController.exifData.value!.exposureTime, onChanged: (value) => imageController.exifData.value!.exposureTime=value, endLabel: "s", width: 100, exposureTime: true,),
              EditItem(keyWord: "ISO".tr, initValue: imageController.exifData.value!.iso, onChanged: (value) => imageController.exifData.value!.iso=value, numberOnly: true, width: 100,),
              EditTime(),
              Row(
                crossAxisAlignment: .center,
                mainAxisAlignment: .spaceBetween,
                children: [
                  TextButton(
                    onPressed: (){
                      showImageInfo(context, imageController.exifData.value!);
                    }, 
                    child: Text('photoInfo'.tr)
                  ),
                  FilledButton(
                    onPressed: saveLoad ? null : () async {
                      setState(() {
                        saveLoad=true;
                      });
                      int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
                      final supportDir=await getApplicationDocumentsDirectory();
                      await compute(editExif, [
                        imageController.filePath.value, 
                        p.join(supportDir.path, "temp_image", "${timestamp.toString()}.jpg"),
                        imageController.exifData.value!.toJsonString(),
                      ]);
                      final String ext=p.extension(imageController.filePath.value);
                      final filePath=p.join(supportDir.path, "temp_image", "${timestamp.toString()}$ext");
                      try {
                        await Gal.putImage(filePath);
                        if(context.mounted){
                          warnDialog(context, "saveSuccess".tr, "saveSuccessTip".tr);
                        }
                      } catch (_) {
                        if(context.mounted){
                          warnDialog(context, "saveFail".tr, "saveFailTip".tr);
                        }
                      }
                      setState(() {
                        saveLoad=false;
                      });
                    }, 
                    child: saveLoad ? SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      )
                    ) : Text('saveImage'.tr)
                  )
                ],
              )
            ],
          )
        )
      ),
    );
  }
}