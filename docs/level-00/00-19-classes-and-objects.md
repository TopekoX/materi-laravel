# Class dan Objek

Bab sebelumnya memperkenalkan gagasan class dan objek. Sekarang kamu menulis sintaksnya:
mendefinisikan class, membuat objek, mengisi property, memanggil method, dan memahami
`$this`. Setelah bab ini, sebagian besar kode Laravel akan terbaca jauh lebih mudah.

## Tujuan pembelajaran

Setelah menyelesaikan bab ini, kamu dapat:

- [ ] Mendefinisikan class dengan property dan method.
- [ ] Membuat objek dengan `new` dan memakai constructor (termasuk *constructor promotion*).
- [ ] Menjelaskan `$this` dan tanda `->`.
- [ ] Memakai visibilitas `public` dan `private` dasar.
- [ ] Memakai konstanta class, property dan method `static`, dan property `readonly`.
- [ ] Membedakan membandingkan, menyalin referensi, dan menggandakan objek (`clone`).
- [ ] Menulis method yang mengembalikan `$this` untuk pemanggilan berantai.

## Prasyarat

- Bab [Pemrograman Berorientasi Objek](00-18-object-oriented-programming.md).
- Bab [Fungsi](00-14-functions.md) (tipe parameter dan kembalian).
- PHP 8.3 atau lebih baru; folder `belajar-php`.

## Konsep

### Mendefinisikan class

```php
class Buku
{
    public string $judul;
    public string $penulis;
    public bool $tersedia = true;

    public function __construct(string $judul, string $penulis)
    {
        $this->judul = $judul;
        $this->penulis = $penulis;
    }

    public function pinjam(): void
    {
        $this->tersedia = false;
    }
}
```

| Bagian | Penjelasan |
|---|---|
| `class Buku` | Nama class ditulis dengan huruf awal besar tiap kata (*StudlyCaps*). |
| `public string $judul;` | **Property** bertipe `string`. `public` berarti dapat diakses dari luar. |
| `public bool $tersedia = true;` | Property dengan **nilai awal** (default). |
| `__construct(...)` | **Constructor**: dijalankan otomatis saat objek dibuat dengan `new`. |
| `$this` | Menunjuk ke **objek yang sedang menjalankan method**. |
| `$this->judul` | Property `judul` milik objek itu. |
| `pinjam()` | **Method**: fungsi yang melekat pada objek. |

### Membuat dan memakai objek

```php
$buku = new Buku("Belajar PHP", "Budi");

echo $buku->judul;   // Belajar PHP
$buku->pinjam();
```

- `new Buku(...)` membuat objek baru dan memanggil constructor.
- `->` membaca property atau memanggil method.
- Tiap objek punya salinan property sendiri.

### Constructor promotion

PHP 8 menyingkat pola "terima parameter lalu isikan ke property":

```php
class Anggota
{
    public function __construct(
        public string $nama,
        public int $id,
    ) {}
}
```

Menulis `public` (atau `private`/`protected`/`readonly`) di depan parameter constructor
otomatis membuat property dengan nama itu **dan** mengisinya. Gaya ini umum di Laravel.

### Visibilitas

Visibilitas menentukan siapa yang boleh mengakses property atau method:

| Kata kunci | Dapat diakses dari |
|---|---|
| `public` | Di mana saja |
| `private` | Hanya di dalam class itu sendiri |
| `protected` | Class itu dan turunannya (dibahas di bab pewarisan) |

Biasakan menjadikan property `private` dan menyediakan method `public` untuk
mengaksesnya. Ini inti dari enkapsulasi, yang dibahas lebih lanjut di bab berikutnya.

### Konstanta, static, dan readonly

```php
class Matematika
{
    public const PI = 3.14159;

    public static int $jumlahPanggilan = 0;

    public static function kuadrat(int $x): int
    {
        self::$jumlahPanggilan++;
        return $x * $x;
    }
}

echo Matematika::PI;
echo Matematika::kuadrat(4);
```

