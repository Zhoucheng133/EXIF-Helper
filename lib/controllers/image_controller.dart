import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:ffi/ffi.dart';

typedef ImageSave = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);
typedef GetEXIF = Pointer<Utf8> Function(Pointer<Utf8>);
typedef ImagePreview = Pointer<Uint8> Function(Pointer<Utf8> path, Pointer<Int32> outLength);
typedef FreeMemory = Void Function(Pointer<Void> ptr);
typedef FreeMemoryDart = void Function(Pointer<Void> ptr);

class ImageController extends GetxController {
  Rx<ImageItem?> item=Rx<ImageItem?>(null);
  late ImageSave imageSave;
  late ImagePreview imagePreview;
  late FreeMemoryDart freeMemory;
  late GetEXIF getEXIF;

  ImageController(){
    final dylib = DynamicLibrary.open(Platform.isWindows ? "image.dll" :"image.dylib");
    imageSave=dylib
    .lookup<NativeFunction<ImageSave>>("ImageSave")
    .asFunction();
    imagePreview=dylib
    .lookup<NativeFunction<ImagePreview>>("ImagePreview")
    .asFunction();
    freeMemory=dylib
    .lookup<NativeFunction<FreeMemory>>("FreeMemory")
    .asFunction();
    getEXIF=dylib
    .lookup<NativeFunction<GetEXIF>>("GetEXIF")
    .asFunction();
  }

  Uint8List? convertImage(String path){
    final pathPtr = path.toNativeUtf8();
    final outLenPtr = malloc<Int32>();
    final dataPtr = imagePreview(pathPtr, outLenPtr);
    final length = outLenPtr.value;

    malloc.free(pathPtr);
    malloc.free(outLenPtr);

    if (dataPtr == nullptr || length == 0) return null;

    final dataCopy = Uint8List.fromList(dataPtr.asTypedList(length));
    freeMemory(dataPtr.cast());
    return dataCopy;

    // final dataList = dataPtr.asTypedList(length);
    // freeMemory(dataPtr.cast());
    // return Uint8List.fromList(dataList);

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