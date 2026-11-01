# Manipulasi String

Teks ada di mana-mana dalam aplikasi web: nama pengguna, judul artikel, alamat email, URL.
**Manipulasi string** adalah kemampuan memeriksa, memotong, mengganti, dan memformat teks.
Laravel menyediakan banyak pembantu string, tetapi semuanya dibangun di atas fungsi
dasar PHP yang kamu pelajari di sini.

## Tujuan pembelajaran

Setelah menyelesaikan bab ini, kamu dapat:

- [ ] Menghitung panjang string dengan benar, termasuk karakter non-ASCII.
- [ ] Mengubah huruf besar-kecil dan membersihkan spasi.
- [ ] Mencari, memotong, dan mengganti bagian string.
- [ ] Memecah string menjadi array dan sebaliknya.
- [ ] Memformat teks dan angka dengan `sprintf` dan `number_format`.
- [ ] Menulis teks banyak baris dengan heredoc.
- [ ] Mengamankan teks yang akan ditampilkan di HTML dengan `htmlspecialchars`.

## Prasyarat

- Bab [Fungsi](00-14-functions.md) dan [Array](00-13-arrays.md).
- Bab [Sintaks PHP](00-07-php-syntax.md): kutip tunggal dan ganda.
- PHP 8.3 atau lebih baru terpasang dengan ekstensi `mbstring` (sudah dicek pada bab
  pemasangan); folder `belajar-php`; berkas disimpan dengan encoding **UTF-8**.

## Konsep

!!! tip "Analogi"
    String seperti kalimat di kertas. Fungsi string adalah gunting, spidol, dan penggaris:
    memotong, mengganti, mengukur. Kertas aslinya tidak berubah; kamu mendapatkan
    salinan hasil olahan.

Hampir semua fungsi string **mengembalikan string baru** dan tidak mengubah aslinya. Hasilnya
perlu ditampung:

```php-inline
$judul = "belajar php";
ucfirst($judul);              // hasil terbuang
$judul = ucfirst($judul);     // benar: ditampung kembali
```

### Panjang dan karakter

| Fungsi | Hasil |
|---|---|
| `strlen("Halo Dunia")` | `10`, jumlah **byte** |
| `mb_strlen("Café")` | `4`, jumlah **karakter** (multibyte) |
| `"belajar"[0]` | `b`, karakter pertama (indeks mulai dari 0) |

Karakter seperti `é` memakai lebih dari satu byte dalam UTF-8. `strlen("Café")` menghasilkan
`5` karena menghitung byte. Untuk teks yang mungkin mengandung huruf non-ASCII,
gunakan fungsi berawalan `mb_` (`mb_strlen`, `mb_strtoupper`, `mb_substr`, ...).

### Huruf besar-kecil dan spasi

| Fungsi | Contoh | Hasil |
|---|---|---|
| `strtoupper` | `strtoupper("halo")` | `HALO` |
| `strtolower` | `strtolower("HALO")` | `halo` |
| `ucfirst` | `ucfirst("budi")` | `Budi` |
| `ucwords` | `ucwords("selamat pagi")` | `Selamat Pagi` |
| `trim` | `trim("  halo  ")` | `halo` |
| `ltrim` / `rtrim` | Hanya sisi kiri / kanan | |

`strtoupper` dan `strtolower` hanya mengubah huruf ASCII; untuk karakter seperti `é`
pakai `mb_strtoupper` dan `mb_strtolower`.

### Mencari

| Fungsi | Arti |
|---|---|
| `str_contains($teks, $cari)` | Apakah teks memuat `$cari` (`bool`) |
| `str_starts_with($teks, $awal)` | Apakah diawali (`bool`) |
| `str_ends_with($teks, $akhir)` | Apakah diakhiri (`bool`) |
| `strpos($teks, $cari)` | Posisi pertama (mulai dari 0) atau `false` |

!!! warning "Periksa `strpos` dengan `===`"
    Jika `$cari` ada di awal teks, `strpos` mengembalikan `0`, yang falsy. Tulis
    `strpos(...) === false` untuk memeriksa "tidak ditemukan", bukan `!strpos(...)`.

### Memotong dan mengganti

