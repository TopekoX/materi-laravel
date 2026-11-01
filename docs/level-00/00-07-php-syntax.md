# Sintaks PHP

Setiap bahasa punya tata bahasa. Sintaks PHP menentukan bagaimana kode ditulis agar
dimengerti interpreter. Bab ini membahas aturan dasarnya: tag PHP, pernyataan,
komentar, perintah mencetak, dan aturan huruf besar-kecil.

## Tujuan pembelajaran

Setelah menyelesaikan bab ini, kamu dapat:

- [ ] Menulis tag PHP dengan benar, termasuk bentuk singkat `<?= ?>`.
- [ ] Mengakhiri pernyataan dengan titik koma.
- [ ] Menulis tiga jenis komentar PHP.
- [ ] Mencetak teks dengan `echo` dan `print`.
- [ ] Menjelaskan aturan huruf besar-kecil dan spasi dalam PHP.
- [ ] Memeriksa sintaks berkas dengan `php -l` dan membaca pesan *parse error*.

## Prasyarat

- Bab [Pemasangan PHP](00-06-php-installation-and-development-environment.md): PHP
  8.3 atau lebih baru terpasang dan `php -v` berfungsi.
- Folder kerja `belajar-php` dan editor teks.

## Konsep

### Tag PHP

Interpreter hanya menjalankan kode yang berada di dalam tag PHP. Segala sesuatu di luar
tag dikirim apa adanya.

| Bentuk | Kegunaan |
|---|---|
| `<?php ... ?>` | Bentuk standar. Dapat disisipkan di tengah HTML. |
| `<?php` (tanpa penutup) | Untuk berkas yang **hanya** berisi PHP. Tag penutup `?>` dihilangkan. |
| `<?= ... ?>` | Singkatan untuk `<?php echo ... ?>`, praktis untuk mencetak satu nilai di HTML. |

Seluruh kode Laravel memakai bentuk kedua pada berkas PHP murni (class, route,
konfigurasi), sedangkan pada template Blade kamu akan memakai sintaks sendiri.

### Pernyataan dan titik koma

Satu **pernyataan** (*statement*) adalah satu perintah lengkap. Pernyataan diakhiri
titik koma:

```php-inline
echo "Satu";
echo "Dua";
```

Pernyataan boleh ditulis berderet pada satu baris atau dipecah ke beberapa baris;
PHP tidak peduli pada spasi dan baris baru di antara token. Demi keterbacaan, tulis
**satu pernyataan per baris**.

Pengecualian: pernyataan terakhir sebelum tag penutup `?>` tidak wajib diberi titik
koma, tetapi sebaiknya tetap ditulis agar seragam.

### Komentar

Komentar diabaikan interpreter. Gunakan untuk menjelaskan *mengapa* kode ditulis begitu,
atau menonaktifkan kode sementara.

```php-inline
// Komentar satu baris gaya C++
# Komentar satu baris gaya shell (jarang dipakai)

/*
   Komentar
   beberapa baris
*/
```

!!! tip "Gaya yang disarankan"
    Pakai `//` untuk satu baris dan `/* ... */` untuk beberapa baris. Pada kode
    Laravel kamu juga akan sering melihat komentar dokumentasi berbentuk `/** ... */`.

### Mencetak: `echo` dan `print`

```php-inline
echo "Halo";
print "Halo";
```

| | `echo` | `print` |
|---|---|---|
| Fungsi | Mencetak satu atau lebih nilai | Mencetak satu nilai |
| Beberapa argumen | Boleh: `echo "A", "B";` | Tidak |
| Pemakaian | Paling umum | Jarang |

Cukup pakai `echo` untuk seterusnya.

Teks (*string*) ditulis dengan tanda kutip. Dua jenis kutip berbeda perilaku:

- `"..."` (kutip ganda) memahami karakter khusus seperti `\n` (baris baru).
- `'...'` (kutip tunggal) mencetak apa adanya.

```php-inline
echo "Baris 1\nBaris 2";   // tercetak dua baris
echo 'Baris 1\nBaris 2';   // tercetak persis: Baris 1\nBaris 2
```

Pembahasan lengkap string ada di sub bab *String Manipulation*.

