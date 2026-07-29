import 'package:desktop_drop/desktop_drop.dart';
import 'package:exif_helper/components/homebuttons/home_buttons.dart';
import 'package:exif_helper/functions/dialog_func.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DropTarget(
          onDragDone: (detail) async {
            // TODO Drag
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