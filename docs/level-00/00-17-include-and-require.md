# Include dan Require

Seiring aplikasi membesar, menaruh semua kode dalam satu berkas tidak lagi praktis. Kamu
akan memecahnya: bagian header dan footer yang dipakai semua halaman, fungsi bantu, dan
berkas pengaturan. PHP menyediakan `include` dan `require` untuk **memuat berkas lain** ke
dalam sebuah skrip.

## Tujuan pembelajaran

Setelah menyelesaikan bab ini, kamu dapat:

- [ ] Memecah halaman menjadi bagian yang dapat dipakai ulang (header, footer).
- [ ] Membedakan `include`, `require`, `include_once`, dan `require_once`.
- [ ] Menulis jalur berkas yang andal dengan `__DIR__`.
- [ ] Memuat berkas yang mengembalikan nilai, misalnya array konfigurasi.
- [ ] Menjelaskan risiko memuat berkas dari input pengguna.

## Prasyarat

- Bab [Penanganan Form PHP](00-16-php-form-handling.md) dan [Fungsi](00-14-functions.md).
- PHP 8.3 atau lebih baru; folder `belajar-php`. Contoh halaman web dijalankan dengan
  `php -S localhost:8000` dari folder `belajar-php`.

## Konsep

### Mengapa memecah berkas?

Tanpa pemecahan, setiap halaman menyalin header dan footer yang sama. Mengubah satu menu
berarti mengedit semua halaman. Dengan `require`, header ditulis **sekali** dan dimuat di
mana saja.

!!! tip "Analogi"
    Seperti membuat buku dengan bab terpisah. Daftar isi atau sampul cukup ditulis
    sekali dan dipakai ulang di setiap edisi.

### Empat perintah pemuatan

```php
include "berkas.php";
require "berkas.php";
include_once "berkas.php";
require_once "berkas.php";
```

| Perintah | Jika berkas tidak ditemukan | Dimuat berkali-kali? |
|---|---|---|
| `include` | **Peringatan**; skrip lanjut | Ya, setiap dipanggil |
| `require` | **Error fatal**; skrip berhenti | Ya |
| `include_once` | Peringatan; lanjut | Hanya sekali |
| `require_once` | Error fatal; berhenti | Hanya sekali |

Aturan praktis:

- Pakai `require`/`require_once` untuk berkas yang **wajib** ada (fungsi, konfigurasi,
  kelas). Lebih baik berhenti daripada berjalan dengan setengah kode.
- Pakai `_once` untuk berkas yang mendefinisikan fungsi atau kelas, supaya tidak terdefinisi
  dua kali (yang menimbulkan error).
- Pakai `include` untuk potongan tampilan yang tidak kritis.

### Jalur berkas dan `__DIR__`

Jalur relatif seperti `"layout/header.php"` atau `"./layout/header.php"` dapat bergantung
pada folder tempat perintah dijalankan, sehingga berperilaku berbeda bila skrip
dijalankan dari folder lain. Gunakan konstanta ajaib **`__DIR__`**, yaitu folder tempat
berkas yang sedang berjalan berada:

```php
require __DIR__ . "/layout/header.php";
```

Selain `__DIR__` ada `__FILE__` (jalur berkas saat ini) dan `__LINE__` (nomor baris).

### Ruang lingkup variabel

Berkas yang dimuat berbagi **scope variabel** dengan tempat pemanggilnya. Variabel yang
ada sebelum `include` dapat dipakai di berkas itu, dan variabel yang dibuat di dalamnya dapat
dipakai sesudahnya. (Jika `include` dipanggil di dalam fungsi, scope-nya adalah scope fungsi itu.)

### Berkas yang mengembalikan nilai

Sebuah berkas boleh `return` nilai, dan `include`/`require` mengembalikan nilai itu.
Pola ini dipakai untuk berkas konfigurasi:

```php
// config.php
return [
    'nama_aplikasi' => 'Situs Latihan',
];

// pemakai
$config = require __DIR__ . '/config.php';
```

Seluruh berkas di folder `config/` pada proyek Laravel memakai pola ini.

### Keamanan: jangan memuat jalur dari pengguna

```php
include $_GET["halaman"] . ".php";   // BERBAHAYA
```

Penyerang dapat memanipulasi nilai itu agar memuat berkas lain di server (*Local File
Inclusion*). Jika harus memilih berkas berdasarkan input, cocokkan dengan **daftar putih**:

```php
$boleh = ["beranda", "tentang"];
$halaman = $_GET["halaman"] ?? "beranda";

if (in_array($halaman, $boleh, true)) {
    require __DIR__ . "/$halaman.php";
}
```

## Praktik

Semua berkas dibuat di folder `belajar-php`.

### Langkah 1: header dan footer

Buat folder `layout` dan dua berkas di dalamnya:

```php title="belajar-php/layout/header.php"
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <title><?= htmlspecialchars($judul) ?> - Situs Latihan</title>
</head>
<body>
    <nav>
        <a href="beranda.php">Beranda</a> |
        <a href="tentang.php">Tentang</a>
    </nav>
    <main>
```

