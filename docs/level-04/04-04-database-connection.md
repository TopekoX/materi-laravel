# Koneksi Database

Database sudah ada; sekarang aplikasi harus tahu **di mana** database itu dan **bagaimana** masuk. Di Laravel, semua pengaturan ini berada di `config/database.php` yang
nilainya diambil dari `.env`. Sub bab ini mengajarkan membaca konfigurasi koneksi, mengatur SQLite dan MySQL, serta memeriksa koneksi. Di sini juga kamu membuat proyek
`cms-artikel` yang dipakai sampai akhir bab utama ini.

## Tujuan Pembelajaran

Setelah menyelesaikan sub bab ini, kamu dapat:

- [ ] Menjelaskan hubungan `.env`, `config/database.php`, dan koneksi aktif.
- [ ] Mengatur koneksi SQLite dan MySQL/MariaDB lewat variabel `DB_*`.
- [ ] Memeriksa koneksi dengan `db:show` dan `DB::connection()->getPdo()`.
- [ ] Memakai `DB_URL` sebagai alternatif satu baris.
- [ ] Mendiagnosis galat koneksi umum.
- [ ] Membuat proyek `cms-artikel` dengan database yang siap dipakai.

## Prasyarat

- [Pengantar Database](04-01-introduction-to-databases.md) dan [Instalasi MySQL](04-03-mysql-installation-and-configuration.md) (opsional).
- [Environment Variables](../level-01/01-11-environment-variables.md) dan [Konfigurasi Laravel](../level-01/01-10-laravel-configuration.md).
- Laravel installer dan terminal Bash.

## Pengantar

Salah satu kesalahan paling umum pemula adalah mengubah `.env` lalu heran mengapa tidak ada yang berubah, atau sebaliknya menaruh kata sandi database langsung di kode.
Memahami aliran konfigurasi menghindari keduanya.

## Penjelasan Konsep

### Aliran konfigurasi

```mermaid
flowchart LR
    A[".env: DB_CONNECTION, DB_HOST, ..."] -->|"env()"| B["config/database.php"]
    B -->|"config('database')"| C["DB facade / Eloquent"]
    C --> D["Koneksi ke database"]
```

- `.env` menyimpan nilai yang berbeda per lingkungan (lokal, server) dan **tidak** di-*commit*.
- `config/database.php` mendefinisikan koneksi (`sqlite`, `mysql`, `mariadb`, `pgsql`, `sqlsrv`) dan membaca nilainya dengan `env()`.
- `DB_CONNECTION` menentukan koneksi mana yang menjadi bawaan.

### Konfigurasi SQLite

Dokumentasi menjelaskan bahwa database SQLite adalah satu berkas. Bila memakai installer dan memilih SQLite, Laravel membuat `database/database.sqlite` dan menjalankan migrasi bawaan.
Pengaturan di `.env`:

```ini
DB_CONNECTION=sqlite
```

Pada kerangka terbaru, baris `DB_DATABASE` untuk SQLite boleh tidak ada (berkas bawaan dipakai). Jika ingin menunjuk berkas lain, isi `DB_DATABASE` dengan path **absolut**.
Menurut dokumentasi, kunci asing (*foreign key constraint*) diaktifkan secara bawaan pada SQLite; variabel `DB_FOREIGN_KEYS=false` mematikannya.

### Konfigurasi MySQL / MariaDB

```ini
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=cms_artikel
DB_USERNAME=cms_user
DB_PASSWORD=GANTI_DENGAN_SANDI_KUAT
```

| Variabel | Arti |
|---|---|
| `DB_CONNECTION` | Nama koneksi bawaan (`sqlite`, `mysql`, `mariadb`, ...) |
| `DB_HOST` / `DB_PORT` | Alamat dan port server |
| `DB_DATABASE` | Nama database |
| `DB_USERNAME` / `DB_PASSWORD` | Kredensial pengguna aplikasi |

Gunakan `mariadb` sebagai `DB_CONNECTION` bila servermu MariaDB; `mysql` juga umumnya bekerja. Nilai bawaan `charset` dan `collation` untuk MySQL di `config/database.php`
adalah `utf8mb4` dan `utf8mb4_unicode_ci`.

