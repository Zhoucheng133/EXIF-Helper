import 'dart:convert';

import 'package:exif_helper/components/map/amap_key.dart';
import 'package:exif_helper/controllers/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Amap extends StatefulWidget {
  final bool select;
  final EXIFData data;
  final ValueChanged locationUpdate;

  const Amap({super.key, required this.select, required this.data, required this.locationUpdate});

  @override
  State<Amap> createState() => _AmapState();
}

class _AmapState extends State<Amap> {
  late final WebViewController _controller;
  bool _pageLoaded = false;
  bool load=true;

  bool get _hasCoords => widget.data.latitude != null && widget.data.longitude != null;

  Future<void> init() async {
    if (!(widget.select == false && !_hasCoords)) {
      final lat = _hasCoords ? widget.data.latitude! : 39.9042;
      final lng = _hasCoords ? widget.data.longitude! : 116.4074;
      final hasMarker = widget.select == false && _hasCoords;

      final html = await rootBundle.loadString(
        'assets/amap.html',
      );
      final content = html.replaceFirst(
        '{{AMAP_KEY}}',
        amapKey,
      );

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
        ..loadHtmlString(content);
      
      setState(() {
        load=false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void didUpdateWidget(covariant Amap oldWidget) {
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
    if (widget.select == false && !_hasCoords) {
      return const SizedBox(
        width: 500,
        height: 500,
        child: Placeholder(),
      );
    }

    return SizedBox(
      width: 500,
      height: 500,
      child:load ? Center(
          child: CircularProgressIndicator(),
        ) : Stack(
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
      ),
    );
  }
}