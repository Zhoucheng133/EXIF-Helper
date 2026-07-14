import 'package:exif_helper/components/config_item.dart';
import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/controllers/theme_controller.dart';
import 'package:exif_helper/functions/cals.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void warnDialog(BuildContext context, String title, String content){
  showDialog(
    context: context, 
    builder: (context)=>AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        ElevatedButton(
          onPressed: ()=>Navigator.pop(context), 
          child: Text("ok".tr)
        )
      ],
    )
  );
}

Future<void> showAbout(BuildContext context) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final version=packageInfo.version;
  if(context.mounted){
    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: Text('about'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 10,),
            Text(
              'EXIF Helper',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 3,),
            Text(
              "v$version",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[400]
              ),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse('https://github.com/Zhoucheng133/EXIF-Helper');
                await launchUrl(url);
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.github,
                      size: 15,
                    ),
                    const SizedBox(width: 5,),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        'prjLink'.tr,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () => showLicensePage(
                applicationName: 'EXIF Helper',
                applicationVersion: 'v$version',
                context: context
              ),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.certificate,
                      size: 15,
                    ),
                    const SizedBox(width: 5,),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        'license'.tr,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text('ok'.tr)
          )
        ],
      ),
    );
  }
}

Future<void> showLanguageDialog(BuildContext context) async {
  final controller = Get.find<ThemeController>();
  await showDialog(
    context: context, 
    builder: (context)=>AlertDialog(
      title: Text('language'.tr),
      content: Obx(
        ()=>DropdownButtonHideUnderline(
          child: DropdownButton(
            focusColor: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            value: controller.lang.value.name,
            items: supportedLocales.map((item)=>DropdownMenuItem<String>(
              value: item.name,
              child: Text(
                item.name
              ),
            )).toList(),
            onChanged: (val){
              final index=supportedLocales.indexWhere((element) => element.name==val);
              controller.changeLanguage(index);
            },
          ),
        )
      ),
      actions: [
        ElevatedButton(
          onPressed: ()=>Navigator.of(context).pop(), 
          child: Text("ok".tr)
        )
      ],
    ),
  );
}

void showImageInfo(BuildContext context, ImageItem item){
  showDialog(
    context: context, 
    builder: (context)=>AlertDialog(
      title: Text('photoInfo'.tr),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConfigItem(keyWord: "camMake".tr, value: item.make, enable: true),
          ConfigItem(keyWord: "camModel".tr, value: item.model, enable: true),
          if(item.lenModel.isNotEmpty) ConfigItem(keyWord: "lenModel".tr, value: item.lenModel, enable: true),
          ConfigItem(keyWord: "forcal".tr, value: "${item.forcal}mm", enable: true),
          ConfigItem(keyWord: "fNumber".tr, value: calFnum(item.fNum), enable: true),
          ConfigItem(keyWord: "exposureTime".tr, value: "${item.exposureTime}s", enable: true),
          ConfigItem(keyWord: "ISO", value: item.iso, enable: true),
          ConfigItem(keyWord: "captureTime".tr, value: calDatatime(item.dateTime), enable: true),
        ]
      ),
      actions: [
        ElevatedButton(
          onPressed: ()=>Navigator.of(context).pop(), 
          child: Text("ok".tr)
        )
      ],
    )
  );
}