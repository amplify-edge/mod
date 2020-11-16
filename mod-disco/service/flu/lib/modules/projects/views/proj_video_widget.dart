import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ProjectVideoPlayer extends StatefulWidget {
  final List<String> videoUrls;

  ProjectVideoPlayer(this.videoUrls);

  @override
  _ProjectVideoPlayerState createState() => _ProjectVideoPlayerState();
}

class _ProjectVideoPlayerState extends State<ProjectVideoPlayer> {
  List<String> get videoUrls => widget.videoUrls;
  List<String> nextVideoUrls = List<String>();
  YoutubePlayerController controller;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      for (var i = 0; i < widget.videoUrls.length; i++) {
        if (i != 0) {
          nextVideoUrls.add(widget.videoUrls[i]);
        }
      }
      controller = YoutubePlayerController(
        initialVideoId:
            YoutubePlayerController.convertUrlToId(widget.videoUrls.first),
        params: YoutubePlayerParams(
          playlist: nextVideoUrls.map(
            (url) {
              YoutubePlayerController.convertUrlToId(url);
            },
          ).toList(),
          // Defining custom playlist
          startAt: Duration(seconds: 30),
          showControls: true,
          showFullscreenButton: true,
        ),
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerIFrame(
      controller: controller,
      aspectRatio: 16 / 9,
    );
  }
}
