import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:instaloader/models/photo_model.dart';
import 'package:instaloader/models/reel_tv_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class DownloadController extends GetxController {
  late TargetPlatform? _platform;

  late bool _isLoading;
  bool get isLoading => _isLoading;

  late bool _permissionReady;
  bool get permissionReady => _permissionReady;

  late String _localPath;
  String get localPath => _localPath;

  DownloadTaskStatus? _status = DownloadTaskStatus.undefined;
  DownloadTaskStatus? get status => _status;

  late String? itemID;
  double _progress = 0;
  double get progress => _progress;

  DownloadController();

  void beforePreparingDownload() {
    _platform = Theme.of(Get.context!).platform;
    bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
    _isLoading = true;
    _permissionReady = false;
    _prepare();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  void bindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    final ReceivePort port = ReceivePort();

    bool isSuccess = IsolateNameServer.registerPortWithName(port.sendPort, 'downloader_send_port');

    if (!isSuccess) {
      unbindBackgroundIsolate();
      bindBackgroundIsolate();
      return;
    }

    port.listen((dynamic data) async {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      _status = status;
      _progress = data[2] / 100;
      if (_status == DownloadTaskStatus.complete && _progress == 1) {
        _isLoading = false;
        Get.snackbar(
          "downloadComplete".tr,
          "downloadCompleteMsg".tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        String query = "SELECT * FROM task WHERE task_id='$id'";
        await FlutterDownloader.loadTasksWithRawQuery(query: query);
        //if the task exists, open it
        FlutterDownloader.open(taskId: id);
      }
      update();
    });
  }

  void unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  void _prepare() async {
    _permissionReady = await _checkPermission();

    if (_permissionReady) {
      await _prepareSaveDir();
    }

    _isLoading = false;
    update();
  }

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) return true;

    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (_platform == TargetPlatform.android) {
      PermissionStatus permission = await Permission.storage.status;
      if (permission != PermissionStatus.granted) {
        Map<Permission, PermissionStatus> permissions = await [Permission.storage].request();
        return permissions[Permission.storage] != PermissionStatus.granted;
      }
      return true;
    }
    return true;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final saveDir = Directory(_localPath);
    bool hasExisted = await saveDir.exists();

    if (!hasExisted) {
      await saveDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (_platform == TargetPlatform.android) {
      try {
        Directory? appDocDir = await getExternalStorageDirectory();
        String appDocPath = appDocDir!.path;
        _localPath = appDocPath;
      } catch (e) {
        return null;
      }
    } else if (_platform == TargetPlatform.iOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.absolute.path;
      _localPath = appDocPath;
    }
    return _localPath;
  }

  Future<String> getContent(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('failedLoadContent'.tr);
    }
    if (response.body.isEmpty || response.body.contains('html')) {
      throw Exception('couldnotGetData'.tr);
    }
    return response.body;
  }

  Future<PhotoModel> getPhotoContent(String url) async {
    var link = url.contains("/?") ? url.split("/?").first : url;
    var uri = "$link/?__a=1&__d=dis";
    var response = await getContent(uri);
    var json = jsonDecode(response);
    update();
    return PhotoModel.fromJson(json);
  }

  Future<ReelModel> getReelContent(String url) async {
    var link = url.contains("/?") ? url.split("/?").first : url;
    var uri = "$link/?__a=1&__d=dis";
    var response = await getContent(uri);
    var json = jsonDecode(response);
    update();
    return ReelModel.fromJson(json);
  }

  Future<void> download(String url) async {
    _isLoading = true;
    update();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd-HHmmss");
    String saveName = dateFormat.format(DateTime.now());
    itemID = await FlutterDownloader.enqueue(
      url: url,
      savedDir: _localPath,
      showNotification: true,
      openFileFromNotification: true,
      fileName: saveName,
      saveInPublicStorage: true,
    ).whenComplete(() => _isLoading = false);
  }

  void pause(String? itemid) async {
    _isLoading = false;
    update();
    await FlutterDownloader.pause(
      taskId: itemid!,
    );
  }

  void resume(String? itemid) async {
    _isLoading = true;
    update();
    itemID = await FlutterDownloader.resume(
      taskId: itemid!,
    );
  }

  void retry(String? itemid) async {
    _isLoading = true;
    update();
    itemID = await FlutterDownloader.retry(taskId: itemID!);
  }
}
