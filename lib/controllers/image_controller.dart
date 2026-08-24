import 'package:exif_helper/controllers/libs.dart';
import 'package:exif_helper/controllers/types.dart';
import 'package:exif_helper/functions/dialog_func.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

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
  RxBool showFocal = true.obs;
  RxBool showLenModel = true.obs;

  Future<bool> fileChecker(BuildContext context,String filePath) async {
    loading.value = true;
    if(p.extension(filePath).toLowerCase()=='.heic' || p.extension(filePath).toLowerCase()=='.heif'){
      heifDialog(context);
      loading.value=false;
      return false;
    }
    if(filePath.toLowerCase().endsWith(".jpg") || filePath.toLowerCase().endsWith(".jpeg")){
      final data = await compute(getEXIFData, [filePath]);
      if(data == null){
        if(context.mounted){
          warnDialog(context, "importErr".tr, "noExif".tr);
        }
        loading.value = false;
        return false;
      }
      exifData.value = data;
    }else{
      if(context.mounted){
        warnDialog(context, "importErr".tr, "unsupportFormat".tr);
      }
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
      [filePath.value, imageOptions.toJsonString()]
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

  ImageOptions get imageOptions {
    final hasLenModel = exifData.value?.lenModel.trim().isNotEmpty ?? false;

    return ImageOptions(
      showLogo: showLogo.value,
      showF: showF.value,
      showExposureTime: showExposureTime.value,
      showISO: showISO.value,
      showFocal: hasLenModel ? showFocal.value : true,
      showLenModel: hasLenModel ? showLenModel.value : false,
    );
  }

}
