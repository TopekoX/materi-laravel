# Service Providers

Service provider adalah tempat Laravel **dibootstrap**: binding, event listener, middleware, dan route didaftarkan di sana. Hampir semua fitur inti Laravel (database, queue, mail) dimulai dari sebuah provider. Kamu akan membuat provider sendiri untuk memusatkan binding aplikasi.

## Tujuan Pembelajaran

- [ ] Menjelaskan peran provider dalam bootstrap aplikasi.
- [ ] Membedakan `register()` dan `boot()`.
- [ ] Membuat provider dengan `make:provider` dan memahami pendaftarannya.
- [ ] Memakai properti `$bindings` dan `$singletons`.
- [ ] Mengetahui provider tertunda (*deferred*).

## Prasyarat

- [Service Container](07-01-service-container.md).
- Menemukan `bootstrap/providers.php` dan `app/Providers/AppServiceProvider.php`.

## Pengantar

Menaruh semua binding di `AppServiceProvider` cepat membengkak. Memisahkannya per topik (mis. `RepositoryServiceProvider`, `RateLimitServiceProvider`) menjaga kode rapi.

## Penjelasan Konsep

### `register()` dan `boot()`

| Method | Kapan | Boleh apa |
|---|---|---|
| `register()` | Awal, sebelum provider lain tentu siap | Hanya **mengikat** ke container; jangan memakai layanan lain |
| `boot()` | Setelah semua provider terdaftar | Memakai layanan lain: event, view composer, rate limiter |

Menurut dokumentasi, di `register()` kamu tidak boleh mendaftarkan listener, route, atau fungsi lain yang bergantung pada provider yang mungkin belum dimuat.

### Membuat provider

```bash
php artisan make:provider PengirimServiceProvider
```

Perintah ini membuat file di `app/Providers` dan, menurut dokumentasi, mendaftarkannya otomatis ke `bootstrap/providers.php`.

File: `app/Providers/PengirimServiceProvider.php`

```php
<?php

namespace App\Providers;

use App\Contracts\PengirimPesan;
use App\Services\PengirimLog;
use Illuminate\Support\ServiceProvider;

class PengirimServiceProvider extends ServiceProvider
{
    public array $bindings = [
        PengirimPesan::class => PengirimLog::class,
    ];

    public function register(): void
    {
        //
    }

    public function boot(): void
    {
        //
    }
}
```

`$bindings` adalah jalan pintas untuk binding sederhana; `$singletons` bekerja serupa untuk singleton.

### Provider tertunda

Provider yang hanya mendaftarkan binding dapat mengimplementasikan `DeferrableProvider` dan mengembalikan daftar layanan lewat `provides()`; Laravel baru memuatnya saat layanan itu diminta. Cocok untuk provider berat; untuk aplikasi kecil tidak perlu.

### Keamanan dan performa

- Kode di `boot()` berjalan pada **setiap permintaan**: jangan memanggil jaringan atau query berat di sana.
- Jangan menaruh rahasia di provider; baca dari konfigurasi (`config()`).

## Cara Kerja

```mermaid
flowchart LR
    B["bootstrap/providers.php"] --> R["register() semua provider"]
    R --> O["boot() semua provider"]
    O --> A["Aplikasi menangani request"]
```

## Contoh Praktik

Kamu membuat interface `PengirimPesan`, implementasi `PengirimLog` (menulis ke log), provider yang mengikatnya, dan route yang memakainya lewat injeksi.

## Penjelasan Kode

File: `app/Contracts/PengirimPesan.php`

```php
<?php

namespace App\Contracts;

interface PengirimPesan
{
    public function kirim(string $tujuan, string $isi): void;
}
```

File: `app/Services/PengirimLog.php`

```php
<?php

namespace App\Services;

use App\Contracts\PengirimPesan;
use Illuminate\Support\Facades\Log;

class PengirimLog implements PengirimPesan
{
    public function kirim(string $tujuan, string $isi): void
    {
        Log::info("Pesan ke {$tujuan}: {$isi}");
    }
}
```

