import 'package:exif_helper/components/homebuttons/home_buttons.dart';
import 'package:flutter/material.dart';

class HomeMView extends StatefulWidget {
  const HomeMView({super.key});

  @override
  State<HomeMView> createState() => _HomeMViewState();
}

class _HomeMViewState extends State<HomeMView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: HomeButtons(),
    );
  }
}