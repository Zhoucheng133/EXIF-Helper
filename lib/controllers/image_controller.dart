import 'dart:ffi';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:ffi/ffi.dart';

typedef SavePhoto = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);

class ImageController extends GetxController {
  Rx<ImageItem?> item=Rx<ImageItem?>(null);

  RxBool loading=false.obs;
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

  // 处理中
  late bool loading;

  late SavePhoto savePhoto;

  ImageItem(this.raw, this.filePath, this.make, this.model, this.dateTime, this.exposureTime, this.fNum, this.iso, this.forcal, this.forcal35, this.lenMake, this.lenModel){
    final dylib = DynamicLibrary.open("image.dylib");
    savePhoto=dylib
    .lookup<NativeFunction<SavePhoto>>("SavePhoto")
    .asFunction();
  }
}