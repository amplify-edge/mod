import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
import 'package:sys_core/sys_core.dart';
import 'translations.dart';

String surveyTranslate(String key) {
  return ModSurveyLocalizations.instance.translate(key);
}

class ModSurveyLocalizations extends Translations {
  final Locale locale;
  static Map<String, String> _localizedStrings;

  ModSurveyLocalizations(this.locale);

  static const LocalizationsDelegate<ModSurveyLocalizations> delegate =
      ModSurveyLocalizationsDelegate();

  static ModSurveyLocalizations get instance =>
      ModSurveyLocalizationsDelegate.instance;

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString(
        'packages/mod_survey/i18n/lang_${locale.languageCode}.json');

    Map<String, dynamic> jsonMap = Map.from(json.decode(jsonString))
      ..removeWhere((key, value) => key[0] == '@');

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key];
  }

  static ModSurveyLocalizations of(BuildContext context) {
    return Localizations.of<ModSurveyLocalizations>(
        context, ModSurveyLocalizations);
  }
}

class ModSurveyLocalizationsDelegate
    extends LocalizationsDelegate<ModSurveyLocalizations> {
  // final Locale overriddenLocale;
  // TODO @gutterbacon: temp workaround to translate without BuildContext
  static ModSurveyLocalizations instance;
  // workaround as const
  const ModSurveyLocalizationsDelegate();

  @override
  bool shouldReload(ModSurveyLocalizationsDelegate old) => true;

  @override
  bool isSupported(Locale locale) {
    return Languages.supportedLanguages.keys
        .contains(locale.languageCode.toString());
  }

  @override
  Future<ModSurveyLocalizations> load(Locale locale) async {
    ModSurveyLocalizations localizations = new ModSurveyLocalizations(locale);
    await localizations.load();
    instance = localizations;
    return localizations;
  }
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => Languages.supportedLanguages.keys
      .contains(locale.languageCode.toString());

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<_DefaultCupertinoLocalizations>(
          _DefaultCupertinoLocalizations(locale));

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}

class _DefaultCupertinoLocalizations extends DefaultCupertinoLocalizations {
  final Locale locale;

  _DefaultCupertinoLocalizations(this.locale);
}
