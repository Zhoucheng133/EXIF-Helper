import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:exif_helper/functions/dialog_func.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as p;

// func ImageSave(path *C.char, output *C.char, showLogo C.int, showF C.int, showExposureTime C.int, showISO C.int)
typedef ImageSave = Void Function(Pointer<Utf8> path, Pointer<Utf8> output, Int showLogo, Int showF, Int showExposureTime, Int showISO);
typedef ImageSaveDart = void Function(Pointer<Utf8> path, Pointer<Utf8> output, int showLogo, int showF, int showExposureTime, int showISO);

typedef GetEXIF = Pointer<Utf8> Function(Pointer<Utf8>);
// func ImagePreview(path *C.char, outLength *C.int, showLogo C.int, showF C.int, showExposureTime C.int, showISO C.int)
typedef ImagePreview = Pointer<Uint8> Function(Pointer<Utf8> path, Pointer<Int32> outLength, Int showLogo, Int showF, Int showExposureTime, Int showISO);
typedef ImagePreviewDart = Pointer<Uint8> Function(Pointer<Utf8> path, Pointer<Int32> outLength, int showLogo, int showF, int showExposureTime, int showISO);

typedef FreeMemory = Void Function(Pointer<Void> ptr);
typedef FreeMemoryDart = void Function(Pointer<Void> ptr);

class ImageController extends GetxController {
  Rx<ImageItem?> item=Rx<ImageItem?>(null);
  // late ImageSaveDart imageSave;
  late GetEXIF getEXIF;
  late FreeMemoryDart freeMemory;

  RxBool load=false.obs;

  bool jsonChecker(Map json) {
    return json.entries.every((entry) {
      if (entry.key == "lenMake" || entry.key == "lenModel" || entry.key =="orientation" || entry.key=="focal35") return true;

      final val = entry.value;
      if (val == null) return false;
      if (val is String) return val.trim().isNotEmpty;
      if (val is Iterable || val is Map) return val.isNotEmpty;
      
      return true;
    });
  }

  Future<bool> fileChecker(BuildContext context,String filePath) async {
    if(filePath.toLowerCase().endsWith(".jpg") || filePath.toLowerCase().endsWith(".jpeg")){
      
      final exifString=getEXIFString(filePath);
      if(exifString.isEmpty){
        warnDialog(context, "importErr".tr, "noExif".tr);
        return false;
      }
      final exifJson=jsonDecode(exifString);

      if(!jsonChecker(exifJson)){
        warnDialog(context, "importErr".tr, "noExif".tr);
        return false;
      }

      item.value=ImageItem(
        await convertImage(filePath) ?? Uint8List(0), 
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
      return false;
    }
    return true;
  }

  ImageController(){
    final dylib = Platform.isIOS ? DynamicLibrary.process() : DynamicLibrary.open(Platform.isWindows ? "image.dll" : Platform.isMacOS ? "image.dylib" : "libcore.so");
    getEXIF=dylib
    .lookup<NativeFunction<GetEXIF>>("GetEXIF")
    .asFunction();
    freeMemory=dylib
    .lookup<NativeFunction<FreeMemory>>("FreeMemory")
    .asFunction();
  }

  String getEXIFString(String path) {
    final pathPtr = path.toNativeUtf8();
    final resultPtr = getEXIF(pathPtr);
    malloc.free(pathPtr);
    final result = resultPtr.toDartString();
    freeMemory(resultPtr.cast());
    return result;
  }

  // params: [path, showLogo(0,1)]
  static Uint8List? previewImageHandler(List params){
    final outLenPtr = malloc<Int32>();
    final dylib = Platform.isIOS ? DynamicLibrary.process() : DynamicLibrary.open(Platform.isWindows ? "image.dll" : Platform.isMacOS ? "image.dylib" : "libcore.so");
    ImagePreviewDart imagePreview=dylib
    .lookup<NativeFunction<ImagePreview>>("ImagePreview")
    .asFunction();
    FreeMemoryDart freeMemory=dylib
    .lookup<NativeFunction<FreeMemory>>("FreeMemory")
    .asFunction();

    final dataPtr = imagePreview(params[0], outLenPtr, params[1], params[2], params[3], params[4]);
    final length = outLenPtr.value;

    malloc.free(params[0]);
    malloc.free(outLenPtr);

    if (dataPtr == nullptr || length == 0) return null;
    final dataCopy = Uint8List.fromList(dataPtr.asTypedList(length));
    freeMemory(dataPtr.cast());
    return dataCopy;
  }

  // params: [filePath, outputPath, showLogo(0,1), showF(0,1), showExposureTime(0,1), showISO(0,1)]
  static saveImageHanlder(List params){
    final dylib = Platform.isIOS ? DynamicLibrary.process() : DynamicLibrary.open(Platform.isWindows ? "image.dll" : Platform.isMacOS ? "image.dylib" : "libcore.so");
    ImageSaveDart imageSave=dylib
    .lookup<NativeFunction<ImageSave>>("ImageSave")
    .asFunction();
    imageSave(params[0], params[1], params[2], params[3], params[4], params[5]);
    malloc.free(params[0]);
    malloc.free(params[1]);
  }

  Future<Uint8List?> convertImage(String path) async {
    load.value=true;
    final pathPtr = path.toNativeUtf8();
    Uint8List? data= await compute(previewImageHandler, [pathPtr, showLogo.value?1:0, showF.value?1:0, showExposureTime.value?1:0, showISO.value?1:0]);
    load.value=false;
    return data;
  }

  Future<void> reloadImage() async {
    load.value=true;
    item.value?.raw=await convertImage(item.value!.filePath) ?? Uint8List(0);
    item.refresh();
    load.value=false;
  }

  RxBool showLogo=true.obs;
  RxBool showF=true.obs;
  RxBool showExposureTime=true.obs;
  RxBool showISO=true.obs;

  Future<void> save(String output, {String? name}) async {
    final String newName=name ?? "${p.basenameWithoutExtension(item.value!.filePath)}_output";
    final String ext=p.extension(item.value!.filePath);
    final String outputPath=p.join(output, "$newName.$ext");
    final filePathPtr=item.value!.filePath.toNativeUtf8();
    final outputPathPtr=outputPath.toNativeUtf8();
    await compute(
      saveImageHanlder, 
      [filePathPtr, outputPathPtr, showLogo.value?1:0, showF.value?1:0, showExposureTime.value?1:0, showISO.value?1:0]
    );
  }
}

class ImageItem{

  // 图片数据
  late Uint8List raw;
  // 文件路径
  late String filePath;

  // 相机制造商
  late String make;
  // 相机型号
  late String model;
  // 拍摄日期
  late String dateTime;
  // 曝光时间
  late String exposureTime;
  // 光圈
  late String fNum;
  // ISO
  late String iso;
  // 焦距
  late String forcal;
  // 35mm焦距
  late String forcal35;
  // 镜头制造商
  late String lenMake;
  // 镜头型号
  late String lenModel;

  ImageItem(this.raw, this.filePath, this.make, this.model, this.dateTime, this.exposureTime, this.fNum, this.iso, this.forcal, this.forcal35, this.lenMake, this.lenModel);
}