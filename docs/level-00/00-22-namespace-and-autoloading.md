# Namespace dan Autoloading

Ketika proyek tumbuh, kamu akan punya puluhan class, sebagian dengan nama yang sama
(`Buku` untuk model, `Buku` untuk layanan). Dua masalah muncul: **bentrok nama** dan
**repotnya memuat satu per satu berkas dengan `require`**. *Namespace* dan *autoloading*
memecahkan keduanya, dan inilah alasan di setiap berkas Laravel ada baris
`namespace App\...` dan `use ...`.

## Tujuan pembelajaran

Setelah menyelesaikan bab ini, kamu dapat:

- [ ] Menjelaskan fungsi namespace dan membaca nama class lengkap (*fully qualified*).
- [ ] Menulis `namespace`, `use`, dan alias `as`.
- [ ] Menjelaskan mengapa class global seperti `Exception` perlu `\` di dalam namespace.
- [ ] Menjelaskan autoloading dan standar PSR-4 yang memetakan namespace ke folder.
- [ ] Menulis autoloader sederhana dengan `spl_autoload_register`.
- [ ] Membaca struktur `App\...` pada proyek Laravel.

## Prasyarat

- Bab [Include dan Require](00-17-include-and-require.md) dan
  [Class dan Objek](00-19-classes-and-objects.md).
- PHP 8.3 atau lebih baru; folder `belajar-php`.

## Konsep

### Masalah bentrok nama

Dua class bernama sama tidak boleh ada dalam satu program. Namun `Buku` sebagai model data
dan `Buku` sebagai entri katalog adalah hal yang wajar. Namespace memberi nama "alamat"
sehingga keduanya bisa hidup berdampingan.

!!! tip "Analogi"
    Dua orang bernama Budi tidak membingungkan bila disebut lengkap: "Budi dari Bandung"
    dan "Budi dari Surabaya". Namespace adalah "kotanya"; nama class adalah "Budi".

### Mendeklarasikan namespace

```php
<?php

namespace Latihan\Model;

class Buku
{
    public function __construct(public string $judul) {}
}
```

- `namespace` harus menjadi pernyataan pertama setelah `<?php` (selain `declare`).
- Nama lengkap class ini adalah **`Latihan\Model\Buku`** (*fully qualified class name*,
  FQCN).
- Tanda `\` memisahkan bagian namespace.
- Setiap bagian ditulis `StudlyCaps`.

`Buku::class` menghasilkan FQCN dalam bentuk teks: `Latihan\Model\Buku`.

### Memakai class dari namespace lain

Ada dua cara merujuk class di namespace lain:

```php
$a = new \Latihan\Model\Buku("PHP");   // nama lengkap, diawali \

use Latihan\Model\Buku;                // impor di atas berkas
$b = new Buku("PHP");                  // cukup nama pendek
```

Aturan `use`:

- Ditaruh di bagian atas berkas, setelah `namespace`.
- Hanya mengimpor **nama**; ia tidak memuat berkas (itu tugas autoloader).
- Bentrok nama diselesaikan dengan alias: `use Latihan\Katalog\Buku as BukuKatalog;`.
- Beberapa class dari namespace sama dapat dikelompokkan:
  `use Latihan\Model\{Buku, Anggota};`.

### Class global di dalam namespace

Di dalam namespace, nama tanpa awalan dianggap ada di namespace itu. Class bawaan PHP
seperti `Exception`, `DateTime`, atau `InvalidArgumentException` berada di namespace
**global**, sehingga harus ditulis dengan `\` di depan atau diimpor:

```php
namespace Latihan\Model;

throw new \InvalidArgumentException("Salah");   // dengan \

