# Operator PHP

**Operator** adalah simbol yang melakukan sesuatu pada satu atau lebih nilai: menjumlahkan,
membandingkan, menggabungkan teks, dan sebagainya. Nilai yang dikenai operator disebut
**operan**. Pada `5 + 3`, tanda `+` adalah operator dan `5` serta `3` operannya.

## Tujuan pembelajaran

Setelah menyelesaikan bab ini, kamu dapat:

- [ ] Memakai operator aritmetika, penugasan, penggabungan teks, dan inkremen.
- [ ] Membedakan `==` dan `===` serta `!=` dan `!==`.
- [ ] Menyusun kondisi dengan operator logika `&&`, `||`, dan `!`.
- [ ] Memakai operator `??` dan ternary `? :` untuk nilai bersyarat singkat.
- [ ] Menjelaskan urutan prioritas operator dan memakai tanda kurung dengan tepat.

## Prasyarat

- Bab [Tipe Data PHP](00-09-php-data-types.md): `int`, `float`, `string`, `bool`, `null`,
  `var_dump`.
- PHP 8.3 atau lebih baru terpasang; folder `belajar-php`.

## Konsep

### Operator aritmetika

| Operator | Nama | Contoh | Hasil |
|---|---|---|---|
| `+` | Penjumlahan | `7 + 2` | `9` |
| `-` | Pengurangan | `7 - 2` | `5` |
| `*` | Perkalian | `7 * 2` | `14` |
| `/` | Pembagian | `7 / 2` | `3.5` |
| `%` | Sisa bagi (modulus) | `7 % 2` | `1` |
| `**` | Pangkat | `7 ** 2` | `49` |

Catatan penting:

- Pembagian menghasilkan `float` kecuali hasilnya bulat tepat: `6 / 3` bertipe `int`,
  `7 / 2` bertipe `float`.
- Untuk pembagian bulat (membuang sisa), pakai fungsi `intdiv(7, 2)` yang menghasilkan `3`.
- Membagi dengan nol pada PHP 8 melempar error `DivisionByZeroError`.

### Operator penugasan

Operator `=` mengisi variabel. Bentuk gabungan menyingkat "ubah nilai berdasarkan nilai
lama":

| Singkat | Setara dengan |
|---|---|
| `$x += 5` | `$x = $x + 5` |
| `$x -= 5` | `$x = $x - 5` |
| `$x *= 5` | `$x = $x * 5` |
| `$x /= 5` | `$x = $x / 5` |
| `$teks .= "abc"` | `$teks = $teks . "abc"` |

**Inkremen dan dekremen** menambah atau mengurangi satu:

| Bentuk | Arti |
|---|---|
| `$x++` | Pakai nilai `$x` dulu, lalu tambah 1 (*post-increment*) |
| `++$x` | Tambah 1 dulu, lalu pakai nilainya (*pre-increment*) |
| `$x--`, `--$x` | Sama, tetapi mengurangi |

### Operator penggabungan teks

Titik (`.`) menggabungkan dua teks menjadi satu:

```php
echo "Halo, " . "dunia";
```

### Operator perbandingan

Hasil perbandingan selalu `bool` (`true` atau `false`).

| Operator | Arti | Contoh | Hasil |
|---|---|---|---|
| `==` | Sama nilainya (tipe boleh beda) | `10 == "10"` | `true` |
| `===` | Sama nilai **dan** tipe | `10 === "10"` | `false` |
| `!=` | Tidak sama nilainya | `10 != 5` | `true` |
| `!==` | Tidak identik (nilai atau tipe berbeda) | `10 !== "10"` | `true` |
| `<`, `>` | Kurang dari, lebih dari | `3 < 5` | `true` |
| `<=`, `>=` | Kurang dari atau sama, lebih dari atau sama | `3 >= 5` | `false` |
| `<=>` | Pembanding gabungan | `5 <=> 3` | `1` |

