import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaloader/utils/constants.dart';

class DownloadButton extends StatelessWidget {
  final VoidCallback onPressed;
  const DownloadButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: defaultPadding),
        child: Text("download".tr),
      ),
      icon: const Icon(Icons.file_download),
      onPressed: onPressed,
    );
  }
}
