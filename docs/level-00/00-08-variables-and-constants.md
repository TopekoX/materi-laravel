# Variabel dan Konstanta

Program hampir selalu perlu menyimpan data sementara: nama pengguna, jumlah barang,
pengaturan aplikasi. **Variabel** dan **konstanta** adalah tempat menyimpan data itu.
Bedanya, isi variabel boleh berubah, isi konstanta tidak.

## Tujuan pembelajaran

Setelah menyelesaikan bab ini, kamu dapat:

- [ ] Membuat variabel dan mengisinya dengan nilai (*assignment*).
- [ ] Menerapkan aturan penamaan variabel PHP.
- [ ] Menyisipkan variabel ke dalam teks (*interpolation*) dan menggabungkan teks.
- [ ] Mengubah, memeriksa (`isset`), dan menghapus (`unset`) variabel.
- [ ] Membuat konstanta dengan `const` dan `define()`.
- [ ] Membedakan variabel dan konstanta serta memilih yang tepat.

## Prasyarat

- Bab [Sintaks PHP](00-07-php-syntax.md): tag PHP, `echo`, titik koma, komentar.
- PHP 8.3 atau lebih baru terpasang; folder `belajar-php`.

## Konsep

### Variabel

**Variabel** adalah nama yang menunjuk ke sebuah nilai di memori.

!!! tip "Analogi"
    Variabel seperti kotak berlabel. Label (`$nama`) tetap, tetapi isi kotak bisa
    diganti kapan saja.

Di PHP, nama variabel selalu diawali tanda dolar `$`. Variabel dibuat saat pertama kali
diberi nilai, tanpa perlu dideklarasikan lebih dulu:

```php
$nama = "Budi";
$umur = 20;
```

Tanda `=` di sini berarti **isi** (*assignment*): nilai di kanan disimpan ke variabel di
kiri. Ini bukan tanda "sama dengan" dalam matematika.

### Aturan penamaan

| Aturan | Contoh benar | Contoh salah |
|---|---|---|
| Diawali `$`, lalu huruf atau garis bawah | `$nama`, `$_data` | `$1nama` (diawali angka) |
| Selanjutnya boleh huruf, angka, garis bawah | `$nama2`, `$total_harga` | `$total-harga` (ada tanda minus) |
| Tidak boleh mengandung spasi | `$namaLengkap` | `$nama lengkap` |
| **Membedakan huruf besar-kecil** | `$nama` ≠ `$Nama` | |

Gaya penulisan yang dipakai di kode Laravel adalah **camelCase** untuk variabel:
`$namaLengkap`, `$totalHarga`. Beri nama yang menjelaskan isi (`$jumlahSiswa`, bukan `$x`).

### Mengubah nilai

```php
$kota = "Bandung";
$kota = "Surabaya";   // nilai lama digantikan
```

Variabel bisa diisi ulang. Variabel juga bisa diisi dengan nilai variabel lain:

```php
$a = "Halo";
$b = $a;
```

Jenis-jenis nilai (teks, angka, dan sebagainya) dibahas di bab berikutnya, Tipe Data.

### Menyisipkan variabel ke teks

Pada teks berkutip **ganda**, nama variabel diganti dengan isinya:

```php
$nama = "Budi";
echo "Halo, $nama!\n";       // Halo, Budi!
echo "Halo, {$nama}!\n";     // bentuk dengan kurung kurawal, lebih jelas
```

Pada kutip **tunggal**, variabel tidak diganti: `'Halo, $nama'` tercetak apa adanya.

Teks juga bisa digabung dengan operator titik `.` (*concatenation*):

```php
echo "Halo, " . $nama . "!\n";
```

!!! note "Gunakan `{$nama}`, bukan `${nama}`"
    Bentuk `${nama}` dalam teks sudah dinyatakan usang (*deprecated*) pada PHP 8.2.
    Pakai `$nama` atau `{$nama}`.

### Memeriksa dan menghapus variabel

| Fungsi | Kegunaan |
|---|---|
| `isset($x)` | `true` jika `$x` ada **dan** nilainya bukan `null` |
| `unset($x)` | Menghapus variabel |

Memakai variabel yang belum pernah diisi menghasilkan peringatan (*warning*)
`Undefined variable` pada PHP 8, dan nilainya dianggap `null`. Selalu isi variabel
sebelum dipakai.

