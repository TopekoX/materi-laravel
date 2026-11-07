# Optimasi Performa Laravel

Sebelum menyentuh kode aplikasi, ada optimasi tingkat framework dan server yang murah dan berdampak besar: meng-*cache* konfigurasi, route, view, dan event; mengoptimalkan autoloader Composer; mengaktifkan OPcache; dan memastikan mode produksi. Kebanyakan dilakukan **saat deploy**, bukan di kode.

## Tujuan Pembelajaran

- [ ] Menjalankan `php artisan optimize` dan memahami apa yang di-cache.
- [ ] Menjelaskan `config:cache`, `route:cache`, `view:cache`, dan `event:cache`.
- [ ] Menjelaskan efek `composer install --optimize-autoloader --no-dev`.
- [ ] Menjelaskan peran OPcache.
- [ ] Menghindari jebakan `env()` di luar `config/` setelah `config:cache`.
- [ ] Menyusun urutan perintah optimasi untuk deploy.

## Prasyarat

- [Dasar-dasar Performa](09-01-performance-fundamentals.md), [Task Scheduling](../level-07/07-11-task-scheduling.md) tidak wajib.

## Pengantar

Pada setiap permintaan, tanpa cache Laravel memuat banyak berkas konfigurasi, memindai definisi route, dan mengompilasi view. Pekerjaan itu bisa dilakukan sekali saat deploy.

## Penjelasan Konsep

### `optimize`

Menurut dokumentasi deployment, `php artisan optimize` meng-cache berkas yang pantas di-cache di produksi (konfigurasi, event, route, view); `php artisan optimize:clear` menghapus semuanya.

```bash
php artisan optimize          # produksi / saat deploy
php artisan optimize:clear    # hapus cache (pengembangan, atau bila ada perubahan tak terbaca)
```

### Perintah granular

| Perintah | Yang di-cache | Catatan |
|---|---|---|
| `config:cache` | Seluruh konfigurasi jadi satu berkas | Setelahnya `.env` tidak dibaca; pakai `config()` bukan `env()` di kode aplikasi |
| `route:cache` | Definisi route | Tidak mendukung route berbasis closure (pakai controller) |
| `view:cache` | View Blade terkompilasi | Menghindari kompilasi saat permintaan pertama |
| `event:cache` | Pemetaan event → listener | Dari 07.08 |

Setelah `config:cache`, pemanggilan `env()` di luar berkas `config/` mengembalikan `null` (lihat dokumentasi). Itu kesalahan umum.

### Route berbasis closure

`route:cache` tidak bisa men-cache route yang memakai closure. Jika `route:cache` gagal, pindahkan closure ke controller. Itu alasan lain mengapa closure sebaiknya hanya untuk percobaan.

### Composer

```bash
composer install --no-dev --optimize-autoloader
```

`--no-dev` tidak memasang paket pengembangan (hemat dan lebih aman); `--optimize-autoloader` membuat peta kelas sehingga pencarian kelas lebih cepat. Jalankan di server/pipeline deploy, bukan di lokal harian.

### OPcache

OPcache adalah ekstensi PHP yang menyimpan hasil kompilasi skrip di memori sehingga PHP tidak mengompilasi ulang tiap permintaan. Biasanya sudah aktif di PHP produksi; nilai penting (`opcache.memory_consumption`, `opcache.validate_timestamps`) diatur di `php.ini`. Dengan `validate_timestamps=0`, perubahan berkas baru terbaca setelah OPcache di-*reset* (mis. restart PHP-FPM) — sesuai untuk produksi dengan deploy terkontrol. Konfigurasi server dibahas di Level 10.

### Mode produksi

- `APP_ENV=production`, `APP_DEBUG=false`.
- Jangan jalankan `artisan serve` di produksi; gunakan Nginx + PHP-FPM atau Octane (09.11).

### Urutan deploy ringkas

```bash
composer install --no-dev --optimize-autoloader
php artisan migrate --force
php artisan optimize
php artisan queue:restart
```

(Dijelaskan penuh di Level 10; `migrate --force` diperlukan karena di produksi perintah meminta konfirmasi.)

### Keamanan

- `APP_DEBUG=false` wajib di produksi.
- `--no-dev` mengurangi permukaan serangan.
- Cache konfigurasi memuat nilai `.env` (termasuk rahasia) dalam berkas di `bootstrap/cache`; pastikan direktori tidak dapat diakses publik dan tidak di-*commit*.

## Cara Kerja

```mermaid
flowchart LR
    D["Deploy"] --> C["composer install --optimize-autoloader --no-dev"]
    C --> O["artisan optimize (config, route, view, event)"]
    O --> R["Request: baca cache, bukan parsing berkas"]
```

## Contoh Praktik

Kamu mengukur baseline, menjalankan `optimize`, mengukur ulang, lalu menjalankan `optimize:clear`. Kamu juga sengaja memicu masalah `env()` untuk memahami jebakannya.

