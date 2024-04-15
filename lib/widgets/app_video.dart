import 'package:flutter/material.dart';
import 'package:instaloader/utils/constants.dart';
import 'package:video_player/video_player.dart';

class AppVideoPlayer extends StatelessWidget {
  final VideoPlayerController? videoController;
  const AppVideoPlayer({Key? key, required this.videoController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: videoController!.value.aspectRatio,
          child: GestureDetector(
            onTap: () {
              if (videoController!.value.isPlaying) {
                videoController!.pause();
              } else {
                videoController!.play();
              }
            },
            child: VideoPlayer(videoController!),
          ),
        ),
        VideoProgressIndicator(
          videoController!,
          allowScrubbing: true,
          colors: const VideoProgressColors(
            backgroundColor: videoProgressIndicatorBgColor,
            playedColor: videoProgressIndicatorBufferedColor,
            bufferedColor: videoProgressIndicatorPlayedColor,
          ),
        ),
      ],
    );
  }
}
