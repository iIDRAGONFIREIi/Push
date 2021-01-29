import 'package:flutter/material.dart';

import 'package:minimalisticpush/controllers/preferences_controller.dart';
import 'package:minimalisticpush/controllers/session_controller.dart';
import 'package:minimalisticpush/localizations.dart';
import 'package:minimalisticpush/screens/error_screen.dart';
import 'package:minimalisticpush/styles/styles.dart';
import 'package:minimalisticpush/widgets/background.dart';
import 'package:minimalisticpush/widgets/custom_button.dart';
import 'package:minimalisticpush/widgets/icon_description_list.dart';
import 'package:minimalisticpush/widgets/location_text.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: 0);

    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints.expand(),
      child: PageView.builder(
        onPageChanged: (value) {
          Background.instance.setSessions([0.2, 0.4, 0.6, 0.8, 1.0]);

          switch (value) {
            case 0:
              Background.instance.factorNotifier.value = 0.0;
              break;
            case 1:
              Background.instance.factorNotifier.value = 0.6;
              break;
            case 2:
              Background.instance.factorNotifier.value = 1.0;
              break;
          }
        },
        controller: pageController,
        itemCount: 3,
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LocationText(
                      text: MyLocalizations.of(context)
                          .getLocale('onboarding')['locations'][index],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        MyLocalizations.of(context)
                            .getLocale('onboarding')['welcome'][0],
                        style: TextStyles.subHeading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        MyLocalizations.of(context).getLocale('title'),
                        style: TextStyles.heading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        MyLocalizations.of(context)
                            .getLocale('onboarding')['welcome'][1],
                        style: TextStyles.subHeading,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomButton(
                        text: MyLocalizations.of(context)
                            .getLocale('onboarding')['titles'][index],
                        onTap: () {
                          pageController.animateToPage(
                            1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOutQuart,
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
              break;
            case 1:
              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LocationText(
                      text: MyLocalizations.of(context)
                          .getLocale('onboarding')['locations'][index],
                    ),
                    Spacer(),
                    IconDescriptionList(
                      elements: [
                        ListElement(
                          number: 1,
                          description: MyLocalizations.of(context)
                              .getLocale('onboarding')['instructions'][0],
                        ),
                        ListElement(
                          number: 2,
                          description: MyLocalizations.of(context)
                              .getLocale('onboarding')['instructions'][1],
                        ),
                        ListElement(
                          number: 3,
                          description: MyLocalizations.of(context)
                              .getLocale('onboarding')['instructions'][2],
                        ),
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomButton(
                        text: MyLocalizations.of(context)
                            .getLocale('onboarding')['titles'][index],
                        onTap: () {
                          pageController.animateToPage(
                            2,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOutQuart,
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
              break;
            case 2:
              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LocationText(
                      text: MyLocalizations.of(context)
                          .getLocale('onboarding')['locations'][index],
                    ),
                    Spacer(),
                    IconDescriptionList(
                      elements: [
                        ListElement(
                          iconData: Icons.bar_chart,
                          description: MyLocalizations.of(context)
                              .getLocale('onboarding')['benefits'][0],
                        ),
                        ListElement(
                          iconData: Icons.cloud_off,
                          description: MyLocalizations.of(context)
                              .getLocale('onboarding')['benefits'][1],
                        ),
                        ListElement(
                          iconData: Icons.code,
                          description: MyLocalizations.of(context)
                              .getLocale('onboarding')['benefits'][2],
                        ),
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomButton(
                        text: MyLocalizations.of(context)
                            .getLocale('onboarding')['titles'][index],
                        onTap: () {
                          SessionController.instance.setNormalizedSessions();
                          PreferencesController.instance.acceptOnboarding();
                        },
                      ),
                    )
                  ],
                ),
              );
              break;
            default:
              return ErrorScreen();
              break;
          }
        },
      ),
    );
  }
}
