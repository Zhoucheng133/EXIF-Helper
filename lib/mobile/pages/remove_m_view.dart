import 'dart:io';

import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/controllers/libs.dart';
import 'package:exif_helper/functions/dialog_func.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';


class RemoveMView extends StatefulWidget {
  const RemoveMView({super.key});

  @override
  State<RemoveMView> createState() => _RemoveMViewState();
}

class _RemoveMViewState extends State<RemoveMView> {
  final imageController=Get.find<ImageController>();

  bool saveLoad=false;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;
        return Scaffold(
          appBar: isLandscape ? null :  AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            scrolledUnderElevation: 0.0,
            title: Text('removeExif'.tr),
          ),
          body: Obx(
            ()=> Column(
              children: [
                Expanded(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: SizedBox.expand(
                      child: Image.file(
                        File(imageController.filePath.value),
                        fit: BoxFit.contain,
                        gaplessPlayback: false,
                        cacheHeight: 800,
                      ),
                    ),
                  )
                ),
                if (!isLandscape) Padding(
                  padding: .only(bottom: MediaQuery.of(context).padding.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                        child: Row(
                          crossAxisAlignment: .center,
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            TextButton(
                              onPressed: (){
                                showImageInfo(context, imageController.exifData.value!);
                              }, 
                              child: Text('photoInfo'.tr)
                            ),
                            FilledButton(
                              onPressed: saveLoad ? null : () async {
                                setState(() {
                                  saveLoad=true;
                                });
                                int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
                                final supportDir=await getApplicationDocumentsDirectory();
                                await compute(
                                  removeExif, 
                                  [imageController.filePath.value, p.join(supportDir.path, "temp_image", "${timestamp.toString()}.jpg")]
                                );
                                final String ext=p.extension(imageController.filePath.value);
                                final filePath=p.join(supportDir.path, "temp_image", "${timestamp.toString()}$ext");
                                try {
                                  await Gal.putImage(filePath);
                                  if(context.mounted){
                                    warnDialog(context, "saveSuccess".tr, "saveSuccessTip".tr);
                                  }
                                } catch (_) {
                                  if(context.mounted){
                                    warnDialog(context, "saveFail".tr, "saveFailTip".tr);
                                  }
                                }
                                setState(() {
                                  saveLoad=false;
                                });
                              }, 
                              child: saveLoad ? SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                )
                              ) : Text('saveImage'.tr)
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}