use InvalidArgumentException;
throw new InvalidArgumentException("Salah");    // atau impor
```

Tanpa itu PHP mencari `Latihan\Model\InvalidArgumentException` dan melaporkan class tidak
ditemukan. Pesan semacam ini sangat sering dijumpai pemula.

### Autoloading

Tanpa autoloading, setiap class harus dimuat dengan `require` secara manual. **Autoloader**
adalah fungsi yang dipanggil PHP **otomatis** ketika sebuah class dipakai tetapi belum
dikenal. Fungsi itu bertugas mencari dan memuat berkas class tersebut. Daftarkan dengan
`spl_autoload_register()`.

### PSR-4: standar pemetaan namespace ke folder

PSR-4 adalah standar komunitas yang disepakati hampir semua proyek PHP. Aturannya:

1. Satu **awalan namespace** dipetakan ke satu **folder dasar**.
2. Sisa namespace menjadi **subfolder**.
3. Nama class menjadi **nama berkas** `NamaClass.php`.

Contoh dengan `Latihan\` → `src/`:

| Nama class | Berkas |
|---|---|
| `Latihan\Model\Buku` | `src/Model/Buku.php` |
| `Latihan\Service\Perpustakaan` | `src/Service/Perpustakaan.php` |

!!! warning "Huruf besar-kecil penting di Linux"
    Linux membedakan huruf besar-kecil pada nama berkas: `buku.php` dan `Buku.php` adalah
    berkas berbeda. Nama berkas harus **persis sama** dengan nama class.

### Di Laravel dan Composer

Kamu tidak perlu menulis autoloader sendiri. **Composer** (dibahas di bab berikutnya)
membuatnya dari bagian `autoload` pada `composer.json`. Proyek Laravel umumnya memetakan
`App\` ke folder `app/`:

| Class | Berkas |
|---|---|
| `App\Http\Controllers\MateriController` | `app/Http/Controllers/MateriController.php` |
| `App\Models\Materi` | `app/Models/Materi.php` |
| `Illuminate\Support\Facades\Route` | di dalam folder `vendor/` (kode Laravel) |

Itulah mengapa di awal controller selalu ada `namespace App\Http\Controllers;`, dan di
route kamu menulis `use App\Http\Controllers\MateriController;`.

## Praktik

Buat proyek mini di dalam `belajar-php`:

```text
belajar-php/autoload/
├── autoload.php
├── index.php
└── src/
    ├── Model/
    │   └── Buku.php
    ├── Service/
    │   └── Perpustakaan.php
    └── Katalog/
        └── Buku.php
```

### Langkah 1: class dalam namespace

```php title="belajar-php/autoload/src/Model/Buku.php"
<?php

namespace Latihan\Model;

class Buku
{
    public function __construct(public string $judul) {}
}
```

```php title="belajar-php/autoload/src/Service/Perpustakaan.php"
<?php

namespace Latihan\Service;

use Latihan\Model\Buku;

class Perpustakaan
{
    private array $koleksi = [];

    public function tambah(Buku $buku): static
    {
        $this->koleksi[] = $buku;

        return $this;
    }

    public function daftar(): array
    {
        return array_map(fn (Buku $buku) => $buku->judul, $this->koleksi);
    }
}
```

`Perpustakaan` memakai `Buku` dari namespace lain, sehingga ia mengimpornya dengan `use`.

### Langkah 2: autoloader

```php title="belajar-php/autoload/autoload.php"
<?php

spl_autoload_register(function (string $class): void {
    $awalan = "Latihan\\";
    $folderDasar = __DIR__ . "/src/";

    if (strncmp($class, $awalan, strlen($awalan)) !== 0) {
        return;
    }

    $relatif = substr($class, strlen($awalan));
    $berkas = $folderDasar . str_replace("\\", "/", $relatif) . ".php";

    if (is_file($berkas)) {
        require $berkas;
    }
});
```

| Bagian | Arti |
|---|---|
| `spl_autoload_register(fn)` | Mendaftarkan fungsi yang dipanggil PHP saat class belum dikenal. |
| `$class` | Nama class lengkap yang dicari, mis. `Latihan\Model\Buku`. |
| `strncmp(...)` | Memastikan class berawalan `Latihan\`; selain itu diabaikan. |
| `substr(...)` | Membuang awalan, sehingga tersisa `Model\Buku`. |
| `str_replace("\\", "/", ...)` | Mengubah pemisah namespace menjadi pemisah folder. |
| `is_file` lalu `require` | Memuat berkas jika ada. |

### Langkah 3: memakai class tanpa `require`

```php title="belajar-php/autoload/index.php"
<?php

