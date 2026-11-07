# Autentikasi API

API tidak punya halaman login, cookie sesi, atau pengguna yang mengklik tombol. Klien (aplikasi seluler, SPA, layanan lain) harus **membuktikan identitasnya di setiap permintaan** lewat kredensial yang dibawa
di header. Sub bab ini membahas konsep autentikasi API: mengapa sesi tidak cocok, jenis kredensial (kunci API, token akses pribadi, OAuth), cara token disimpan dan dicabut dengan aman, serta pilihan yang
disediakan ekosistem Laravel. Pemasangan dan pemakaian paket autentikasi dibahas pada sub bab berikutnya.

## Tujuan Pembelajaran

Setelah menyelesaikan sub bab ini, kamu dapat:

- [ ] Menjelaskan perbedaan autentikasi berbasis sesi dan berbasis token.
- [ ] Menjelaskan skema header `Authorization: Bearer <token>`.
- [ ] Membedakan kunci API, token akses pribadi, dan OAuth 2.0.
- [ ] Menjelaskan praktik aman token: di-hash di server, berumur terbatas, dapat dicabut, dan memiliki cakupan (*abilities*).
- [ ] Menjelaskan perbedaan SPA (sesi + CSRF) dan klien seluler/pihak ketiga (token).
- [ ] Menyebut pilihan Laravel (Sanctum, Passport) dan kapan masing-masing cocok.

## Prasyarat

- [Pengantar Autentikasi](../level-05/05-08-introduction-to-authentication.md) dan [Hashing Kata Sandi](../level-05/05-12-password-hashing.md).
- [Penanganan Error API](06-11-api-error-handling.md) dan [CSRF](../level-05/05-20-csrf-protection.md).
- Pemahaman header HTTP.

## Pengantar

Saat ini endpoint tulis API dilindungi satu kunci rahasia yang dipakai bersama. Kelemahannya jelas: tidak diketahui siapa pelakunya, tidak bisa mencabut akses satu klien tanpa mengganti kunci untuk semua, dan
tidak ada pembatasan hak. Autentikasi yang benar menjawab ketiganya.

## Penjelasan Konsep

### Sesi vs token

| Aspek | Sesi (web) | Token (API) |
|---|---|---|
| Bukti identitas | Cookie sesi | Header `Authorization` |
| Disimpan di klien | Browser mengelola cookie | Aplikasi mengelola token |
| Status di server | Data sesi | Catatan token (atau token mandiri bertanda tangan) |
| Risiko khas | CSRF | Pencurian token, kebocoran log |
| Cocok untuk | Aplikasi web berbasis browser | Seluler, layanan, pihak ketiga |

Karena API stateless, setiap permintaan membawa token. Tanpa cookie otomatis, CSRF bukan ancaman utama; kebocoran token menjadi risiko utama.

### Skema Bearer

```http
GET /api/v1/me HTTP/1.1
Host: contoh.test
Accept: application/json
Authorization: Bearer 3|aBcDeF...
```

Siapa pun yang memegang token dapat bertindak sebagai pemiliknya (*bearer*): token diperlakukan seperti kata sandi. Selalu lewat HTTPS dan jangan menaruhnya di URL (tercatat di log dan riwayat).

### Jenis kredensial

| Jenis | Ciri | Kelemahan | Cocok untuk |
|---|---|---|---|
| Kunci API tunggal | Satu string untuk semua | Tidak ada identitas, sulit dicabut sebagian | Prototipe, layanan internal kecil |
| Token akses pribadi | Token per pengguna/perangkat, dapat dicabut, punya cakupan | Pengelolaan token | Aplikasi seluler, SPA, integrasi pengguna |
| OAuth 2.0 | Delegasi akses oleh pihak ketiga dengan persetujuan pengguna, token berumur pendek + refresh | Kompleks | Platform terbuka yang memberi akses ke aplikasi pihak ketiga |
| JWT (token mandiri) | Token bertanda tangan berisi klaim | Sulit dicabut sebelum kedaluwarsa | Layanan terdistribusi (dengan kehati-hatian) |

### Praktik aman token

| Praktik | Alasan |
|---|---|
| Simpan **hash** token di database, tampilkan token polos hanya sekali | Pencurian database tidak membocorkan token |
| Token acak panjang (entropi tinggi) | Mustahil ditebak |
| Umur terbatas atau kedaluwarsa | Membatasi kerusakan bila bocor |
| Dapat dicabut per token | Logout satu perangkat; respons insiden |
| Cakupan/kemampuan (*abilities*) | Hak terkecil per token (`articles:read`, `articles:write`) |
| Catat penggunaan terakhir | Mendeteksi token tidak aktif atau mencurigakan |
| Rotasi | Ganti token berkala |
| HTTPS wajib | Token tidak boleh lewat jaringan terbuka |

### Alur token pribadi