### `DB_URL`

Penyedia database terkelola sering memberi satu URL berisi semua informasi. Laravel mendukungnya sebagai alternatif:

```ini
DB_URL=mysql://cms_user:SANDI@127.0.0.1:3306/cms_artikel
```

Bila `DB_URL` diisi, ia dipakai untuk mengambil informasi koneksi. Karakter khusus dalam kata sandi harus di-*URL-encode*.

### Memeriksa koneksi

```bash
php artisan db:show
```

Perintah ini terhubung ke database dan menampilkan ringkasan; bila gagal, pesan galat menjelaskan alasannya. Dari Tinker:

```php-inline
DB::connection()->getPdo();
DB::connection()->getDatabaseName();
```

### Cache konfigurasi

Perintah `php artisan config:cache` menyimpan konfigurasi dan **mengabaikan `.env`**. Selama pengembangan jangan menjalankannya; bila terlanjur, ubah kembali dengan
`php artisan config:clear` agar perubahan `.env` terbaca.

### Migrasi pertama dan pembuatan database otomatis

Menjalankan `php artisan migrate` pada koneksi MySQL yang databasenya belum ada akan menawarkan membuatnya (pada kerangka terbaru). Pastikan pengguna database berhak membuat database,
atau buat databasenya terlebih dahulu seperti pada sub bab sebelumnya.

### Keamanan

- `.env` tidak boleh masuk Git. Periksa `.gitignore`; simpan `.env.example` tanpa kata sandi asli.
- Pengguna database aplikasi: hak akses minimum, tidak `root`.
- Jangan menaruh kredensial di `config/database.php` atau kode; selalu lewat `env()`.
- Di produksi, gunakan kata sandi unik dan koneksi terenkripsi bila database berada di jaringan lain.

## Cara Kerja

```mermaid
sequenceDiagram
    participant A as php artisan db:show
    participant C as config/database.php
    participant P as PDO
    participant D as Database
    A->>C: baca koneksi bawaan (DB_CONNECTION)
    C-->>A: host, port, database, kredensial
    A->>P: buka koneksi
    P->>D: handshake
    D-->>P: OK
    A-->>A: tampilkan ringkasan
```

## Contoh Praktik

Kamu membuat proyek `cms-artikel` dengan SQLite, memeriksa koneksinya, lalu (opsional) menyiapkan koneksi MySQL ke database `cms_artikel` dan memeriksanya.

## Penjelasan Kode

Tidak ada kode aplikasi baru; konfigurasi dilakukan di `.env`. Contoh `.env` untuk dua pilihan sudah ada pada bagian konsep.

## Implementasi Langkah demi Langkah

### Langkah 1: buat proyek

```bash
cd ~/belajar-laravel
laravel new cms-artikel --git
```

Jawab pertanyaan installer: tanpa starter kit, Blade, pengujian pilihanmu, tanpa Boost, **SQLite**, dan `npm install` bila Node.js terpasang. Lalu:

```bash
cd cms-artikel
php artisan --version
```

### Langkah 2: periksa koneksi bawaan

```bash
grep -n "^DB_" .env
php artisan db:show
```

### Langkah 3: lihat konfigurasi

```bash
php artisan config:show database.default
php artisan config:show database.connections.sqlite
```

Bandingkan dengan isi `config/database.php`.

### Langkah 4: uji dari Tinker

```bash
php artisan tinker
```

```php-inline
DB::connection()->getDatabaseName();
DB::select('select 1 as satu');
```

### Langkah 5 (opsional): beralih ke MySQL

Pastikan database `cms_artikel` dan pengguna `cms_user` sudah dibuat (sub bab sebelumnya). Ubah `.env`:

```ini
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=cms_artikel
DB_USERNAME=cms_user
DB_PASSWORD=sandi_milikmu
```

Lalu:

```bash
php artisan config:clear
php artisan db:show
php artisan migrate
```

Untuk kembali ke SQLite, ubah `DB_CONNECTION=sqlite` dan hapus baris `DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD` yang kamu tambahkan.

