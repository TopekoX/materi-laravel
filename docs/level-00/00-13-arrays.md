# Array

Sejauh ini satu variabel hanya menyimpan satu nilai. Bagaimana jika kamu perlu menyimpan
daftar nama siswa, atau data lengkap seorang pengguna? **Array** adalah variabel yang
menyimpan banyak nilai sekaligus. Hampir semua data di Laravel, dari hasil database sampai
konfigurasi, bergerak dalam bentuk array atau turunannya.

## Tujuan pembelajaran

Setelah menyelesaikan bab ini, kamu dapat:

- [ ] Membuat array berindeks, array asosiatif, dan array multidimensi.
- [ ] Membaca, menambah, mengubah, dan menghapus elemen array.
- [ ] Menelusuri array dengan `foreach`.
- [ ] Memakai fungsi array umum: `count`, `in_array`, `sort`, `array_merge`, dan lainnya.
- [ ] Menjelaskan bahwa array disalin berdasarkan nilai saat ditugaskan ke variabel lain.

## Prasyarat

- Bab [Perulangan](00-12-loops.md): terutama `foreach`.
- Bab [Tipe Data PHP](00-09-php-data-types.md).
- PHP 8.3 atau lebih baru terpasang; folder `belajar-php`.

## Konsep

!!! tip "Analogi"
    Array seperti rak berlaci. Setiap laci punya nomor atau label (kunci), dan di dalamnya
    ada satu isi (nilai).

### Array berindeks

Elemen diberi nomor otomatis mulai dari `0`:

```php
$buah = ["apel", "jeruk", "mangga"];

echo $buah[0];   // apel
echo $buah[2];   // mangga
```

| Indeks | 0 | 1 | 2 |
|---|---|---|---|
| Nilai | apel | jeruk | mangga |

### Array asosiatif

Kunci berupa **teks** yang kamu tentukan sendiri, ditulis dengan `=>`:

```php
$siswa = [
    "nama" => "Budi",
    "umur" => 20,
    "kota" => "Bandung",
];

echo $siswa["nama"];   // Budi
```

Array asosiatif cocok untuk satu "benda" yang punya beberapa atribut, mirip satu baris
data di database.

### Array multidimensi

Elemen array boleh berupa array lagi:

```php
$daftarSiswa = [
    ["nama" => "Budi", "nilai" => 80],
    ["nama" => "Sari", "nilai" => 90],
];

echo $daftarSiswa[1]["nama"];   // Sari
```

Bentuk ini (daftar yang berisi array asosiatif) sama persis dengan hasil query database
yang akan kamu temui di Laravel.

### Menambah, mengubah, dan menghapus

| Aksi | Kode |
|---|---|
| Menambah di akhir | `$buah[] = "pisang";` atau `array_push($buah, "pisang");` |
| Mengubah | `$buah[1] = "anggur";` |
| Menambah kunci baru | `$siswa["jurusan"] = "Informatika";` |
| Menghapus elemen | `unset($buah[1]);` |
| Mengambil dan membuang elemen terakhir | `array_pop($buah);` |
| Mengambil dan membuang elemen pertama | `array_shift($buah);` |
| Menambah di awal | `array_unshift($buah, "kiwi");` |

`unset` pada array berindeks meninggalkan "lubang" pada nomor indeks; array tidak
dinomori ulang otomatis.

### Memeriksa isi

| Fungsi / ekspresi | Kegunaan |
|---|---|
| `count($a)` | Jumlah elemen |
| `in_array($nilai, $a)` | Apakah nilai ada di array |
| `array_key_exists("kunci", $a)` | Apakah kunci ada (termasuk bernilai `null`) |
| `isset($a["kunci"])` | Kunci ada **dan** nilainya bukan `null` |
| `$a["kunci"] ?? "cadangan"` | Nilai, atau cadangan bila kunci tidak ada |
| `array_keys($a)`, `array_values($a)` | Semua kunci, atau semua nilai |
| `array_sum($a)`, `max($a)`, `min($a)` | Total, terbesar, terkecil (untuk angka) |

