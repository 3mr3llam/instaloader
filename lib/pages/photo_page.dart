import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:instaloader/models/reel_tv_model.dart';
import 'package:instaloader/utils/constants.dart';
import 'package:instaloader/controllers/download_controller.dart';
import 'package:instaloader/utils/download_button.dart';
import 'package:instaloader/widgets/top_form.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({Key? key}) : super(key: key);

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  late DownloadController _downloadController;
  final TextEditingController _topFromTextController = TextEditingController();
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
                    TopForm(controller: _topFromTextController, onPressed: _topFormOnPressed),
                    const SizedBox(height: defaultPadding),
                    Expanded(
                        child: _reelModel == null || _reelModel!.graphql!.shortcodeMedia!.displayUrl == null
                            ? const Icon(
                                Icons.image,
                                size: 100,
                                color: Colors.white10,
                              )
                            : Image.network(_reelModel!.graphql!.shortcodeMedia!.displayUrl ?? "")),
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
    String url = _topFromTextController.text;
    if (url.isNotEmpty && url.contains("instagram.com")) {
      try {
        _reelModel = await _downloadController.getReelContent(url);
        setState(() {});
      } catch (e) {
        Get.snackbar("error".tr, e.toString(), snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar("error".tr, "invalidUrlText", snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _onDownloadButtonPressed() {
    if (_downloadController.status == DownloadTaskStatus.undefined) {
      if (_reelModel!.graphql!.shortcodeMedia!.displayUrl!.isNotEmpty) {
        _downloadController.download(_reelModel!.graphql!.shortcodeMedia!.displayUrl!);
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
