import 'package:flutter/material.dart';
import 'package:instaloader/utils/constants.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateAppInit extends StatefulWidget {
  final Widget Function(RateMyApp) builder;
  const RateAppInit({Key? key, required this.builder}) : super(key: key);

  @override
  State<RateAppInit> createState() => _RateAppInitState();
}

class _RateAppInitState extends State<RateAppInit> {
  RateMyApp? _rateMyApp;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RateMyAppBuilder(
      rateMyApp: RateMyApp(
        googlePlayIdentifier: googlePlayIdentifier,
        appStoreIdentifier: appStoreIdentifier,
      ),
      onInitialized: (context, rateMyApp) {
        setState(() {
          _rateMyApp = rateMyApp;
        });
      },
      builder: (context) {
        return _rateMyApp == null
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : widget.builder(_rateMyApp!);
      },
    );
  }
}
