// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaloader/controllers/menu_controller.dart';
import 'package:instaloader/utils/constants.dart';

class ZoomScaffold extends StatefulWidget {
  final Widget menuScreen;
  final Layout contentScreen;
  final Widget bottomNavBar;

  const ZoomScaffold({
    Key? key,
    required this.menuScreen,
    required this.contentScreen,
    required this.bottomNavBar,
  }) : super(key: key);

  @override
  _ZoomScaffoldState createState() => _ZoomScaffoldState();
}

class _ZoomScaffoldState extends State<ZoomScaffold> with TickerProviderStateMixin {
  Curve scaleDownCurve = const Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve = const Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve = const Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve = const Interval(0.0, 1.0, curve: Curves.easeOut);

  MyMenuController? _menuController;

  @override
  initState() {
    super.initState();
    Get.put(MyMenuController(vsync: this));
    _menuController = Get.find<MyMenuController>();
  }

  createContentDisplay() {
    return zoomAndSlideContent(Scaffold(
      bottomNavigationBar: widget.bottomNavBar,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.0,
        leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () {
              Get.find<MyMenuController>().toggle();
            }),
      ),
      body: widget.contentScreen.contentBuilder(context),
    ));
  }

  zoomAndSlideContent(Widget content) {
    double slidePercent, scalePercent;

    switch (_menuController!.state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.opening:
        slidePercent = slideOutCurve.transform(_menuController!.percentOpen);
        scalePercent = scaleDownCurve.transform(_menuController!.percentOpen);
        break;
      case MenuState.closing:
        slidePercent = slideInCurve.transform(_menuController!.percentOpen);
        scalePercent = scaleUpCurve.transform(_menuController!.percentOpen);
        break;
    }

    final slideAmount = 275.0 * slidePercent;
    final contentScale = 1.0 - (0.2 * scalePercent);
    final cornerRadius = 16.0 * _menuController!.percentOpen;

    return Transform(
      transform: Matrix4.translationValues(slideAmount, 0.0, 0.0)..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 5.0),
              blurRadius: 15.0,
              spreadRadius: 10.0,
            ),
          ],
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(cornerRadius), child: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: widget.menuScreen,
        ),
        createContentDisplay()
      ],
    );
  }
}

class ZoomScaffoldMenuController extends StatefulWidget {
  final ZoomScaffoldBuilder builder;

  const ZoomScaffoldMenuController({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  ZoomScaffoldMenuControllerState createState() {
    return ZoomScaffoldMenuControllerState();
  }
}

class ZoomScaffoldMenuControllerState extends State<ZoomScaffoldMenuController> with TickerProviderStateMixin {
  MenuController? menuController;

  @override
  void initState() {
    Get.put(MyMenuController(vsync: this));
    menuController = Get.find<MenuController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, menuController!);
  }
}

typedef ZoomScaffoldBuilder = Widget Function(BuildContext context, MenuController menuController);

class Layout {
  final WidgetBuilder contentBuilder;

  Layout({
    required this.contentBuilder,
  });
}