| Fungsi | Contoh | Hasil |
|---|---|---|
| `substr($t, $mulai, $panjang)` | `substr("belajar laravel", 0, 7)` | `belajar` |
| `substr` dengan indeks negatif | `substr("belajar laravel", -7)` | `laravel` |
| `str_replace($cari, $ganti, $t)` | `str_replace("laravel", "PHP", "belajar laravel")` | `belajar PHP` |
| `str_repeat($t, $n)` | `str_repeat("=", 5)` | `=====` |
| `str_pad($t, $n, $isi, $arah)` | `str_pad("7", 3, "0", STR_PAD_LEFT)` | `007` |

### Memecah dan menggabung

```php-inline
$daftar = explode(",", "apel,jeruk,mangga");   // ["apel", "jeruk", "mangga"]
$teks = implode(" | ", $daftar);               // "apel | jeruk | mangga"
```

`explode(pemisah, teks)` mengubah string menjadi array; `implode(pemisah, array)`
melakukan sebaliknya.

### Memformat

`sprintf` menyusun teks dari cetakan dengan penanda:

| Penanda | Arti |
|---|---|
| `%s` | String |
| `%d` | Bilangan bulat |
| `%.2f` | Desimal dengan 2 angka di belakang titik |
| `%05d` | Bilangan bulat, lebar 5, diisi `0` di kiri |

```php-inline
sprintf("Nama: %s, Umur: %d", "Budi", 20);   // Nama: Budi, Umur: 20
sprintf("%.2f", 3.14159);                    // 3.14
sprintf("%05d", 42);                         // 00042
```

`number_format($angka, $desimal, $pemisahDesimal, $pemisahRibuan)` memformat angka.
Format Indonesia memakai koma untuk desimal dan titik untuk ribuan:

```php-inline
number_format(1234567.891, 2, ",", ".");   // 1.234.567,89
```

### Heredoc dan nowdoc

Untuk teks banyak baris:

```php-inline
$nama = "Budi";

echo <<<TEKS
Halo, $nama!
Selamat belajar.
TEKS;
```

- **Heredoc** (`<<<TEKS`) bekerja seperti kutip ganda: variabel diganti.
- **Nowdoc** (`<<<'TEKS'`, dengan kutip tunggal) bekerja seperti kutip tunggal: apa adanya.
- Penanda penutup (`TEKS;`) berdiri di barisnya sendiri.

### Mengamankan teks untuk HTML

Teks dari pengguna tidak boleh langsung dicetak ke halaman HTML. Pengguna jahat bisa
menyisipkan `<script>` (serangan **XSS**). `htmlspecialchars` mengubah karakter khusus
HTML menjadi padanan aman:

```php-inline
echo htmlspecialchars("<script>alert('x')</script>");
// &lt;script&gt;alert(&#039;x&#039;)&lt;/script&gt;
```

Inilah yang dilakukan sintaks `{{ $teks }}` di Blade secara otomatis.

!!! note "Pembantu string Laravel"
    Laravel menyediakan kelas `Illuminate\Support\Str` dan helper seperti `Str::slug()`
    untuk pekerjaan umum. Semuanya memakai fungsi PHP dasar seperti di bab ini, dan akan
    kamu temui kembali nanti.

## Praktik

Semua berkas dibuat di folder `belajar-php` dan disimpan sebagai UTF-8.

### Langkah 1: panjang dan huruf

```php title="belajar-php/string-dasar.php"
<?php

echo strlen("Halo Dunia"), "\n";
echo strlen("Café"), "\n";
echo mb_strlen("Café"), "\n";

echo strtoupper("halo"), "\n";
echo ucfirst("budi"), "\n";
echo ucwords("selamat pagi dunia"), "\n";
echo strtoupper("café"), "\n";
echo mb_strtoupper("café"), "\n";

echo "[" . trim("  halo  ") . "]", "\n";
echo "belajar"[0], "\n";
```

```bash
cd belajar-php
php string-dasar.php
```

**Yang seharusnya terlihat (PHP 8.3 atau lebih baru):**

```text
10
5
4
HALO
Budi
Selamat Pagi Dunia
CAFé
CAFÉ
[halo]
b
```

Perhatikan `strlen("Café")` menghasilkan `5` sedangkan `mb_strlen` menghasilkan `4`, dan
`strtoupper` tidak mengubah `é`. Kamu perlu mencocokkan sendiri hasil di terminalmu dengan
keluaran di atas.

