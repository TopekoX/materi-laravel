# Composer dan Manajemen Paket

Hampir tidak ada aplikasi PHP modern yang ditulis dari nol. Kamu memakai pustaka orang
lain untuk tanggal, email, pengujian, bahkan seluruh framework seperti Laravel.
**Composer** adalah alat yang mengunduh, memasang, dan memperbarui pustaka-pustaka itu
(disebut **paket**) serta menyiapkan autoloader-nya. Laravel sendiri dipasang dan
dijalankan lewat Composer.

## Tujuan pembelajaran

Setelah menyelesaikan bab ini, kamu dapat:

- [ ] Menjelaskan fungsi Composer, Packagist, `composer.json`, `composer.lock`, dan `vendor/`.
- [ ] Membuat `composer.json` dan menghasilkan autoloader PSR-4 dengan Composer.
- [ ] Memasang, menghapus, dan memperbarui paket dengan `composer require`, `remove`, dan `update`.
- [ ] Membaca batasan versi seperti `^3.0` dan `~3.1`.
- [ ] Membedakan `composer install` dan `composer update`.
- [ ] Memakai `vendor/autoload.php` di aplikasimu dan menjelaskan apa yang tidak boleh di-commit.

## Prasyarat

- Bab [Namespace dan Autoloading](00-22-namespace-and-autoloading.md): PSR-4.
- Bab [Pemasangan PHP](00-06-php-installation-and-development-environment.md): Composer
  terpasang (`composer -V` berfungsi), koneksi internet, dan `unzip` terpasang di Ubuntu.
- PHP 8.3 atau lebih baru; folder `belajar-php`.

## Konsep

!!! tip "Analogi"
    Composer seperti **aplikasi pemesanan belanja**. Kamu menulis daftar belanja
    (`composer.json`), Composer membeli barangnya dari toko besar (**Packagist**), menyimpannya
    di gudang (`vendor/`), dan mencatat merek serta versi persis yang dibeli di struk
    (`composer.lock`).

### Istilah penting

| Istilah | Arti |
|---|---|
| **Paket** (*package*) | Pustaka kode yang dapat dipasang, bernama `vendor/nama` (mis. `nesbot/carbon`) |
| **Packagist** | Katalog publik paket PHP yang dipakai Composer secara bawaan |
| **`composer.json`** | Berkas yang kamu tulis: paket apa yang dibutuhkan, pengaturan autoload |
| **`composer.lock`** | Berkas yang dibuat Composer: versi **persis** tiap paket terpasang |
| **`vendor/`** | Folder tempat paket diunduh, berikut `vendor/autoload.php` |

### Berkas `composer.json`

```json
{
    "name": "latihan/proyek-composer",
    "description": "Proyek latihan Composer",
    "type": "project",
    "require": {
        "php": "^8.3"
    },
    "autoload": {
        "psr-4": {
            "Latihan\\": "src/"
        }
    }
}
```

| Kunci | Arti |
|---|---|
| `name` | Nama proyek dalam format `vendor/nama`, huruf kecil |
| `require` | Paket dan versi yang dibutuhkan saat berjalan (termasuk syarat versi PHP) |
| `require-dev` | Paket yang hanya dibutuhkan saat pengembangan (mis. alat pengujian) |
| `autoload.psr-4` | Pemetaan namespace → folder, seperti autoloader yang kamu tulis di bab sebelumnya |

