# Pemasangan PHP dan Lingkungan Pengembangan

Sekarang saatnya menyiapkan "dapur" tempat kode PHP dijalankan. Pada bab ini kamu
memasang PHP dan Composer di **Ubuntu (Linux)**, memastikan keduanya berfungsi, lalu
menjalankan kode dari bab sebelumnya untuk pertama kali.

## Tujuan pembelajaran

Setelah menyelesaikan bab ini, kamu dapat:

- [ ] Memeriksa versi Ubuntu dan menentukan cara pemasangan yang sesuai.
- [ ] Memasang PHP 8.3 atau lebih baru, Composer, dan ekstensi PHP yang dibutuhkan Laravel.
- [ ] Memverifikasi pemasangan dengan `php -v`, `php -m`, dan `composer -V`.
- [ ] Menjalankan berkas PHP lewat terminal.
- [ ] Menjalankan berkas PHP lewat server pengembangan bawaan PHP dan membukanya di browser.

## Prasyarat

- Bab [Pengantar PHP](00-05-introduction-to-php.md): berkas `halo.php` dan `sambutan.php`.
- Komputer dengan **Ubuntu** (disarankan 24.04 LTS atau yang lebih baru), akses internet,
  dan hak `sudo`.
- Dasar penggunaan terminal: berpindah folder (`cd`), melihat isi folder (`ls`).

## Konsep

### Apa yang perlu dipasang?

| Komponen | Fungsi | Dibutuhkan sekarang? |
|---|---|---|
| **PHP (CLI)** | Interpreter untuk menjalankan kode PHP | Ya |
| **Ekstensi PHP** | Fitur tambahan yang dipakai Laravel (mbstring, xml, curl, sqlite, dan lainnya) | Ya |
| **Composer** | Pengelola paket PHP; dipakai memasang Laravel | Ya |
| **Editor kode** | Menulis kode (mis. Visual Studio Code) | Ya, pilih sesuai selera |
| **Git** | Pengelola versi kode | Nanti, di bab Git dan GitHub |
| **Web server (Nginx)** | Melayani situs di produksi | Tidak sekarang; pengembangan memakai server bawaan PHP |

### Versi PHP

Laravel 13.x membutuhkan **PHP 8.3 atau lebih baru**, beserta ekstensi: Ctype, cURL,
DOM, Fileinfo, Filter, Hash, Mbstring, OpenSSL, PCRE, PDO, Session, Tokenizer, dan XML.
Daftar ini berasal dari dokumentasi Laravel (bagian *Server Requirements*).

Versi PHP bawaan repositori Ubuntu bergantung pada rilis Ubuntu. Karena itu cek versi
Ubuntu dulu, lalu pilih cara pemasangan.

### Dua cara pemasangan

| | Cara A: `php.new` | Cara B: `apt` |
|---|---|---|
| Hasil | PHP, Composer, dan Laravel installer sekaligus | PHP dan ekstensi dari repositori Ubuntu; Composer terpisah |
| Versi PHP | Mengikuti skrip (contoh dokumentasi memakai 8.5) | Mengikuti repositori Ubuntu kamu |
| Cocok untuk | Pemula; semua rilis Ubuntu | Yang ingin memakai paket resmi distribusi |
| Catatan | Skrip diunduh dari internet | Bila versinya di bawah 8.3, gunakan Cara A |

Dokumentasi resmi Laravel menyebut `php.new` sebagai jalur pemasangan yang
direkomendasikan di Linux. Pilih **salah satu** cara saja.

## Langkah 1: periksa sistem

```bash
lsb_release -a
```

Catat nilai **Release** (misalnya `24.04`). Lalu cek apakah PHP sudah ada:

```bash
php -v
```

