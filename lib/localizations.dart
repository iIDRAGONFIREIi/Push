import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyLocalizations {
  MyLocalizations(this.locale);

  final Locale locale;

  static MyLocalizations of(BuildContext context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  static Map<String, Map<String, dynamic>> _localizedValues = {
    'en': {
      'title': 'Minimalistic Push',
      'onboarding': {
        'locations': [
          'Page 1',
          'Page 2',
          'Page 3',
        ],
        'titles': [
          'Instructions',
          'Benefits',
          'Let\'s go!',
        ],
        'welcome': [
          'Welcome to',
          'The simplest push-up tracker.',
        ],
        'instructions': [
          'Record your sessions in the \'Training Mode\'.',
          'Delete previous sessions in the \'Sessions Overview\'.',
          'Watch your improvement.',
        ],
        'benefits': [
          'Track your improvement over time.',
          'Keep your data on your device.',
          'Support open-source development.',
        ]
      },
      'training': {
        'title': 'Training Mode',
        'start': 'Start',
        'alert': {
          'title': 'Wohoo!',
          'contents': [
            'It seems like your counter is already at ',
            '.',
            'Do you want to end your session?',
          ],
          'continue': 'Let me finish this.',
          'end': 'I\'m done.',
        },
      },
      'sessions': {
        'title': 'Sessions Overview',
        'empty': 'You should record a session.',
      },
      'settings': {
        'title': 'Settings',
        'themes': {
          'title': 'Themes',
          'description':
              'You can choose your preferred theme. You have a theme idea? Check my website for instructions.',
        },
        'about': 'About',
        'thanks':
            'Thank you so much for using my app \'Minimalistic Push\'. Feel free to check out the GitHub repository.',
        'github button': 'View the source-code on GitHub.',
      },
      'share': {
        'subject': 'That\'s my Curve!',
        'text': 'Hey, check out my curve in #minimalisticpush!',
      },
    },
    'de': {
      'title': 'Minimalistic Push',
      'onboarding': {
        'locations': [
          'Seite 1',
          'Seite 2',
          'Seite 3',
        ],
        'titles': [
          'Erklärung',
          'Vorteile',
          'Los geht\'s!',
        ],
        'welcome': [
          'Willkommen bei',
          'Der einfachste Liegestütz-Tracker.',
        ],
        'instructions': [
          'Schließe Sessions im \'Trainingsmodus\' ab.',
          'Lösche vorherige Sessions im \'Sessions Überblick\'.',
          'Sieh deine Verbesserungen.',
        ],
        'benefits': [
          'Verfolge die Verbesserungen.',
          'Behalten deine Daten auf deinem Smartphone.',
          'Unterstütze open-source Entwicklung.',
        ]
      },
      'training': {
        'title': 'Trainingsmodus',
        'start': 'Start',
        'alert': {
          'title': 'Wohoo!',
          'contents': [
            'Es sieht so aus, als wäre dein Zähler schon bei ',
            '.',
            'Willst du diese Session schon beenden?',
          ],
          'continue': 'Lass mich noch etwas.',
          'end': 'Bin fertig.',
        },
      },
      'sessions': {
        'title': 'Sessions Überblick',
        'empty': 'Du musst zuerst eine Session abschließen.',
      },
      'settings': {
        'title': 'Einstellungen',
        'themes': {
          'title': 'Themes',
          'description':
              'Hier kannst du ein Theme auswählen, das dir gefällt. Du hast eine Idee für ein neues Theme? Auf meiner Internetseite kannst du dich hierzu informieren.',
        },
        'about': 'Über',
        'thanks':
            'Vielen Dank, dass du meine App \'Minimalistic Push\' verwendest. Gerne kannst du dir das GitHub Repository dieser App ansehen.',
        'github button': 'Den Quellcode auf GitHub ansehen.',
      },
      'share': {
        'subject': 'Das ist meine Kurve!',
        'text': 'Hey, sieh Dir meine Kurve in #minimalisticpush an!',
      },
    },
  };

  dynamic getLocale(String key) {
    return _localizedValues[locale.languageCode][key];
  }
}

class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<MyLocalizations> load(Locale locale) {
    return SynchronousFuture<MyLocalizations>(MyLocalizations(locale));
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}
