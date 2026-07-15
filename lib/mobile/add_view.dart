import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/mobile/config_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {

  final ImageController imageController=Get.find();

  bool load=false;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          load ? CircularProgressIndicator() : IconButton(
            onPressed: () async {
              final picker = ImagePicker();
              final XFile? image = await picker.pickImage(source: ImageSource.gallery);
              setState(() {
                load=true;
              });
              if (image != null && context.mounted) {
                if(await imageController.fileChecker(context, image.path)){
                  Get.to(()=>ConfigView());
                }
              }
              setState(() {
                load=false;
              });
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
    );
  }
}