### Langkah 6: uji galat sengaja

Salah ketik satu karakter pada `DB_PASSWORD` (atau `DB_DATABASE`), jalankan `php artisan db:show`, baca pesan galat, lalu perbaiki.

### Langkah 7: catat di Git

```bash
git status
git log --oneline
```

Pastikan `.env` tidak muncul di `git status`.

## Eksekusi dan Verifikasi

| Langkah | Cara memverifikasi |
|---|---|
| 1 | `php artisan --version` menampilkan Laravel Framework 13.x |
| 2 | `DB_CONNECTION=sqlite`; `db:show` menampilkan SQLite dan tabel bawaan |
| 4 | `getDatabaseName()` mengembalikan nama atau path database; `select 1` mengembalikan satu baris |
| 5 | `db:show` menampilkan MySQL/MariaDB dan nama database `cms_artikel`; `migrate` membuat tabel |
| 6 | Galat `Access denied` / `Unknown database` terbaca dan dapat dijelaskan |
| 7 | `.env` tidak ter-*track* |

## Hasil yang Diharapkan

| Perintah | Hasil |
|---|---|
| `db:show` (SQLite) | Jenis SQLite, daftar tabel bawaan (`users`, `cache`, `jobs`, `sessions`, `migrations`, dan sejenisnya) |
| `db:show` (MySQL) | Jenis MySQL/MariaDB, nama `cms_artikel`, daftar tabel setelah `migrate` |
| Kata sandi salah | Galat `SQLSTATE[HY000] [1045] Access denied for user ...` |

Format keluaran bergantung versi. Hasil ini diturunkan dari dokumentasi dan belum dijalankan oleh penulis materi; cocokkan dengan hasilmu.

## Kesalahan Umum dan Pemecahan Masalah

| Gejala | Penyebab | Cara mengenali | Solusi | Pencegahan |
|---|---|---|---|---|
| `SQLSTATE[HY000] [2002] Connection refused` | Server MySQL mati atau host/port salah | Galat 2002 | Jalankan server; periksa `DB_HOST` dan `DB_PORT` | Cek layanan dahulu |
| `SQLSTATE[HY000] [1045] Access denied` | Pengguna atau kata sandi salah | Galat 1045 | Perbaiki `DB_USERNAME`/`DB_PASSWORD` | Uji dengan klien `mysql` |
| `SQLSTATE[HY000] [1049] Unknown database` | Database belum dibuat | Galat 1049 | Buat database | Ikuti urutan langkah |
| `could not find driver` | Ekstensi PDO tidak aktif | Galat driver | Aktifkan `pdo_mysql`/`pdo_sqlite` | `php -m` |
| Perubahan `.env` tak berpengaruh | Konfigurasi ter-*cache* | Nilai lama tetap dipakai | `php artisan config:clear` | Jangan `config:cache` saat pengembangan |
| `Database file at path [...] does not exist` | Berkas SQLite tidak ada | Galat path | Buat berkas atau jalankan `migrate` | Pakai installer dengan SQLite |
| Kata sandi berisi `#` terpotong | `#` dianggap komentar di `.env` | Akses ditolak | Bungkus nilai dengan tanda kutip: `"sandi#1"` | Quote nilai berisi karakter khusus |
| `.env` ikut ter-*commit* | `.gitignore` diubah | `git status` memuat `.env` | Hapus dari index; ganti kata sandi yang terlanjur bocor | Jangan sentuh entri `.gitignore` bawaan |

## Latihan Praktik

### Latihan dasar

**D1. Baca konfigurasi**
- *Masalah:* ingin tahu koneksi yang aktif.
- *Persyaratan:* jalankan `php artisan config:show database.default` dan jelaskan dari mana nilainya berasal.
- *Perilaku yang diharapkan:* kamu menunjuk `DB_CONNECTION` di `.env` dan nilai bawaan di `config/database.php`.
- *Tujuan belajar:* memahami aliran konfigurasi.