## Penjelasan Kode

Jebakan `env()`: di controller, `env('APP_NAME')` bekerja tanpa cache tetapi `null` setelah `config:cache`. Perbaikan: `config('app.name')`.

## Implementasi Langkah demi Langkah

### Langkah 1: baseline

Ukur halaman daftar lima kali dengan `curl` (09.01).

### Langkah 2: optimalkan

```bash
php artisan optimize
```

### Langkah 3: ukur ulang

Ulangi pengukuran dan bandingkan median.

### Langkah 4: picu jebakan

Tambahkan sementara `dd(env('APP_NAME'))` di route percobaan sebelum dan sesudah `config:cache`; amati `null`. Hapus.

### Langkah 5: closure route

Tambahkan route closure, jalankan `php artisan route:cache`, baca galatnya. Hapus closure.

### Langkah 6: bersihkan

```bash
php artisan optimize:clear
```

### Langkah 7: catat

Tuliskan hasil sebelum/sesudah di catatan performa dan commit.

## Eksekusi dan Verifikasi

| Langkah | Hasil yang diharapkan |
|---|---|
| 3 | Median sama atau sedikit lebih cepat (efek kecil di `artisan serve`) |
| 4 | `env()` → `null` setelah cache |
| 5 | `route:cache` menolak route closure |

## Hasil yang Diharapkan

Dampak nyata bergantung pada ukuran aplikasi dan server. Penulis tidak mengukur; kenaikan di server pengembangan bisa tidak terlihat.

## Kesalahan Umum dan Pemecahan Masalah

| Gejala | Penyebab | Cara mengenali | Solusi | Pencegahan |
|---|---|---|---|---|
| Perubahan `.env` tak berlaku | Konfigurasi ter-cache | Nilai lama | `config:clear` / `optimize:clear` | Optimize hanya di produksi |
| `env()` mengembalikan null | Dipanggil di luar `config/` | Nilai kosong | Pakai `config()` | Review kode |
| `route:cache` gagal | Route closure | Galat serialisasi | Pindah ke controller | Hindari closure |
| Tampilan lama | View ter-cache | Perubahan view tak muncul | `view:clear` | Clear di lokal |
| Cache usang setelah deploy | Lupa `optimize` ulang | Perilaku lama | Jalankan pada tiap deploy | Skrip deploy |
| OPcache menahan kode lama | Timestamp tidak divalidasi | Kode lama berjalan | Reset OPcache/restart FPM | Langkah deploy |

## Latihan Praktik

### Latihan dasar

**D1. Pilih perintah**
- *Masalah:* mencocokkan perintah.
- *Persyaratan:* pasangkan tujuan: (a) mempercepat pemuatan konfigurasi, (b) pemetaan listener, (c) kompilasi Blade.
- *Perilaku yang diharapkan:* `config:cache`, `event:cache`, `view:cache`.
- *Tujuan belajar:* mengenali cache.

### Latihan implementasi

**I1. Skrip deploy**
- *Masalah:* deploy manual rawan lupa langkah.
- *Persyaratan:* tulis skrip `deploy.sh` berisi urutan perintah optimasi dengan `set -e` (berhenti saat gagal), tanpa menyertakan rahasia.
- *Perilaku yang diharapkan:* urutan benar.
- *Tujuan belajar:* mengotomasi.

### Latihan tantangan

**T1. Audit `env()`**
- *Masalah:* ingin aman dengan `config:cache`.
- *Persyaratan:* cari semua pemanggilan `env(` di `app/`, `routes/`, `resources/` dan rencanakan migrasinya ke `config()`.
- *Perilaku yang diharapkan:* daftar dan rencana.
- *Tujuan belajar:* kebersihan konfigurasi.
- *Catatan:* kerjakan mandiri; tidak ada kunci jawaban.

## Uji Pemahaman

1. Apa yang dilakukan `optimize`?
2. Mengapa `env()` jadi `null` setelah `config:cache`?
3. Mengapa `route:cache` gagal pada closure?
4. Apa fungsi OPcache?

??? success "Kunci jawaban singkat"
    1. Meng-cache konfigurasi, event, route, dan view.
    2. `.env` tidak dibaca lagi; hanya cache konfigurasi.
    3. Closure tidak dapat diserialisasi.
    4. Menyimpan hasil kompilasi skrip PHP di memori.

## Ringkasan

- Cache konfigurasi, route, view, event saat deploy.
- Optimalkan autoloader dan aktifkan OPcache; produksi = debug off.
- Gunakan `config()`, bukan `env()`, di kode aplikasi.

Selanjutnya: *Optimasi Query Database*.

## Referensi Resmi

- [Laravel: Deployment, Optimization](https://laravel.com/docs/13.x/deployment#optimization)
- [PHP: OPcache](https://www.php.net/manual/en/book.opcache.php)
