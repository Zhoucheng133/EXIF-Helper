import 'package:exif_helper/components/config_item.dart';
import 'package:exif_helper/controllers/image_controller.dart';
import 'package:expressions/expressions.dart';
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

  String calFnum(String input){
    final expression = Expression.parse(input);
    final evaluator = const ExpressionEvaluator();

    return "F${evaluator.eval(expression, {})}";
  }

  String calDatatime(String input){
    input=input.replaceFirst(":", "-");
    input=input.replaceFirst(":", "-");
    return input;
  }

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
              width: 270,
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
                      ),
                      const SizedBox(height: 10,),
                      ConfigItem(keyWord: "相机制造商", value: imageController.item.value!.make, enable: true),
                      ConfigItem(keyWord: "相机型号", value: imageController.item.value!.model, enable: true),
                      ConfigItem(keyWord: "镜头型号", value: imageController.item.value!.lenModel, enable: true),
                      ConfigItem(keyWord: "焦距", value: "${imageController.item.value!.forcal}mm", enable: true),
                      ConfigItem(keyWord: "光圈", value: calFnum(imageController.item.value!.fNum), enable: true),
                      ConfigItem(keyWord: "曝光时间", value: "${imageController.item.value!.exposureTime}s", enable: true),
                      ConfigItem(keyWord: "ISO", value: imageController.item.value!.iso, enable: true),
                      ConfigItem(keyWord: "拍摄时间", value: calDatatime(imageController.item.value!.dateTime), enable: true)
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