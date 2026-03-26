import 'dart:async';

import 'package:get_storage/get_storage.dart';


class Preference {
  static const String authorization = "AUTHORIZATION";

  static const String selectedLanguage = "LANGUAGE";
  static const String selectedCountryCode = "SELECTED_COUNTRY_CODE";
  static const String isSOUND = "SOUND";
  static const String isMusic = "Music";
  static const String hintAnimal = "HINT_ANIMAL";
  static const String hintFruits = "HINT_FRUITS";
  static const String hintBirds = "HINT_BIRDS";
  static const String hintShapes = "HINT_SHAPES";
  static const String hintEducation = "HINT_EDUCATION";
  static const String hintVehicles = "HINT_VEHICLES";
  static const String hintMoney = "HintMoney";
  static const String trackStatus = "TRACK_STATUS";
  static const String interstitialCount = "INTERSTITIAL_COUNT";


  static const String isPurchasePremium = "IS_PURCHASE_PREMIUM";
  static const String interstitialAdCount = "INTERSTITIAL_AD_COUNT";


  static const String isFirstTimeOpenApp = "IS_FIRST_TIME_OPEN_APP";


 /// ------------------ SINGLETON -----------------------
  static final Preference _preference = Preference._internal();

  factory Preference() {
    return _preference;
  }

  Preference._internal();

  static Preference get shared => _preference;

  static GetStorage? _pref;


  Future<GetStorage?> instance() async {
    if (_pref != null) return _pref;
    await GetStorage.init().then((value) {
      if (value) {
        _pref = GetStorage();
      }
    }).catchError((onError) {
      _pref = null;
    });
    return _pref;
  }

  String? getString(String key) {
    return _pref!.read(key);
  }

  Future<void> setString(String key, String value) {
    return _pref!.write(key, value);
  }

  int? getInt(String key) {
    return _pref!.read(key);
  }

  Future<void> setInt(String key, int value) {
    return _pref!.write(key, value);
  }

  bool? getBool(String key) {
    return _pref!.read(key);
  }

  Future<void> setBool(String key, bool value) {
    return _pref!.write(key, value);
  }

  double? getDouble(String key) {
    return _pref!.read(key);
  }

  Future<void> setDouble(String key, double value) {
    return _pref!.write(key, value);
  }

  List<String>? getStringList(String key) {
    return _pref!.read(key);
  }

  Future<void> setStringList(String key, List<String> value) {
    return _pref!.write(key, value);
  }


  /// In app purchase
  Future<void> setIsPurchase(bool value) {
    return _pref!.write(isPurchasePremium, value);
  }

  bool getIsPurchase() {
    return _pref!.read(isPurchasePremium) ?? false;
  }

  /// google ad
  int getInterstitialAdCount() {
    return _pref!.read(interstitialAdCount) ?? 1;
  }
  Future<void> setInterstitialAdCount(int value) {
    return _pref!.write(interstitialAdCount, value);
  }

  Future<void> remove(key, [multi = false]) async {
    GetStorage? pref = await instance();
    if (multi) {
      key.forEach((f) async {
        return await pref!.remove(f);
      });
    } else {
      return await pref!.remove(key);
    }
  }


  static Future<bool> clear() async {
    _pref!.getKeys().forEach((key) async {
      await _pref!.remove(key);
    });

    return Future.value(true);
  }

  static Future<bool> clearLogout() async {
    return Future.value(true);
  }

}