`PengirimLog` memenuhi kontrak dengan menulis ke log, aman untuk latihan karena tidak mengirim apa pun keluar.

## Implementasi Langkah demi Langkah

### Langkah 1: buat interface dan implementasi

Buat dua berkas di atas.

### Langkah 2: buat provider

```bash
php artisan make:provider PengirimServiceProvider
```

Isi `$bindings`. Periksa `bootstrap/providers.php`:

```bash
git diff bootstrap/providers.php
```

### Langkah 3: pakai di route sementara

```php-inline
Route::get('/uji-pengirim', function (\App\Contracts\PengirimPesan $p) {
    $p->kirim('ani@contoh.test', 'Halo');

    return 'terkirim: '.$p::class;
});
```

### Langkah 4: jalankan dan periksa

```bash
curl -s http://127.0.0.1:8000/uji-pengirim
tail -n 3 storage/logs/laravel.log
```

### Langkah 5: bersihkan

Hapus route sementara; pertahankan provider untuk bab berikut.

## Eksekusi dan Verifikasi

| Langkah | Hasil |
|---|---|
| 2 | `bootstrap/providers.php` memuat provider baru |
| 4 | Respons `terkirim: App\Services\PengirimLog`; log memuat "Pesan ke ani@contoh.test: Halo" |

## Hasil yang Diharapkan

Diturunkan dari dokumentasi; belum dijalankan penulis.

## Kesalahan Umum dan Pemecahan Masalah

| Gejala | Penyebab | Cara mengenali | Solusi | Pencegahan |
|---|---|---|---|---|
| Provider tidak berjalan | Tidak ada di `bootstrap/providers.php` | Binding tak berlaku | Daftarkan | Pakai `make:provider` |
| Layanan `null` di `register()` | Memakai layanan lain terlalu dini | Galat saat boot | Pindah ke `boot()` | Aturan register vs boot |
| Aplikasi lambat | Pekerjaan berat di `boot()` | Semua request lambat | Pindahkan / cache | Profiling |
| Cache konfigurasi usang | `config:cache` lama | Perubahan tak terbaca | `php artisan optimize:clear` | Bersihkan setelah ubah |

## Latihan Praktik

### Latihan dasar

**D1. Daftar provider**
- *Masalah:* ingin tahu provider aktif.
- *Persyaratan:* buka `bootstrap/providers.php` dan sebutkan isinya.
- *Perilaku yang diharapkan:* daftar sesuai berkas.
- *Tujuan belajar:* lokasi registrasi.

### Latihan implementasi

**I1. `$singletons`**
- *Masalah:* ingin satu instance bersama.
- *Persyaratan:* ubah ke `$singletons` dan buktikan dengan membandingkan `spl_object_id`.
- *Perilaku yang diharapkan:* id sama.
- *Tujuan belajar:* singleton lewat provider.

### Latihan tantangan

**T1. Provider tertunda**
- *Masalah:* provider berat dimuat tiap permintaan.
- *Persyaratan:* baca dokumentasi `DeferrableProvider`, jelaskan syaratnya dan kapan manfaatnya terasa.
- *Perilaku yang diharapkan:* penjelasan benar.
- *Tujuan belajar:* optimasi bootstrap.
- *Catatan:* kerjakan mandiri; tidak ada kunci jawaban.

## Uji Pemahaman

1. Apa beda `register()` dan `boot()`?
2. Di mana provider didaftarkan?
3. Apa fungsi `$bindings`?
4. Mengapa tidak boleh ada query berat di `boot()`?

??? success "Kunci jawaban singkat"
    1. `register()` hanya mengikat; `boot()` boleh memakai layanan lain.
    2. `bootstrap/providers.php`.
    3. Binding sederhana interface ke implementasi.
    4. Berjalan pada setiap permintaan.

## Ringkasan

- Provider adalah titik bootstrap; `register` untuk binding, `boot` untuk sisanya.
- `make:provider` membuat dan mendaftarkan provider.
- Jaga `boot()` tetap ringan.

Selanjutnya: *Dependency Injection*.

## Referensi Resmi

- [Laravel: Service Providers](https://laravel.com/docs/13.x/providers)
