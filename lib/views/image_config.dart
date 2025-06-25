import 'package:exif_helper/controllers/image_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageConfig extends StatefulWidget {
  const ImageConfig({super.key});

  @override
  State<ImageConfig> createState() => _ImageConfigState();
}

class _ImageConfigState extends State<ImageConfig> {

  final ImageController imageController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Obx(()=>
                      Image.memory(
                        imageController.item.value!.raw,
                        fit: BoxFit.contain
                      )
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: (){
                        imageController.item.value=null;
                      }, 
                      icon: const Icon(Icons.close_rounded)
                    )
                  )
                ],
              )
            ),
            SizedBox(width: 10,),
            Container(
              width: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(()=>
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        imageController.item.value!.fileName,
                        style: GoogleFonts.notoSansSc(
                          fontSize: 18,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}