Mengakses kunci yang tidak ada menghasilkan peringatan `Undefined array key`. Gunakan `??`
atau `isset` bila kunci mungkin tidak ada.

### Mengurutkan

| Fungsi | Urut berdasarkan | Mempertahankan kunci? |
|---|---|---|
| `sort($a)` | Nilai, naik | Tidak (kunci dinomori ulang) |
| `rsort($a)` | Nilai, turun | Tidak |
| `asort($a)` | Nilai, naik | Ya |
| `arsort($a)` | Nilai, turun | Ya |
| `ksort($a)` | Kunci, naik | Ya |

Fungsi urut **mengubah array aslinya** dan mengembalikan `true`/`false`, bukan array baru.

### Menggabung dan mengubah menjadi teks

```php
$gabungan = array_merge($a, $b);   // atau [...$a, ...$b]
echo implode(", ", $buah);         // apel, jeruk, mangga
```

`implode(pemisah, array)` menggabungkan elemen array menjadi satu teks.

### Array disalin berdasarkan nilai

Menugaskan array ke variabel lain membuat **salinan**:

```php
$a = [1, 2, 3];
$b = $a;
$b[] = 4;
// $a tetap [1, 2, 3]; $b menjadi [1, 2, 3, 4]
```

### Melihat isi array

`echo` tidak bisa mencetak array. Gunakan:

- `print_r($a)`: tampilan ringkas dan mudah dibaca.
- `var_dump($a)`: lengkap dengan tipe tiap elemen.

Di browser, bungkus keluarannya dengan tag `<pre>` agar rapi.

## Praktik

Semua berkas dibuat di folder `belajar-php`.

### Langkah 1: array berindeks

```php title="belajar-php/array-dasar.php"
<?php

$buah = ["apel", "jeruk", "mangga"];

echo $buah[0], "\n";
echo $buah[2], "\n";
echo count($buah), "\n";

$buah[] = "pisang";
echo count($buah), "\n";

$buah[1] = "anggur";
print_r($buah);

echo implode(", ", $buah), "\n";
```

```bash
cd belajar-php
php array-dasar.php
```

**Yang seharusnya terlihat:**

```text
apel
mangga
3
4
Array
(
    [0] => apel
    [1] => anggur
    [2] => mangga
    [3] => pisang
)
apel, anggur, mangga, pisang
```

Kamu perlu mencocokkan sendiri hasil di terminalmu dengan keluaran di atas.

### Langkah 2: array asosiatif

```php title="belajar-php/array-asosiatif.php"
<?php

$siswa = [
    "nama" => "Budi",
    "umur" => 20,
    "kota" => "Bandung",
];

echo $siswa["nama"], "\n";

$siswa["jurusan"] = "Informatika";

foreach ($siswa as $kunci => $nilai) {
    echo "$kunci: $nilai\n";
}

var_dump(isset($siswa["alamat"]));
echo $siswa["alamat"] ?? "-", "\n";
var_dump(array_key_exists("kota", $siswa));
```

**Yang seharusnya terlihat:**

```text
Budi
nama: Budi
umur: 20
kota: Bandung
jurusan: Informatika
bool(false)
-
bool(true)
```

### Langkah 3: array multidimensi

```php title="belajar-php/array-multi.php"
<?php

$daftarSiswa = [
    ["nama" => "Budi", "nilai" => 80],
    ["nama" => "Sari", "nilai" => 90],
];

foreach ($daftarSiswa as $siswa) {
    echo $siswa["nama"], ": ", $siswa["nilai"], "\n";
}

echo $daftarSiswa[1]["nama"], "\n";
```

**Yang seharusnya terlihat:**

```text
Budi: 80
Sari: 90
Sari
```

### Langkah 4: menambah, menghapus, dan mengurutkan

