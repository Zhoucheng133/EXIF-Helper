import 'package:desktop_drop/desktop_drop.dart';
import 'package:exif_helper/components/homebuttons/home_buttons.dart';
import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/functions/dialog_func.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  final ImageController imageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DropTarget(
          onDragDone: (detail) async {
            final bool checker=await imageController.fileChecker(context, detail.files[0].path);
            if(checker && context.mounted){
              showDialog(
                context: context, 
                builder: (context) => AlertDialog(
                  contentPadding: .zero,
                  clipBehavior: Clip.antiAlias,
                  content: Column(
                    mainAxisSize: .min,
                    children: [
                      ListTile(
                        mouseCursor: SystemMouseCursors.basic,
                        leading: Icon(
                          Icons.edit_rounded,
                          size: 18,
                        ),
                        title: Text("editExif".tr),
                        onTap: (){
                          Navigator.pop(context);
                          imageController.loading.value = false;
                          Get.toNamed("/edit", id: 1);
                        },
                      ),
                      ListTile(
                        mouseCursor: SystemMouseCursors.basic,
                        leading: Icon(
                          Icons.delete_rounded,
                          size: 18,
                        ),
                        title: Text("removeExif".tr),
                        onTap: (){
                          Navigator.pop(context);
                          imageController.loading.value = false;
                          Get.toNamed("/remove", id: 1);
                        },
                      ),
                      ListTile(
                        mouseCursor: SystemMouseCursors.basic,
                        leading: Icon(
                          Icons.picture_in_picture_alt_rounded,
                          size: 18,
                        ),
                        title: Text("addMark".tr),
                        onTap: () async {
                          Navigator.pop(context);
                          imageController.loading.value = false;
                          Get.toNamed("/mark", id: 1);
                          await imageController.loadPreviewImage();
                        },
                      ),
                    ],
                  ),
                )
              );
            }
          },
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20,
                children: [
                  HomeButtons(),
                  Text(
                    "addView".tr,
                    style: TextStyle(
                      color: Theme.of(context).brightness==Brightness.dark ? Colors.purple[200] : Colors.purple,
                    )
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 30,
          bottom: 30,
          child: Row(
            mainAxisSize: .min,
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              FilledButton(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)
                    )
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                ),
                onPressed: ()=>showLanguageDialog(context), 
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    Icon(Icons.translate_rounded),
                    SizedBox(width: 5,),
                    Text("language".tr),
                  ],
                )
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)
                    )
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                ),
                onPressed: ()=>showAbout(context), 
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    Icon(Icons.info_rounded),
                    SizedBox(width: 5,),
                    Text("about".tr),
                  ],
                )
              ),
            ],
          )
        )
      ],
    );
  }
}