### Huruf besar-kecil dan spasi

- **Kata kunci** dan nama fungsi **tidak** membedakan huruf besar-kecil:
  `echo`, `ECHO`, dan `Echo` sama saja. Namun tulislah dengan huruf kecil sesuai
  kebiasaan.
- **Nama variabel** membedakan huruf besar-kecil (dibahas di bab Variabel dan Konstanta).
- Spasi, tab, dan baris kosong di antara pernyataan tidak memengaruhi hasil;
  gunakan untuk merapikan kode (indentasi 4 spasi lazim di PHP/Laravel).

## Praktik

Semua berkas dibuat di folder `belajar-php`.

### Langkah 1: pernyataan dan komentar

```php title="belajar-php/sintaks.php"
<?php

// Mencetak dua baris teks
echo "Baris pertama\n";
echo "Baris kedua\n";

/* Beberapa argumen sekaligus */
echo "A", "B", "C", "\n";

print "Dicetak dengan print\n";

# Baris di bawah ini dinonaktifkan oleh komentar
// echo "Tidak tampil\n";
```

Jalankan:

```bash
php sintaks.php
```

**Yang seharusnya terlihat:**

```text
Baris pertama
Baris kedua
ABC
Dicetak dengan print
```

Alasan hasil ini: dua `echo` pertama masing-masing mencetak satu baris; `echo "A", "B", "C", "\n"`
mencetak ketiga huruf bersambung lalu baris baru; `print` mencetak satu baris; baris
yang diawali komentar tidak dijalankan. Kamu perlu mencocokkan sendiri hasil di terminalmu
dengan keluaran di atas.

### Langkah 2: kutip tunggal dan ganda

```php title="belajar-php/kutip.php"
<?php

echo "Ganda:  satu\ndua\n";
echo 'Tunggal: satu\ndua';
echo "\n";
```

**Yang seharusnya terlihat:**

```text
Ganda:  satu
dua
Tunggal: satu\ndua
```

### Langkah 3: huruf besar-kecil

```php title="belajar-php/besar-kecil.php"
<?php

echo "kecil\n";
ECHO "BESAR\n";
Echo "Campur\n";
```

**Yang seharusnya terlihat:** tiga baris, `kecil`, `BESAR`, `Campur`. Ketiga bentuk
`echo` bekerja, tetapi gunakan huruf kecil.

### Langkah 4: PHP di dalam HTML dengan `<?=`

```html+php title="belajar-php/tag.php"
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <title>Tag PHP</title>
</head>
<body>
    <h1><?= "Belajar Sintaks PHP" ?></h1>
    <p><?php echo "Ini dari tag standar."; ?></p>
    <p>Teks biasa di luar PHP.</p>
</body>
</html>
```

Jalankan server pengembangan dari folder `belajar-php`:

```bash
php -S localhost:8000
```

Buka `http://localhost:8000/tag.php`.

**Yang seharusnya terlihat:** judul "Belajar Sintaks PHP" dan dua paragraf. Lewat
**View Page Source**, kamu hanya melihat HTML: tag `<?= ?>` dan `<?php ?>` sudah
diganti hasilnya. Hentikan server dengan ++ctrl+c++.

### Langkah 5: memeriksa sintaks dengan `php -l`

Opsi `-l` (*lint*) memeriksa sintaks tanpa menjalankan kode:

```bash
php -l sintaks.php
```

**Yang seharusnya terlihat:** pesan `No syntax errors detected in sintaks.php`.

### Langkah 6: sengaja membuat error

Salin `sintaks.php` menjadi `rusak.php`, lalu hapus titik koma pada salah satu `echo`:

```php title="belajar-php/rusak.php"
<?php

echo "Baris pertama\n"
echo "Baris kedua\n";
```

```bash
php -l rusak.php
```

**Yang seharusnya terlihat:** pesan *Parse error: syntax error* disertai nama berkas dan
nomor baris, dengan keterangan token yang tidak diharapkan. Bunyi tepat pesan bisa
berbeda antar versi PHP, tetapi pola "parse error + berkas + baris" selalu ada. Perhatikan
bahwa nomor baris yang dilaporkan sering kali baris **sesudah** kesalahan sebenarnya
(karena interpreter baru sadar ada yang salah di baris berikutnya).

