import 'package:exif_helper/components/homebuttons/home_button_item.dart';
import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/functions/cals.dart';
import 'package:exif_helper/mobile/pages/edit_m_view.dart';
import 'package:exif_helper/mobile/pages/mark_m_view.dart';
import 'package:exif_helper/mobile/pages/remove_m_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeButtons extends StatefulWidget {
  const HomeButtons({super.key});

  @override
  State<HomeButtons> createState() => _HomeButtonsState();
}

class _HomeButtonsState extends State<HomeButtons> {

  final ImageController imageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      mainAxisSize: .min,
      children: [
        Row(
          spacing: 10,
          mainAxisSize: .min,
          children: [
            HomeButtonItem(
              title: "editExif".tr, 
              icon: Icons.edit_rounded,
              width: 140, 
              height: 150, 
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
              ), 
              onDone: (){
                imageController.loading.value = false;
                if(isDesktop()){
                  Get.toNamed("/edit", id: 1);
                }else{
                  Get.to(()=> EditMView());
                }
              },
            ),
            HomeButtonItem(
              title: "removeExif".tr, 
              icon: Icons.delete_rounded, 
              width: 140, 
              height: 150, 
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
              ),
              onDone: (){
                imageController.loading.value = false;
                if(isDesktop()){
                  Get.toNamed("/remove", id: 1);
                }else{
                  Get.to(()=> RemoveMView());
                }
              },
            ),
          ],
        ),
        HomeButtonItem(
          title: "addMark".tr, 
          icon: Icons.picture_in_picture_alt_rounded, 
          width: 290, 
          height: 150, 
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          onDone: () async {
            imageController.loading.value = false;
            if(isDesktop()){
              Get.toNamed("/mark", id: 1);
            }else{
              Get.to(()=> MarkMView());
            }
            await imageController.loadPreviewImage();
          },
        ),
      ],
    );
  }
}