### Konstanta

**Konstanta** adalah nilai bernama yang **tidak dapat diubah** setelah ditetapkan.
Cocok untuk nilai tetap seperti nama aplikasi atau batas maksimum.

Dua cara membuatnya:

```php
const NAMA_APLIKASI = "Pustaka Materi";     // cara disarankan di tingkat atas berkas
define('VERSI', '1.0');                     // fungsi; nama berupa teks
```

Aturan dan kebiasaan:

- **Tidak** memakai tanda `$`.
- Nama ditulis **HURUF_BESAR** dengan garis bawah pemisah kata.
- Setelah dibuat, nilainya tidak bisa diganti.
- Bisa dipakai di bagian mana pun dari kode setelah dibuat.

```php
echo NAMA_APLIKASI;
```

PHP juga menyediakan konstanta bawaan, misalnya `PHP_VERSION` (versi PHP yang menjalankan
kode) dan `PHP_EOL` (karakter baris baru sesuai sistem).

### Variabel atau konstanta?

| | Variabel | Konstanta |
|---|---|---|
| Awalan | `$` | Tidak ada |
| Isi dapat berubah | Ya | Tidak |
| Penamaan | `camelCase` | `HURUF_BESAR` |
| Contoh pemakaian | Nama pengguna, jumlah, hasil hitungan | Nama aplikasi, nilai tetap |

Aturan praktis: jika nilai tidak seharusnya berubah selama program berjalan, jadikan
konstanta.

## Praktik

Semua berkas dibuat di folder `belajar-php`.

### Langkah 1: variabel dasar

```php title="belajar-php/variabel.php"
<?php

$nama = "Budi";
$kota = "Bandung";

echo "Nama: $nama\n";
echo "Kota: {$kota}\n";

$kota = "Surabaya";
echo "Kota sekarang: " . $kota . "\n";

echo 'Kutip tunggal: $nama' . "\n";
```

```bash
cd belajar-php
php variabel.php
```

**Yang seharusnya terlihat:**

```text
Nama: Budi
Kota: Bandung
Kota sekarang: Surabaya
Kutip tunggal: $nama
```

Hasil ini diturunkan dari aturan bahasa; cocokkan dengan keluaran di terminalmu.

### Langkah 2: membedakan huruf besar-kecil

```php title="belajar-php/besar-kecil-variabel.php"
<?php

$nama = "Budi";
$Nama = "Sari";

echo $nama . "\n";
echo $Nama . "\n";
```

**Yang seharusnya terlihat:** `Budi` lalu `Sari`. `$nama` dan `$Nama` adalah dua variabel
berbeda.

### Langkah 3: isset dan unset

```php title="belajar-php/isset.php"
<?php

$kode = "A1";

if (isset($kode)) {
    echo "kode ada: $kode\n";
}

unset($kode);

if (!isset($kode)) {
    echo "kode sudah dihapus\n";
}
```

**Yang seharusnya terlihat:**

```text
kode ada: A1
kode sudah dihapus
```

Struktur `if` dipelajari penuh di sub bab *Conditional Statements*; di sini cukup
dibaca sebagai "jika kondisi benar, jalankan blok ini".

### Langkah 4: konstanta

```php title="belajar-php/konstanta.php"
<?php

const NAMA_APLIKASI = "Pustaka Materi";
define('VERSI', '1.0');

echo NAMA_APLIKASI . " v" . VERSI . "\n";
echo "PHP versi " . PHP_VERSION . "\n";
```

**Yang seharusnya terlihat:**

- Baris pertama: `Pustaka Materi v1.0`
- Baris kedua: `PHP versi ` diikuti nomor versi PHP yang terpasang di komputermu
  (8.3 atau lebih tinggi).

### Langkah 5: mencoba mengubah konstanta

Tambahkan di akhir `konstanta.php`:

```php
const NAMA_APLIKASI = "Nama Lain";
```

Jalankan lagi. **Yang seharusnya terlihat:** PHP memberi peringatan atau error bahwa
konstanta sudah ada (bunyi pesan tergantung versi dan konfigurasi), dan nilai awalnya
tidak berubah. Hapus baris tambahan itu setelah mencoba.

### Langkah 6: variabel yang belum diisi

