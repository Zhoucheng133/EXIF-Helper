import 'dart:convert';

import 'package:exif_helper/controllers/types.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Openstreetmap extends StatefulWidget {

  final bool select;
  final EXIFData data;
  final ValueChanged locationUpdate;

  const Openstreetmap({super.key, required this.select, required this.data, required this.locationUpdate});

  @override
  State<Openstreetmap> createState() => _OpenstreetmapState();
}

class _OpenstreetmapState extends State<Openstreetmap> {

  late final WebViewController _controller;
  bool _pageLoaded = false;

  bool get _hasCoords => widget.data.latitude != null && widget.data.longitude != null;

  Future<void> init() async {
    if (!(widget.select == false && !_hasCoords)) {
      final lat = _hasCoords ? widget.data.latitude! : 39.9042;
      final lng = _hasCoords ? widget.data.longitude! : 116.4074;
      final hasMarker = widget.select == false && _hasCoords;

      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptChannel(
          'FlutterChannel',
          onMessageReceived: (message) {
            final data = jsonDecode(message.message);
            final newLat = data['lat'] as double;
            final newLng = data['lng'] as double;
            widget.locationUpdate(Location(latitude: newLat, longitude: newLng));
          },
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (_) {
              _pageLoaded = true;
              _controller.runJavaScript(
                'initMap($lat, $lng, ${widget.select}, $hasMarker);',
              );
            },
          ),
        )
        ..loadFlutterAsset("assets/osm.html");
      
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void didUpdateWidget(covariant Openstreetmap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_pageLoaded &&
        _hasCoords &&
        (oldWidget.data.latitude != widget.data.latitude ||
            oldWidget.data.longitude != widget.data.longitude)) {
      _controller.runJavaScript(
        'updateLocation(${widget.data.latitude}, ${widget.data.longitude});',
      );
    }
  }

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
          WebViewWidget(controller: _controller),
          if (widget.select == true) const IgnorePointer(
            child: Center(
              child: Padding(
                padding: .only(bottom: 20),
                child: Icon(
                  Icons.location_on_rounded,
                  color: Colors.red,
                  size: 35,
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}