```php title="belajar-php/layout/footer.php"
    </main>
    <footer>
        <p>&copy; <?= date("Y") ?> Situs Latihan</p>
    </footer>
</body>
</html>
```

Lalu dua halaman yang memakainya:

```php title="belajar-php/beranda.php"
<?php

$judul = "Beranda";
require __DIR__ . "/layout/header.php";
?>
<h1>Selamat datang</h1>
<p>Ini halaman beranda.</p>
<?php require __DIR__ . "/layout/footer.php"; ?>
```

```php title="belajar-php/tentang.php"
<?php

$judul = "Tentang";
require __DIR__ . "/layout/header.php";
?>
<h1>Tentang</h1>
<p>Situs ini dibuat untuk berlatih PHP.</p>
<?php require __DIR__ . "/layout/footer.php"; ?>
```

Jalankan server dari folder `belajar-php`:

```bash
php -S localhost:8000
```

Buka `http://localhost:8000/beranda.php` lalu klik menu **Tentang**.

**Yang seharusnya terlihat:**

- Judul tab: `Beranda - Situs Latihan`, dan `Tentang - Situs Latihan` pada halaman kedua.
- Menu navigasi dan footer (dengan tahun berjalan) tampil di kedua halaman.
- *View Page Source* menampilkan satu dokumen HTML utuh, hasil gabungan header, isi
  halaman, dan footer.

Coba ubah teks menu di `header.php`, lalu muat ulang kedua halaman: keduanya ikut berubah
karena header hanya ditulis sekali.

### Langkah 2: `require_once` untuk fungsi

```php title="belajar-php/helpers.php"
<?php

function rupiah(int $angka): string
{
    return "Rp " . number_format($angka, 0, ",", ".");
}
```

```php title="belajar-php/pakai-helpers.php"
<?php

require_once __DIR__ . "/helpers.php";
require_once __DIR__ . "/helpers.php";

echo rupiah(2500000), "\n";
```

Jalankan di terminal (hentikan server dahulu dengan ++ctrl+c++, atau buka terminal baru):

```bash
php pakai-helpers.php
```

**Yang seharusnya terlihat:** `Rp 2.500.000`. Pemuatan kedua diabaikan oleh `_once`.

Ganti kedua baris `require_once` menjadi `require`, lalu jalankan lagi. **Yang seharusnya
terlihat:** error fatal bahwa fungsi `rupiah()` tidak dapat dideklarasikan ulang (*Cannot
redeclare*). Kembalikan ke `require_once` setelah mencoba.

### Langkah 3: berkas yang mengembalikan nilai

```php title="belajar-php/config.php"
<?php

return [
    "nama_aplikasi" => "Situs Latihan",
    "versi" => "1.0",
    "debug" => true,
];
```

```php title="belajar-php/pakai-config.php"
<?php

$config = require __DIR__ . "/config.php";

echo $config["nama_aplikasi"], " v", $config["versi"], "\n";
var_dump($config["debug"]);
```

```bash
php pakai-config.php
```

**Yang seharusnya terlihat:**

```text
Situs Latihan v1.0
bool(true)
```

### Langkah 4: berbagi variabel

```php title="belajar-php/partial.php"
<?php

echo "Halo, $nama, dari berkas yang di-include.\n";
$dariPartial = "dibuat di partial";
```

```php title="belajar-php/bagikan.php"
<?php

$nama = "Budi";
include __DIR__ . "/partial.php";
echo $dariPartial, "\n";
```

```bash
php bagikan.php
```

**Yang seharusnya terlihat:**

```text
Halo, Budi, dari berkas yang di-include.
dibuat di partial
```

### Langkah 5: berkas yang hilang

```php title="belajar-php/hilang.php"
<?php

echo "Sebelum\n";

include __DIR__ . "/tidak-ada.php";
echo "Sesudah include\n";

require __DIR__ . "/tidak-ada.php";
echo "Sesudah require\n";
```

```bash
php hilang.php
```

**Yang seharusnya terlihat:**

- `Sebelum`.
- Peringatan bahwa berkas `tidak-ada.php` gagal dibuka (jika PHP-mu menampilkan peringatan),
  lalu `Sesudah include`: `include` tidak menghentikan skrip.
- Untuk `require`, pesan peringatan lalu **error fatal**, dan teks `Sesudah require` **tidak
  pernah tercetak**: `require` menghentikan skrip.

Bunyi pesan persisnya dapat berbeda antar versi dan pengaturan PHP.

### Langkah 6: daftar putih halaman

```php title="belajar-php/index.php"
<?php

$boleh = ["beranda", "tentang"];
$halaman = $_GET["halaman"] ?? "beranda";

if (!in_array($halaman, $boleh, true)) {
    http_response_code(404);
    echo "Halaman tidak ditemukan.";
    exit;
}

require __DIR__ . "/$halaman.php";
```

Dengan server berjalan, buka:

