import 'package:flutter/material.dart';

class HomeButtonItem extends StatefulWidget {

  final String title;
  final IconData icon;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const HomeButtonItem({super.key, required this.title, required this.icon, required this.width, required this.height, required this.borderRadius});

  @override
  State<HomeButtonItem> createState() => _HomeButtonItemState();
}

class _HomeButtonItemState extends State<HomeButtonItem> {
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
          onTap: (){},
          child: Stack(
            children: [
              Center(
                child: Icon(
                  widget.icon,
                  color: Colors.purple,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 30,
                  color: Theme.of(context).brightness==Brightness.dark ? Colors.black.withAlpha(80) : Colors.white.withAlpha(80),
                  child: Center(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: Theme.of(context).brightness==Brightness.dark ? Colors.white : Colors.black,
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