Tanda `\\` di JSON mewakili satu tanda `\` pada namespace `Latihan\`.

### Batasan versi

Paket mengikuti *semantic versioning* `MAJOR.MINOR.PATCH`. Batasan menentukan pembaruan
yang boleh diambil Composer:

| Batasan | Artinya |
|---|---|
| `3.1.2` | Persis versi itu |
| `^3.1` | `>=3.1.0` dan `<4.0.0` (pembaruan minor dan patch, bukan major) |
| `~3.1` | `>=3.1.0` dan `<4.0.0` |
| `~3.1.2` | `>=3.1.2` dan `<3.2.0` |
| `*` | Versi apa pun (hindari) |

Yang paling umum adalah `^`, dan itulah yang otomatis ditulis `composer require`.
Pembaruan *major* dapat memecahkan kompatibilitas, jadi tidak diambil otomatis.

### Perintah utama

| Perintah | Fungsi |
|---|---|
| `composer require vendor/paket` | Memasang paket baru, menulis ke `composer.json` dan `composer.lock` |
| `composer require --dev vendor/paket` | Memasang paket untuk pengembangan |
| `composer remove vendor/paket` | Menghapus paket |
| `composer install` | Memasang **persis** versi di `composer.lock` |
| `composer update` | Mencari versi terbaru yang sesuai batasan, lalu memperbarui `composer.lock` |
| `composer dump-autoload` | Membuat ulang autoloader (mis. setelah menambah class/namespace) |
| `composer show` | Menampilkan paket terpasang |
| `composer audit` | Memeriksa paket terpasang terhadap kerentanan keamanan yang diketahui |

### `install` dibanding `update`

- Pada **mesin baru** atau saat menggunakan proyek orang lain: `composer install`. Hasilnya sama
  persis dengan mesin pengembang lain karena mengikuti `composer.lock`.
- Saat sengaja ingin **menaikkan versi**: `composer update`. Berhati-hatilah; lakukan lalu uji.

### Apa yang di-commit ke Git?

| Berkas / folder | Commit? | Alasan |
|---|---|---|
| `composer.json` | Ya | Definisi kebutuhan |
| `composer.lock` | Ya (untuk aplikasi) | Menjamin versi sama di semua mesin |
| `vendor/` | **Tidak** | Besar dan bisa dibuat ulang dengan `composer install` |

Tambahkan `/vendor/` ke `.gitignore`.

### Keamanan

Paket adalah kode orang lain yang berjalan di aplikasimu. Pasang hanya yang dikenal dan
terawat, periksa jumlah pemakai dan pemeliharanya di Packagist, jalankan `composer audit`
secara berkala, dan jangan pernah menjalankan skrip dari sumber tak dikenal.

### Di Laravel

- Laravel dipasang dengan Composer (`laravel/framework` ada di `require`).
- Autoloader `vendor/autoload.php` dimuat oleh `public/index.php`; karena itulah
  `use Illuminate\...` dan `use App\...` langsung berfungsi.
- `composer.json` Laravel juga berisi bagian `scripts`, misalnya perintah `composer run dev`
  yang dipakai pada pemasangan Laravel.

## Praktik

Kita ubah proyek `autoload` dari bab sebelumnya menjadi proyek Composer dan memasang paket
tanggal **Carbon**. Pastikan kamu terhubung ke internet.

### Langkah 1: periksa Composer

```bash
composer -V
```

**Yang seharusnya terlihat:** satu baris yang diawali `Composer version` diikuti nomor versi.
Jika perintah tidak dikenal, ulangi bab pemasangan PHP.

### Langkah 2: siapkan proyek

Buat folder `belajar-php/proyek-composer` dan salin folder `src` dari `belajar-php/autoload`:

```bash
cd belajar-php
mkdir proyek-composer
cp -r autoload/src proyek-composer/src
cd proyek-composer
```

Buat berkas `composer.json` sebagai berikut:

```json title="belajar-php/proyek-composer/composer.json"
{
    "name": "latihan/proyek-composer",
    "description": "Proyek latihan Composer",
    "type": "project",
    "require": {
        "php": "^8.3"
    },
    "autoload": {
        "psr-4": {
            "Latihan\\": "src/"
        }
    }
}
```

### Langkah 3: hasilkan autoloader

```bash
composer dump-autoload
```

**Yang seharusnya terlihat:** pesan bahwa berkas autoload dibuat, dan folder `vendor/` baru
berisi `autoload.php`. Tidak ada paket yang diunduh karena belum ada yang dibutuhkan selain PHP.

### Langkah 4: pakai autoloader Composer

```php title="belajar-php/proyek-composer/index.php"
<?php

require __DIR__ . "/vendor/autoload.php";

use Latihan\Model\Buku;
use Latihan\Service\Perpustakaan;

$perpustakaan = new Perpustakaan();
$perpustakaan
    ->tambah(new Buku("Belajar PHP"))
    ->tambah(new Buku("Belajar Laravel"));