- Jika perintah dikenali dan versinya **8.3 atau lebih tinggi**, lompat ke
  [Langkah 4](#langkah-4-verifikasi-pemasangan).
- Jika `command not found` atau versinya lebih rendah, lanjut ke Langkah 2.

## Langkah 2: pasang PHP dan Composer

### Cara A: `php.new` (disarankan)

Sebaiknya jangan langsung menjalankan skrip dari internet tanpa melihat isinya.
Unduh dulu, baca, baru jalankan:

```bash
curl -fsSL https://php.new/install/linux/8.5 -o php-new-install.sh
less php-new-install.sh
```

Tekan `q` untuk keluar dari `less`. Jika isinya wajar menurutmu, jalankan:

```bash
bash php-new-install.sh
```

Setelah selesai, **tutup lalu buka kembali terminal** supaya perubahan `PATH` terbaca.
Skrip ini memasang PHP, Composer, dan Laravel installer (sesuai dokumentasi
Laravel).

!!! warning "Skrip dari internet"
    Perintah `curl ... | bash` yang umum ditemukan menjalankan kode tanpa sempat kamu
    periksa. Cara unduh-baca-jalankan di atas lebih aman. Hanya pasang dari sumber
    yang kamu percaya.

### Cara B: `apt` (paket Ubuntu)

Perbarui daftar paket dan pasang PHP beserta ekstensi umum:

```bash
sudo apt update
sudo apt install -y php-cli php-mbstring php-xml php-curl php-sqlite3 unzip
```

Lalu pasang Composer. Cara paling sederhana adalah paket Ubuntu:

```bash
sudo apt install -y composer
```

Cek versi PHP yang terpasang. Jika **di bawah 8.3** (umum pada Ubuntu 22.04), gunakan
Cara A atau sumber paket PHP yang menyediakan versi lebih baru.

!!! note "Mengapa bukan Apache/Nginx sekarang?"
    Untuk belajar, server pengembangan bawaan PHP sudah cukup (lihat Langkah 6).
    Nginx dibahas di bab deployment.

## Langkah 3: pilih editor

Pakai editor teks apa pun yang nyaman, misalnya Visual Studio Code atau editor
bawaan Ubuntu. Pastikan berkas disimpan dengan encoding **UTF-8**.

## Langkah 4: verifikasi pemasangan

```bash
php -v
composer -V
```

**Yang seharusnya terlihat:**

- `php -v`: baris pertama menyebut `PHP` diikuti nomor versi **8.3 atau lebih tinggi**.
- `composer -V`: baris berisi `Composer version` diikuti nomor versi.

Periksa ekstensi:

```bash
php -m
```

Perintah ini menampilkan daftar ekstensi terpasang. Cek yang terpenting:

```bash
php -m | grep -i -E "mbstring|xml|curl|sqlite|openssl|tokenizer|fileinfo|pdo"
```

**Yang seharusnya terlihat:** setiap ekstensi berikut muncul sebagai satu baris:
`mbstring`, `curl`, `openssl`, `tokenizer`, `fileinfo`, `PDO`, `pdo_sqlite`, `sqlite3`,
`xml`, dan sejenisnya (huruf besar-kecil dan susunan baris bisa berbeda). Ekstensi yang
tidak muncul harus dipasang.

## Langkah 5: jalankan PHP lewat terminal

Masuk ke folder `belajar-php` dari bab sebelumnya (buat jika belum ada) dan pastikan
`halo.php` berisi:

```php title="belajar-php/halo.php"
<?php

echo "Halo, dunia!\n";
echo "Saya belajar PHP.\n";
```

Jalankan:

```bash
cd belajar-php
php halo.php
```

**Yang seharusnya terlihat:**

```text
Halo, dunia!
Saya belajar PHP.
```

Hasil ini sesuai prediksi di bab sebelumnya. Coba juga versi tanpa `\n`; keduanya
teks akan tercetak bersambung dalam satu baris.

## Langkah 6: jalankan lewat server pengembangan

PHP menyertakan server web mini untuk pengembangan. Dari folder `belajar-php`:

```bash
php -S localhost:8000
```

Terminal akan tampak "menggantung": itu normal, artinya server sedang berjalan. Biarkan
terbuka. Buka browser:

- `http://localhost:8000/halo.php`
- `http://localhost:8000/sambutan.php` (jika berkas dari bab sebelumnya ada di folder ini)

**Yang seharusnya terlihat:**

- `halo.php`: dua kalimat teks. Di browser baris baru tampil sebagai spasi, bukan
  pemisah baris.
- `sambutan.php`: judul "Selamat datang" dan kalimat "Hari ini belajar PHP." tanpa
  tanda `<?php` yang terlihat. Klik kanan dan pilih **View Page Source** untuk
  memastikan: yang sampai ke browser hanya HTML.

Pada terminal server akan muncul catatan setiap request yang masuk. Ini
konkretnya apa yang kamu pelajari di bab client-server: browser (client) meminta,
PHP (server) menjawab.

Tekan ++ctrl+c++ pada terminal server untuk menghentikannya.

!!! warning "Hanya untuk pengembangan"
    Server bawaan PHP tidak dirancang untuk produksi. Jangan dipakai untuk
    melayani situs yang diakses publik.

## Kesalahan umum dan debugging

| Gejala | Kemungkinan penyebab | Solusi |
|---|---|---|
| `php: command not found` | PHP belum terpasang, atau terminal belum dibuka ulang setelah `php.new` | Pasang PHP; tutup dan buka lagi terminal. |
| `php -v` menunjukkan versi di bawah 8.3 | Repositori Ubuntu menyediakan PHP lebih lama | Gunakan Cara A (`php.new`). |
| `Failed to listen on localhost:8000 (reason: Address already in use)` | Port 8000 dipakai program lain | Pakai port lain: `php -S localhost:8080`. |
| Browser menampilkan kode PHP, bukan hasilnya | Berkas dibuka lewat `file:///` | Buka lewat `http://localhost:8000/...`. |
| `404 Not Found` di browser | Server dijalankan dari folder yang salah, atau nama berkas keliru | Jalankan `php -S` dari folder yang berisi berkas. |
| `could not find driver` nanti saat memakai database | Ekstensi `pdo_sqlite`/`sqlite3` belum terpasang | `sudo apt install php-sqlite3`. |
| `Permission denied` saat `apt` | Lupa `sudo` | Awali perintah dengan `sudo`. |
| `composer: command not found` | Composer belum terpasang atau `PATH` belum diperbarui | Pasang Composer; buka ulang terminal. |

## Latihan terpandu

1. Catat hasil `lsb_release -a`, `php -v`, dan `composer -V` milikmu.
2. Buat `profil.php` yang mencetak nama dan kotamu, masing-masing satu baris, lalu
   jalankan dengan `php profil.php`. Bandingkan dengan prediksimu di bab sebelumnya.
3. Jalankan server dengan `php -S localhost:8080` dan buka `profil.php` di browser.
   Mengapa tampilannya berbeda dari di terminal?
4. Ubah `sambutan.php` agar mencetak namamu, muat ulang browser tanpa menghentikan server,
   dan pastikan perubahan langsung terlihat.
5. Tuliskan tiga ekstensi PHP yang kamu pastikan terpasang dan alasan Laravel
   membutuhkannya (cari di dokumentasi bila perlu).

??? success "Jawaban nomor 3"
    Terminal mencetak teks apa adanya, termasuk baris baru. Browser menafsirkan
    isi sebagai HTML, sehingga baris baru biasa dianggap spasi. Pemisah baris di
    halaman web memakai tag HTML seperti `<br>` atau `<p>`.

## Pertanyaan review

1. Komponen apa saja yang perlu dipasang untuk mulai belajar Laravel?
2. Versi PHP minimum untuk Laravel 13.x berapa?
3. Apa beda Cara A dan Cara B pemasangan?
4. Mengapa skrip dari internet sebaiknya dibaca dulu sebelum dijalankan?
5. Perintah apa yang menampilkan ekstensi PHP terpasang?
6. Apa beda `php halo.php` dan membuka `http://localhost:8000/halo.php`?
7. Mengapa server `php -S` tidak boleh dipakai di produksi?

## Ringkasan

- Kebutuhan awal: PHP 8.3 atau lebih baru, ekstensi yang dibutuhkan, Composer, dan editor.
- Di Ubuntu: `php.new` (semua rilis) atau `apt` (cek versi PHP-nya).
- Verifikasi dengan `php -v`, `php -m`, dan `composer -V`.
- PHP dapat dijalankan lewat terminal (`php berkas.php`) atau server bawaan
  (`php -S localhost:8000`).
- Server bawaan PHP hanya untuk pengembangan.

Selanjutnya: **PHP Syntax**.

## Referensi resmi

- [Laravel: Installation](https://laravel.com/docs/13.x/installation)
- [Laravel: Server Requirements](https://laravel.com/docs/13.x/deployment#server-requirements)
- [php.new](https://php.new)
- [Composer: Introduction](https://getcomposer.org/doc/00-intro.md)
- [PHP Manual: Built-in web server](https://www.php.net/manual/en/features.commandline.webserver.php)
- [PHP Manual: Installation on Unix systems](https://www.php.net/manual/en/install.unix.debian.php)
- [Ubuntu Server Documentation](https://documentation.ubuntu.com/server/)
