import 'package:exif_helper/components/homebuttons/home_button_item.dart';
import 'package:flutter/material.dart';

class HomeButtons extends StatefulWidget {
  const HomeButtons({super.key});

  @override
  State<HomeButtons> createState() => _HomeButtonsState();
}

class _HomeButtonsState extends State<HomeButtons> {
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
              title: "1", 
              icon: Icons.edit_rounded,
              width: 120, 
              height: 120, 
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
              )
            ),
            HomeButtonItem(
              title: "1", 
              icon: Icons.abc, 
              width: 120, 
              height: 120, 
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
              )
            ),
          ],
        ),
        HomeButtonItem(
          title: "1", 
          icon: Icons.abc, 
          width: 250, 
          height: 120, 
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          )
        ),
      ],
    );
  }
}