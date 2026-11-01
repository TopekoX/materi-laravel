# Fungsi

Bayangkan kamu perlu menghitung diskon di sepuluh tempat berbeda. Menyalin kode yang sama
sepuluh kali melelahkan dan rawan salah. **Fungsi** adalah blok kode bernama yang bisa
dipanggil berulang kali. Fungsi juga fondasi dari hampir semua kode Laravel: setiap method
controller dan setiap route adalah fungsi.

## Tujuan pembelajaran

Setelah menyelesaikan bab ini, kamu dapat:

- [ ] Membuat fungsi dengan parameter dan nilai kembalian.
- [ ] Memakai nilai default, *named arguments*, dan parameter *variadic*.
- [ ] Menambahkan deklarasi tipe pada parameter dan nilai kembalian.
- [ ] Menjelaskan ruang lingkup (*scope*) variabel di dalam dan di luar fungsi.
- [ ] Menulis fungsi anonim (closure) dan *arrow function*.
- [ ] Memakai fungsi bawaan yang menerima fungsi, seperti `array_map` dan `usort`.

## Prasyarat

- Bab [Array](00-13-arrays.md), [Perulangan](00-12-loops.md), dan
  [Pernyataan Kondisional](00-11-conditional-statements.md).
- PHP 8.3 atau lebih baru terpasang; folder `belajar-php`.

## Konsep

!!! tip "Analogi"
    Fungsi seperti resep. Resep ditulis sekali (definisi), lalu dipakai setiap kali kamu
    memasak (pemanggilan). Bahan yang kamu berikan adalah parameter, masakan jadi adalah
    nilai kembalian.

### Mendefinisikan dan memanggil fungsi

```php
function sapa(string $nama): string
{
    return "Halo, $nama!";
}

echo sapa("Budi");   // Halo, Budi!
```

| Bagian | Arti |
|---|---|
| `function` | Kata kunci pembuat fungsi |
| `sapa` | Nama fungsi |
| `(string $nama)` | **Parameter**: data masukan yang diterima fungsi |
| `: string` | **Tipe kembalian**: jenis nilai yang dikembalikan |
| `return` | Mengirim nilai ke pemanggil dan **menghentikan** fungsi |
| `sapa("Budi")` | **Pemanggilan**; `"Budi"` disebut **argumen** |

Aturan nama fungsi sama dengan variabel (huruf, angka, garis bawah), tanpa `$`. Tulislah
dalam `camelCase` dan buat namanya berupa kata kerja: `hitungDiskon`, `ambilPengguna`.

Fungsi tingkat atas yang didefinisikan tanpa syarat dapat dipanggil sebelum baris
definisinya, karena PHP membaca definisinya lebih dulu.

### Parameter

**Nilai default** dipakai bila argumen tidak diberikan. Parameter dengan default harus
ditulis setelah parameter wajib:

```php
function sapa(string $nama, string $sapaan = "Halo"): string
{
    return "$sapaan, $nama!";
}

echo sapa("Budi");              // Halo, Budi!
echo sapa("Budi", "Selamat pagi");
```

**Named arguments** (PHP 8) memanggil argumen berdasarkan nama, sehingga urutan bebas dan
maksudnya jelas:

```php
echo sapa(sapaan: "Selamat malam", nama: "Sari");
```

**Variadic** (`...`) menerima sejumlah argumen sebagai satu array:

```php
function jumlah(int ...$angka): int
{
    return array_sum($angka);
}

echo jumlah(1, 2, 3, 4);   // 10
```

### Deklarasi tipe

Menulis tipe pada parameter dan kembalian membuat kode lebih jelas dan memunculkan error
lebih awal.

| Bentuk | Arti |
|---|---|
| `int $a` | Harus bilangan bulat |
| `?string $nama` | `string` atau `null` (nullable) |
| <code>int&#124;float $x</code> | Gabungan tipe (*union*) |
| `: void` | Fungsi tidak mengembalikan nilai |
| `: bool`, `: array`, `: string`, ... | Tipe kembalian |

