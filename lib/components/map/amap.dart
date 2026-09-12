import 'dart:convert';

import 'package:exif_helper/controllers/types.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Amap extends StatefulWidget {
  final bool select;
  final EXIFData data;

  const Amap({super.key, required this.select, required this.data});

  @override
  State<Amap> createState() => _AmapState();
}

class _AmapState extends State<Amap> {
  late final WebViewController _controller;
  bool _pageLoaded = false;

  bool get _hasCoords =>
      widget.data.latitude != null && widget.data.longitude != null;

  @override
  void initState() {
    super.initState();

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
            // TODO 位置更新
            // 例如: widget.data.latitude = newLat; widget.data.longitude = newLng;
            debugPrint('地图中心更新: $newLat, $newLng');
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
        ..loadFlutterAsset('assets/amap.html');
    }
  }

  @override
  void didUpdateWidget(covariant Amap oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 外部数据变化时，同步更新地图中心/marker
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
      child: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (widget.select == true)
            const IgnorePointer(
              child: Center(
                child: Icon(
                  Icons.my_location,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            ),
        ],
      ),
    );
  }
}