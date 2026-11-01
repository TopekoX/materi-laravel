# Tipe Data PHP

Setiap nilai di PHP punya **tipe**: teks, bilangan bulat, bilangan desimal, benar/salah,
dan seterusnya. Tipe menentukan apa yang boleh dilakukan pada nilai itu. Memahami tipe
membantu kamu membaca pesan error dan menghindari bug yang halus.

## Tujuan pembelajaran

Setelah menyelesaikan bab ini, kamu dapat:

- [ ] Menyebutkan tipe data dasar PHP: `string`, `int`, `float`, `bool`, `array`, dan `null`.
- [ ] Memeriksa tipe nilai dengan `var_dump()`, `gettype()`, dan fungsi `is_*`.
- [ ] Mengubah tipe dengan *casting* (`(int)`, `(string)`, dan seterusnya).
- [ ] Menjelaskan nilai yang dianggap `true` dan `false` (*truthy* dan *falsy*).
- [ ] Menjelaskan mengapa bilangan desimal tidak selalu persis.

## Prasyarat

- Bab [Variabel dan Konstanta](00-08-variables-and-constants.md).
- PHP 8.3 atau lebih baru terpasang; folder `belajar-php`.

## Konsep

### Tipe data dasar

| Tipe | Isi | Contoh |
|---|---|---|
| `string` | Teks | `"Budi"`, `'Bandung'` |
| `int` | Bilangan bulat | `20`, `-7`, `1_000_000` |
| `float` | Bilangan desimal | `1.75`, `-0.5`, `2.0` |
| `bool` | Benar atau salah | `true`, `false` |
| `array` | Kumpulan banyak nilai | `["apel", "jeruk"]` |
| `null` | "Tidak ada nilai" | `null` |

Tipe yang lebih lanjut, seperti objek, dipelajari pada sub bab pemrograman berorientasi
objek. Array dibahas penuh di sub bab *Arrays*.

!!! tip "Analogi"
    Wadah berbeda untuk isi berbeda: gelas untuk cairan, kotak untuk barang. Tipe data
    menentukan "wadah" yang cocok untuk sebuah nilai.

PHP adalah bahasa **berketik dinamis**: kamu tidak menulis tipe saat membuat variabel,
PHP menentukannya dari nilai yang diberikan.

```php
$nilai = 10;       // int
$nilai = "sepuluh"; // sekarang string
```

### Detail tiap tipe

**String.** Urutan karakter dalam tanda kutip. Panjang string dihitung dalam *byte*.

**Integer.** Bilangan bulat. Pada sistem 64-bit, nilai terbesarnya tersimpan di konstanta
`PHP_INT_MAX`. Menambah melewati batas itu mengubah hasilnya menjadi `float`.
Garis bawah boleh dipakai sebagai pemisah agar mudah dibaca: `1_000_000`.

**Float.** Bilangan desimal ditulis dengan titik (bukan koma): `1.75`. Float disimpan
dalam format biner, sehingga beberapa pecahan desimal tidak bisa disimpan persis.
Contoh klasik: `0.1 + 0.2` tidak sama persis dengan `0.3`. Untuk uang, jangan
mengandalkan float sembarangan; praktik yang lazim adalah menyimpan dalam satuan terkecil
(mis. sen) sebagai integer.

**Boolean.** Hanya `true` atau `false`. Digunakan untuk keputusan (`if`).

**Null.** Menandakan "tidak ada nilai". Variabel yang diisi `null`, atau yang belum
dibuat, dianggap `null`.

### Memeriksa tipe

| Fungsi | Kegunaan |
|---|---|
| `var_dump($x)` | Mencetak **tipe dan nilai** sekaligus; alat debugging utama |
| `gettype($x)` | Mengembalikan nama tipe sebagai teks |
| `is_int($x)`, `is_string($x)`, `is_float($x)`, `is_bool($x)`, `is_array($x)`, `is_null($x)` | Mengembalikan `true` atau `false` |

Format `var_dump` untuk tipe dasar:

| Nilai | Contoh keluaran |
|---|---|
| String `"Budi"` | `string(4) "Budi"` (angka 4 = jumlah byte) |
| Integer `20` | `int(20)` |
| Float `1.75` | `float(1.75)` |
| Boolean `true` | `bool(true)` |
| Null | `NULL` |