Operator `<=>` mengembalikan `-1` jika kiri lebih kecil, `0` jika sama, dan `1` jika
kiri lebih besar.

!!! warning "Biasakan memakai `===`"
    `==` mengubah tipe terlebih dulu, sehingga hasilnya bisa mengejutkan
    (misalnya `1 == true` bernilai `true`). `===` lebih ketat dan lebih aman. Gunakan
    `===` dan `!==` sebagai pilihan awal; pakai `==` hanya bila memang disengaja.

### Operator logika

| Operator | Arti | Benar jika |
|---|---|---|
| `&&` | DAN | kedua sisi benar |
| <code>&#124;&#124;</code> | ATAU | salah satu sisi benar |
| `!` | BUKAN | operan salah |

Evaluasi bersifat *short-circuit*: pada `A && B`, jika `A` sudah salah maka `B` tidak
dievaluasi lagi; pada `A || B`, jika `A` sudah benar maka `B` dilewati.

Ada juga `and` dan `or`, tetapi prioritasnya berbeda dan sering menimbulkan kebingungan.
Pakai `&&` dan `||`.

### Operator null coalescing `??`

`$a ?? $b` berarti: pakai `$a` jika ada **dan** tidak `null`, selain itu pakai `$b`.
Tidak menimbulkan peringatan jika `$a` belum dibuat.

```php
$nama = $inputNama ?? "Tamu";
```

### Operator ternary

`kondisi ? nilaiJikaBenar : nilaiJikaSalah` adalah `if`-`else` ringkas:

```php
$status = $umur >= 17 ? "Dewasa" : "Anak";
```

Bentuk singkat `$a ?: $b` berarti: pakai `$a` jika bernilai truthy, selain itu `$b`.
Perbedaannya dengan `??`: `?:` menganggap `""` dan `0` sebagai salah, sedangkan `??` hanya
menganggap `null` (atau belum ada) sebagai "kosong".

### Prioritas operator

Seperti matematika, perkalian lebih dulu daripada penjumlahan. Tanda kurung `( )`
mengubah urutan dan membuat maksud kodemu jelas.

```php
2 + 3 * 4     // 14
(2 + 3) * 4   // 20
```

Pada PHP 8, `+` dan `-` diproses **sebelum** operator titik `.`. Karena itu
`"Total: " . 5 + 3` menghasilkan `Total: 8`. Gunakan kurung agar jelas:
`"Total: " . (5 + 3)`.

!!! tip "Saat ragu, pakai kurung"
    Kamu tidak perlu menghafal seluruh tabel prioritas. Tanda kurung tambahan tidak
    merugikan dan membantu pembaca kodemu.

## Praktik

Semua berkas dibuat di folder `belajar-php`.

### Langkah 1: aritmetika

```php title="belajar-php/aritmetika.php"
<?php

$a = 7;
$b = 2;

echo "Tambah: ", $a + $b, "\n";
echo "Kurang: ", $a - $b, "\n";
echo "Kali: ", $a * $b, "\n";
echo "Bagi: ", $a / $b, "\n";
echo "Sisa: ", $a % $b, "\n";
echo "Pangkat: ", $a ** $b, "\n";
echo "Bagi bulat: ", intdiv($a, $b), "\n";

var_dump(6 / 3);
var_dump(7 / 2);
```

```bash
cd belajar-php
php aritmetika.php
```

**Yang seharusnya terlihat:**

```text
Tambah: 9
Kurang: 5
Kali: 14
Bagi: 3.5
Sisa: 1
Pangkat: 49
Bagi bulat: 3
int(2)
float(3.5)
```

Kamu perlu mencocokkan sendiri hasil di terminalmu dengan keluaran di atas.

### Langkah 2: penugasan dan inkremen

```php title="belajar-php/penugasan.php"
<?php

$skor = 10;
$skor += 5;
$skor -= 3;
$skor *= 2;
$skor /= 4;
$skor++;
echo $skor, "\n";

$teks = "Halo";
$teks .= ", dunia";
echo $teks, "\n";

$x = 5;
echo $x++, "\n";
echo $x, "\n";
echo ++$x, "\n";
```

