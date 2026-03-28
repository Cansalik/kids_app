import 'package:get/get.dart';
import 'languages/language_en.dart';
import 'languages/language_tr.dart';


class AppLanguages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    "en_US": enUS,
    "tr_TR": trTR,

  };
}

final List<LanguageModel> languages = [

  LanguageModel("🇦🇱", "Albanian (shqiptare)", 'sq', 'AL'),
  LanguageModel("🇸🇦", "(عربى) Arabic", 'ar', 'SA'),
  LanguageModel("🇦🇿", "Azerbaijani (Azərbaycan)", 'az', 'AF'),
  LanguageModel("🇮🇳", "Bengali (বাংলা)", 'bn', 'IN'),
  LanguageModel("🇲🇲", "Burmese (မြန်မာ)", 'my', 'MM'),
  LanguageModel("🇨🇳", "Chinese Simplified (中国人)", 'zh', 'CN'),
  LanguageModel("🇹🇼", "Chinese Traditional (中國人)", 'zh', 'TW'),
  LanguageModel("🇭🇷", "Croatian (Hrvatski)", 'hr', 'HR'),
  LanguageModel("🇨🇿", "Czech (čeština)", 'cs', 'CZ'),
  LanguageModel("🇳🇱", "Dutch (Nederlands)", 'nl', 'NL'),
  LanguageModel("🇺🇸", "English (English)", 'en', 'US'),
  LanguageModel("🇫🇷", "French (français)", 'fr', 'FR'),
  LanguageModel("🇩🇪", "German (Deutsche)", 'de', 'DE'),
  LanguageModel("🇬🇷", "Greek (Ελληνικά)", 'el', 'GR'),
  LanguageModel("🇮🇳", "Gujarati (ગુજરાતી)", 'gu', 'IN'),
  LanguageModel("🇳🇬", "Hausa (Hausa)", 'ha', 'NG'),
  LanguageModel("🇮🇳", "Hindi (हिंदी)", 'hi', 'IN'),
  LanguageModel("🇭🇺", "Hungarian (Magyar)", 'hu', 'HU'),
  LanguageModel("🇮🇩", "Indonesian (bahasa indo)", 'id', 'ID'),
  LanguageModel("🇮🇹", "Italian (italiana)", 'it', 'IT'),
  LanguageModel("🇯🇵", "Japanese (日本)", 'ja', 'JP'),
  LanguageModel("🇮🇩", "Javanese (basa jawa)", 'jv', 'ID'),
  LanguageModel("🇮🇳", "Kannada (ಕನ್ನಡ)", 'kn', 'IN'),
  LanguageModel("🇰🇵", "Korean (한국인)", 'ko', 'KR'),
  LanguageModel("🇫🇷", "Latin (Latinus)", 'la', 'FR'),
  LanguageModel("🇮🇳", "Malayalam (മലയാളം)", 'ml', 'IN'),
  LanguageModel("🇮🇳", "Marathi (मराठी)", 'mr', 'IN'),
  LanguageModel("🇮🇳", "Assamese (অসমীয়া)", 'as', 'IN'),
  LanguageModel("🇳🇴", "Norwegian (norsk)", 'nb', 'NO'),
  LanguageModel("🇮🇳", "Odia (ଓଡିଆ)", 'or', 'IN'),
  LanguageModel("🇮🇷", "Persian (فارسی)", 'fa', 'IR'),
  LanguageModel("🇵🇱", "Polish (Polski)", 'pl', 'PL'),
  LanguageModel("🇵🇹", "Portuguese (português)", 'pt', 'PT'),
  LanguageModel("🇮🇳", "Punjabi (ਪੰਜਾਬੀ)", 'pa', 'IN'),
  LanguageModel("🇷🇴", "Romanian (Română)", 'ro', 'RO'),
  LanguageModel("🇷🇺", "Russian (русский)", 'ru', 'RU'),
  LanguageModel("🇪🇸", "Spanish (Español)", 'es', 'ES'),
  LanguageModel("🇮🇩", "Sundanese (basa Sunda)", 'su', 'ID'),
  LanguageModel("🇸🇪", "Swedish (svenska)", 'sv', 'SE'),
  LanguageModel("🇮🇳", "Tamil (தமிழ்)", 'ta', 'IN'),
  LanguageModel("🇮🇳", "Telugu (తెలుగు)", 'te', 'IN'),
  LanguageModel("🇹🇭", "Thai (แบบไทย)", 'th', 'TH'),
  LanguageModel("🇹🇷", "Turkish (Türk)", 'tr', 'TR'),
  LanguageModel("🇺🇦", "Ukrainian (українська)", 'uk', 'UA'),
  LanguageModel("🇵🇰", "(اردو) Urdu", 'ur', 'PK'),
  LanguageModel("🇻🇳", "Vietnamese (Tiếng Việt)", 'vi', 'VN'),
  LanguageModel("🇳🇬", "Yoruba (Yoruba)", 'yo', 'NG'),

];

class LanguageModel {
  LanguageModel(
    this.symbol,
    this.language,
    this.languageCode,
    this.countryCode,
  );

  String language;
  String symbol;
  String countryCode;
  String languageCode;
}