echo implode(", ", $perpustakaan->daftar()), "\n";
```

```bash
php index.php
```

**Yang seharusnya terlihat:** `Belajar PHP, Belajar Laravel`. Autoloader PSR-4 buatan sendiri
sudah digantikan oleh `vendor/autoload.php` dari Composer, dengan hasil yang sama.

### Langkah 5: pasang paket

```bash
composer require nesbot/carbon
```

**Yang seharusnya terlihat:**

- Composer mengunduh Carbon (dan paket-paket yang dibutuhkannya) dari Packagist.
- Berkas `composer.lock` baru muncul.
- `composer.json` kini memiliki entri `nesbot/carbon` di `require`, dengan batasan berbentuk
  `^` diikuti nomor versi (nomor persisnya mengikuti rilis terbaru saat kamu menjalankan).
- Folder `vendor/` berisi folder `nesbot` dan beberapa folder paket lain.

Periksa paket terpasang:

```bash
composer show
```

### Langkah 6: pakai paket

Ubah `index.php` menjadi:

```php title="belajar-php/proyek-composer/index.php"
<?php

require __DIR__ . "/vendor/autoload.php";

use Carbon\Carbon;
use Latihan\Model\Buku;
use Latihan\Service\Perpustakaan;

$perpustakaan = new Perpustakaan();
$perpustakaan
    ->tambah(new Buku("Belajar PHP"))
    ->tambah(new Buku("Belajar Laravel"));

echo implode(", ", $perpustakaan->daftar()), "\n";

$tanggal = Carbon::create(2026, 1, 15);

