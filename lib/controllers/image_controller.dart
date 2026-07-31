import 'package:exif_helper/controllers/libs.dart';
import 'package:exif_helper/controllers/types.dart';
import 'package:exif_helper/functions/dialog_func.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageController extends GetxController {

  Rx<Uint8List?> previewImage = (null as Uint8List?).obs;
  Rx<EXIFData?> exifData = (null as EXIFData?).obs;

  RxBool loading = false.obs;
  RxBool previewLoad = false.obs;

  RxString filePath = "".obs;

  RxBool showLogo = true.obs;
  RxBool showF = true.obs;
  RxBool showExposureTime = true.obs;
  RxBool showISO = true.obs;

  Future<bool> fileChecker(BuildContext context,String filePath) async {
    loading.value = true;
    if(filePath.toLowerCase().endsWith(".jpg") || filePath.toLowerCase().endsWith(".jpeg")){
      exifData.value = await compute(getEXIFData, [filePath]);
      if(exifData.value == null && context.mounted){
        warnDialog(context, "importErr".tr, "noExif".tr);
        return false;
      }
    }else{
      warnDialog(context, "importErr".tr, "unsupportFormat".tr);
      loading.value = false;
      return false;
    }
    this.filePath.value=filePath;
    return true;
  }

  Future<void> loadPreviewImage() async {
    previewLoad.value = true;
    previewImage.value = await compute(
      previewImageHandler, 
      [filePath.value, showLogo.value ? 1:0, showF.value ? 1:0, showExposureTime.value ? 1:0, showISO.value ? 1:0]
    );
    previewLoad.value = false;
  }

  bool checkExif(BuildContext context){
    if(exifData.value==null){
      return false;
    }

    if(exifData.value!.camMake.isEmpty || exifData.value!.camModel.isEmpty || exifData.value!.lenModel.isEmpty || exifData.value!.captureTime.isEmpty || exifData.value!.exposureTime.isEmpty || exifData.value!.fNum.isEmpty || exifData.value!.iso.isEmpty || exifData.value!.focal.isEmpty){
      warnDialog(context, "saveFail".tr, "exifIncomplete".tr);
      return false;
    }
    return true;
  }

}