```mermaid
sequenceDiagram
    participant K as Klien (seluler)
    participant S as Server API
    K->>S: POST /login (email, sandi)
    S->>S: verifikasi, buat token acak (simpan hash)
    S-->>K: token polos (sekali tampil)
    K->>S: GET /api/v1/me (Authorization: Bearer token)
    S->>S: cari hash token → pengguna + abilities
    S-->>K: data milik pengguna
    K->>S: POST /logout (cabut token)
```

### SPA dan klien seluler

- **SPA di domain yang sama (atau subdomain)**: dapat memakai autentikasi sesi berbasis cookie dengan perlindungan CSRF; tidak perlu menyimpan token di JavaScript.
- **Aplikasi seluler / pihak ketiga**: memakai token akses pribadi.

Menyimpan token di `localStorage` membuatnya terbaca skrip XSS; cookie `HttpOnly` lebih aman terhadap pencurian lewat XSS tetapi memerlukan perlindungan CSRF.

### Pilihan di ekosistem Laravel

| Paket | Fungsi | Kapan |
|---|---|---|
| **Laravel Sanctum** | Token akses pribadi sederhana + autentikasi sesi untuk SPA | Sebagian besar aplikasi: seluler, SPA, token pribadi |
| **Laravel Passport** | Server OAuth 2.0 lengkap | Bila menyediakan OAuth bagi aplikasi pihak ketiga |

Menurut dokumentasi, `php artisan install:api` memasang Sanctum dan membuat `routes/api.php`. Keduanya adalah paket resmi tambahan (dependensi baru), sehingga pemakaiannya mengikuti persetujuan.

### Anti-pola

- Mengirim token di query string.
- Token tanpa kedaluwarsa dan tanpa pencabutan.
- Menyimpan token polos di database.
- Satu kunci bersama untuk semua klien.
- Mengembalikan detail berbeda untuk "pengguna tidak ada" dan "sandi salah" pada login API.
- Mencatat header `Authorization` di log.

### Keamanan

- Selalu HTTPS; batasi laju endpoint login dan penerbitan token (sub bab 05.24).
- Token baru dikembalikan sekali; pengguna melihat daftar token aktif dan dapat mencabutnya.
- Saat kata sandi diubah, cabut semua token lain.
- Gunakan cakupan sempit untuk token integrasi.

## Cara Kerja

```mermaid
flowchart LR
    R["Request + Authorization: Bearer token"] --> G["Guard token: hash(token) cocok?"]
    G -->|Tidak| X["401"]
    G -->|Ya| U["Pengguna + abilities dimuat"]
    U --> P["Policy/Gate memeriksa hak"]
    P -->|Tidak| F["403"]
    P -->|Ya| C["Controller"]
```

## Contoh Praktik

Tanpa memasang apa pun, kamu merancang skema autentikasi API untuk proyek: memilih jenis kredensial, menentukan abilities, merancang alur login/logout API, dan memperbarui dokumen rancangan. Pemasangan dan
implementasi dilakukan setelah persetujuan dependensi.

## Penjelasan Kode

Tidak ada kode baru. Untuk memahami bentuk permintaan, kamu dapat mengamati header `Authorization` yang diterima server dengan route sementara:

```php-inline
Route::get('/v1/uji-header', function (\Illuminate\Http\Request $request) {
    return response()->json([
        'ada_bearer' => $request->bearerToken() !== null,
        'panjang' => strlen((string) $request->bearerToken()),
    ]);
});
```

Jangan mengembalikan token itu sendiri. `bearerToken()` membaca nilai setelah `Bearer `.

## Implementasi Langkah demi Langkah

### Langkah 1: amati header

Tambahkan route sementara di atas dan panggil:

```bash
curl -s -H "Accept: application/json" -H "Authorization: Bearer contoh-token-rahasia" http://127.0.0.1:8000/api/v1/uji-header
curl -s -H "Accept: application/json" http://127.0.0.1:8000/api/v1/uji-header
```

### Langkah 2: rancang kredensial

Isi tabel keputusan: jenis kredensial untuk (a) aplikasi seluler pembaca, (b) SPA admin di domain yang sama, (c) sistem mitra yang mengirim artikel, (d) skrip internal.

### Langkah 3: rancang abilities

Tentukan cakupan, misalnya `articles:read`, `articles:write`, `comments:moderate`, dan petakan ke endpoint.

### Langkah 4: rancang alur

Gambar alur login API (penerbitan token), pemakaian, dan logout (pencabutan), termasuk batas laju dan masa berlaku.

### Langkah 5: perbarui dokumen rancangan

Tambahkan bagian autentikasi pada `docs/api-rancangan.md` dan commit.

### Langkah 6: hapus route sementara

```bash
git add docs
git commit -m "Rancang autentikasi API"
```

## Eksekusi dan Verifikasi

| Langkah | Cara memverifikasi |
|---|---|
| 1 | Dengan header: `ada_bearer: true` dan panjang sesuai; tanpa header: `false` |
| 2–4 | Rancangan lengkap dan konsisten dengan praktik aman |
| 5 | Dokumen di-*commit* |