echo $tanggal->format("d-m-Y"), "\n";
echo $tanggal->copy()->addDays(10)->format("d-m-Y"), "\n";
echo $tanggal->locale("id")->translatedFormat("l, d F Y"), "\n";
```

```bash
php index.php
```

**Yang seharusnya terlihat:**

```text
Belajar PHP, Belajar Laravel
15-01-2026
25-01-2026
Kamis, 15 Januari 2026
```

Perhatikan bahwa kamu memakai class `Carbon\Carbon` tanpa `require` tambahan; autoloader
Composer sudah mengenalnya. Kamu perlu mencocokkan sendiri hasil di terminalmu dengan
keluaran di atas.

### Langkah 7: `install` dari `composer.lock`

Simulasikan memakai proyek di mesin baru: hapus `vendor/` lalu pasang ulang.

```bash
rm -rf vendor
composer install
php index.php
```

**Yang seharusnya terlihat:** Composer memasang paket sesuai versi di `composer.lock`
(tanpa mencari versi baru), dan `index.php` kembali menampilkan keluaran yang sama.

Tambahkan berkas `.gitignore` di folder proyek:

```text title="belajar-php/proyek-composer/.gitignore"
/vendor/
```

### Langkah 8: menghapus paket

```bash
composer remove nesbot/carbon
```

**Yang seharusnya terlihat:** entri `nesbot/carbon` hilang dari `composer.json`, dan
`php index.php` kini gagal karena class `Carbon\Carbon` tidak ditemukan. Pasang lagi dengan
`composer require nesbot/carbon` bila ingin melanjutkan latihan.

## Kesalahan umum dan debugging

| Gejala | Kemungkinan penyebab | Solusi |
|---|---|---|
| `composer: command not found` | Composer belum terpasang atau `PATH` belum diperbarui | Ulangi pemasangan; buka ulang terminal. |
| `Failed to open stream: vendor/autoload.php` | Belum menjalankan `composer install` / `dump-autoload` | Jalankan perintah yang sesuai. |
| `Class "X" not found` setelah menambah class baru | Autoloader belum diperbarui (terutama untuk pemetaan non-PSR-4) | `composer dump-autoload`. |
| Gagal mengunduh paket | Tidak ada internet, atau proxy | Periksa koneksi; ulangi. |
| Pesan tentang ekstensi PHP yang hilang | Paket membutuhkan ekstensi yang belum terpasang | Pasang ekstensi (mis. `php-mbstring`, `php-xml`), lalu ulangi. |
| `Your requirements could not be resolved` | Batasan versi tidak bisa dipenuhi bersama | Cek batasan; naikkan atau turunkan versi paket terkait. |
| `composer.lock` berbeda antar anggota tim | `composer update` dijalankan tidak sengaja | Gunakan `composer install` pada mesin lain; commit `composer.lock`. |
| Folder `vendor/` ikut di-commit | `.gitignore` belum diatur | Tambahkan `/vendor/` ke `.gitignore`. |
| `Invalid ... name` pada `composer.json` | Nama paket tidak memakai huruf kecil `vendor/nama` | Perbaiki format nama. |
| JSON error saat membaca `composer.json` | Koma berlebih atau tanda kutip hilang | Rapikan sintaks JSON. |

## Latihan terpandu

1. Jalankan `composer show nesbot/carbon` dan catat versi yang terpasang. Bandingkan dengan
   batasan di `composer.json`.
2. Buka `composer.lock` (jangan diedit) dan temukan entri `nesbot/carbon`. Apa yang
   disimpan di sana yang tidak ada di `composer.json`?
3. Tambahkan class baru `Latihan\Model\Anggota` di `src/Model/Anggota.php` dan pakai di
   `index.php`. Apakah `composer dump-autoload` perlu dijalankan lagi? Mengapa?
4. Pasang satu paket untuk pengembangan dengan `composer require --dev symfony/var-dumper`
   dan lihat bagian `require-dev` di `composer.json`.
5. Jalankan `composer audit` dan catat hasilnya.
6. Tentukan rentang versi yang diizinkan oleh batasan `^2.4`, `~2.4`, dan `~2.4.1`.
7. Jelaskan dengan kata-katamu mengapa `vendor/` tidak di-commit sedangkan `composer.lock` di-commit.

??? success "Jawaban nomor 3, 6, dan 7"
    **Nomor 3:** tidak perlu, karena pemetaan PSR-4 mencari berkas berdasarkan nama class,
    sehingga class baru di `src/` langsung ditemukan.

    **Nomor 6:** `^2.4` = `>=2.4.0 <3.0.0`; `~2.4` = `>=2.4.0 <3.0.0`;
    `~2.4.1` = `>=2.4.1 <2.5.0`.

    **Nomor 7:** `vendor/` dapat dibuat ulang dengan `composer install` dan berukuran besar.
    `composer.lock` mengunci versi persis sehingga semua orang memasang paket yang sama.

## Pertanyaan review

1. Apa fungsi Composer dan Packagist?
2. Apa beda `composer.json` dan `composer.lock`?
3. Apa arti `^3.1` dan `~3.1.2`?
4. Kapan memakai `composer install` dan kapan `composer update`?
5. Apa fungsi `composer dump-autoload`?
6. Apa fungsi `vendor/autoload.php`?
7. Mengapa `vendor/` tidak di-commit?
8. Mengapa paket pihak ketiga perlu diperiksa sebelum dipasang?

## Ringkasan

- Composer mengelola paket PHP dari Packagist dan menghasilkan autoloader.
- `composer.json` adalah daftar kebutuhan; `composer.lock` mengunci versi persis.
- `require` memasang, `remove` menghapus, `install` memasang sesuai lock, `update` menaikkan versi.
- Batasan `^` mengizinkan pembaruan minor dan patch, bukan major.
- Commit `composer.json` dan `composer.lock`; jangan commit `vendor/`.
- Laravel memanfaatkan Composer untuk pemasangan, autoloading, dan skrip.

Selanjutnya: **Git dan GitHub Fundamentals**, bab terakhir pada bagian Dasar Web dan PHP.

## Referensi resmi

- [Composer: Introduction](https://getcomposer.org/doc/00-intro.md)
- [Composer: Basic usage](https://getcomposer.org/doc/01-basic-usage.md)
- [Composer: Command-line interface](https://getcomposer.org/doc/03-cli.md)
- [Composer: composer.json schema](https://getcomposer.org/doc/04-schema.md)
- [Composer: Versions and constraints](https://getcomposer.org/doc/articles/versions.md)
- [Composer: Autoloader optimization](https://getcomposer.org/doc/articles/autoloader-optimization.md)
- [Packagist](https://packagist.org)
- [Carbon di Packagist](https://packagist.org/packages/nesbot/carbon)
- [Laravel: Installation](https://laravel.com/docs/13.x/installation)