| Konsep | Penjelasan |
|---|---|
| `const` | Nilai tetap milik class; diakses `NamaClass::NAMA`. |
| `static` | Milik **class**, bukan objek; dipakai tanpa `new`, diakses dengan `::`. |
| `self::` | Merujuk class itu sendiri dari dalam class. |
| `readonly` | Property hanya bisa diisi sekali (biasanya di constructor), lalu tak bisa diubah. |

Tanda `::` (*scope resolution*) inilah yang kamu lihat pada `Route::get(...)`,
`Materi::where(...)`, dan `MateriController::class` di Laravel.

### Objek adalah referensi

Berbeda dengan array, menugaskan objek ke variabel lain **tidak menyalin objeknya**; kedua
variabel menunjuk ke objek yang sama:

```php
$a = new Buku("A", "X");
$c = $a;          // $c dan $a menunjuk objek yang sama
$d = clone $a;    // $d adalah salinan terpisah
```

| Operator | Arti untuk objek |
|---|---|
| `==` | Sama class dan semua property bernilai sama |
| `===` | Persis objek yang sama |
| `instanceof` | Memeriksa apakah objek berasal dari class tertentu |

### Pemanggilan berantai

Jika method mengembalikan `$this`, pemanggilan bisa dirangkai. Pola ini dipakai pada query
Eloquent, `Materi::where(...)->orderBy(...)->get()`:

```php
public function tambah(string $nama): static
{
    $this->item[] = $nama;
    return $this;
}
```

### Aturan penulisan

- Satu class per berkas, nama berkas sama dengan nama class (`Buku.php`). Aturan ini
  dipakai oleh *autoloading* yang dibahas pada bab berikutnya.
- Nama class `StudlyCaps`; nama method dan property `camelCase`.

## Praktik

Untuk latihan, setiap contoh menaruh class dan penggunaannya dalam satu berkas di folder
`belajar-php`. Pada proyek nyata, class dipisah ke berkasnya sendiri.

### Langkah 1: class `Buku`

```php title="belajar-php/buku.php"
<?php

class Buku
{
    public string $judul;
    public string $penulis;
    public bool $tersedia = true;

    public function __construct(string $judul, string $penulis)
    {
        $this->judul = $judul;
        $this->penulis = $penulis;
    }

    public function pinjam(): void
    {
        $this->tersedia = false;
    }

    public function kembalikan(): void
    {
        $this->tersedia = true;
    }

    public function info(): string
    {
        $status = $this->tersedia ? "tersedia" : "dipinjam";

        return "{$this->judul} oleh {$this->penulis} ($status)";
    }
}

$buku = new Buku("Belajar PHP", "Budi");
echo $buku->info(), "\n";

$buku->pinjam();
echo $buku->info(), "\n";

$buku->kembalikan();
echo $buku->info(), "\n";
```

```bash
cd belajar-php
php buku.php
```

**Yang seharusnya terlihat:**

```text
Belajar PHP oleh Budi (tersedia)
Belajar PHP oleh Budi (dipinjam)
Belajar PHP oleh Budi (tersedia)
```

Kamu perlu mencocokkan sendiri hasil di terminalmu dengan keluaran di atas.

### Langkah 2: constructor promotion dan `readonly`

```php title="belajar-php/anggota.php"
<?php

class Anggota
{
    public function __construct(
        public readonly int $id,
        public string $nama,
    ) {}
}

$anggota = new Anggota(1, "Sari");
echo $anggota->id, ": ", $anggota->nama, "\n";

$anggota->nama = "Sari Dewi";
echo $anggota->nama, "\n";

$anggota->id = 2;
```

**Yang seharusnya terlihat:**

```text
1: Sari
Sari Dewi
```

Setelah dua baris itu, `$anggota->id = 2;` menghentikan program dengan error karena
property `readonly` tidak boleh diubah (bunyi pesan persis bisa berbeda antar versi PHP).
Hapus baris terakhir itu setelah mencobanya.

### Langkah 3: visibilitas `private`

