import 'package:exif_helper/controllers/libs.dart';
import 'package:exif_helper/controllers/types.dart';
import 'package:exif_helper/functions/dialog_func.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageController extends GetxController {

  late Uint8List previewImage;
  Rx<EXIFData?> exifData = (null as EXIFData?).obs;
  RxBool loading = false.obs;
  RxString filePath = "".obs;

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
    loading.value = false;
    return true;
  }

}