Jika nilai yang diberikan tidak cocok dan tidak bisa diubah dengan aman, PHP melempar
`TypeError`. Secara bawaan PHP masih mau mengubah nilai yang "mirip", misalnya teks `"5"`
menjadi `5` untuk parameter `int`. Dengan `declare(strict_types=1);` di baris pertama
berkas, hal itu dilarang. Pada kode Laravel kamu akan melihat deklarasi tipe di hampir
semua tempat.

### Ruang lingkup variabel

Variabel yang dibuat **di dalam** fungsi bersifat lokal. Variabel di luar fungsi tidak
terlihat dari dalam fungsi:

```php
$pesan = "luar";

function tes()
{
    return $pesan ?? "tidak terlihat";
}

echo tes();   // tidak terlihat
```

Cara yang benar untuk memberi data ke fungsi adalah lewat **parameter**, dan
mengambil hasilnya lewat **return**. Hindari variabel global.

### Fungsi anonim dan arrow function

Fungsi tanpa nama bisa disimpan dalam variabel atau dikirim ke fungsi lain. Disebut juga
**closure**:

```php
$kali2 = function (int $x): int {
    return $x * 2;
};
echo $kali2(4);   // 8

$kali3 = fn (int $x): int => $x * 3;   // arrow function
echo $kali3(4);   // 12
```

- *Arrow function* (`fn`) berisi satu ekspresi dan **otomatis** mengambil variabel luar
  yang dipakainya (berdasarkan nilai).
- Fungsi anonim biasa memakai `use` untuk mengambil variabel luar:

```php
$faktor = 10;
$tambah = function (int $x) use ($faktor): int {
    return $x + $faktor;
};
```

Closure inilah yang kamu lihat di route Laravel: `Route::get('/tentang', function () { ... });`.

### Fungsi yang menerima fungsi

| Fungsi | Kegunaan |
|---|---|
| `array_map($fungsi, $array)` | Menerapkan fungsi ke tiap elemen, hasilnya array baru |
| `array_filter($array, $fungsi)` | Menyaring elemen yang membuat fungsi bernilai `true` |
| `usort($array, $fungsi)` | Mengurutkan dengan aturan sendiri |

```php
$ganda = array_map(fn ($n) => $n * 2, [1, 2, 3]);       // [2, 4, 6]
$genap = array_filter([1, 2, 3, 4], fn ($n) => $n % 2 === 0);   // [1 => 2, 3 => 4]
```

`array_filter` mempertahankan kunci aslinya; bungkus dengan `array_values()` jika ingin
dinomori ulang.

### Rekursi

Fungsi boleh memanggil dirinya sendiri, selama ada **kondisi berhenti**:

```php
function faktorial(int $n): int
{
    return $n <= 1 ? 1 : $n * faktorial($n - 1);
}
```

### Fungsi bawaan

PHP memiliki ribuan fungsi bawaan, misalnya `count`, `strlen`, `round`, `date`,
`array_sum`. Kamu sudah memakai beberapa di bab-bab sebelumnya. Cari fungsi di
dokumentasi PHP sebelum menulisnya sendiri.

## Praktik

Semua berkas dibuat di folder `belajar-php`.

### Langkah 1: fungsi dasar

```php title="belajar-php/fungsi.php"
<?php

function sapa(string $nama, string $sapaan = "Halo"): string
{
    return "$sapaan, $nama!";
}

function tambah(int $a, int $b): int
{
    return $a + $b;
}

function cetakGaris(): void
{
    echo "--------\n";
}

echo sapa("Budi"), "\n";
echo sapa("Sari", "Selamat pagi"), "\n";
echo sapa(sapaan: "Selamat malam", nama: "Andi"), "\n";
cetakGaris();
echo tambah(2, 3), "\n";
```

```bash
cd belajar-php
php fungsi.php
```

**Yang seharusnya terlihat:**

```text
Halo, Budi!
Selamat pagi, Sari!
Selamat malam, Andi!
--------
5
```

Kamu perlu mencocokkan sendiri hasil di terminalmu dengan keluaran di atas.

### Langkah 2: variadic dan nullable

