/// Türkçeye uygun büyük/küçük harf dönüşümü.
///
/// Dart'ın toUpperCase()/toLowerCase() fonksiyonları Türkçeyi bilmez:
/// "i" -> "I" (doğrusu "İ"), "İ" -> "i̇" (fazladan görünmez nokta) olur.
extension TurkishCase on String {
  String toUpperTr() =>
      replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase();

  String toLowerTr() =>
      replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase();
}