```php title="belajar-php/array-operasi.php"
<?php

$angka = [3, 1, 2];

array_push($angka, 5);
echo implode(", ", $angka), "\n";

$terakhir = array_pop($angka);
echo "Dibuang: $terakhir\n";

array_unshift($angka, 0);
echo implode(", ", $angka), "\n";

array_shift($angka);

sort($angka);
echo implode(", ", $angka), "\n";

rsort($angka);
echo implode(", ", $angka), "\n";

var_dump(in_array(2, $angka));
echo array_sum($angka), " ", max($angka), " ", min($angka), "\n";
```

**Yang seharusnya terlihat:**

```text
3, 1, 2, 5
Dibuang: 5
0, 3, 1, 2
1, 2, 3
3, 2, 1
bool(true)
6 3 1
```

Telusuri tiap langkah di atas kertas sebelum membandingkan dengan hasilmu.

### Langkah 5: mengurutkan array asosiatif

```php title="belajar-php/array-urut.php"
<?php

$nilai = ["Budi" => 80, "Sari" => 90, "Andi" => 70];

asort($nilai);
foreach ($nilai as $nama => $skor) {
    echo "$nama: $skor\n";
}

echo "--\n";

ksort($nilai);
foreach ($nilai as $nama => $skor) {
    echo "$nama: $skor\n";
}
```

**Yang seharusnya terlihat:**

```text
Andi: 70
Budi: 80
Sari: 90
--
Andi: 70
Budi: 80
Sari: 90
```

Kebetulan urutan nilai dan urutan nama sama di data ini. Ubah nilai Andi menjadi `95`
dan jalankan lagi: pengurutan berdasarkan nilai dan berdasarkan nama kini berbeda.

### Langkah 6: salinan dan penggabungan

```php title="belajar-php/array-salinan.php"
<?php

$a = [1, 2, 3];
$b = $a;
$b[] = 4;

echo implode(", ", $a), "\n";
echo implode(", ", $b), "\n";

$c = array_merge($a, [10, 20]);
echo implode(", ", $c), "\n";
```

**Yang seharusnya terlihat:**

```text
1, 2, 3
1, 2, 3, 4
1, 2, 3, 10, 20
```

### Langkah 7: array di halaman web

```php title="belajar-php/tabel.php"
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <title>Daftar Siswa</title>
</head>
<body>
    <?php
    $daftarSiswa = [
        ["nama" => "Budi", "nilai" => 80],
        ["nama" => "Sari", "nilai" => 90],
    ];
    ?>
    <table border="1">
        <tr><th>Nama</th><th>Nilai</th></tr>
        <?php foreach ($daftarSiswa as $siswa): ?>
            <tr>
                <td><?= $siswa["nama"] ?></td>
                <td><?= $siswa["nilai"] ?></td>
            </tr>
        <?php endforeach; ?>
    </table>
</body>
</html>
```

```bash
php -S localhost:8000
```

Buka `http://localhost:8000/tabel.php`.

**Yang seharusnya terlihat:** tabel dengan judul kolom Nama dan Nilai, serta dua baris
data (Budi 80, Sari 90). Hentikan server dengan ++ctrl+c++.

## Kesalahan umum dan debugging

| Gejala | Kemungkinan penyebab | Solusi |
|---|---|---|
| `Undefined array key "x"` | Kunci tidak ada atau salah ketik | Periksa ejaan; gunakan `??` atau `isset`. |
| Mengambil elemen pertama dengan `[1]` | Indeks dimulai dari `0` | Pakai `[0]`. |
| `echo $array` mencetak `Array` | `echo` tidak bisa mencetak array | Gunakan `print_r` atau `var_dump`. |
| `$x = sort($x);` membuat `$x` menjadi `true` | `sort` mengubah array asli dan mengembalikan `bool` | Cukup panggil `sort($x);`. |
| Indeks melompat setelah `unset` | `unset` tidak menomori ulang | Pakai `array_values($a)` untuk menomori ulang. |
| `Parse error` pada daftar elemen | Koma ganda (`,,`) atau koma hilang di antara elemen | Koma setelah elemen terakhir boleh; koma ganda tidak. |
| Mengubah `$b` tetapi `$a` tidak ikut berubah | Array disalin berdasarkan nilai saat ditugaskan | Ubah variabel yang dimaksud, atau tugaskan ulang hasilnya. |
| `foreach` pada nilai `null` memberi peringatan | Yang ditelusuri bukan array | Periksa dengan `var_dump`, isi dengan array kosong `[]`. |