```php title="belajar-php/fungsi-lanjut.php"
<?php

function jumlah(int ...$angka): int
{
    return array_sum($angka);
}

function namaAtauTamu(?string $nama = null): string
{
    return $nama ?? "Tamu";
}

echo jumlah(1, 2, 3, 4), "\n";
echo jumlah(), "\n";
echo namaAtauTamu(), "\n";
echo namaAtauTamu("Budi"), "\n";
```

**Yang seharusnya terlihat:**

```text
10
0
Tamu
Budi
```

### Langkah 3: ruang lingkup

```php title="belajar-php/scope.php"
<?php

$pesan = "luar";

function tanpaParameter()
{
    return $pesan ?? "tidak terlihat";
}

function denganParameter(string $pesan): string
{
    return $pesan;
}

echo tanpaParameter(), "\n";
echo denganParameter($pesan), "\n";
```

**Yang seharusnya terlihat:**

```text
tidak terlihat
luar
```

### Langkah 4: kesalahan tipe

```php title="belajar-php/tipe-error.php"
<?php

function tambah(int $a, int $b): int
{
    return $a + $b;
}

echo tambah("5", 3), "\n";
echo tambah("abc", 3), "\n";
```

**Yang seharusnya terlihat:** baris pertama mencetak `8` (teks `"5"` diubah menjadi
bilangan karena tidak ada `strict_types`). Pemanggilan kedua menghentikan program dengan
error fatal bertipe `TypeError` yang menyebut argumen ke-1 harus bertipe `int` tetapi
menerima `string` (bunyi pesan lengkap bisa berbeda antar versi PHP). Tambahkan
`declare(strict_types=1);` tepat di bawah `<?php` dan lihat bahwa pemanggilan pertama
pun kini gagal.

### Langkah 5: closure dan fungsi yang menerima fungsi

```php title="belajar-php/closure.php"
<?php

$kali2 = function (int $x): int {
    return $x * 2;
};

$kali3 = fn (int $x): int => $x * 3;

$faktor = 10;
$tambah = function (int $x) use ($faktor): int {
    return $x + $faktor;
};

echo $kali2(4), "\n";
echo $kali3(4), "\n";
echo $tambah(5), "\n";

$ganda = array_map(fn ($n) => $n * 2, [1, 2, 3]);
echo implode(", ", $ganda), "\n";

$genap = array_filter([1, 2, 3, 4], fn ($n) => $n % 2 === 0);
echo implode(", ", $genap), "\n";

$siswa = [
    ["nama" => "Budi", "nilai" => 80],
    ["nama" => "Sari", "nilai" => 90],
    ["nama" => "Andi", "nilai" => 70],
];

usort($siswa, fn ($a, $b) => $b["nilai"] <=> $a["nilai"]);

foreach ($siswa as $s) {
    echo $s["nama"], ": ", $s["nilai"], "\n";
}
```

**Yang seharusnya terlihat:**

```text
8
12
15
2, 4, 6
2, 4
Sari: 90
Budi: 80
Andi: 70
```

`usort` mengurutkan dari nilai tertinggi karena fungsi pembanding membalik urutan
(`$b` dibanding `$a`).

### Langkah 6: rekursi

```php title="belajar-php/rekursi.php"
<?php

function faktorial(int $n): int
{
    return $n <= 1 ? 1 : $n * faktorial($n - 1);
}

echo faktorial(5), "\n";
echo faktorial(1), "\n";
```

**Yang seharusnya terlihat:**

```text
120
1
```

## Kesalahan umum dan debugging

| Gejala | Kemungkinan penyebab | Solusi |
|---|---|---|
| `Call to undefined function x()` | Salah ketik nama, atau fungsi belum dimuat | Periksa ejaan dan pastikan definisinya ada. |
| `Cannot redeclare x()` | Dua fungsi dengan nama sama | Beri nama berbeda. |
| `ArgumentCountError: Too few arguments` | Argumen wajib kurang | Lengkapi argumen atau beri nilai default. |
| `TypeError: ... must be of type int, string given` | Tipe argumen tidak cocok | Kirim tipe yang benar atau ubah dengan casting yang disengaja. |
| Fungsi mengembalikan `null` | Lupa `return` | Tambahkan `return`. |
| Variabel luar "tidak ditemukan" dalam fungsi | Scope lokal | Kirim lewat parameter, atau `use` pada closure. |
| Kode setelah `return` tidak jalan | `return` mengakhiri fungsi | Pindahkan kodenya sebelum `return`. |
| Rekursi tak berujung | Kondisi berhenti hilang atau salah | Pastikan setiap panggilan mendekati kondisi berhenti. |