- `http://localhost:8000/index.php` dan `...?halaman=tentang`: menampilkan halaman yang sesuai.
- `...?halaman=config`: menampilkan `Halaman tidak ditemukan.` (status 404), karena tidak
  ada di daftar putih.

Periksa statusnya dengan `curl.exe -i "http://localhost:8000/index.php?halaman=config"`
(di macOS/Linux cukup `curl`). **Yang seharusnya terlihat:** baris status berkode `404`.

## Kesalahan umum dan debugging

| Gejala | Kemungkinan penyebab | Solusi |
|---|---|---|
| Warning *Failed to open stream* | Jalur salah atau berkas belum dibuat | Cek jalur; gunakan `__DIR__ . "/..."`. |
| Bekerja di satu folder, gagal di folder lain | Jalur relatif bergantung pada folder kerja | Pakai `__DIR__`. |
| `Cannot redeclare nama()` | Berkas fungsi dimuat dua kali dengan `require`/`include` | Pakai `require_once`. |
| `Undefined variable $judul` di header | Variabel belum diisi sebelum `require` | Isi variabel sebelum memuat header. |
| Spasi/baris kosong tak terduga di keluaran | Ada spasi di luar tag PHP pada berkas yang dimuat | Rapikan; hindari baris kosong sebelum `<?php`. |
| Pesan `headers already sent` setelah `include` | Berkas yang dimuat menghasilkan keluaran sebelum `header()` | Panggil `header()` sebelum memuat berkas bertampilan. |
| Skrip tetap jalan padahal berkas penting hilang | Memakai `include` | Gunakan `require` untuk berkas wajib. |
| Berkas lain terbaca di server | Jalur dibentuk dari input pengguna | Pakai daftar putih; jangan pernah menggabungkan input langsung ke jalur. |

## Latihan terpandu

1. Tambahkan halaman `kontak.php` yang memakai header dan footer yang sama dan tambahkan
   menu **Kontak** di `header.php`. Pastikan menu muncul di ketiga halaman.
2. Tambahkan fungsi `salam(string $nama): string` ke `helpers.php` dan pakai di halaman
   `beranda.php` lewat `require_once`.
3. Tambahkan `"email_admin"` ke `config.php`, lalu tampilkan di footer lewat
   `require`-nya (`$config = require __DIR__ . "/../config.php";` dari dalam `layout`).
4. Ubah `header.php` agar menampilkan nama aplikasi dari `config.php`.
5. Tambahkan `"kontak"` ke daftar putih `index.php` dan uji `?halaman=kontak`.
6. Jelaskan mengapa `include $_GET["halaman"] . ".php"` berbahaya dan bagaimana daftar
   putih mencegahnya.

??? success "Petunjuk nomor 3 dan 6"
    **Nomor 3:** pada `footer.php`, `__DIR__` menunjuk folder `layout`, jadi jalur ke
    `config.php` di folder induk adalah `__DIR__ . "/../config.php"`.

    **Nomor 6:** input pengguna bisa diisi nama berkas lain yang tidak dimaksudkan,
    sehingga kode atau data sensitif ikut dimuat. Daftar putih hanya mengizinkan nilai
    yang sudah kamu tentukan, jadi nilai lain ditolak.

## Pertanyaan review

1. Mengapa aplikasi dipecah menjadi beberapa berkas?
2. Apa beda `include` dan `require` ketika berkas tidak ada?
3. Apa fungsi akhiran `_once`?
4. Mengapa `__DIR__` lebih andal daripada jalur relatif?
5. Bagaimana berkas bisa mengembalikan nilai, dan di mana pola ini dipakai di Laravel?
6. Apa risiko memuat berkas berdasarkan input pengguna?
7. Apa kaitan bab ini dengan `@include` pada Blade?

## Ringkasan

- `include` dan `require` memuat berkas lain; `require` menghentikan skrip bila gagal.
- `_once` mencegah pemuatan ganda, penting untuk berkas berisi fungsi atau kelas.
- Gunakan `__DIR__` agar jalur berkas selalu benar.
- Berkas yang dimuat berbagi scope variabel dan dapat `return` nilai (pola konfigurasi).
- Jangan pernah menyusun jalur berkas dari input pengguna tanpa daftar putih.

Selanjutnya: **Object-Oriented Programming**.

## Referensi resmi

- [PHP Manual: include](https://www.php.net/manual/en/function.include.php)
- [PHP Manual: require](https://www.php.net/manual/en/function.require.php)
- [PHP Manual: include_once](https://www.php.net/manual/en/function.include-once.php)
- [PHP Manual: require_once](https://www.php.net/manual/en/function.require-once.php)
- [PHP Manual: Magic constants](https://www.php.net/manual/en/language.constants.magic.php)
- [PHP Manual: Filesystem security](https://www.php.net/manual/en/security.filesystem.php)
- [Laravel: Configuration](https://laravel.com/docs/13.x/configuration)
- [Laravel: Blade Templates](https://laravel.com/docs/13.x/blade)