**Yang seharusnya terlihat:**

```text
7
Halo, dunia
5
6
7
```

Telusuri: `10 → 15 → 12 → 24 → 6 → 7`. Pada `$x++`, nilai `5` dicetak dulu baru bertambah;
pada `++$x`, bertambah dulu menjadi `7` baru dicetak.

### Langkah 3: perbandingan

```php title="belajar-php/perbandingan.php"
<?php

var_dump(10 == "10");
var_dump(10 === "10");
var_dump(10 != 5);
var_dump(10 !== "10");
var_dump(3 < 5);
var_dump(3 >= 5);
var_dump(5 <=> 3);
var_dump(3 <=> 5);
var_dump(5 <=> 5);
var_dump(1 == true);
var_dump(1 === true);
```

**Yang seharusnya terlihat:**

```text
bool(true)
bool(false)
bool(true)
bool(true)
bool(true)
bool(false)
int(1)
int(-1)
int(0)
bool(true)
bool(false)
```

### Langkah 4: operator logika

```php title="belajar-php/logika.php"
<?php

$umur = 20;
$punyaKtp = true;

var_dump($umur >= 17 && $punyaKtp);
var_dump($umur < 17 || $punyaKtp);
var_dump(!$punyaKtp);
var_dump($umur < 17 && $punyaKtp);
```

**Yang seharusnya terlihat:**

```text
bool(true)
bool(true)
bool(false)
bool(false)
```

### Langkah 5: `??` dan ternary

```php title="belajar-php/null-ternary.php"
<?php

$nama = null;
echo $nama ?? "Tamu", "\n";
echo $belumAda ?? "Kosong", "\n";

$umur = 20;
echo $umur >= 17 ? "Dewasa" : "Anak", "\n";

$kota = "";
echo $kota ?: "Tidak diisi", "\n";
```

**Yang seharusnya terlihat:**

```text
Tamu
Kosong
Dewasa
Tidak diisi
```

Baris kedua tidak menimbulkan peringatan `Undefined variable`, karena `??` memang aman
untuk variabel yang belum ada.

### Langkah 6: prioritas operator

```php title="belajar-php/prioritas.php"
<?php

echo 2 + 3 * 4, "\n";
echo (2 + 3) * 4, "\n";
echo "Total: " . (5 + 3), "\n";
echo true, "|", false, "|\n";
```

**Yang seharusnya terlihat:**

```text
14
20
Total: 8
1||
```

Baris terakhir menunjukkan bahwa `echo true` mencetak `1`, sedangkan `echo false`
mencetak teks kosong. Karena itu gunakan `var_dump` saat ingin melihat nilai `bool`.

## Kesalahan umum dan debugging

| Gejala | Kemungkinan penyebab | Solusi |
|---|---|---|
| Menulis `=` padahal maksudnya `==`/`===` | `=` adalah penugasan, bukan perbandingan | Pakai `===` untuk membandingkan. |
| `1 == true` bernilai benar | `==` mengubah tipe | Pakai `===`. |
| `echo false` tidak mencetak apa-apa | `false` menjadi teks kosong | Gunakan `var_dump(false)`. |
| `DivisionByZeroError` | Membagi dengan nol | Periksa pembagi sebelum membagi. |
| Hasil `7 / 2` bukan bilangan bulat | `/` menghasilkan float | Pakai `intdiv()` untuk pembagian bulat. |
| `"Total: " . 5 + 3` memberi `Total: 8` | `+` diproses lebih dulu daripada `.` | Pakai kurung: `"Total: " . (5 + 3)`. |
| Kondisi `and`/`or` memberi hasil aneh | Prioritasnya lebih rendah dari `&&`/<code>&#124;&#124;</code> dan dari `=` | Pakai `&&` dan <code>&#124;&#124;</code>. |
| `Undefined variable` pada pemeriksaan sederhana | Variabel belum ada | Pakai `??` atau `isset`. |