require __DIR__ . "/autoload.php";

use Latihan\Model\Buku;
use Latihan\Service\Perpustakaan;

$perpustakaan = new Perpustakaan();
$perpustakaan
    ->tambah(new Buku("Belajar PHP"))
    ->tambah(new Buku("Belajar Laravel"));

echo implode(", ", $perpustakaan->daftar()), "\n";
echo Buku::class, "\n";
```

Jalankan dari folder `belajar-php/autoload`:

```bash
cd belajar-php/autoload
php index.php
```

**Yang seharusnya terlihat:**

```text
Belajar PHP, Belajar Laravel
Latihan\Model\Buku
```

Perhatikan bahwa `index.php` hanya memuat `autoload.php`. Berkas `Buku.php` dan
`Perpustakaan.php` dimuat otomatis saat class-nya pertama kali dipakai. Kamu perlu
mencocokkan sendiri hasil di terminalmu dengan keluaran di atas.

### Langkah 4: bentrok nama dan alias

Buat class kedua bernama `Buku` di namespace lain:

```php title="belajar-php/autoload/src/Katalog/Buku.php"
<?php

namespace Latihan\Katalog;

class Buku
{
    public function __construct(public string $isbn) {}
}
```

Ubah bagian bawah `index.php` menjadi:

```php title="belajar-php/autoload/index.php"
<?php

require __DIR__ . "/autoload.php";

use Latihan\Katalog\Buku as BukuKatalog;
use Latihan\Model\Buku;

$model = new Buku("Belajar PHP");
$katalog = new BukuKatalog("978-0-00-000000-0");

