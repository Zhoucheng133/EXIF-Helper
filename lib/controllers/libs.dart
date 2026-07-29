import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:exif_helper/controllers/types.dart';
import 'package:ffi/ffi.dart';

DynamicLibrary getDylib(){
  // TODO 注意修改Android动态库名
  return Platform.isIOS ? DynamicLibrary.process() : DynamicLibrary.open(Platform.isWindows ? "image.dll" : Platform.isMacOS ? "image.dylib" : "image.so");
}

void freeMemory(Pointer<Utf8> pointer){
  final dylib = getDylib();
  FreeMemoryDart freeMemory=dylib
  .lookup<NativeFunction<FreeMemory>>("FreeMemory")
  .asFunction();
  freeMemory(pointer.cast());
}

// params: [filePath, showLogo(0,1), showF(0,1), showExposureTime(0,1), showISO(0,1)]
Uint8List? previewImageHandler(List params) {
  final outLenPtr = malloc<Int32>();
  final dylib = getDylib();
  ImagePreviewDart imagePreview = dylib
  .lookup<NativeFunction<ImagePreview>>("ImagePreview")
  .asFunction();

  final pathPtr = params[0].toNativeUtf8();
  final dataPtr = imagePreview(pathPtr, outLenPtr, params[1], params[2], params[3], params[4]);
  final length = outLenPtr.value;

  malloc.free(pathPtr);
  malloc.free(outLenPtr);

  if (dataPtr == nullptr || length == 0) return null;
  final dataCopy = Uint8List.fromList(dataPtr.asTypedList(length));
  freeMemory(dataPtr.cast());
  return dataCopy;
}
// params: [filePath, outputPath, showLogo(0,1), showF(0,1), showExposureTime(0,1), showISO(0,1)]
void saveImageHanlder(List params) {
  final dylib = getDylib();
  ImageSaveDart imageSave = dylib
  .lookup<NativeFunction<ImageSave>>("ImageSave")
  .asFunction();

  final inputPathPtr = params[0].toNativeUtf8();
  final outputPathPtr = params[1].toNativeUtf8();

  imageSave(inputPathPtr, outputPathPtr, params[2], params[3], params[4], params[5]);

  malloc.free(inputPathPtr);
  malloc.free(outputPathPtr);
}
// params: [path]
EXIFData getEXIFData(List params) {
  final dylib = getDylib();
  GetEXIFDart getEXIF=dylib
  .lookup<NativeFunction<GetEXIF>>("GetEXIF")
  .asFunction();
  final pathPtr = params[0].toNativeUtf8();
  final resultPtr = getEXIF(pathPtr);
  final result = resultPtr.toDartString();
  malloc.free(pathPtr);
  return EXIFData.fromJson(jsonDecode(result));
}

// params: [inputPath, outputPath]
void removeExif(List params) {
  final dylib = getDylib();
  RemoveExifDart removeExif=dylib
  .lookup<NativeFunction<RemoveExif>>("RemoveExif")
  .asFunction();
  final inputPathPtr = params[0].toNativeUtf8();
  final outputPathPtr = params[1].toNativeUtf8();
  removeExif(inputPathPtr, outputPathPtr);
  malloc.free(inputPathPtr);
  malloc.free(outputPathPtr);
}

 // params: [inputPath, outputPath, exif]
 void editExif(List params) {
  final dylib = getDylib();
  EditEXIFDart editExif=dylib
  .lookup<NativeFunction<EditEXIF>>("EditEXIF")
  .asFunction();
  final inputPathPtr = params[0].toNativeUtf8();
  final outputPathPtr = params[1].toNativeUtf8();
  final exifPtr = params[2].toNativeUtf8();
  editExif(inputPathPtr, outputPathPtr, exifPtr);
  malloc.free(inputPathPtr);
  malloc.free(outputPathPtr);
  malloc.free(exifPtr);
}