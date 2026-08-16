import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';

// func ImageSave(path *C.char, output *C.char, options *C.char)
typedef ImageSave = Void Function(Pointer<Utf8> path, Pointer<Utf8> output, Pointer<Utf8> options);
typedef ImageSaveDart = void Function(Pointer<Utf8> path, Pointer<Utf8> output, Pointer<Utf8> options);

// func GetEXIF(path *C.char) *C.char
typedef GetEXIF = Pointer<Utf8> Function(Pointer<Utf8> path);
typedef GetEXIFDart = Pointer<Utf8> Function(Pointer<Utf8> path);

// func ImagePreview(path *C.char, outLength *C.int, options *C.char)
typedef ImagePreview = Pointer<Uint8> Function(Pointer<Utf8> path, Pointer<Int32> outLength, Pointer<Utf8> options);
typedef ImagePreviewDart = Pointer<Uint8> Function(Pointer<Utf8> path, Pointer<Int32> outLength, Pointer<Utf8> options);

// func FreeMemory(ptr unsafe.Pointer)
typedef FreeMemory = Void Function(Pointer<Void> ptr);
typedef FreeMemoryDart = void Function(Pointer<Void> ptr);

// func RemoveExif(inputPath *C.char, output *C.char)
typedef RemoveExif = Void Function(Pointer<Utf8> inputPath, Pointer<Utf8> output);
typedef RemoveExifDart = void Function(Pointer<Utf8> inputPath, Pointer<Utf8> output);

// func EditEXIF(inputPath *C.char, output *C.char, exif *C.char)
typedef EditEXIF = Void Function(Pointer<Utf8> inputPath, Pointer<Utf8> output, Pointer<Utf8> exif);
typedef EditEXIFDart = void Function(Pointer<Utf8> inputPath, Pointer<Utf8> output, Pointer<Utf8> exif);

// type EXIFInfo struct {
// 	CamMake      string `json:"camMake"`
// 	CamModel     string `json:"camModel"`
// 	LenMake      string `json:"lenMake"`
// 	LenModel     string `json:"lenModel"`
// 	CaptureTime  string `json:"captureTime"`
// 	ExposureTime string `json:"exposureTime"`
// 	Fnum         string `json:"fNum"`
// 	Iso          string `json:"iso"`
// 	Focal        string `json:"focal"`
// 	Focal35      string `json:"focal35"`
// 	Orientation  string `json:"orientation"`
// }

class EXIFData{
  String camMake;
  String camModel;
  String lenMake;
  String lenModel;
  String captureTime;
  String exposureTime;
  String fNum;
  String iso;
  String focal;
  String focal35;
  String orientation;
  EXIFData({
    required this.camMake, 
    required this.camModel, 
    required this.lenMake, 
    required this.lenModel, 
    required this.captureTime, 
    required this.exposureTime, 
    required this.fNum, 
    required this.iso, 
    required this.focal, 
    required this.focal35, 
    required this.orientation
  });

  factory EXIFData.fromJson(Map<String, dynamic> json) {
    if(json.isEmpty || 
      (json['camMake'] as String).isEmpty || 
      (json['camModel'] as String).isEmpty ||
      (json['focal'] as String).isEmpty ||
      (json['fNum'] as String).isEmpty ||
      (json['exposureTime'] as String).isEmpty ||
      (json['iso'] as String).isEmpty ||
      (json['captureTime'] as String).isEmpty
    ){
      throw ArgumentError('No EXIF data found');
    }
    return EXIFData(
      camMake: json["camMake"].replaceAll("\"", ""), 
      camModel: json["camModel"].replaceAll("\"", ""), 
      captureTime: json["captureTime"].replaceAll("\"", ""), 
      exposureTime: json["exposureTime"].replaceAll("\"", ""), 
      fNum: json["fNum"].replaceAll("\"", ""), 
      iso: json["iso"].replaceAll("\"", ""), 
      focal: json["focal"].replaceAll("\"", ""), 
      focal35: json["focal35"].replaceAll("\"", ""), 
      lenMake: json["lenMake"].replaceAll("\"", ""), 
      lenModel: json["lenModel"].replaceAll("\"", ""), 
      orientation: json["orientation"]
    );
  }

  String toJsonString(){
    return jsonEncode({
      "camMake": camMake, 
      "camModel": camModel, 
      "lenMake": lenMake, 
      "lenModel": lenModel, 
      "captureTime": captureTime, 
      "exposureTime": exposureTime, 
      "fNum": fNum, 
      "iso": iso, 
      "focal": focal, 
      "focal35": focal35,
      "orientation": orientation
    });
  }
}

class ImageOptions {
  final bool showLogo;
  final bool showF;
  final bool showExposureTime;
  final bool showISO;
  final bool showFocal;
  final bool showLenModel;

  const ImageOptions({
    required this.showLogo,
    required this.showF,
    required this.showExposureTime,
    required this.showISO, 
    required this.showFocal, 
    required this.showLenModel,
  });

  String toJsonString() => jsonEncode({
    'showLogo': showLogo,
    'showF': showF,
    'showExposureTime': showExposureTime,
    'showISO': showISO,
    'showFocal': showFocal,
    'showLenModel': showLenModel,
  });
}