```php title="belajar-php/belum-diisi.php"
<?php

echo "Halo, $namaTamu!\n";
```

**Yang seharusnya terlihat:** peringatan `Undefined variable $namaTamu` (bila
pelaporan error aktif di pengaturan PHP-mu) dan teks `Halo, !`. Jika peringatan tidak
muncul, itu karena pengaturan PHP menyembunyikannya; nilai kosongnya tetap ada. Biasakan
mengisi variabel sebelum dipakai.

## Kesalahan umum dan debugging

| Gejala | Kemungkinan penyebab | Solusi |
|---|---|---|
| `Undefined variable $x` | Variabel belum diisi, atau salah ketik nama | Periksa ejaan dan huruf besar-kecil; isi sebelum dipakai. |
| `$Nama` kosong padahal sudah mengisi `$nama` | Nama variabel membedakan huruf besar-kecil | Samakan penulisan. |
| `Parse error` pada nama variabel | Nama diawali angka atau mengandung `-` atau spasi | Ikuti aturan penamaan. |
| `$nama` tercetak apa adanya | Memakai kutip tunggal | Pakai kutip ganda atau gabungkan dengan `.`. |
| Lupa `$` | `nama = "Budi";` | Awali variabel dengan `$`. |
| Menaruh `$` di depan konstanta | `echo $NAMA_APLIKASI;` | Konstanta ditulis tanpa `$`. |
| Konstanta tidak bisa diubah | Memang disengaja | Gunakan variabel jika nilai harus berubah. |

## Latihan terpandu

1. Buat `profil.php` dengan variabel `$nama`, `$kota`, dan `$hobi`, lalu cetak kalimat
   `Saya <nama> tinggal di <kota> dan suka <hobi>.` memakai interpolasi.
2. Ubah `$kota` setelah kalimat pertama dicetak, lalu cetak kalimat kedua dengan kota baru.
3. Buat konstanta `BATAS_PEMINJAMAN` dengan nilai `3` dan cetak
   `Maksimal peminjaman: 3 buku`.
4. Jelaskan mengapa `$nama` dan `$Nama` bisa memicu bug yang sulit dilihat.
5. Tentukan mana yang cocok sebagai konstanta dan mana sebagai variabel: nama aplikasi,
   nama pengguna yang sedang login, jumlah halaman maksimum, skor permainan.

??? success "Jawaban nomor 5"
    Konstanta: nama aplikasi, jumlah halaman maksimum. Variabel: nama pengguna yang
    sedang login, skor permainan (nilainya berubah-ubah).

## Pertanyaan review

1. Apa itu variabel? Apa arti tanda `=` pada PHP?
2. Sebutkan aturan penamaan variabel PHP.
3. Apa beda kutip tunggal dan ganda untuk variabel di dalam teks?
4. Apa fungsi `isset` dan `unset`?
5. Apa beda `const` dan `define()`?
6. Apa beda variabel dan konstanta?
7. Apa yang terjadi saat memakai variabel yang belum diisi?

## Ringkasan

- Variabel diawali `$`, dibuat saat diisi, dan membedakan huruf besar-kecil.
- Isi variabel boleh berubah; gunakan `camelCase` dengan nama yang bermakna.
- Kutip ganda menyisipkan variabel; kutip tunggal tidak. Titik `.` menggabungkan teks.
- `isset` memeriksa keberadaan, `unset` menghapus.
- Konstanta (`const`/`define()`) tidak berubah, tanpa `$`, ditulis `HURUF_BESAR`.

Selanjutnya: **PHP Data Types**.

## Referensi resmi

- [PHP Manual: Variables](https://www.php.net/manual/en/language.variables.php)
- [PHP Manual: Variable basics](https://www.php.net/manual/en/language.variables.basics.php)
- [PHP Manual: Constants](https://www.php.net/manual/en/language.constants.php)
- [PHP Manual: Constants syntax](https://www.php.net/manual/en/language.constants.syntax.php)
- [PHP Manual: Predefined constants](https://www.php.net/manual/en/language.constants.predefined.php)
- [PHP Manual: isset](https://www.php.net/manual/en/function.isset.php)
- [PHP-FIG: PSR-12 Extended Coding Style](https://www.php-fig.org/psr/psr-12/)
