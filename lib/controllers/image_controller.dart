import 'dart:ffi';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ffi/ffi.dart';

typedef ImageSave = Void Function(Pointer<Utf8>, Pointer<Utf8>, Int);
typedef ImageSaveDart = void Function(Pointer<Utf8>, Pointer<Utf8>, int);
typedef GetEXIF = Pointer<Utf8> Function(Pointer<Utf8>);
typedef ImagePreview = Pointer<Uint8> Function(Pointer<Utf8>, Pointer<Int32>, Int);
typedef ImagePreviewDart = Pointer<Uint8> Function(Pointer<Utf8>, Pointer<Int32>, int);
typedef FreeMemory = Void Function(Pointer<Void> ptr);
typedef FreeMemoryDart = void Function(Pointer<Void> ptr);

class ImageController extends GetxController {
  Rx<ImageItem?> item=Rx<ImageItem?>(null);
  late ImageSaveDart imageSave;
  late GetEXIF getEXIF;

  RxBool load=false.obs;

  ImageController(){
    final dylib = DynamicLibrary.open(Platform.isWindows ? "image.dll" :"image.dylib");
    imageSave=dylib
    .lookup<NativeFunction<ImageSave>>("ImageSave")
    .asFunction();
    getEXIF=dylib
    .lookup<NativeFunction<GetEXIF>>("GetEXIF")
    .asFunction();
  }

  // params: [path, showLogo(0,1)]
  static Uint8List? previewImageHandler(List params){
    final outLenPtr = malloc<Int32>();
    final dylib = DynamicLibrary.open(Platform.isWindows ? "image.dll" :"image.dylib");
    ImagePreviewDart imagePreview=dylib
    .lookup<NativeFunction<ImagePreview>>("ImagePreview")
    .asFunction();
    FreeMemoryDart freeMemory=dylib
    .lookup<NativeFunction<FreeMemory>>("FreeMemory")
    .asFunction();

    final dataPtr = imagePreview(params[0], outLenPtr, params[1]);
    final length = outLenPtr.value;

    malloc.free(params[0]);
    malloc.free(outLenPtr);

    if (dataPtr == nullptr || length == 0) return null;
    freeMemory(dataPtr.cast());
    final dataCopy = Uint8List.fromList(dataPtr.asTypedList(length));
    return dataCopy;
  }

  Future<Uint8List?> convertImage(String path) async {
    load.value=true;
    final pathPtr = path.toNativeUtf8();
    Uint8List? data= await compute(previewImageHandler, [pathPtr, showLogo.value?1:0]);
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