### Langkah 2: mencari, memotong, mengganti

```php title="belajar-php/string-cari.php"
<?php

$teks = "belajar laravel";

var_dump(str_contains($teks, "laravel"));
var_dump(str_starts_with($teks, "bel"));
var_dump(str_ends_with($teks, "jar"));
var_dump(strpos($teks, "a"));
var_dump(strpos($teks, "z"));

echo substr($teks, 0, 7), "\n";
echo substr($teks, -7), "\n";
echo str_replace("laravel", "PHP", $teks), "\n";
echo $teks, "\n";
```

**Yang seharusnya terlihat:**

```text
bool(true)
bool(true)
bool(false)
int(3)
bool(false)
belajar
laravel
belajar PHP
belajar laravel
```

Penjelasan: teks memuat `laravel` (`true`) dan diawali `bel` (`true`), tetapi berakhir
dengan `vel`, bukan `jar` (`false`). Huruf `a` pertama berada di posisi `3` (hitungan
dimulai dari 0: b=0, e=1, l=2, a=3), sedangkan `z` tidak ada sehingga hasilnya `false`.
Baris terakhir membuktikan teks asli tidak berubah oleh `str_replace`.

### Langkah 3: memecah dan menggabung

```php title="belajar-php/string-pecah.php"
<?php

$daftar = explode(",", "apel,jeruk,mangga");

echo count($daftar), "\n";
echo implode(" | ", $daftar), "\n";
echo $daftar[1], "\n";

$kata = explode(" ", "belajar php dan laravel");
echo count($kata), "\n";
```

**Yang seharusnya terlihat:**

```text
3
apel | jeruk | mangga
jeruk
4
```

### Langkah 4: memformat

```php title="belajar-php/string-format.php"
<?php

echo sprintf("Nama: %s, Umur: %d", "Budi", 20), "\n";
echo sprintf("%.2f", 3.14159), "\n";
echo sprintf("%05d", 42), "\n";
echo number_format(1234567.891, 2, ",", "."), "\n";
echo str_repeat("=", 10), "\n";
echo str_pad("7", 3, "0", STR_PAD_LEFT), "\n";
```

**Yang seharusnya terlihat:**

```text
Nama: Budi, Umur: 20
3.14
00042
1.234.567,89
==========
007
```

### Langkah 5: heredoc

```php title="belajar-php/heredoc.php"
<?php

$nama = "Budi";

echo <<<TEKS
Halo, $nama!
Selamat belajar.
TEKS;
echo "\n";

echo <<<'MENTAH'
Halo, $nama!
MENTAH;
echo "\n";
```

**Yang seharusnya terlihat:**

```text
Halo, Budi!
Selamat belajar.
Halo, $nama!
```

Heredoc mengganti `$nama`; nowdoc (dengan kutip tunggal) tidak.

### Langkah 6: mengamankan teks untuk HTML

```php title="belajar-php/aman.php"
<?php

$masukan = "<script>alert('x')</script>";

echo $masukan, "\n";
echo htmlspecialchars($masukan), "\n";
```

**Yang seharusnya terlihat:** baris pertama adalah teks `<script>alert('x')</script>`
apa adanya. Baris kedua adalah
`&lt;script&gt;alert(&#039;x&#039;)&lt;/script&gt;`. Jika kedua baris dicetak pada halaman
HTML, versi pertama akan dijalankan browser sebagai skrip, sedangkan versi kedua tampil
sebagai teks biasa.

## Kesalahan umum dan debugging

