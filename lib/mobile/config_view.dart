import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/functions/dialog_func.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigView extends StatefulWidget {
  const ConfigView({super.key});

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {

  final imageController=Get.find<ImageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0.0,
        title: Text('config'.tr),
      ),
      body: Obx(
        ()=> Column(
          children: [
            Expanded(
              child: Center(
                child: imageController.load.value ? CircularProgressIndicator() : Image.memory(
                  imageController.item.value!.raw,
                  fit: BoxFit.contain,
                  gaplessPlayback: false,
                  cacheHeight: 800,
                ),
                ),
              ),
            Column(
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
                  onTap: (){
                    imageController.showExposureTime.value=!imageController.showExposureTime.value;
                    imageController.reloadImage();
                  },
                  trailing: Switch(
                    value: imageController.showExposureTime.value,
                    onChanged: (value) {
                      imageController.showExposureTime.value=!imageController.showExposureTime.value;
                      imageController.reloadImage();
                    },
                  ),
                ),
                ListTile(
                  title: Text("fNumber".tr),
                  onTap: (){
                    imageController.showF.value=!imageController.showF.value;
                    imageController.reloadImage();
                  },
                  trailing: Switch(
                    value: imageController.showF.value,
                    onChanged: (value) {
                      imageController.showF.value=!imageController.showF.value;
                      imageController.reloadImage();
                    },
                  ),
                ),
                ListTile(
                  title: Text("ISO"),
                  onTap: (){
                    imageController.showISO.value=!imageController.showISO.value;
                    imageController.reloadImage();
                  },
                  trailing: Switch(
                    value: imageController.showISO.value,
                    onChanged: (value) {
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
                        onPressed: (){
            
                        }, 
                        child: Text('saveImage'.tr)
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}