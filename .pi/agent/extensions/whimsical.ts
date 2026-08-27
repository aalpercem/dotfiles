import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const messages = [
  // Short
  "Vibing...",
  "Tokenmaxxing...",
  "Abracadabraing...",
  "Caffeinating...",
  "Procrastinating...",

  // --- Short & Fun ---
  "Demleniyor...",
  "Kurcalanıyor...",
  "Beyin fırtınası esiyor...",
  "Çarklar dönüyor...",
  "Pürüzler düzeltiliyor...",
  "İnce ayar çekiliyor...",
  "Üflenip okunuyor...",
  "Cıvatalar sıkılıyor...",
  "Sihir yapılıyor...",
  "Zbab ivj'laniyor...",

  // --- Long & Geek ---
  "Kisik ateste pisiriliyor...",
  "Bir bardak soguk su iciliyor...",
  "Eski yazilimciya sovuluyor...",
  "Iki tik tik bi şık şık yapiliyor...",
  "Nazar duasi okunuyor...", 
  "Kodla derin bir sohbet ediliyor...",
  "Compiler'a rüşvet veriliyor...",
  "Derleme tanrılarına adak adanıyor...",
  "Kendi kendine duzelir mi diye bekleniyor...",
  "Garbage collector ile pazarlık yapılıyor...",
  "Merge confict'ler arasinda hellallesiliyor...",
  "Bug'lar sevgiyle temizleniyor...",
  "Rubber duck'a soru soruluyor...",
  "Noktalı virgüller hizalanıyor...",
  "Stack Overflow'da gezintiye çıkıldı...",
  "Algoritmanın çayı tazeleniyor...",
  "Sunucuya moral desteği veriliyor...",
  "Spagetti kod çözülüyor...",
  "RAM'deki kediler hizaya sokuluyor...",
  "Cache'e tatlı dille yaklaşılıyor...",
  "Sonsuz döngüye masal anlatılıyor...",
  "Linter ile barış imzalanıyor...",
  "Veritabanıyla helalleşiliyor...",
  "Prod ortamı için dualar ediliyor...",
];

function pickRandom(): string {
  return messages[Math.floor(Math.random() * messages.length)]!;
}

export default function (pi: ExtensionAPI) {
  pi.on("turn_start", async (_event, ctx) => {
    ctx.ui.setWorkingMessage(pickRandom());
  });

  pi.on("turn_end", async (_event, ctx) => {
    ctx.ui.setWorkingMessage(); // Reset for next time
  });
}
