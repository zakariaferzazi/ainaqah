import 'package:flutter/material.dart';

class Language {
  int id;
  String name;
  String languageCode;
  String? fullLanguageCode;
  String? flag;

  Language(this.id, this.name, this.languageCode);

  static List<Language> getLanguages() {
    return <Language>[
      Language(0, 'English', 'en'),
     // Language(1, 'Afrikaans', 'af'),
      Language(1, 'Arabic', 'ar'),
     // Language(3, 'Bengali', 'bn'),
     // Language(4, 'German', 'de'),
     // Language(5, 'Spanish', 'es'),
     // Language(6, 'French', 'fr'),
     // Language(7, 'Hebrew', 'he'),
     // Language(8, 'Hindi', 'hi'),
     // Language(9, 'Italian', 'it'),
     // Language(10, 'Japanese', 'ja'),
     // Language(11, 'Korean', 'ko'),
     // Language(12, 'Marathi', 'mr'),
     // Language(13, 'Nepali', 'ne'),
     // Language(14, 'dutch', 'nl'),
     // Language(15, 'portuguese', 'pt'),
     // Language(16, 'Romanian', 'ro'),
     // Language(17, 'Tamil', 'ta'),
     // Language(18, 'Telugu', 'te'),
     // Language(19, 'Thai', 'th'),
     // Language(20, 'Turkish', 'tr'),
     // Language(21, 'Vietnamese', 'vi'),
     // Language(22, 'Chinese', 'zh'),
    ];
  }

  static List<String> languages() {
    List<String> list = [];

    getLanguages().forEach((element) {
      list.add(element.languageCode);
    });

    return list;
  }

  static List<Locale> languagesLocale() {
    List<Locale> list = [];

    getLanguages().forEach((element) {
      list.add(Locale(element.languageCode, ''));
    });

    return list;
  }
}
