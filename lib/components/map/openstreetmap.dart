import 'package:exif_helper/controllers/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Openstreetmap extends StatefulWidget {

  final bool select;
  final EXIFData data;

  const Openstreetmap({super.key, required this.select, required this.data});

  @override
  State<Openstreetmap> createState() => _OpenstreetmapState();
}

class _OpenstreetmapState extends State<Openstreetmap> {
  @override
  Widget build(BuildContext context) {
    if(widget.select==false && (widget.data.latitude==null || widget.data.longitude==null)){
      return SizedBox(
        width: 500,
        height: 500,
        child: Placeholder(),
      );
    }
    return SizedBox(
      width: 500,
      height: 500,
      child: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: (widget.data.latitude!=null && widget.data.longitude!=null) ? LatLng(widget.data.latitude!, widget.data.longitude!) : LatLng(39.9042, 116.4074),
              initialZoom: 12.0,
              onMapEvent: (event) {
                // TODO 位置更新
                // final center = event.camera.center;
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'zhouc.exifhelper'
              ),
              if(widget.select==false && widget.data.longitude!=null && widget.data.latitude!=null) MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(widget.data.latitude!, widget.data.longitude!),
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ]
              )
            ]
          ),
          if(widget.select==true) IgnorePointer(
            child: Center(
              child: Icon(
                Icons.my_location,
                color: Colors.red,
                size: 30,
              ),
            ),
          ),
        ],
      )
    );
  }
}