```php title="belajar-php/rekening.php"
<?php

class Rekening
{
    private int $saldo = 0;

    public function setor(int $jumlah): void
    {
        if ($jumlah <= 0) {
            return;
        }

        $this->saldo += $jumlah;
    }

    public function saldo(): int
    {
        return $this->saldo;
    }
}

$rekening = new Rekening();
$rekening->setor(100000);
$rekening->setor(-5000);

echo $rekening->saldo(), "\n";
echo $rekening->saldo;
```

**Yang seharusnya terlihat:** baris pertama `100000` (setoran negatif ditolak oleh
method). Baris terakhir menghentikan program dengan error karena property `saldo` bersifat
`private` dan tidak boleh diakses dari luar class. Method `setor()` menjaga aturan
bahwa saldo hanya bertambah lewat setoran yang valid.

### Langkah 4: konstanta dan static

```php title="belajar-php/statis.php"
<?php

class Matematika
{
    public const PI = 3.14159;

    public static int $jumlahPanggilan = 0;

    public static function kuadrat(int $x): int
    {
        self::$jumlahPanggilan++;

        return $x * $x;
    }
}

echo Matematika::PI, "\n";
echo Matematika::kuadrat(4), "\n";
echo Matematika::kuadrat(5), "\n";
echo Matematika::$jumlahPanggilan, "\n";
```

**Yang seharusnya terlihat:**

```text
3.14159
16
25
2
```

Tidak ada `new` di sini: semuanya dipanggil langsung lewat nama class.

### Langkah 5: identitas objek dan `clone`

```php title="belajar-php/identitas.php"
<?php

class Buku
{
    public bool $tersedia = true;

    public function __construct(public string $judul, public string $penulis) {}

    public function pinjam(): void
    {
        $this->tersedia = false;
    }

    public function kembalikan(): void
    {
        $this->tersedia = true;
    }
}

$a = new Buku("A", "X");
$b = new Buku("A", "X");
$c = $a;

var_dump($a == $b);
var_dump($a === $b);
var_dump($a === $c);

$c->pinjam();
var_dump($a->tersedia);

$d = clone $a;
$d->kembalikan();
var_dump($a->tersedia);
var_dump($d->tersedia);
var_dump($a instanceof Buku);
```

**Yang seharusnya terlihat:**

```text
bool(true)
bool(false)
bool(true)
bool(false)
bool(false)
bool(true)
bool(true)
```

Penjelasan: `$a` dan `$b` bernilai sama tetapi bukan objek yang sama; `$c` adalah objek
yang sama dengan `$a`, jadi `$c->pinjam()` ikut mengubah `$a`. `clone` membuat salinan
terpisah, sehingga `$d->kembalikan()` tidak mengubah `$a`.

### Langkah 6: pemanggilan berantai

```php title="belajar-php/berantai.php"
<?php

class Keranjang
{
    private array $item = [];

    public function tambah(string $nama): static
    {
        $this->item[] = $nama;

        return $this;
    }

    public function daftar(): string
    {
        return implode(", ", $this->item);
    }
}

echo (new Keranjang())->tambah("apel")->tambah("jeruk")->tambah("mangga")->daftar(), "\n";
```

**Yang seharusnya terlihat:** `apel, jeruk, mangga`.

## Kesalahan umum dan debugging

| Gejala | Kemungkinan penyebab | Solusi |
|---|---|---|
| `Class "Buku" not found` | Class belum didefinisikan atau berkasnya belum dimuat | Definisikan atau `require` berkas class. |
| `Too few arguments ... __construct()` | Argumen constructor kurang | Berikan semua argumen wajib. |
| `Call to undefined method Buku::x()` | Nama method salah atau tidak ada | Periksa ejaan dan definisi. |
| `Cannot access private property` | Mengakses property `private` dari luar | Gunakan method `public` (getter/setter). |
| `Cannot modify readonly property` | Mengubah property `readonly` | Buat objek baru, atau jangan ubah nilainya. |
| `Using $this when not in object context` | `$this` dipakai di method `static` atau di luar class | Pakai `self::` untuk static, atau pakai objek. |
| Mengubah `$b` ikut mengubah `$a` | Objek disalin sebagai referensi | Gunakan `clone` bila perlu salinan. |
| `Typed property must not be accessed before initialization` | Property bertipe tanpa nilai awal dibaca sebelum diisi | Beri nilai awal atau isi di constructor. |
| Salah memakai `.` alih-alih `->` | Mencampur penggabungan teks dengan akses objek | Akses objek memakai `->`. |

