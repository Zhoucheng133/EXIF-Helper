import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/functions/dialog_func.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ConfigView extends StatefulWidget {
  const ConfigView({super.key});

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {

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
            title: Text('config'.tr),
          ),
          body: Obx(
            ()=> Column(
              children: [
                Expanded(
                  child: imageController.load.value ? Center(
                    child: CircularProgressIndicator()
                  ) : InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: SizedBox.expand(
                      child: Image.memory(
                        imageController.item.value!.raw,
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
                      ListTile(
                        title: Text("showBrandLogo".tr),
                        onTap: (){
                          imageController.showLogo.value=!imageController.showLogo.value;
                          imageController.reloadImage();
                        },
                        trailing: Switch(
                          value: imageController.showLogo.value,
                          onChanged: (value) {
                            imageController.showLogo.value=!imageController.showLogo.value;
                            imageController.reloadImage();
                          },
                        ),
                      ),
                      ListTile(
                        title: Text("exposureTime".tr),
                        onTap: !imageController.showF.value && !imageController.showISO.value ? null :(){
                          imageController.showExposureTime.value=!imageController.showExposureTime.value;
                          imageController.reloadImage();
                        },
                        trailing: Switch(
                          value: imageController.showExposureTime.value,
                          onChanged: !imageController.showF.value && !imageController.showISO.value ? null : (value) {
                            imageController.showExposureTime.value=!imageController.showExposureTime.value;
                            imageController.reloadImage();
                          },
                        ),
                      ),
                      ListTile(
                        title: Text("fNumber".tr),
                        onTap: !imageController.showExposureTime.value && !imageController.showISO.value ? null : (){
                          imageController.showF.value=!imageController.showF.value;
                          imageController.reloadImage();
                        },
                        trailing: Switch(
                          value: imageController.showF.value,
                          onChanged: !imageController.showExposureTime.value && !imageController.showISO.value ? null : (value) {
                            imageController.showF.value=!imageController.showF.value;
                            imageController.reloadImage();
                          },
                        ),
                      ),
                      ListTile(
                        title: Text("ISO"),
                        onTap: !imageController.showExposureTime.value && !imageController.showF.value ? null : (){
                          imageController.showISO.value=!imageController.showISO.value;
                          imageController.reloadImage();
                        },
                        trailing: Switch(
                          value: imageController.showISO.value,
                          onChanged: !imageController.showExposureTime.value && !imageController.showF.value ? null : (value) {
                            imageController.showISO.value=!imageController.showISO.value;
                            imageController.reloadImage();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                        child: Row(
                          crossAxisAlignment: .center,
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            TextButton(
                              onPressed: ()=>showImageInfo(context, imageController.item.value!), 
                              child: Text('photoInfo'.tr)
                            ),
                            FilledButton(
                              onPressed: saveLoad ? null : () async {
                                setState(() {
                                  saveLoad=true;
                                });
                                int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
                                final supportDir=await getApplicationDocumentsDirectory();
                                await imageController.save(
                                  p.join(supportDir.path, "temp_image"),
                                  name: timestamp.toString(),
                                );
                                final String ext=p.extension(imageController.item.value!.filePath);
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