import 'package:flutter/material.dart';
import '/../component/VideoFileWidget.dart';
import '/../component/YouTubeEmbedWidget.dart';
import '/../models/ProductDetailResponse.dart';
import '/../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class VideoPlayDialog extends StatefulWidget {
  static String tag = '/VideoPlayDialog';
  final VideoData? data;

  VideoPlayDialog({this.data});

  @override
  VideoPlayDialogState createState() => VideoPlayDialogState();
}

class VideoPlayDialogState extends State<VideoPlayDialog> {
  String videoType = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    log(widget.data!.url.validate());
    if (widget.data!.url.validate().contains(VideoTypeYouTube))
      videoType = VideoTypeYouTube;
    else
      videoType = VideoTypeCustom;

  }

  @override
  void dispose() {
    super.dispose();
    setOrientationPortrait();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
            onPressed: () {
              finish(context);
            }),
      ),
      body: Stack(
        children: [
          videoType.validate() == VideoTypeYouTube
              ? YouTubeEmbedWidget(widget.data!.url.validate().toYouTubeId()).center()
              : videoType.validate() == VideoTypeIFrame
                  ? YouTubeEmbedWidget(widget.data!.url.validate(), fullIFrame: true).center()
                  : videoType.validate() == VideoTypeCustom
                      ? VideoFileWidget(widget.data!.url.validate()).center()
                      : Container(child: Text('Invalid video').center()),
        ],
      ),
    );
  }
}