echo get_class($model), "\n";
echo get_class($katalog), "\n";
echo $model->judul, " / ", $katalog->isbn, "\n";
```

**Yang seharusnya terlihat:**

```text
Latihan\Model\Buku
Latihan\Katalog\Buku
Belajar PHP / 978-0-00-000000-0
```

Dua class `Buku` berdampingan tanpa bentrok. Tanpa alias `as`, `use` kedua akan gagal
karena nama `Buku` sudah dipakai.

### Langkah 5: class global di dalam namespace

Tambahkan method berikut ke `src/Model/Buku.php`:

```php
public function validasi(): void
{
    if ($this->judul === "") {
        throw new Exception("Judul kosong");
    }
}
```

Lalu panggil dari `index.php`:

```php
(new Buku(""))->validasi();
```

**Yang seharusnya terlihat:** error bahwa class `Latihan\Model\Exception` tidak ditemukan
(bunyi persis tergantung versi PHP), karena `Exception` dicari di dalam namespace
`Latihan\Model`. Perbaiki dengan `throw new \Exception("Judul kosong");` atau
`use Exception;` di bagian atas `Buku.php`. Setelah diperbaiki, program berhenti dengan
exception `Judul kosong` yang tidak tertangkap (seperti pada bab sebelumnya); itu sudah
sesuai.

### Langkah 6: salah nama berkas

Ganti nama `src/Service/Perpustakaan.php` menjadi `src/Service/perpustakaan.php`, kembalikan
`index.php` ke versi Langkah 3, dan jalankan lagi.

**Yang seharusnya terlihat:** pada Linux, error bahwa class `Latihan\Service\Perpustakaan`
tidak ditemukan, karena huruf kecil membuat nama berkas tidak lagi cocok dengan nama class.
Kembalikan nama berkas ke `Perpustakaan.php` setelah mencobanya.

## Kesalahan umum dan debugging

| Gejala | Kemungkinan penyebab | Solusi |
|---|---|---|
| `Class "X\Y" not found` | Namespace, nama berkas, atau lokasi folder tidak cocok dengan aturan autoloader | Samakan namespace ↔ folder ↔ nama berkas. |
| Class bawaan (`Exception`, `DateTime`) tidak ditemukan di namespace | Lupa `\` atau `use` | Tulis `\Exception` atau `use Exception;`. |
| Berhasil di Windows, gagal di Linux | Huruf besar-kecil nama berkas berbeda | Samakan persis dengan nama class. |
| `Cannot use X as Y because the name is already in use` | Dua `use` dengan nama pendek sama | Beri alias dengan `as`. |
| `Namespace declaration statement has to be the very first statement` | Ada keluaran atau kode sebelum `namespace` | Pindahkan `namespace` tepat setelah `<?php`. |
| `use` tidak memuat berkas | `use` hanya mengimpor nama | Pastikan autoloader terdaftar atau berkas dimuat. |
| Autoloader tidak dipanggil | `autoload.php` belum dimuat sebelum class dipakai | `require` autoloader paling awal. |
| Nama class dalam string kutip ganda berubah aneh | Tanda `\` dapat terbaca sebagai karakter escape (mis. `\n`, `\t`) | Pakai `Buku::class`, atau gandakan menjadi `\\`. |

## Latihan terpandu

1. Tambahkan class `Latihan\Model\Anggota` dengan property `nama`, lalu pakai di `index.php`
   tanpa menambah `require` baru.
2. Tambahkan namespace baru `Latihan\Exception` berisi `BukuTidakDitemukanException` yang
   mewarisi `\RuntimeException`, simpan di `src/Exception/`, dan lempar dari
   `Perpustakaan::cari()`.
3. Tuliskan FQCN dan jalur berkas untuk class berikut bila dipetakan seperti pada praktik:
   `Latihan\Service\Pembayaran\Tunai`.
4. Ubah `autoload.php` agar memetakan dua awalan namespace berbeda ke dua folder dasar.
5. Buka `composer.json` pada proyek Laravel (bila sudah ada) atau bayangkan isinya dan
   tuliskan pemetaan `App\` ke folder yang sesuai.
6. Jelaskan mengapa `use` tidak sama dengan `require`.

??? success "Petunjuk nomor 3 dan 6"
    **Nomor 3:** FQCN `Latihan\Service\Pembayaran\Tunai`, berkas
    `src/Service/Pembayaran/Tunai.php`.

    **Nomor 6:** `use` hanya memberi tahu PHP nama pendek apa yang merujuk ke class lengkap
    mana. Memuat kode class dilakukan oleh `require` atau, lebih baik, autoloader.

## Pertanyaan review

1. Masalah apa yang dipecahkan namespace?
2. Apa itu FQCN dan bagaimana mendapatkannya dari `Nama::class`?
3. Apa fungsi `use` dan alias `as`?
4. Mengapa `Exception` perlu `\` di dalam namespace?
5. Apa tugas autoloader dan bagaimana `spl_autoload_register` bekerja?
6. Apa tiga aturan utama PSR-4?
7. Di folder mana `App\Http\Controllers\MateriController` berada pada proyek Laravel?
8. Mengapa huruf besar-kecil nama berkas penting di Linux?

## Ringkasan

- Namespace memberi class "alamat" sehingga nama yang sama dapat dipakai tanpa bentrok.
- `use` mengimpor nama; `as` membuat alias; class global memakai `\` atau `use`.
- Autoloader memuat berkas class otomatis saat dibutuhkan; daftarkan dengan
  `spl_autoload_register`.
- PSR-4 memetakan awalan namespace ke folder dan nama class ke nama berkas.
- Composer membuat autoloader PSR-4 untuk proyek Laravel (`App\` → `app/`).

Selanjutnya: **Composer dan Package Management**.

## Referensi resmi

- [PHP Manual: Namespaces](https://www.php.net/manual/en/language.namespaces.php)
- [PHP Manual: Namespaces basics](https://www.php.net/manual/en/language.namespaces.basics.php)
- [PHP Manual: Using namespaces (aliasing/importing)](https://www.php.net/manual/en/language.namespaces.importing.php)
- [PHP Manual: Global space](https://www.php.net/manual/en/language.namespaces.global.php)
- [PHP Manual: Autoloading classes](https://www.php.net/manual/en/language.oop5.autoload.php)
- [PHP Manual: spl_autoload_register](https://www.php.net/manual/en/function.spl-autoload-register.php)
- [PHP-FIG: PSR-4 Autoloader](https://www.php-fig.org/psr/psr-4/)
- [Composer: Basic usage](https://getcomposer.org/doc/01-basic-usage.md)