Catatan: `gettype()` menyebut float sebagai `double` karena alasan historis.

### Casting: mengubah tipe

Tulis tipe tujuan dalam kurung di depan nilai:

```php
(int) 3.9        // 3 (bagian desimal dibuang, bukan dibulatkan)
(int) "123abc"   // 123 (dibaca dari depan sampai karakter yang bukan angka)
(int) "abc"      // 0
(float) "2.5"    // 2.5
(string) 42      // "42"
(bool) "abc"     // true
```

!!! warning "Casting menyembunyikan data yang hilang"
    `(int) 3.9` menghasilkan `3` tanpa peringatan. Gunakan casting dengan sadar, dan
    jangan mengubah tipe input pengguna tanpa memvalidasinya terlebih dahulu.

### Truthy dan falsy

Ketika nilai dipakai sebagai kondisi, PHP mengubahnya menjadi `bool`. Nilai yang dianggap
**`false`** hanya:

- `false`
- `0` dan `0.0`
- `""` (string kosong) dan `"0"`
- `[]` (array kosong)
- `null`

Semua nilai lain dianggap `true`, termasuk `"false"` dan `"0.0"` sebagai teks.

### Type juggling

Karena PHP berketik dinamis, nilai kadang diubah tipenya otomatis saat dipakai dalam
operasi. Perilaku ini nyaman, tetapi bisa membuat hasil mengejutkan. Pembahasan lanjut
(perbandingan `==` dan `===`) ada di sub bab *PHP Operators*, dan pengetikan ketat pada
sub bab *Functions*.

## Praktik

Semua berkas dibuat di folder `belajar-php`.

### Langkah 1: tipe dasar dengan `var_dump`

```php title="belajar-php/tipe.php"
<?php

$nama = "Budi";
$umur = 20;
$tinggi = 1.75;
$aktif = true;
$alamat = null;

var_dump($nama);
var_dump($umur);
var_dump($tinggi);
var_dump($aktif);
var_dump($alamat);

echo gettype($tinggi), "\n";
```

```bash
cd belajar-php
php tipe.php
```

**Yang seharusnya terlihat:**

```text
string(4) "Budi"
int(20)
float(1.75)
bool(true)
NULL
double
```

Kamu perlu mencocokkan sendiri hasil di terminalmu dengan keluaran di atas.

### Langkah 2: fungsi `is_*`

```php title="belajar-php/is-tipe.php"
<?php

var_dump(is_int(5));
var_dump(is_string(5));
var_dump(is_string("5"));
var_dump(is_null(null));
```

**Yang seharusnya terlihat:**

```text
bool(true)
bool(false)
bool(true)
bool(true)
```

Perhatikan bahwa `"5"` (dengan kutip) adalah string, bukan integer.

### Langkah 3: casting

```php title="belajar-php/casting.php"
<?php

var_dump((int) 3.9);
var_dump((int) "123abc");
var_dump((int) "abc");
var_dump((float) "2.5");
var_dump((string) 42);
```

**Yang seharusnya terlihat:**

```text
int(3)
int(123)
int(0)
float(2.5)
string(2) "42"
```

### Langkah 4: truthy dan falsy

```php title="belajar-php/truthy.php"
<?php

var_dump((bool) "");
var_dump((bool) "0");
var_dump((bool) 0);
var_dump((bool) []);
var_dump((bool) null);
var_dump((bool) "abc");
var_dump((bool) "false");
```

**Yang seharusnya terlihat:** lima baris `bool(false)` untuk lima nilai pertama,
lalu dua baris `bool(true)` untuk `"abc"` dan `"false"`.

### Langkah 5: float yang tidak persis

```php title="belajar-php/float.php"
<?php

var_dump(0.1 + 0.2);
var_dump(0.1 + 0.2 === 0.3);
var_dump(PHP_INT_MAX);
var_dump(PHP_INT_MAX + 1);
```

(Operator `+` dan `===` dibahas di bab berikutnya; di sini cukup diamati hasilnya.)

**Yang seharusnya terlihat (sistem 64-bit):**

- `float(0.30000000000000004)`: hasil penjumlahan sedikit melenceng dari `0.3`.
- `bool(false)`: karena itu perbandingan dengan `0.3` bernilai salah.
- `int(9223372036854775807)`: nilai `int` terbesar pada sistem 64-bit.
- Baris terakhir bertipe `float` dengan notasi ilmiah (sekitar `9.2233720368547758E+18`),
  karena hasil melewati batas integer.