## Kesalahan umum dan debugging

| Gejala | Kemungkinan penyebab | Solusi |
|---|---|---|
| `Parse error: syntax error, unexpected ...` | Titik koma, kutip, atau kurung hilang | Periksa baris yang dilaporkan **dan baris sebelumnya**. |
| Browser menampilkan kode PHP | Berkas dibuka lewat `file:///` | Buka lewat `http://localhost:8000/...` (server PHP). |
| `\n` tercetak apa adanya | Memakai kutip tunggal `'...'` | Pakai kutip ganda `"..."`. |
| Semua teks bersambung di browser | Baris baru PHP diabaikan HTML | Tambahkan `<br>`/`<p>` pada HTML. |
| Teks aneh muncul sebelum halaman | Spasi/baris kosong sebelum `<?php` | Mulai berkas langsung dengan `<?php`. |
| Perubahan tidak terlihat | Berkas belum disimpan, atau server dijalankan dari folder lain | Simpan, dan jalankan `php -S` dari folder yang benar. |
| `Undefined constant`/`Unknown ...` pada teks | Lupa tanda kutip di sekitar teks | Bungkus teks dengan kutip. |

## Latihan terpandu

1. Tulis `biodata.php` yang mencetak tiga baris (nama, kota, hobi) memakai `echo`, dan
   beri satu komentar penjelasan di atas tiap baris.
2. Cetak satu baris `Halo, dunia!` dengan tiga argumen `echo` (`"Halo, "`, `"dunia"`, `"!\n"`).
3. Buat `kartu.php` berisi HTML yang menampilkan namamu lewat `<?= ?>` pada elemen
   `<h1>`. Jalankan lewat `php -S` dan periksa *page source*.
4. Hilangkan satu tanda kutip penutup pada salah satu `echo`, jalankan `php -l`, lalu
   catat pesan dan nomor barisnya. Perbaiki dan ulangi sampai bersih.
5. Jelaskan perbedaan keluaran `echo "a\nb";` dan `echo 'a\nb';`.

??? success "Jawaban nomor 5"
    Dengan kutip ganda, `\n` diubah menjadi baris baru sehingga tercetak `a` lalu
    `b` pada baris berikutnya. Dengan kutip tunggal, `\n` tercetak sebagai dua karakter
    literal: `a\nb`.

## Pertanyaan review

1. Apa fungsi tag `<?php` dan mengapa tag penutup boleh dihilangkan?
2. Kapan memakai `<?= ?>`?
3. Mengapa pernyataan diakhiri titik koma?
4. Sebutkan tiga bentuk komentar PHP.
5. Apa beda `echo` dan `print`?
6. Apa beda kutip tunggal dan kutip ganda?
7. Apa yang dilakukan `php -l`?
8. Apakah `ECHO "x";` valid? Mengapa sebaiknya tidak ditulis begitu?

## Ringkasan

- Kode PHP berada di dalam tag `<?php`; berkas PHP murni tidak memakai `?>`.
- Pernyataan diakhiri `;`; spasi dan baris baru tidak berpengaruh pada hasil.
- Komentar: `//`, `#`, `/* ... */`.
- `echo` mencetak; kutip ganda memahami `\n`, kutip tunggal tidak.
- Kata kunci tidak membedakan huruf besar-kecil, tetapi tulis dengan huruf kecil.
- `php -l` memeriksa sintaks; baca pesan error beserta nomor barisnya.

Selanjutnya: **Variabel dan Konstanta**.

## Referensi resmi

- [PHP Manual: Basic syntax](https://www.php.net/manual/en/language.basic-syntax.php)
- [PHP Manual: Escaping from HTML](https://www.php.net/manual/en/language.basic-syntax.phpmode.php)
- [PHP Manual: Instruction separation](https://www.php.net/manual/en/language.basic-syntax.instruction-separation.php)
- [PHP Manual: Comments](https://www.php.net/manual/en/language.basic-syntax.comments.php)
- [PHP Manual: print](https://www.php.net/manual/en/function.print.php)
- [PHP Manual: Strings](https://www.php.net/manual/en/language.types.string.php)