## Latihan terpandu

1. Tambahkan class `Produk` dengan property `nama` dan `harga`, constructor promotion, dan
   method `hargaRupiah(): string` yang mengembalikan `Rp 2.500.000` (pakai `number_format`).
2. Ubah `Rekening` agar punya method `tarik(int $jumlah): bool` yang menolak penarikan
   jika saldo tidak cukup (mengembalikan `false`).
3. Tambahkan konstanta `BATAS_PINJAM = 3` ke class `Anggota` dan sebuah method yang
   memeriksa apakah anggota boleh meminjam lagi.
4. Buat class `Penghitung` dengan property `private int $nilai = 0` dan method
   `tambah(): static` serta `nilai(): int`, lalu rangkai tiga kali `tambah()`.
5. Prediksi, lalu uji: apa yang dicetak `var_dump(new Buku("A", "X") == new Buku("A", "X"))`
   dan `var_dump(new Buku("A", "X") === new Buku("A", "X"))`?
6. Jelaskan mengapa `private` pada saldo membuat `Rekening` lebih aman.

??? success "Petunjuk nomor 2 dan 5"
    **Nomor 2:**
    ```php
    public function tarik(int $jumlah): bool
    {
        if ($jumlah <= 0 || $jumlah > $this->saldo) {
            return false;
        }

        $this->saldo -= $jumlah;

        return true;
    }
    ```

    **Nomor 5:** `bool(true)` lalu `bool(false)`. Dua objek baru bernilai sama, tetapi
    bukan objek yang sama.

## Pertanyaan review

1. Apa itu constructor dan kapan dijalankan?
2. Apa arti `$this`?
3. Apa beda `public` dan `private`?
4. Apa beda property biasa dan property `static`? Kapan memakai `::`?
5. Apa fungsi `readonly`?
6. Apa beda `==` dan `===` pada objek? Apa fungsi `clone`?
7. Bagaimana method bisa dirangkai, dan di mana pola ini dipakai di Laravel?
8. Mengapa satu class sebaiknya satu berkas?

## Ringkasan

- Class didefinisikan dengan `class`, objek dibuat dengan `new`, dan keduanya dihubungkan
  lewat `->`.
- Constructor menyiapkan objek; *constructor promotion* menyingkat penulisannya.
- `$this` adalah objek yang sedang berjalan; visibilitas `private` menjaga data dari luar.
- `const`, `static`, dan `::` bekerja pada class; `readonly` mencegah perubahan.
- Objek ditugaskan sebagai referensi; gunakan `clone` untuk salinan.
- Method yang mengembalikan `$this` memungkinkan pemanggilan berantai.

Selanjutnya: **Inheritance, Encapsulation, dan Polymorphism**.

## Referensi resmi

- [PHP Manual: The basics (class, new, $this)](https://www.php.net/manual/en/language.oop5.basic.php)
- [PHP Manual: Properties](https://www.php.net/manual/en/language.oop5.properties.php)
- [PHP Manual: Constructors and destructors](https://www.php.net/manual/en/language.oop5.decon.php)
- [PHP Manual: Visibility](https://www.php.net/manual/en/language.oop5.visibility.php)
- [PHP Manual: Class constants](https://www.php.net/manual/en/language.oop5.constants.php)
- [PHP Manual: Static keyword](https://www.php.net/manual/en/language.oop5.static.php)
- [PHP Manual: Object cloning](https://www.php.net/manual/en/language.oop5.cloning.php)
- [PHP Manual: Comparing objects](https://www.php.net/manual/en/language.oop5.object-comparison.php)