## Hasil yang Diharapkan

| Permintaan | Hasil |
|---|---|
| Dengan `Authorization: Bearer ...` | `{"ada_bearer":true,"panjang":21}` (panjang sesuai token contoh) |
| Tanpa header | `{"ada_bearer":false,"panjang":0}` |

Hasil ini diturunkan dari dokumentasi dan belum dijalankan oleh penulis materi; cocokkan dengan hasilmu.

## Kesalahan Umum dan Pemecahan Masalah

| Gejala | Penyebab | Cara mengenali | Solusi | Pencegahan |
|---|---|---|---|---|
| `bearerToken()` selalu `null` | Header tidak diteruskan (proxy) / skema salah | Tidak ada nilai | Pakai `Bearer ` (spasi) dan periksa proxy | Uji header di lingkungan nyata |
| Token tercatat di log | Mencatat semua header | Token terlihat di log | Saring header sensitif | Jangan catat `Authorization` |
| Token tidak bisa dicabut | Desain token statis | Kebocoran tak tertangani | Gunakan token per-klien tercatat | Pilih desain yang dapat dicabut |
| Token di URL | Kemudahan sesaat | Token di riwayat | Pindahkan ke header | Larang di panduan |
| Satu kunci dipakai semua | Kemalasan desain | Tak tahu siapa pelaku | Token per klien | Rancang identitas |
| XSS mencuri token di `localStorage` | Penyimpanan tidak aman | Token bocor | Cookie `HttpOnly` / pendek umur | Pahami kompromi penyimpanan |

## Latihan Praktik

### Latihan dasar

**D1. Pilih kredensial**
- *Masalah:* pilih jenis kredensial.
- *Persyaratan:* untuk empat skenario pada Langkah 2, pilih dan beri alasan dalam satu kalimat tiap skenario.
- *Perilaku yang diharapkan:* pilihan beralasan.
- *Tujuan belajar:* memilih autentikasi.

### Latihan implementasi

**I1. Peta abilities**
- *Masalah:* hak per token.
- *Persyaratan:* buat tabel endpoint × ability yang diperlukan, termasuk endpoint publik.
- *Perilaku yang diharapkan:* setiap endpoint tulis memiliki ability.
- *Tujuan belajar:* hak terkecil per token.

**I2. Skenario pencurian**
- *Masalah:* token seluler bocor.
- *Persyaratan:* tulis langkah respons (cabut, ganti kata sandi, telusuri log, beri tahu pengguna) dan perubahan desain yang membatasi dampak berikutnya.
- *Perilaku yang diharapkan:* rencana insiden jelas.
- *Tujuan belajar:* merencanakan respons insiden.

### Latihan tantangan

**T1. Sanctum atau Passport**
- *Masalah:* tim membutuhkan keputusan.
- *Persyaratan:* baca dokumentasi keduanya dan tulis rekomendasi untuk API artikel (kebutuhan: aplikasi seluler sendiri, SPA admin, belum ada pihak ketiga), lengkap dengan alasan dan kapan akan berubah pikiran.
- *Perilaku yang diharapkan:* rekomendasi beralasan.
- *Tujuan belajar:* memilih solusi autentikasi.
- *Catatan:* kerjakan mandiri; tidak ada kunci jawaban.

## Uji Pemahaman

1. Apa beda autentikasi sesi dan token?
2. Mengapa token di-hash di database?
3. Apa itu skema Bearer?
4. Mengapa token tidak boleh di URL?
5. Apa fungsi abilities?
6. Kapan memilih OAuth dibanding token pribadi?

??? success "Kunci jawaban singkat"
    1. Sesi memakai cookie dan data di server; token dibawa di header setiap permintaan.
    2. Agar pencurian database tidak membocorkan token yang masih berlaku.
    3. Token dikirim di header `Authorization: Bearer <token>`; pemegangnya dianggap pemilik.
    4. URL tercatat di log, riwayat, dan referer.
    5. Membatasi hak tiap token (hak terkecil).
    6. Saat aplikasi pihak ketiga perlu diberi akses atas nama pengguna dengan persetujuan.

## Ringkasan

- API stateless membuktikan identitas di setiap permintaan lewat token di header.
- Token pribadi: di-hash, berumur terbatas, dapat dicabut, punya abilities.
- SPA sedomain dapat memakai sesi + CSRF; seluler dan pihak ketiga memakai token.
- Ekosistem Laravel: Sanctum (token pribadi/SPA) dan Passport (OAuth 2.0).

Selanjutnya: *Laravel Sanctum*. Sub bab ini memasang paket resmi tambahan dan membutuhkan persetujuanmu sebelum dilanjutkan.

## Referensi Resmi

- [Laravel: Authentication](https://laravel.com/docs/13.x/authentication)
- [Laravel: Sanctum](https://laravel.com/docs/13.x/sanctum)
- [Laravel: Passport](https://laravel.com/docs/13.x/passport)
- [OWASP: REST Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html)
