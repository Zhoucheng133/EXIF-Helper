import 'dart:typed_data';

import 'package:exif_helper/controllers/types.dart';
import 'package:get/get.dart';

class ImageController extends GetxController {

  late Uint8List previewImage;
  Rx<EXIFData?> exifData = (null as EXIFData?).obs;

}