Format desimal persisnya bisa berbeda tipis antar konfigurasi PHP; yang penting kamu
mengenali pola: tipe berubah menjadi `float`, dan float tidak selalu presisi.

## Kesalahan umum dan debugging

| Gejala | Kemungkinan penyebab | Solusi |
|---|---|---|
| `"5"` dianggap angka padahal string | Angka dalam kutip adalah teks | Cek dengan `var_dump`; ubah dengan `(int)` bila perlu. |
| `(int) 3.9` menghasilkan `3`, bukan `4` | Casting memotong, tidak membulatkan | Pakai `round()` bila ingin pembulatan. |
| Desimal ditulis dengan koma (`1,75`) | PHP memakai titik sebagai pemisah desimal | Tulis `1.75`. |
| Perbandingan float meleset | Representasi biner float | Hindari membandingkan float langsung dengan `===`; pakai selisih atau simpan dalam integer. |
| Kondisi tak terduga untuk `"0"` | `"0"` bernilai falsy | Periksa tipe dengan `var_dump` dan bandingkan secara eksplisit. |
| `NULL` muncul padahal variabel sudah dibuat | Variabel diisi `null` atau belum dipakai dengan benar | Telusuri isinya dengan `var_dump`. |
| Output `var_dump` tampil rapat di browser | HTML menggabungkan spasi dan baris | Jalankan di terminal, atau bungkus dengan tag `<pre>`. |

## Latihan terpandu

1. Buat `biodata-tipe.php` dengan lima variabel (nama, umur, tinggi, status menikah,
   alamat kosong) dan cetak tipenya dengan `var_dump`.
2. Prediksi, lalu jalankan: `var_dump((int) "45 tahun");`, `var_dump((bool) "0.0");`,
   `var_dump((string) true);`, `var_dump((float) 7);`.
3. Jelaskan mengapa `var_dump("10")` dan `var_dump(10)` menghasilkan keluaran berbeda.
4. Sebutkan semua nilai falsy dari ingatan, lalu uji satu per satu dengan `(bool)`.
5. Jelaskan mengapa uang tidak aman disimpan sebagai float, dan satu alternatifnya.

??? success "Jawaban nomor 2"
    `int(45)`, `bool(true)` (`"0.0"` bukan falsy), `string(1) "1"`, `float(7)`.
    Hasil ini diturunkan dari aturan casting; cocokkan dengan keluaran di terminalmu.

## Pertanyaan review

1. Sebutkan enam tipe data dasar PHP.
2. Apa arti PHP berketik dinamis?
3. Apa beda `var_dump` dan `gettype`?
4. Apa beda `(int) 3.9` dan `round(3.9)`?
5. Nilai apa saja yang dianggap falsy?
6. Mengapa `0.1 + 0.2 === 0.3` bernilai `false`?
7. Apa arti `null`?

## Ringkasan

- Tipe dasar: `string`, `int`, `float`, `bool`, `array`, `null`.
- PHP menentukan tipe dari nilai (berketik dinamis).
- `var_dump` menampilkan tipe dan nilai; `gettype` dan `is_*` memeriksa tipe.
- Casting mengubah tipe dan bisa membuang data.
- Falsy: `false`, `0`, `0.0`, `""`, `"0"`, `[]`, `null`.
- Float tidak selalu presisi; waspadai untuk perhitungan uang.

Selanjutnya: **PHP Operators**.

## Referensi resmi

- [PHP Manual: Types](https://www.php.net/manual/en/language.types.php)
- [PHP Manual: Type juggling](https://www.php.net/manual/en/language.types.type-juggling.php)
- [PHP Manual: Booleans](https://www.php.net/manual/en/language.types.boolean.php)
- [PHP Manual: Integers](https://www.php.net/manual/en/language.types.integer.php)
- [PHP Manual: Floating point numbers](https://www.php.net/manual/en/language.types.float.php)
- [PHP Manual: NULL](https://www.php.net/manual/en/language.types.null.php)
- [PHP Manual: var_dump](https://www.php.net/manual/en/function.var-dump.php)
- [PHP Manual: gettype](https://www.php.net/manual/en/function.gettype.php)