## Latihan terpandu

1. Buat `kalkulator.php` dengan dua variabel angka, lalu cetak hasil enam operasi
   aritmetika dan hasil `intdiv`.
2. Hitung dengan PHP: berapa sisa 29 dibagi 5? Berapa 2 pangkat 10?
3. Tentukan hasil dan tipe (prediksi dulu, lalu cek dengan `var_dump`): `"5" == 5`,
   `"5" === 5`, `null == false`, `null === false`, `10 <=> 7`.
4. Tulis ekspresi yang bernilai `true` bila seseorang boleh masuk: umur minimal 17 **dan**
   (membawa KTP **atau** membawa SIM).
5. Buat `diskon.php`: jika `$total` lebih dari `100000` tampilkan `Diskon`, selain itu
   `Tidak ada diskon`, memakai operator ternary. Uji dengan dua nilai `$total`.
6. Jelaskan perbedaan `$nama ?? "Tamu"` dan `$nama ?: "Tamu"` bila `$nama = ""`.

??? success "Jawaban nomor 2, 3, dan 6"
    **Nomor 2:** sisa 29 dibagi 5 adalah `4`; 2 pangkat 10 adalah `1024`.

    **Nomor 3:** `true`, `false`, `true`, `false`, dan `int(1)`. Cocokkan dengan
    keluaran `var_dump` di terminalmu.

    **Nomor 6:** `$nama ?? "Tamu"` menghasilkan `""` (karena `""` bukan `null`),
    sedangkan `$nama ?: "Tamu"` menghasilkan `"Tamu"` (karena `""` bersifat falsy).

## Pertanyaan review

1. Apa yang dimaksud operator dan operan?
2. Mengapa `7 / 2` bertipe `float` tetapi `6 / 3` bertipe `int`?
3. Apa beda `$x++` dan `++$x`?
4. Apa beda `==` dan `===`? Mana yang disarankan?
5. Apa itu evaluasi *short-circuit*?
6. Apa fungsi `??`? Kapan lebih tepat dibanding `?:`?
7. Mengapa tanda kurung dianjurkan pada ekspresi yang rumit?

## Ringkasan

- Aritmetika: `+ - * / % **`; `intdiv()` untuk pembagian bulat.
- Penugasan: `=`, `+=`, `-=`, `*=`, `/=`, `.=`, serta `++` dan `--`.
- Perbandingan menghasilkan `bool`; utamakan `===` dan `!==`.
- Logika: `&&`, `||`, `!` dengan evaluasi short-circuit.
- `??` memberi nilai cadangan untuk `null`/belum ada; `? :` adalah `if`-`else` ringkas.
- Gunakan tanda kurung agar urutan operasi jelas.

Selanjutnya: **Conditional Statements**, tempat hasil perbandingan dan logika dipakai
untuk mengambil keputusan.

## Referensi resmi

- [PHP Manual: Operators](https://www.php.net/manual/en/language.operators.php)
- [PHP Manual: Arithmetic operators](https://www.php.net/manual/en/language.operators.arithmetic.php)
- [PHP Manual: Assignment operators](https://www.php.net/manual/en/language.operators.assignment.php)
- [PHP Manual: Comparison operators](https://www.php.net/manual/en/language.operators.comparison.php)
- [PHP Manual: Logical operators](https://www.php.net/manual/en/language.operators.logical.php)
- [PHP Manual: Operator precedence](https://www.php.net/manual/en/language.operators.precedence.php)
- [PHP Manual: Incrementing/Decrementing operators](https://www.php.net/manual/en/language.operators.increment.php)
- [PHP Manual: String operators](https://www.php.net/manual/en/language.operators.string.php)
- [PHP Manual: intdiv](https://www.php.net/manual/en/function.intdiv.php)
