import 'dart:async';

import 'package:all_sensors/all_sensors.dart';
import 'package:flutter/material.dart';
import 'package:sprinkle/Observer.dart';
import 'package:sprinkle/sprinkle.dart';

import '../localizations.dart';
import '../managers/background_manager.dart';
import '../managers/preferences_manager.dart';
import '../managers/session_manager.dart';
import '../models/session.dart';
import '../styles/styles.dart';
import '../widgets/navigation_bar.dart';
import 'named_overlay_route.dart';

/// The main screen of the application.
class MainScreen extends StatefulWidget {
  /// The constructor for the main screen.
  const MainScreen({key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  final ValueNotifier<double> animationNotifier = ValueNotifier(0.0);
  final ValueNotifier<bool> trainingModeNotifier = ValueNotifier(false);

  @override
  void initState() {
    trainingModeNotifier.addListener(() => super.setState(() {}));

    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _animationController.animateTo(
      1.0,
      curve: Curves.easeInOutQuart,
    );

    // this listener gets executed, when this widget comes into focus again
    animationNotifier.addListener(() {
      _animationController.animateTo(
        1.0 - animationNotifier.value,
        curve: Curves.easeInOutQuart,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var preferencesManager = context.use<PreferencesManager>();
    var backgroundManager = context.use<BackgroundManager>();

    if (backgroundManager.factor.value <= 0.6) {
      backgroundManager.updateFactor(0.6);
    }

    if (!trainingModeNotifier.value) {
      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _animationController.value,
            child: child,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0.0, -20 + _animationController.value * 20),
                  child: child,
                );
              },
              child: NavigationBar(
                text:
                    MyLocalizations.of(context).getLocale('training')['title'],
                leftOption: NavigationOption(
                  icon: Icons.list,
                  onPressed: () => Navigator.push(
                    context,
                    NamedOverlayRoute(
                      overlayName: 'sessions',
                      animationNotifier: animationNotifier,
                      context: context,
                    ),
                  ),
                ),
                rightOption: NavigationOption(
                  icon: Icons.settings,
                  onPressed: () => Navigator.push(
                    context,
                    NamedOverlayRoute(
                      overlayName: 'settings',
                      animationNotifier: animationNotifier,
                      context: context,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  trainingModeNotifier.value = true;
                },
                child: Center(
                  child: Container(
                    constraints: BoxConstraints.tightForFinite(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        const Radius.circular(24.0),
                      ),
                      border: Border.all(
                        color: Colors.white,
                        width: 4.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        MyLocalizations.of(context)
                            .getLocale('training')['start'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 64.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0.0, 20 - _animationController.value * 20),
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Observer<bool>(
                  stream: preferencesManager.hardcore,
                  builder: (context, value) {
                    return Text(
                      MyLocalizations.of(context)
                          .getLocale('training')['hardcore'][value],
                      style: TextStyles.body,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return _TrainingWidget(
        trainingMode: trainingModeNotifier,
        hardcore: preferencesManager.hardcore.value,
      );
    }
  }
}

class _TrainingWidget extends StatefulWidget {
  const _TrainingWidget({
    Key key,
    @required this.trainingMode,
    @required this.hardcore,
  }) : super(key: key);

  final ValueNotifier<bool> trainingMode;
  final bool hardcore;

  @override
  _TrainingWidgetState createState() => _TrainingWidgetState();
}

class _TrainingWidgetState extends State<_TrainingWidget> {
  int counter = 1;

  var _proximity = false;
  StreamSubscription<dynamic> _streamSubscription;

  void _buttonTap() async {
    super.setState(() {
      counter++;
    });
  }

  @override
  void initState() {
    if (!widget.hardcore) {
      _streamSubscription = proximityEvents.listen((event) {
        var p = event.getValue();
        if (_proximity && !p) {
          _buttonTap();
        }
        _proximity = p;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (!widget.hardcore) {
      _streamSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sessionManager = context.use<SessionManager>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              padding: const EdgeInsets.all(16.0),
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () => _showCancelDialog(counter),
            ),
            IconButton(
              padding: const EdgeInsets.all(16.0),
              icon: const Icon(
                Icons.done_all,
                color: Colors.white,
              ),
              onPressed: () {
                sessionManager.insertSession(Session(count: counter));
                widget.trainingMode.value = false;
              },
            ),
          ],
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _buttonTap,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  counter.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 64.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showCancelDialog(int count) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            MyLocalizations.of(context).getLocale('training')['alert']['title'],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  MyLocalizations.of(context).getLocale('training')['alert']
                          ['contents'][0] +
                      count.toString() +
                      MyLocalizations.of(context).getLocale('training')['alert']
                          ['contents'][1],
                ),
                Text(MyLocalizations.of(context).getLocale('training')['alert']
                    ['contents'][2]),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style:
                  TextButton.styleFrom(primary: Theme.of(context).primaryColor),
              child: Text(
                MyLocalizations.of(context).getLocale('training')['alert']
                    ['continue'],
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style:
                  TextButton.styleFrom(primary: Theme.of(context).primaryColor),
              child: Text(
                MyLocalizations.of(context).getLocale('training')['alert']
                    ['end'],
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                widget.trainingMode.value = false;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
