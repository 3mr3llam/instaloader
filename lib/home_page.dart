import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaloader/controllers/menu_controller.dart';
import 'package:instaloader/pages/menu_page.dart';
import 'package:instaloader/utils/constants.dart';
import 'package:instaloader/pages/photo_page.dart';
import 'package:instaloader/pages/reel_page.dart';
import 'package:instaloader/pages/tv_page.dart';
import 'package:instaloader/widgets/zoom_scaffold.dart';
import 'package:rate_my_app/rate_my_app.dart';

class HomePage extends StatefulWidget {
  final RateMyApp? rateMyApp;

  const HomePage({Key? key, this.rateMyApp}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  //State class
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  late PageController _pageController;

  final List<Widget> _pages = [
    const PhotoPage(),
    const ReelPage(),
    const TVPage(),
  ];

  @override
  void initState() {
    _pageController = PageController();
    Get.put(MyMenuController(vsync: this));
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: Get.find<MyMenuController>(),
        builder: (menuController) {
          return SafeArea(
            child: ZoomScaffold(
              bottomNavBar: CurvedNavigationBar(
                key: _bottomNavigationKey,
                backgroundColor: bgColor,
                color: secondaryColor,
                index: _page,
                buttonBackgroundColor: secondaryColor,
                items: const <Widget>[
                  Icon(Icons.photo_album, size: 30, color: Colors.white),
                  Icon(Icons.videocam, size: 30, color: Colors.white),
                  Icon(Icons.movie, size: 30, color: Colors.white),
                ],
                onTap: (index) {
                  setState(() {
                    _page = index;
                    //using this page controller you can make beautiful animation effects
                    _pageController.animateToPage(_page, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
                  });
                },
              ),
              contentScreen: Layout(
                contentBuilder: (context) => PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _page = index;
                    });
                  },
                  children: _pages,
                ),
              ),
              menuScreen: MenuPage(
                rateMyApp: widget.rateMyApp!,
              ),
            ),
          );
        });
  }
}
