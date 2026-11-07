# Proyek Praktik: Performance Optimization for Article Management

Proyek ini menerapkan siklus **ukur → ubah satu hal → ukur ulang** pada aplikasi `cms-artikel`. Kamu mengisi data besar, mengukur baseline, menghilangkan N+1, menambah indeks dan cache, memasang header HTTP caching, memisahkan antrean, dan menulis laporan hasil yang jujur.

!!! warning "Belum dijalankan penulis"
    Tidak ada pengukuran yang dilakukan penulis. Tabel hasil di bawah sengaja **kosong** untukmu isi. Jangan menyalin angka dari tempat lain; bandingkan hanya dengan baselinemu sendiri.

## Tujuan Pembelajaran

- [ ] Menetapkan baseline dan anggaran performa yang terukur.
- [ ] Menemukan dan memperbaiki N+1, query berlebih, dan indeks yang hilang.
- [ ] Menerapkan cache Redis dengan invalidasi dan HTTP caching yang aman.
- [ ] Memisahkan antrean dan memantau permintaan lambat.
- [ ] Menyusun laporan sebelum/sesudah dan rencana skalabilitas.

## Prasyarat

Semua sub bab 09.01–09.13 dan proyek Level 07–08 (uji harus tetap hijau sepanjang proyek).

## Masalah yang Diselesaikan

Setelah jumlah artikel mencapai puluhan ribu, beranda dan daftar artikel melambat. Tim butuh perbaikan terukur tanpa merusak perilaku dan keamanan.

## Anggaran Performa (isi dan sesuaikan)

| Halaman | Waktu median lokal | Jumlah query | Catatan |
|---|---|---|---|
| Beranda | ≤ 150 ms | ≤ 6 | Artikel terbaru + terpopuler |
| Daftar artikel (15/halaman) | ≤ 200 ms | ≤ 6 | Termasuk paginasi |
| Detail artikel | ≤ 150 ms | ≤ 8 | Termasuk komentar |
| Dashboard penulis | ≤ 250 ms | ≤ 8 | Dengan hitungan komentar |

Nilai di atas adalah target contoh, bukan klaim. Ubah menurut mesinmu setelah baseline.

## Langkah demi Langkah

### Langkah 1: data dan baseline

Isi data besar (`PerfSeeder`, 09.01), lalu ukur setiap halaman lima kali (median) dan catat jumlah query (09.03, 09.12). Simpan di `docs-performa.md`. Pastikan `php artisan test` hijau.

### Langkah 2: pasang alat ukur

Tambahkan `MeasureRequest` (09.12), `Model::preventLazyLoading` (09.06), dan `DB::whenQueryingForLongerThan`.

### Langkah 3: perbaiki N+1 dan hidrasi

Terapkan `with`, `withCount`, `select` (09.05–09.06). Ukur ulang setelah **setiap** perubahan dan catat.

### Langkah 4: tambah indeks

Tentukan indeks dari `EXPLAIN` query nyata (09.04). Tulis migrasi dengan `down()`. Verifikasi `key` dipakai.

### Langkah 5: cache

Cache daftar terpopuler dan data beranda dengan Redis (09.07), lengkap dengan TTL, invalidasi lewat event, dan perlindungan stampede.

### Langkah 6: HTTP caching

Terapkan `cache.headers` hanya pada halaman publik aman (09.08); tulis uji bahwa dashboard tidak `public`.

### Langkah 7: optimasi deploy

Jalankan urutan `optimize` (09.02) dan catat dampaknya. Pastikan tidak ada `env()` di luar `config/`.

### Langkah 8: antrean

Pisahkan antrean `critical`/`default`/`bulk`, atur prioritas worker (09.09).

### Langkah 9: (opsional) Octane

Hanya bila kamu memutuskan memakainya: audit singleton, ukur, uji kebocoran data antar pengguna (09.11). Catat keputusan dan alasannya.

### Langkah 10: uji regresi performa dan perilaku

Tambahkan uji jumlah query untuk halaman utama (09.06) dan jalankan seluruh suite uji.

### Langkah 11: laporan

Lengkapi tabel hasil dan analisis (apa yang paling berdampak, apa yang tidak, kompromi yang diambil).

### Langkah 12: catat di Git

```bash
git add app database routes config tests docs-performa.md
git commit -m "Selesaikan optimasi performa artikel"
```

## Tabel Hasil (isi sendiri)

| Halaman | Median sebelum | Median sesudah | Query sebelum | Query sesudah | Perubahan paling berdampak |
|---|---|---|---|---|---|
| Beranda | | | | | |
| Daftar | | | | | |
| Detail | | | | | |
| Dashboard | | | | | |

## Eksekusi dan Verifikasi

| Pemeriksaan | Cara | Hasil yang diharapkan |
|---|---|---|
| Perilaku tak berubah | `php artisan test` | Semua lulus |
| Tidak ada N+1 | `preventLazyLoading` di lokal | Tidak ada pengecualian |
| Indeks dipakai | `EXPLAIN` | `key` menyebut indeks baru |
| Cache bekerja | Ukur hit vs miss, `redis-cli` | Hit jauh lebih cepat |
| Header benar | `curl -I` | Publik `public`; dashboard bukan `public` |
| Tidak ada kebocoran | Dua pengguna bergantian pada halaman ter-cache | Data tidak tertukar |

## Kesalahan Umum dan Pemecahan Masalah

| Gejala | Penyebab | Cara mengenali | Solusi | Pencegahan |
|---|---|---|---|---|
| Tidak ada perbaikan | Bottleneck salah | Waktu sama | Profil ulang | Siklus ukur |
| Uji gagal setelah optimasi | `select` menghilangkan kolom | Relasi null / error | Sertakan kolom | Jalankan uji tiap langkah |
| Data basi | Invalidasi hilang | Perubahan tak tampil | Hapus kunci pada event | Catat pemicu |
| Data tertukar antar pengguna | Cache publik pada halaman pribadi | Kebocoran | `private`/kunci per pengguna | Uji dua pengguna |
| Migrasi indeks lambat | Tabel besar | Aplikasi tersendat | Jendela perawatan | Uji di salinan |

## Latihan Praktik

**P1 (dasar).** Tambahkan halaman "kategori" dengan hitungan artikel menggunakan `withCount` dan buktikan jumlah query konstan.

**P2 (implementasi).** Terapkan kunci cache berversi untuk daftar artikel per halaman dan invalidasi saat artikel berubah.

**P3 (tantangan).** Tulis proposal skala horizontal untuk `cms-artikel` (status yang dipindahkan, load balancer, replika baca, biaya, risiko) tanpa mengimplementasikannya. *Catatan:* kerjakan mandiri; tidak ada kunci jawaban.

## Daftar Periksa Penyelesaian

- [ ] Baseline dan target tercatat.
- [ ] Setiap perubahan diukur sebelum/sesudah.
- [ ] Seluruh uji hijau.
- [ ] Tidak ada kebocoran data antar pengguna pada cache/Octane.
- [ ] Header cache sesuai sensitivitas halaman.
- [ ] Laporan jujur: yang berhasil, tidak berhasil, kompromi.

## Ringkasan

Kamu telah menerapkan optimasi berbasis pengukuran lintas lapisan: query, indeks, cache, HTTP, antrean, dan arsitektur. Berikutnya bab utama *Deployment dan DevOps*.

## Referensi Resmi

- [Laravel: Deployment](https://laravel.com/docs/13.x/deployment)
- [Laravel: Cache](https://laravel.com/docs/13.x/cache)
- [Laravel: Eloquent Relationships](https://laravel.com/docs/13.x/eloquent-relationships)
