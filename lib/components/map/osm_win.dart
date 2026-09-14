import 'dart:convert';
import 'package:exif_helper/controllers/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_windows/webview_windows.dart';

class OsmWin extends StatefulWidget {

  final bool select;
  final EXIFData data;
  final ValueChanged locationUpdate;

  const OsmWin({
    super.key,
    required this.select,
    required this.data,
    required this.locationUpdate,
  });

  @override
  State<OsmWin> createState() => _OsmWinState();
}

class _OsmWinState extends State<OsmWin> {
  final WebviewController _controller =WebviewController();

  bool _pageLoaded = false;
  bool load = true;

  bool get _hasCoords => widget.data.latitude != null && widget.data.longitude != null;

  Future<String> _createHtmlFile() async {
    var html = await rootBundle.loadString('assets/osm_win.html',);
    return html;
  }

  Future<void> init() async {
    if (!(widget.select == false && !_hasCoords)) {
      final lat = _hasCoords ? widget.data.latitude! : 39.9042;
      final lng = _hasCoords ? widget.data.longitude! : 116.4074;

      final hasMarker = widget.select == false && _hasCoords;
      await _controller.initialize();

      _controller.webMessage.listen((message) {
        try {
          final data = jsonDecode(message);
          final newLat = (data['lat'] as num).toDouble();
          final newLng = (data['lng'] as num).toDouble();
          widget.locationUpdate(
            Location(
              latitude:newLat,
              longitude:newLng,
            ),
          );
        } catch(_){}
      });

      _controller.loadingState.listen((state) {
        if(state ==LoadingState.navigationCompleted){
          _pageLoaded=true;
          _controller.executeScript(
            "initMap($lat,$lng, ${widget.select}, $hasMarker);",
          );
        }
      });

      final url = await _createHtmlFile();
      await _controller.loadUrl(url);

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
  void didUpdateWidget(covariant OsmWin oldWidget){
    super.didUpdateWidget(oldWidget);

    if(_pageLoaded && _hasCoords &&
      (oldWidget.data.latitude !=widget.data.latitude || oldWidget.data.longitude !=widget.data.longitude)
    ){
      _controller.executeScript(
        "updateLocation(${widget.data.latitude}, ${widget.data.longitude});",
      );
    }
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(widget.select == false && !_hasCoords){
      return const SizedBox(
        width: 500,
        height: 500,
        child:Placeholder(),
      );
    }

    return SizedBox(
      width: 500,
      height: 500,
      child: load ? const Center(
        child:CircularProgressIndicator(),
      ) :Stack(
        children:[
          Webview(_controller),
          if(widget.select)
            const IgnorePointer(
              child:Center(
                child:Padding(
                  padding:
                  EdgeInsets.only(
                    bottom:20,
                  ),
                  child:Icon(
                    Icons.location_on_rounded,
                    color:Colors.red,
                    size:35,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}