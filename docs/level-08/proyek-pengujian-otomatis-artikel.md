# Proyek Praktik: Automated Testing for Article Management

Proyek ini membangun jaring pengaman pengujian otomatis untuk aplikasi `cms-artikel`: uji unit, uji fitur, uji autentikasi dan otorisasi, uji API, dan uji dengan fake. Kamu juga mengukur cakupan dan membiasakan alur reproduksi-bug-sebagai-uji.

!!! warning "Belum dijalankan penulis"
    Kode uji belum dijalankan pada aplikasi Laravel sungguhan. Nama route, kolom, dan teks mengikuti proyek di bab sebelumnya; sesuaikan dengan milikmu dan perlakukan hasil yang diharapkan sebagai target, bukan bukti.

## Tujuan Pembelajaran

- [ ] Menyusun suite uji yang terorganisasi (`Unit`, `Feature`, `Feature/Api`).
- [ ] Menguji alur autentikasi, otorisasi (matriks peran), dan validasi.
- [ ] Menguji API dengan token dan format galat.
- [ ] Memakai fake untuk antrean, email, notifikasi, dan penyimpanan.
- [ ] Mengukur cakupan dan menentukan prioritas uji.

## Prasyarat

Semua sub bab 08.01–08.14 dan proyek Level 05–07.

## Masalah yang Diselesaikan

Setiap perubahan pada aplikasi berisiko merusak fitur yang ada. Tim ingin menjalankan satu perintah dan tahu dalam hitungan detik apakah sesuatu rusak.

## Spesifikasi

| Area | Minimal uji |
|---|---|
| Unit | `ArticleExcerpt` (4 kasus + galat), pembuatan slug |
| Artikel publik | Daftar hanya artikel terbit; detail draf = 404; paginasi |
| Komentar | Sukses, validasi gagal, batas laju |
| Autentikasi | Login sukses/gagal, tamu dialihkan, belum verifikasi, registrasi tidak menerima `role` |
| Otorisasi | Matriks peran × aksi untuk artikel, kategori, pengguna; IDOR |
| Database | Soft delete, pemulihan, integritas, sandi ter-hash |
| API | Daftar terpaginasi, `store` 401/422/201, kepemilikan dari token, abilities, 404 JSON |
| Fake | Penerbitan → job/notifikasi dikirim, tidak ada email nyata |
| Cakupan | Ukur dan catat; target awal realistis |

## Langkah demi Langkah

### Langkah 1: siapkan lingkungan uji

Pastikan `phpunit.xml` memakai database terpisah (SQLite `:memory:`), `MAIL_MAILER=array`, `QUEUE_CONNECTION=sync`, dan `CACHE_STORE=array`. Jalankan `php artisan test` dan catat hasil dasar.

### Langkah 2: perkuat factory

Tambahkan state `admin()`, `editor()`, `unverified()` (bila belum), `draft()`, `published()` (08.12).

### Langkah 3: uji unit

Tulis `ArticleExcerptTest` dan uji pembuatan slug (08.04).

### Langkah 4: uji fitur publik

`ArticleListTest`, `CommentTest` (08.05).

### Langkah 5: uji autentikasi

`AuthenticationTest` (08.08) termasuk uji registrasi dan batas laju.

### Langkah 6: uji otorisasi

`ArticlePolicyTest` dan `ArticleAuthorizationTest` plus matriks peran (08.09).

### Langkah 7: uji database

`ArticleDeleteTest`, uji pemulihan, uji sandi hash (08.07).

### Langkah 8: uji API

`Api/ArticleApiTest` dan `Api/AuthApiTest` (08.10).

### Langkah 9: uji dengan fake

`PublishNotificationTest` untuk alur penerbitan nyata (08.11).

### Langkah 10: cakupan

Jalankan `php artisan test --coverage` (butuh Xdebug/PCOV) dan catat kelas berisiko dengan cakupan rendah. Tambah uji untuk satu kelas berisiko.

### Langkah 11: mutasi manual

Untuk tiga kontrol keamanan (middleware `auth`, `authorize`, validasi), hapus sementara satu per satu dan pastikan ada uji yang gagal. Kembalikan.

### Langkah 12: catat di Git

```bash
git add tests database phpunit.xml .gitignore
git commit -m "Selesaikan suite pengujian otomatis artikel"
```

## Eksekusi dan Verifikasi

| Pemeriksaan | Perintah | Hasil yang diharapkan |
|---|---|---|
| Seluruh uji | `php artisan test` | Semua lulus |
| Hanya API | `php artisan test --filter=Api` | Lulus |
| Stabilitas | Jalankan 3 kali | Hasil identik |
| Mutasi keamanan | Hapus `authorize` sementara | Uji IDOR gagal |
| Cakupan | `php artisan test --coverage` | Laporan tampil (butuh driver) |

## Kesalahan Umum dan Pemecahan Masalah

| Gejala | Penyebab | Cara mengenali | Solusi | Pencegahan |
|---|---|---|---|---|
| Uji menyentuh DB kerja | `phpunit.xml` salah | Data berubah | SQLite memori | Periksa konfigurasi |
| Uji kadang gagal | Data acak / waktu | Tidak stabil | Nilai eksplisit; `freezeTime` | Deterministik |
| Uji lambat | Seeder penuh / relasi berlebih | Durasi tinggi | Factory minimal | Audit data |
| Email nyata terkirim | Tidak ada fake | Penerima asli | Fake / mailer `array` | `phpunit.xml` |
| Cakupan tak bisa diukur | Driver tidak ada | Pesan galat | Pasang Xdebug/PCOV | `php -m` |

## Latihan Praktik

**P1 (dasar).** Tambahkan uji untuk halaman 404 kustom dan pencarian judul. *Perilaku yang diharapkan:* lulus.

**P2 (implementasi).** Tulis uji kontrak untuk tiga endpoint API utama dengan `assertJsonStructure` dan dokumentasikan bahwa perubahan kunci berarti versi baru. *Perilaku yang diharapkan:* gagal saat kunci diubah.

**P3 (tantangan).** Rancang pipeline CI (GitHub Actions) yang menjalankan `composer install`, `php artisan test`, dan batas cakupan; jelaskan rahasia yang tidak boleh masuk. *Catatan:* hanya rancangan; implementasi di Level 10. Kerjakan mandiri; tidak ada kunci jawaban.

## Daftar Periksa Penyelesaian

- [ ] `php artisan test` hijau dan stabil.
- [ ] Matriks otorisasi tercakup, termasuk IDOR.
- [ ] Alur auth dan registrasi aman teruji.
- [ ] API teruji (401/403/404/422/201).
- [ ] Tidak ada layanan eksternal nyata dipanggil oleh uji.
- [ ] Cakupan diukur dan prioritas dicatat.
- [ ] Tidak ada rahasia di berkas uji.

## Ringkasan

Kamu memiliki jaring pengaman otomatis yang menjaga perilaku inti dan keamanan aplikasi dari regresi. Berikutnya bab utama *Performa dan Skalabilitas*.

## Referensi Resmi

- [Laravel: Testing](https://laravel.com/docs/13.x/testing)
- [Laravel: HTTP Tests](https://laravel.com/docs/13.x/http-tests)
- [Laravel: Database Testing](https://laravel.com/docs/13.x/database-testing)
