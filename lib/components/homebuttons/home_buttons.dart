import 'package:exif_helper/components/homebuttons/home_button_item.dart';
import 'package:exif_helper/controllers/image_controller.dart';
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
                Get.toNamed("/edit", id: 1);
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
                Get.toNamed("/remove", id: 1);
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
            Get.toNamed("/mark", id: 1);
            await imageController.loadPreviewImage();
          },
        ),
      ],
    );
  }
}