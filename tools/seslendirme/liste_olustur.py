"""Uygulamada seslendirilen tüm metinleri toplar -> tools/seslendirme/liste.csv
Sütunlar: dosya, anahtar (uygulamanın gönderdiği metin, normalize), okunacak (seslendirilecek metin), kaynak
"""
import sqlite3, re, csv, os
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
db = sqlite3.connect(os.path.join(ROOT, 'assets/database/KidsPlayroom.db'))
lang = open(os.path.join(ROOT, 'lib/localization/languages/language_tr.dart'), encoding='utf-8').read()
TR = {m.group(1): m.group(2) for m in re.finditer(r"""^\s*['"](.+?)['"]\s*:\s*["'](.+?)["']\s*,?\s*$""", lang, re.M)}
tr = lambda s: TR.get(s, s)

def low(s):
    s = s.replace('İ', 'i').replace('I', 'ı').lower()
    return re.sub(r'\s+', ' ', s).strip()

def slug(s):
    t = low(s)
    for a, b in zip('çğıöşüâî', 'cgiosuai'):
        t = t.replace(a, b)
    t = re.sub(r'[^a-z0-9]+', '_', t).strip('_')
    return t or 'x'

rows = {}  # anahtar -> (okunacak, kaynak)
FIX = {"Havuçun H'Si": "Havucun H'si", "Papağanın P'Si": "Papağanın P'si",
       "Saatin S'si": "Saatin sesi"}  # "S'si" -> "es i" okunuyordu
def add(key, speak=None, src='', force=False):
    if not key or not str(key).strip():
        return
    k = low(str(key))
    sp = (speak or str(key)).strip()
    sp = FIX.get(sp, sp)
    if force or k not in rows:
        rows[k] = (sp, src)

# 1) Veritabanı
for t, col in [('ItemTable', 'item_name_tts'), ('DragItemsTable', 'item_name'), ('DragSpellingTable', 'spelling')]:
    for (v,) in db.execute(f'select {col} from {t}'):
        add(tr(v), src=t)
for t in ['CategoryTable', 'SubCategoryTable', 'DragCategoryTable']:
    cols = [r[1] for r in db.execute(f'pragma table_info({t})')]
    name = next(c for c in cols if 'name' in c)
    for (v,) in db.execute(f'select {name} from {t}'):
        add(tr(v), src=t)
# Alfabe ekranı ("Atın A'sı"); yazım hataları okunacak metinde düzeltilir
for (v,) in db.execute('select tts_text from DragAlphabetsTable'):
    add(v, src='Alfabe')

# 2) Sabit cümleler
for s in ['Harika', 'Tebrikler', 'Doğru Cevap', 'Yanlış Cevap', 'Objeleri say', 'Kaç Tane Obje Var?',
          'Hangisi daha az?', 'Hangisi daha fazla?', 'artı', 'eksi', 'eşittir']:
    add(s, src='Sabit')
tc = open(os.path.join(ROOT, 'lib/ui/time/controller/time_controller.dart'), encoding='utf-8').read()
for m in re.finditer(r'"\d\d:\d\d"\s*:\s*"([^"]+)"', tc):
    add(m.group(1), src='Saat')
for k in ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October',
          'November', 'December', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']:
    if k in TR:
        add(TR[k], src='Ay/Gün')

# 3) Sayılar 0-100: hem rakam ("5") hem yazı ("beş") aynı dosyayı kullanır
birler = ['', 'bir', 'iki', 'üç', 'dört', 'beş', 'altı', 'yedi', 'sekiz', 'dokuz']
onlar = ['', 'on', 'yirmi', 'otuz', 'kırk', 'elli', 'altmış', 'yetmiş', 'seksen', 'doksan']
def yazi(n):
    if n == 0: return 'sıfır'
    if n == 100: return 'yüz'
    return (onlar[n // 10] + ' ' + birler[n % 10]).strip()
for n in range(0, 101):
    add(yazi(n), src='Sayı')

# 4) Harfler (tek harf seslendirmesi)
harf = {'a': 'a', 'b': 'be', 'c': 'ce', 'ç': 'çe', 'd': 'de', 'e': 'e', 'f': 'fe', 'g': 'ge', 'ğ': 'yumuşak ge',
        'h': 'he', 'ı': 'ı', 'i': 'i', 'j': 'je', 'k': 'ke', 'l': 'le', 'm': 'me', 'n': 'ne', 'o': 'o', 'ö': 'ö',
        'p': 'pe', 'q': 'kü', 'r': 're', 's': 'se', 'ş': 'şe', 't': 'te', 'u': 'u', 'ü': 'ü', 'v': 've',
        'w': 'çift ve', 'x': 'iks', 'y': 'ye', 'z': 'ze'}
for k, v in harf.items():
    add(k, v, 'Harf', force=True)

# Çıktı
used = set(); out = []
for k, (speak, src) in sorted(rows.items(), key=lambda x: (x[1][1], x[0])):
    f = ('harf_' + slug(speak)) if src == 'Harf' else slug(k)
    base, i = f, 2
    while f in used:
        f = f'{base}_{i}'; i += 1
    used.add(f); out.append((f + '.mp3', k, speak, src))
# rakam anahtarları (0-100) -> sayı dosyası
digit_rows = [(next(r[0] for r in out if r[1] == low(yazi(n))), str(n), yazi(n), 'Rakam') for n in range(0, 101)]
with open(os.path.join(os.path.dirname(__file__), 'liste.csv'), 'w', encoding='utf-8', newline='') as fh:
    w = csv.writer(fh); w.writerow(['dosya', 'anahtar', 'okunacak', 'kaynak']); w.writerows(out + digit_rows)
print('seslendirilecek dosya:', len(out), '| toplam karakter:', sum(len(r[2]) for r in out),
      '| rakam anahtarı:', len(digit_rows))
from collections import Counter; print(Counter(r[3] for r in out))
