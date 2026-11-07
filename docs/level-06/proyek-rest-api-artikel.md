# Proyek Praktik: Article Management REST API

Proyek ini menyatukan seluruh bab utama REST API: endpoint artikel versi `v1` yang dilindungi Sanctum, divalidasi, terpaginasi, dapat disaring, dibatasi lajunya, didokumentasikan, dan dipanggil dari klien frontend.

## Tujuan Pembelajaran

- [ ] Merakit API `v1` lengkap pada proyek `cms-artikel`.
- [ ] Menerapkan autentikasi token, otorisasi Policy, dan pembatasan laju.
- [ ] Menyeragamkan respons sukses dan galat.
- [ ] Mendokumentasikan dan menguji API secara manual.
- [ ] Memanggil API dari klien lintas asal.

## Prasyarat

Semua sub bab 06.01–06.22 dan proyek [Dashboard Artikel Berbasis Peran](../level-05/proyek-dashboard-artikel-berbasis-peran.md). Kode contoh mengikuti sub bab terkait; proyek ini adalah daftar periksa perakitan.

## Masalah yang Diselesaikan

Tim seluler membutuhkan API untuk membaca artikel publik, serta membuat dan mengelola artikel milik pengguna terautentikasi, tanpa dapat mengakses artikel orang lain.

## Spesifikasi Fitur

| Endpoint | Akses | Keterangan |
|---|---|---|
| `POST /api/v1/auth/login` | Publik, `api-login` | Mengeluarkan token dengan abilities sesuai peran |
| `GET /api/v1/auth/me` | Token | Profil pengguna |
| `POST /api/v1/auth/logout` | Token | Mencabut token saat ini |
| `GET /api/v1/articles` | Publik | Terpaginasi, `filter[...]`, `q`, `sort`, `include` |
| `GET /api/v1/articles/{slug}` | Publik | Detail artikel terbit |
| `POST /api/v1/articles` | Token + `articles:write` | Pemilik = pengguna token |
| `PATCH/DELETE /api/v1/articles/{slug}` | Token + Policy | Hanya pemilik atau admin |

Aturan lintas fitur: format galat seragam (`message`, `code`, `errors`, `request_id`), `throttle:api` dan `throttle:api-write`, CORS hanya untuk asal klien.

## Langkah demi Langkah

### Langkah 1: fondasi

```bash
php artisan install:api
git diff bootstrap/app.php
```

Pastikan argumen `api:` tidak terduplikasi di `withRouting`. Jalankan `php artisan migrate` agar tabel `personal_access_tokens` ada, dan tambahkan `HasApiTokens` pada `User`.

### Langkah 2: routing dan controller

Susun grup `v1` dengan `->name('api.v1.')`, `apiResource('articles', ...)->scoped(['article' => 'slug'])`, serta `AuthController` (sub bab 06.06–06.08, 06.16).

### Langkah 3: Resource, validasi, galat

Buat `ArticleResource`, `StoreArticleRequest`/`UpdateArticleRequest`, dan penanganan galat JSON untuk `api/*` (06.09–06.11).

### Langkah 4: paginasi dan penyaringan

Terapkan `paginate()` dengan `per_page` dibatasi, serta allow-list `filter`, `sort`, `include` (06.12–06.13).

### Langkah 5: keamanan

Pasang `auth:sanctum`, abilities, Policy, dan pembatas laju (06.14–06.18). Pemilik artikel selalu diisi dari token, bukan dari input.

### Langkah 6: dokumentasi dan koleksi

Tulis `docs/openapi.yaml`, `docs/api-changelog.md`, dan koleksi Postman (06.19–06.21).

### Langkah 7: klien frontend

Konfigurasikan `config/cors.php`, lalu jalankan klien dari `localhost:5500` (06.22).

### Langkah 8: catat di Git

```bash
git add .
git commit -m "Selesaikan proyek REST API artikel"
```

Pastikan `.env` tidak ikut ter-*commit*.

## Eksekusi dan Verifikasi

| Skenario | Perintah/aksi | Hasil yang diharapkan |
|---|---|---|
| Daftar publik | `curl -H "Accept: application/json" .../articles?per_page=5` | `200` dengan `data`, `links`, `meta` |
| Tanpa token | `POST /articles` tanpa header | `401` JSON seragam |
| Judul kosong | `POST /articles` dengan token, tanpa `title` | `422` dengan `errors.title` |
| Artikel orang lain | `PATCH` dengan token Budi pada artikel Ani | `403` |
| Batas laju | 70 permintaan beruntun | `429` dengan `Retry-After` |
| Klien lintas asal | Buka `http://localhost:5500` | Daftar tampil; login dan buat artikel berhasil |

Hasil di atas diturunkan dari dokumentasi Laravel 13.x. Kode belum dijalankan penulis pada aplikasi sungguhan; jalankan dan cocokkan sendiri.

## Kesalahan Umum dan Pemecahan Masalah

| Gejala | Penyebab | Cara mengenali | Solusi | Pencegahan |
|---|---|---|---|---|
| Route `api` tidak ada | Registrasi `api:` hilang/duplikat | `route:list` kosong | Perbaiki `bootstrap/app.php` | Periksa `git diff` setelah `install:api` |
| `401` pada token valid | Header salah / token dicabut | `Authorization` kosong | Kirim `Bearer <token>` | Uji dengan `curl -i` |
| Respons HTML | `Accept` tidak dikirim | Halaman HTML | Tambah header; tangani galat `api/*` | Header di koleksi |
| Galat CORS | Asal tidak diizinkan | Pesan di konsol | Sesuaikan `allowed_origins` | `config:clear` |
| Pemilik artikel bisa dipalsukan | `user_id` dari input | Artikel atas nama orang lain | Isi dari token | Jangan masukkan ke `$fillable` |

## Latihan Praktik

**P1 (dasar).** Tambahkan endpoint `GET /api/v1/categories` publik dengan Resource dan paginasi. *Perilaku yang diharapkan:* `200` dengan `data` dan `meta`.

**P2 (implementasi).** Tambahkan komentar: `GET` publik terpaginasi dan `POST` terbatas laju per IP. *Perilaku yang diharapkan:* `201` pada komentar valid, `429` saat melebihi batas.

**P3 (tantangan).** Rilis `v2` dengan `headline` menggantikan `title`, tandai `v1` dengan `Deprecation` dan `Sunset`, serta perbarui OpenAPI dan changelog. *Catatan:* kerjakan mandiri; tidak ada kunci jawaban.

## Daftar Periksa Penyelesaian

- [ ] Semua endpoint tabel spesifikasi berfungsi.
- [ ] Galat selalu JSON seragam.
- [ ] Tidak ada IDOR: token Budi tidak dapat mengubah artikel Ani.
- [ ] Pembatas laju aktif.
- [ ] OpenAPI dan koleksi Postman tidak memuat rahasia.
- [ ] `.env` tidak ter-*commit*.

## Ringkasan

Kamu telah merakit API REST lengkap: terdokumentasi, aman, terpaginasi, dan dapat dipakai klien lintas asal. Berikutnya bab utama *Backend Architecture and Advanced Laravel*.

## Referensi Resmi

- [Laravel: Sanctum](https://laravel.com/docs/13.x/sanctum)
- [Laravel: Eloquent API Resources](https://laravel.com/docs/13.x/eloquent-resources)
- [Laravel: Routing](https://laravel.com/docs/13.x/routing)
