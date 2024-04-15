import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:instaloader/utils/constants.dart';
import 'package:instaloader/controllers/download_controller.dart';
import 'package:instaloader/models/reel_tv_model.dart';
import 'package:instaloader/utils/download_button.dart';
import 'package:instaloader/widgets/app_video.dart';
import 'package:instaloader/widgets/top_form.dart';
import 'package:video_player/video_player.dart';

class ReelPage extends StatefulWidget {
  const ReelPage({Key? key}) : super(key: key);

  @override
  State<ReelPage> createState() => _ReelPageState();
}

class _ReelPageState extends State<ReelPage> {
  late DownloadController _downloadController;
  final TextEditingController _videoUrlController = TextEditingController();

  VideoPlayerController? _videoController;
  ReelModel? _reelModel;

  @override
  void initState() {
    super.initState();
    _downloadController = Get.put(DownloadController());
    _downloadController.beforePreparingDownload();
  }

  @override
  void dispose() {
    _downloadController.unbindBackgroundIsolate();
    if (_videoController != null) {
      _videoController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: bgColor,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TopForm(controller: _videoUrlController, onPressed: _topFormOnPressed),
                    const SizedBox(height: defaultPadding),
                    Expanded(
                        child: _reelModel == null || _reelModel!.graphql!.shortcodeMedia!.displayUrl == null
                            ? const Icon(
                                Icons.videocam,
                                size: 100,
                                color: Colors.white10,
                              )
                            : AppVideoPlayer(videoController: _videoController)),
                    const SizedBox(height: defaultPadding),
                    DownloadButton(onPressed: _onDownloadButtonPressed),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _topFormOnPressed() async {
    String url = _videoUrlController.text;
    if (url.isNotEmpty && url.contains("instagram.com")) {
      try {
        _reelModel = await _downloadController.getReelContent(url);
        _videoController = VideoPlayerController.network(_reelModel!.graphql!.shortcodeMedia!.videoUrl ?? "");
        _videoController!.addListener(() {
          setState(() {});
        });
        _videoController!.initialize().then((value) {
          setState(() {});
        });
        setState(() {});
        _videoController!.play();
      } catch (e) {
        Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar("Error", "Please enter a valid Instagram URL", snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _onDownloadButtonPressed() {
    if (_downloadController.status == DownloadTaskStatus.undefined) {
      if (_reelModel!.graphql!.shortcodeMedia!.videoUrl!.isNotEmpty) {
        _downloadController.download(_reelModel!.graphql!.shortcodeMedia!.videoUrl!);
      } else {
        Get.snackbar("warning".tr, "invalidUrlText".tr, snackPosition: SnackPosition.BOTTOM);
      }
    } else if (_downloadController.status == DownloadTaskStatus.failed) {
      if (_downloadController.itemID != null) {
        _downloadController.retry(_downloadController.itemID);
      }
    }
  }
}