## Latihan terpandu

1. Buat `luasPersegiPanjang(float $panjang, float $lebar): float` dan cetak hasil untuk
   `5` dan `3`.
2. Buat `hitungDiskon(int $harga, int $persen = 10): int` yang mengembalikan harga setelah
   diskon. Panggil dengan satu dan dua argumen, serta dengan named arguments.
3. Buat `ratarata(float ...$angka): float` yang mengembalikan rata-rata. Tangani kasus tanpa
   argumen dengan mengembalikan `0.0`.
4. Dari `[1, 2, 3, 4, 5, 6]`, hasilkan array kuadrat dengan `array_map` dan array bilangan
   ganjil dengan `array_filter`.
5. Urutkan array siswa pada praktik berdasarkan nama (naik) memakai `usort` dan `<=>`.
6. Jelaskan perbedaan fungsi anonim biasa dengan arrow function, dan kapan memakai `use`.

??? success "Petunjuk nomor 3 dan 6"
    **Nomor 3:**
    ```php
    function ratarata(float ...$angka): float
    {
        return count($angka) === 0 ? 0.0 : array_sum($angka) / count($angka);
    }
    ```

    **Nomor 6:** arrow function hanya berisi satu ekspresi dan otomatis menangkap variabel
    luar berdasarkan nilai. Fungsi anonim biasa boleh berisi banyak pernyataan dan harus
    menyebut variabel luar secara eksplisit dengan `use`.

## Pertanyaan review

1. Apa beda parameter dan argumen?
2. Apa yang dilakukan `return`?
3. Apa fungsi nilai default dan named arguments?
4. Apa arti tipe `?string` dan `: void`?
5. Mengapa variabel di luar fungsi tidak terlihat di dalam fungsi?
6. Apa itu closure, dan di mana kamu akan menemuinya di Laravel?
7. Apa yang dilakukan `array_map` dan `array_filter`?
8. Apa syarat agar rekursi aman?

## Ringkasan

- Fungsi membungkus kode agar dapat dipakai ulang: `function nama(parameter): tipe { ... }`.
- Parameter dapat punya nilai default, dipanggil dengan nama, atau bersifat variadic.
- Deklarasi tipe membuat kode lebih jelas; ketidakcocokan memicu `TypeError`.
- Variabel di dalam fungsi bersifat lokal; kirim data lewat parameter dan `return`.
- Closure dan arrow function dapat disimpan di variabel atau dikirim ke fungsi lain, dan
  menjadi dasar route Laravel.
- `array_map`, `array_filter`, dan `usort` memproses array dengan fungsi.

Selanjutnya: **String Manipulation**.

## Referensi resmi

- [PHP Manual: Functions](https://www.php.net/manual/en/language.functions.php)
- [PHP Manual: User-defined functions](https://www.php.net/manual/en/functions.user-defined.php)
- [PHP Manual: Function arguments](https://www.php.net/manual/en/functions.arguments.php)
- [PHP Manual: Returning values](https://www.php.net/manual/en/functions.returning-values.php)
- [PHP Manual: Type declarations](https://www.php.net/manual/en/language.types.declarations.php)
- [PHP Manual: Variable scope](https://www.php.net/manual/en/language.variables.scope.php)
- [PHP Manual: Anonymous functions](https://www.php.net/manual/en/functions.anonymous.php)
- [PHP Manual: Arrow functions](https://www.php.net/manual/en/functions.arrow.php)
- [PHP Manual: array_map](https://www.php.net/manual/en/function.array-map.php)
- [PHP Manual: array_filter](https://www.php.net/manual/en/function.array-filter.php)
- [PHP Manual: usort](https://www.php.net/manual/en/function.usort.php)