## Latihan terpandu

1. Buat array tiga nama kota, cetak setiap kota dengan nomor urut mulai dari 1.
2. Buat array asosiatif `$buku` dengan kunci `judul`, `penulis`, `tahun`, lalu cetak seluruh
   isinya memakai `foreach`.
3. Buat array multidimensi berisi tiga produk (`nama`, `harga`), cetak nama dan harga tiap
   produk, lalu hitung total harga dengan perulangan.
4. Dari array `[5, 3, 9, 1]`, cetak nilai terbesar, terkecil, jumlah, dan versi yang
   sudah diurutkan turun.
5. Periksa apakah `"Sari"` ada pada array `["Budi", "Sari", "Andi"]` dan cetak "Ada" atau
   "Tidak ada".
6. Jelaskan perbedaan `isset($a["x"])` dan `array_key_exists("x", $a)` ketika
   `$a = ["x" => null]`.

??? success "Jawaban nomor 6"
    `array_key_exists` mengembalikan `true` karena kunci `"x"` ada. `isset` mengembalikan
    `false` karena nilainya `null`.

## Pertanyaan review

1. Apa beda array berindeks dan array asosiatif?
2. Dari angka berapa indeks array dimulai?
3. Bagaimana menambahkan elemen di akhir array?
4. Apa beda `sort` dan `asort`?
5. Mengapa `$x = sort($x)` salah?
6. Apa yang terjadi saat sebuah array ditugaskan ke variabel lain lalu diubah?
7. Mengapa struktur "daftar yang berisi array asosiatif" penting untuk Laravel?

## Ringkasan

- Array menyimpan banyak nilai: berindeks (mulai dari `0`), asosiatif (kunci teks), dan
  multidimensi.
- Tambah dengan `[]`/`array_push`, hapus dengan `unset`/`array_pop`/`array_shift`.
- `count`, `in_array`, `isset`, `??`, `array_sum`, `max`, `min` membantu memeriksa isi.
- `sort`, `asort`, `ksort`, dan kawan-kawannya mengubah array asli.
- Array disalin berdasarkan nilai; lihat isi dengan `print_r` atau `var_dump`.

Selanjutnya: **Functions**.

## Referensi resmi

- [PHP Manual: Arrays](https://www.php.net/manual/en/language.types.array.php)
- [PHP Manual: Array functions](https://www.php.net/manual/en/ref.array.php)
- [PHP Manual: count](https://www.php.net/manual/en/function.count.php)
- [PHP Manual: print_r](https://www.php.net/manual/en/function.print-r.php)
- [PHP Manual: in_array](https://www.php.net/manual/en/function.in-array.php)
- [PHP Manual: array_key_exists](https://www.php.net/manual/en/function.array-key-exists.php)
- [PHP Manual: array_push](https://www.php.net/manual/en/function.array-push.php)
- [PHP Manual: array_merge](https://www.php.net/manual/en/function.array-merge.php)
- [PHP Manual: implode](https://www.php.net/manual/en/function.implode.php)
- [PHP Manual: sort](https://www.php.net/manual/en/function.sort.php)
- [PHP Manual: asort](https://www.php.net/manual/en/function.asort.php)
- [PHP Manual: ksort](https://www.php.net/manual/en/function.ksort.php)