| Gejala | Kemungkinan penyebab | Solusi |
|---|---|---|
| `strlen` salah untuk huruf beraksen | Menghitung byte, bukan karakter | Pakai `mb_strlen`. |
| Hasil fungsi seolah tidak berefek | Hasil tidak ditampung | `$teks = trim($teks);`. |
| `strpos` dianggap "tidak ketemu" padahal ada di awal | Hasil `0` bersifat falsy | Bandingkan dengan `=== false`. |
| Argumen terbalik pada `str_contains`/`str_replace` | Urutan argumen berbeda antar fungsi | Cek dokumentasi: `str_contains(teks, cari)`; `str_replace(cari, ganti, teks)`. |
| Huruf aneh (`Ã©`) pada keluaran | Berkas atau terminal tidak UTF-8 | Simpan berkas sebagai UTF-8; pastikan terminal UTF-8. |
| `Undefined variable` di heredoc | Salah ketik nama variabel | Periksa ejaan; atau pakai nowdoc bila variabel tidak perlu diganti. |
| `Parse error` pada heredoc | Penanda penutup tidak sendirian di barisnya | Letakkan `TEKS;` di baris sendiri. |
| Skrip pengguna berjalan di halaman | Teks pengguna dicetak tanpa di-*escape* | Gunakan `htmlspecialchars` (atau `{{ }}` di Blade). |

## Latihan terpandu

1. Ubah `"  selamat DATANG di laravel  "` menjadi format judul rapi
   (`"Selamat Datang Di Laravel"`) dengan `trim`, `strtolower`, dan `ucwords`.
2. Buat fungsi `buatSlug(string $judul): string` sederhana yang mengubah judul menjadi huruf
   kecil dan mengganti spasi dengan tanda `-` (misalnya `"Belajar PHP Dasar"` menjadi
   `belajar-php-dasar`).
3. Periksa apakah sebuah alamat email mengandung `@` dengan `str_contains`, dan ambil nama
   pengguna (bagian sebelum `@`) dengan `explode` atau `strpos` dan `substr`.
4. Cetak harga `2500000` sebagai `Rp 2.500.000` memakai `number_format`.
5. Buat teks "struk" dengan `sprintf`/`str_pad`: dua kolom (nama barang dan harga) yang
   rata untuk tiga barang.
6. Jelaskan mengapa `{{ $nama }}` pada Blade lebih aman daripada `echo $nama` di HTML mentah.

??? success "Petunjuk nomor 2 dan 4"
    **Nomor 2:**
    ```php-inline
    function buatSlug(string $judul): string
    {
        return str_replace(" ", "-", strtolower(trim($judul)));
    }
    ```

    **Nomor 4:** `echo "Rp " . number_format(2500000, 0, ",", ".");`

## Pertanyaan review

1. Apa beda `strlen` dan `mb_strlen`?
2. Mengapa hasil fungsi string perlu ditampung ke variabel?
3. Mengapa `strpos` harus dibandingkan dengan `=== false`?
4. Apa fungsi `explode` dan `implode`?
5. Apa beda heredoc dan nowdoc?
6. Apa itu XSS dan bagaimana `htmlspecialchars` membantu?
7. Bagaimana memformat angka agar sesuai penulisan Indonesia?

## Ringkasan

- Fungsi string mengembalikan string baru; asli tidak berubah.
- Untuk teks non-ASCII, pakai fungsi `mb_*`; `strlen` menghitung byte.
- Cari dengan `str_contains`, `strpos`; potong dengan `substr`; ganti dengan `str_replace`.
- `explode` memecah menjadi array, `implode` menggabung.
- `sprintf` dan `number_format` memformat teks dan angka.
- Heredoc untuk teks banyak baris; `htmlspecialchars` mencegah XSS.

Selanjutnya: **PHP Form Handling**.

## Referensi resmi

- [PHP Manual: Strings](https://www.php.net/manual/en/language.types.string.php)
- [PHP Manual: String functions](https://www.php.net/manual/en/ref.strings.php)
- [PHP Manual: Multibyte String](https://www.php.net/manual/en/book.mbstring.php)
- [PHP Manual: str_contains](https://www.php.net/manual/en/function.str-contains.php)
- [PHP Manual: strpos](https://www.php.net/manual/en/function.strpos.php)
- [PHP Manual: substr](https://www.php.net/manual/en/function.substr.php)
- [PHP Manual: str_replace](https://www.php.net/manual/en/function.str-replace.php)
- [PHP Manual: explode](https://www.php.net/manual/en/function.explode.php)
- [PHP Manual: sprintf](https://www.php.net/manual/en/function.sprintf.php)
- [PHP Manual: number_format](https://www.php.net/manual/en/function.number-format.php)
- [PHP Manual: htmlspecialchars](https://www.php.net/manual/en/function.htmlspecialchars.php)
- [Laravel: Strings](https://laravel.com/docs/13.x/strings)
