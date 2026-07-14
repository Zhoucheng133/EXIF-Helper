import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/mobile/config_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  final ImageController imageController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                final picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null && context.mounted) {
                  if(await imageController.fileChecker(context, image.path)){
                    Get.to(()=>ConfigView());
                  }
                }
              }, 
              icon: const Icon(
                Icons.add_rounded,
                size: 30,
              )
            ),
            const SizedBox(height: 10,),
            Text(
              "openPhoto".tr,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface
              )
            )
          ],
        ),
      ),
    );
  }
}