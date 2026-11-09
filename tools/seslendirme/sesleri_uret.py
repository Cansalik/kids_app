"""liste.csv'deki metinleri ElevenLabs ile seslendirir -> sesler/ klasörü.

Kullanım (proje klasöründe):
  python3 tools/seslendirme/sesleri_uret.py --deneme     # 10 örnek dosya
  python3 tools/seslendirme/sesleri_uret.py              # hepsi (var olanları atlar)
  python3 tools/seslendirme/sesleri_uret.py --yeniden kedi.mp3 harika.mp3   # seçilenleri yeniden üret
API anahtarı tools/seslendirme/.elevenlabs_key dosyasından okunur; ekrana yazılmaz.
"""
import csv, json, os, subprocess, sys, time, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
VOICE_ID = "cbqdgvVi3C6sgxIWpqIh"          # Füsun Tuncer
MODELS = ["eleven_v4", "eleven_multilingual_v2"]  # ilk çalışan kullanılır
SETTINGS = {"stability": 0.65, "similarity_boost": 0.75, "style": 0.0, "use_speaker_boost": True}
FORMAT = "mp3_44100_64"
OUT = os.path.join(HERE, "sesler")
DENEME = ["kedi.mp3", "harika.mp3", "dogru_cevap.mp3", "kac_tane_obje_var.mp3", "dokuz_bucuk.mp3",
          "yirmi_bir.mp3", "harf_be.mp3", "hindistan_cevizi.mp3", "itfaiye_araci.mp3", "atin_a_si.mp3"]

key = open(os.path.join(HERE, ".elevenlabs_key")).read().strip()
os.makedirs(OUT, exist_ok=True)
rows = [r for r in csv.DictReader(open(os.path.join(HERE, "liste.csv"), encoding="utf-8")) if r["kaynak"] != "Rakam"]

args = sys.argv[1:]
force = False
if args[:1] == ["--deneme"]:
    rows = [r for r in rows if r["dosya"] in DENEME]
elif args[:1] == ["--yeniden"]:
    sec = set(args[1:]); rows = [r for r in rows if r["dosya"] in sec]; force = True

def tts(text, model):
    body = json.dumps({"text": text, "model_id": model, "language_code": "tr", "voice_settings": SETTINGS})
    with tempfile.NamedTemporaryFile(delete=False, suffix=".mp3") as tmp:
        path = tmp.name
    code = subprocess.run(
        ["curl", "-s", "-o", path, "-w", "%{http_code}", "-X", "POST",
         f"https://api.elevenlabs.io/v1/text-to-speech/{VOICE_ID}?output_format={FORMAT}",
         "-H", f"xi-api-key: {key}", "-H", "Content-Type: application/json", "--data-binary", body],
        capture_output=True, text=True).stdout.strip()
    data = open(path, "rb").read(); os.remove(path)
    return code, data

model = None
done = skipped = 0
for i, r in enumerate(rows, 1):
    dest = os.path.join(OUT, r["dosya"])
    if os.path.exists(dest) and not force:
        skipped += 1; continue
    for attempt in range(5):
        candidates = [model] if model else MODELS
        for m in candidates:
            code, data = tts(r["okunacak"], m)
            if code == "200":
                model = m; break
            if model is None and code in ("400", "422"):
                continue  # bu model yok/desteklenmiyor -> sıradakini dene
            break
        if code == "200":
            open(dest, "wb").write(data); done += 1
            print(f"[{i}/{len(rows)}] {r['dosya']}  <- {r['okunacak']}")
            break
        if code == "429" or code.startswith("5"):
            time.sleep(3 * (attempt + 1)); continue
        print(f"HATA {code} {r['dosya']}: {data[:200].decode('utf-8', 'ignore')}"); sys.exit(1)
print(f"\nBitti. Üretilen: {done}, zaten vardı: {skipped}, model: {model}")
