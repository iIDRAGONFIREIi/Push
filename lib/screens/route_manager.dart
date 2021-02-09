import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:minimalisticpush/controllers/preferences_controller.dart';
import 'package:minimalisticpush/screens/error_screen.dart';
import 'package:minimalisticpush/screens/main_screen.dart';
import 'package:minimalisticpush/screens/onboarding_screen.dart';
import 'package:minimalisticpush/widgets/background.dart';

// TODO: change to stateless widget when creating the preferences manager
class RouteManager extends StatefulWidget {
  ValueNotifier<bool> onboarding;

  static RouteManager _instance;

  static get instance {
    if (_instance == null) {
      _instance = RouteManager._internal();
    }

    return _instance;
  }

  RouteManager._internal();

  @override
  _RouteManagerState createState() => _RouteManagerState();
}

class _RouteManagerState extends State<RouteManager> {
  @override
  void initState() {
    widget.onboarding =
        ValueNotifier(PreferencesController.instance.showOnboarding());
    widget.onboarding.addListener(() => super.setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget overlay;
    var size = MediaQuery.of(context).size;

    switch (widget.onboarding.value) {
      case true:
        Background.instance.factorNotifier.value = 0.0;
        overlay = OnboardingScreen();
        break;
      case false:
        Background.instance.factorNotifier.value = 0.6;
        overlay = Container(
          height: size.height,
          width: size.width,
          child: MainScreen(),
        );
        break;
      default:
        overlay = ErrorScreen();
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Container(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Background.instance,
              SafeArea(
                child: overlay,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
