import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:exif_helper/controllers/types.dart';
import 'package:ffi/ffi.dart';

DynamicLibrary getDylib(){
  return Platform.isIOS ? DynamicLibrary.process() : DynamicLibrary.open(Platform.isWindows ? "image.dll" : Platform.isMacOS ? "image.dylib" : "image.so");
}

void freeMemory(Pointer<Utf8> pointer){
  final dylib = getDylib();
  FreeMemoryDart freeMemory=dylib
  .lookup<NativeFunction<FreeMemory>>("FreeMemory")
  .asFunction();
  freeMemory(pointer.cast());
}

// params: [filePath, optionsJson]
Uint8List? previewImageHandler(List params) {
  final outLenPtr = malloc<Int32>();
  final dylib = getDylib();
  ImagePreviewDart imagePreview = dylib
  .lookup<NativeFunction<ImagePreview>>("ImagePreview")
  .asFunction();

  final pathPtr = (params[0] as String).toNativeUtf8();
  final optionsPtr = (params[1] as String).toNativeUtf8();
  final dataPtr = imagePreview(pathPtr, outLenPtr, optionsPtr);
  final length = outLenPtr.value;

  malloc.free(pathPtr);
  malloc.free(optionsPtr);
  malloc.free(outLenPtr);

  if (dataPtr == nullptr || length == 0) return null;
  final dataCopy = Uint8List.fromList(dataPtr.asTypedList(length));
  freeMemory(dataPtr.cast());
  return dataCopy;
}
// params: [filePath, outputPath, optionsJson]
void saveImageHanlder(List params) {
  final dylib = getDylib();
  ImageSaveDart imageSave = dylib
  .lookup<NativeFunction<ImageSave>>("ImageSave")
  .asFunction();

  final inputPathPtr = (params[0] as String).toNativeUtf8();
  final outputPathPtr = (params[1] as String).toNativeUtf8();
  final optionsPtr = (params[2] as String).toNativeUtf8();

  imageSave(inputPathPtr, outputPathPtr, optionsPtr);

  malloc.free(inputPathPtr);
  malloc.free(outputPathPtr);
  malloc.free(optionsPtr);
}
// params: [path]
EXIFData? getEXIFData(List params) {
  final dylib = getDylib();
  GetEXIFDart getEXIF=dylib
  .lookup<NativeFunction<GetEXIF>>("GetEXIF")
  .asFunction();
  final pathPtr = (params[0] as String).toNativeUtf8();
  final resultPtr = getEXIF(pathPtr);
  final result = resultPtr.toDartString();
  malloc.free(pathPtr);
  freeMemory(resultPtr.cast());
  try {
    return EXIFData.fromJson(jsonDecode(result));
  } catch (_) {
    return null;
  }
}

// params: [inputPath, outputPath]
void removeExif(List params) {
  final dylib = getDylib();
  RemoveExifDart removeExif=dylib
  .lookup<NativeFunction<RemoveExif>>("RemoveExif")
  .asFunction();
  final inputPathPtr = (params[0] as String).toNativeUtf8();
  final outputPathPtr = (params[1] as String).toNativeUtf8();
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
  final inputPathPtr = (params[0] as String).toNativeUtf8();
  final outputPathPtr = (params[1] as String).toNativeUtf8();
  final exifPtr = (params[2] as String).toNativeUtf8();
  editExif(inputPathPtr, outputPathPtr, exifPtr);
  malloc.free(inputPathPtr);
  malloc.free(outputPathPtr);
  malloc.free(exifPtr);
}