**D2. Uji galat**
- *Masalah:* ingin mengenali pesan galat.
- *Persyaratan:* buat tiga kesalahan konfigurasi berbeda (host, kata sandi, nama database) di MySQL, catat pesan masing-masing, lalu perbaiki.
- *Perilaku yang diharapkan:* tiga pesan berbeda dikenali.
- *Tujuan belajar:* mendiagnosis galat koneksi.

### Latihan implementasi

**I1. Dua lingkungan**
- *Masalah:* ingin berpindah SQLite ↔ MySQL dengan cepat.
- *Persyaratan:* buat `.env.sqlite` dan `.env.mysql` (tanpa kata sandi asli di berkas yang di-*commit*), dan tuliskan langkah menukarnya serta `config:clear`.
- *Perilaku yang diharapkan:* pindah koneksi tanpa mengubah kode.
- *Tujuan belajar:* mengelola konfigurasi lingkungan.

**I2. Koneksi dari kode**
- *Masalah:* ingin mengecek koneksi dari route.
- *Persyaratan:* buat route `/db-cek` yang mengembalikan JSON `['database' => ..., 'ok' => true]` memakai `DB::connection()->getDatabaseName()`, dan tangani pengecualian dengan `try/catch` (`ok => false`). Hapus route ini setelah selesai.
- *Perilaku yang diharapkan:* JSON `ok: true` saat koneksi baik, `false` saat gagal.
- *Tujuan belajar:* memeriksa koneksi secara terprogram.

### Latihan tantangan

**T1. Audit keamanan konfigurasi**
- *Masalah:* repo tim berisi `.env.example` dengan kata sandi asli.
- *Persyaratan:* tulis daftar periksa audit (isi `.env.example`, `.gitignore`, riwayat Git, hak akses pengguna database), langkah memperbaiki bila kata sandi sudah bocor, dan alasan tiap langkah.
- *Perilaku yang diharapkan:* daftar periksa mencakup penggantian kata sandi, bukan sekadar menghapus berkas.
- *Tujuan belajar:* mengelola kredensial dengan aman.
- *Catatan:* kerjakan mandiri; tidak ada kunci jawaban.

## Uji Pemahaman

1. Apa hubungan `.env`, `config/database.php`, dan koneksi aktif?
2. Apa fungsi `DB_CONNECTION`?
3. Apa arti galat 1045, 1049, dan 2002?
4. Mengapa `config:cache` berbahaya selama pengembangan?
5. Kapan memakai `DB_URL`?
6. Mengapa `.env` tidak boleh di-*commit*?
7. Bagaimana memeriksa koneksi tanpa menulis kode aplikasi?

??? success "Kunci jawaban singkat"
    1. `.env` menyimpan nilai; `config/database.php` membacanya lewat `env()`; Laravel membuka koneksi sesuai konfigurasi itu.
    2. Menentukan koneksi bawaan yang dipakai.
    3. 1045: akses ditolak; 1049: database tidak ada; 2002: tidak bisa terhubung ke server.
    4. Konfigurasi di-*cache* dan `.env` diabaikan sehingga perubahan tidak terbaca.
    5. Saat penyedia memberi satu URL berisi seluruh informasi koneksi.
    6. Berisi rahasia (kata sandi, kunci) yang tidak boleh terekspos.
    7. `php artisan db:show`.

## Ringkasan

- Koneksi dikonfigurasi lewat `.env` dan `config/database.php`; `DB_CONNECTION` menentukan koneksi bawaan.
- SQLite memerlukan sedikit konfigurasi; MySQL membutuhkan host, port, database, pengguna, dan kata sandi.
- `php artisan db:show` dan Tinker memeriksa koneksi; `config:clear` memperbaiki konfigurasi yang ter-*cache*.
- Pahami galat 1045, 1049, dan 2002.
- Jaga `.env` dari Git dan gunakan pengguna database berhak minimum.

Selanjutnya: *Migration Database*, menulis struktur tabel sebagai kode.

## Referensi Resmi

- [Laravel: Database, Configuration](https://laravel.com/docs/13.x/database#configuration)
- [Laravel: Configuration, Environment](https://laravel.com/docs/13.x/configuration)
- [Laravel: Inspecting Your Databases](https://laravel.com/docs/13.x/database#inspecting-your-databases)
