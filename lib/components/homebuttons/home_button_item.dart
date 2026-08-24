import 'package:exif_helper/controllers/image_controller.dart';
import 'package:exif_helper/functions/cals.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class HomeButtonItem extends StatefulWidget {

  final String title;
  final IconData icon;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final VoidCallback onDone;

  const HomeButtonItem({super.key, required this.title, required this.icon, required this.width, required this.height, required this.borderRadius, required this.onDone});

  @override
  State<HomeButtonItem> createState() => _HomeButtonItemState();
}

class _HomeButtonItemState extends State<HomeButtonItem> {

  final ImageController imageController = Get.find();
  bool loading=false;

  Future<void> pickImage(BuildContext context) async {
    if(isDesktop()){
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && context.mounted) {
        if(await imageController.fileChecker(context, result.files.single.path!)){
          widget.onDone();
        }
      }
    }else{
      setState(() {
        loading=true;
      });
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null && context.mounted){
        if(await imageController.fileChecker(context, image.path)){
          widget.onDone();
        }
      }
      setState(() {
        loading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Material(
        color: Theme.of(context).brightness==Brightness.dark ? Colors.grey[800] : Colors.purple[100],
        borderRadius: widget.borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: ()=>pickImage(context),
          child: Stack(
            children: [
              Padding(
                padding: .only(bottom: 20),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: loading ? SizedBox(
                      key: ValueKey(1),
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator()
                    ) : Icon(
                      key: ValueKey(2),
                      widget.icon,
                      color: Theme.of(context).brightness==Brightness.dark ? Colors.purple[200] : Colors.purple,
                    ),
                  )
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 40,
                  color: Theme.of(context).brightness==Brightness.dark ? Colors.black.withAlpha(80) : Colors.white.withAlpha(80),
                  child: Center(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: Theme.of(context).brightness==Brightness.dark ? Colors.purple[200] : Colors.purple,
                      ),
                    ),
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}