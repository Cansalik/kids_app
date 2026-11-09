import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

import 'turkish_case.dart';

/// Önceden kaydedilmiş Türkçe seslendirmeler (assets/voice).
/// Metnin kaydı yoksa çağıran taraf cihazın TTS'ine düşer.
class VoiceHelper {
  static final AudioPlayer _player = AudioPlayer();
  static Map<String, String> _map = {};
  static Future<void>? _loading;
  static Completer<void>? _current;
  static int _session = 0;

  /// voice_map.json anahtarlarıyla aynı kural: Türkçe küçük harf,
  /// noktalama yok, tek boşluk.
  static String normalize(String text) => text
      .toLowerTr()
      .replaceAll(RegExp(r'[.,!?:;]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  static Future<void> ensureLoaded() => _loading ??= _load();

  /// Uygulama açılırken çağrılır: eşleşme listesini ve ses oynatıcısını
  /// önceden hazırlar; böylece ilk seslendirme gecikmeden başlar.
  static Future<void> warmUp() async {
    await ensureLoaded();
    try {
      await _player.setSource(AssetSource('voice/harika.mp3'));
    } catch (_) {}
  }

  static Future<void> _load() async {
    try {
      final raw = await rootBundle.loadString('assets/voice/voice_map.json');
      _map = Map<String, String>.from(json.decode(raw) as Map);
      // Arka plan müziğini durdurmadan onunla birlikte çal.
      await _player.setAudioContext(
          AudioContextConfig(focus: AudioContextConfigFocus.mixWithOthers)
              .build());
      await _player.setReleaseMode(ReleaseMode.stop);
    } catch (_) {
      _map = {};
    }
  }

  /// Metnin tamamı ya da "3 + 2 =" gibi işlem cümlesi için dosya listesi.
  static List<String>? _filesFor(String text) {
    final key = normalize(text);
    final whole = _map[key];
    if (whole != null) return [whole];

    final op = RegExp(r'^(\d+) ?(\+|-|eksi|artı) ?(\d+) ?=?$').firstMatch(key);
    if (op != null) {
      final sign =
          (op.group(2) == '+' || op.group(2) == 'artı') ? 'artı' : 'eksi';
      final parts = [op.group(1)!, sign, op.group(3)!, 'eşittir']
          .map((p) => _map[p])
          .toList();
      if (parts.every((p) => p != null)) return parts.cast<String>();
    }
    return null;
  }

  static bool canPlay(String text) => _filesFor(text) != null;

  /// Kaydı çalar ve bitmesini bekler. Kayıt yoksa false döner.
  static Future<bool> play(String text) async {
    await ensureLoaded();
    final files = _filesFor(text);
    if (files == null) return false;

    final session = ++_session;
    for (final file in files) {
      if (session != _session) break;
      final done = Completer<void>();
      _current = done;
      final sub = _player.onPlayerComplete.listen((_) {
        if (!done.isCompleted) done.complete();
      });
      try {
        await _player.stop();
        await _player.play(AssetSource('voice/$file'));
        await done.future
            .timeout(const Duration(seconds: 6), onTimeout: () {});
      } catch (_) {
        // Çalınamazsa sessiz geç; uygulama akışı durmasın.
      } finally {
        await sub.cancel();
      }
    }
    return true;
  }

  static Future<void> stop() async {
    _session++;
    final c = _current;
    if (c != null && !c.isCompleted) c.complete();
    try {
      await _player.stop();
    } catch (_) {}
  }
}
