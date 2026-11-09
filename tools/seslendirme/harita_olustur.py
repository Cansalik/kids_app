"""liste.csv -> assets/voice/voice_map.json  (anahtar -> dosya). Uygulama metni bu anahtarla arar."""
import csv, json, os, re
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.join(HERE, '..', '..')
def norm(s):
    s = s.replace('İ', 'i').replace('I', 'ı').lower()
    s = re.sub(r'[.,!?:;]', '', s)
    return re.sub(r'\s+', ' ', s).strip()
m = {}
for r in csv.DictReader(open(os.path.join(HERE, 'liste.csv'), encoding='utf-8')):
    if os.path.exists(os.path.join(ROOT, 'assets/voice', r['dosya'])):
        m.setdefault(norm(r['anahtar']), r['dosya'])
json.dump(m, open(os.path.join(ROOT, 'assets/voice/voice_map.json'), 'w', encoding='utf-8'), ensure_ascii=False, sort_keys=True)
print('anahtar:', len(m))
