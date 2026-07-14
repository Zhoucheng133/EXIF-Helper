import 'package:exif_helper/controllers/image_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigView extends StatefulWidget {
  const ConfigView({super.key});

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  @override
  Widget build(BuildContext context) {
    final imageController=Get.find<ImageController>();
    return Scaffold(
      body: Obx(
        ()=> Image.memory(
          imageController.item.value!.raw,
          fit: BoxFit.contain,
          gaplessPlayback: false,
          cacheHeight: 800,
        ),
      ),
    );
  }
}