# Proyek Praktik: Modular Laravel Enterprise Application

Proyek penutup kurikulum: mengubah `cms-artikel` menjadi **monolit modular** dengan batas tegas, komunikasi lewat kontrak dan event, satu package lokal, command operasional, middleware, isolasi tenant sederhana, integrasi eksternal yang tangguh, dan laporan review arsitektur. Proyek ini mengumpulkan Level 07–11 (antrean, cache Redis, notifikasi, optimasi, Docker, CI/CD).

!!! warning "Belum dijalankan penulis"
    Tidak ada kode PHP yang dijalankan penulis. Kerjakan bertahap dengan uji hijau di setiap langkah (Level 08), dan perlakukan "hasil yang diharapkan" sebagai target.

## Tujuan Pembelajaran

- [ ] Menerapkan SOLID dan struktur modular pada aplikasi yang ada.
- [ ] Menjaga batas modul dengan kontrak, event, dan uji arsitektur.
- [ ] Membuat package, command, dan middleware kustom.
- [ ] Menambah isolasi tenant dan integrasi eksternal yang aman.
- [ ] Menulis ADR dan laporan review arsitektur.

## Prasyarat

Semua sub bab 11.01–11.15 dan proyek Level 05–10.

## Masalah yang Diselesaikan

`cms-artikel` tumbuh: banyak fitur, banyak tim, aturan bisnis tersebar. Tim ingin rilis lebih cepat tanpa merusak bagian lain, serta menyiapkan kemungkinan pemisahan layanan di masa depan.

## Spesifikasi

| Modul | Tanggung jawab | Antarmuka publik |
|---|---|---|
| Articles | Artikel, penjadwalan, penerbitan | `ArticleLookup`, event `ArticlePublished` |
| Comments | Komentar dan moderasi | `CommentCounter` |
| Identity | Pengguna, peran, tenant | `CurrentUser`, `TenantContext` |
| Notifications | Email dan notifikasi | Mendengarkan event |
| Search (opsional) | Indeks pencarian | `SearchIndexer` (adapter) |

Aturan: modul hanya mengimpor `Contracts` modul lain; komunikasi sebab-akibat lewat event; uji arsitektur menegakkannya.

## Langkah demi Langkah

### Tahap 1: dasar dan ADR (11.01–11.03)

Tulis ADR struktur, peta ketergantungan, dan aturan batas. Pastikan seluruh uji hijau sebagai baseline.

### Tahap 2: modul (11.05)

Buat `app/Modules/{Articles,Comments,Identity,Notifications}` dengan provider; pindahkan satu modul per iterasi (uji hijau tiap iterasi). Ganti akses lintas-modul dengan kontrak.

### Tahap 3: domain (11.06)

Tambahkan glosarium, Value Object `Slug`, aturan penjadwalan di entity, use case `SchedulePublication`, dan event domain.

### Tahap 4: event (11.11)

Hubungkan Notifications dan Search lewat `ArticlePublished` (listener antre, idempoten, after commit).

### Tahap 5: pola dan kualitas (11.02, 11.04)

Terapkan Decorator cache pada pembaca artikel dan Pipeline pemrosesan isi; jalankan Pint.

### Tahap 6: package (11.07)

Ekstrak `acme/reading-time` sebagai package lokal lewat repositori `path`.

### Tahap 7: command dan middleware (11.08–11.09)

Buat `articles:archive-stale` (dry-run) dan middleware peran; uji keduanya.

### Tahap 8: tenant (11.10)

Tambah `tenant_id`, `TenantContext` (`scoped`), middleware, global scope, dan uji isolasi untuk setiap model dan endpoint.

### Tahap 9: integrasi (11.12–11.14)

Adapter `Translator` bertimeout, retry, dan fallback; webhook ber-HMAC; endpoint BFF beranda dengan agregasi tangguh.

### Tahap 10: operasi

Perbarui Compose dan CI (Level 10) agar menjalankan uji arsitektur; pastikan monitoring dan backup tetap berlaku.

### Tahap 11: review (11.15)

Tulis laporan review arsitektur dan peta jalan 30/60/90 hari.

### Tahap 12: catat di Git

```bash
git add -A
git commit -m "Selesaikan aplikasi modular enterprise"
```

## Eksekusi dan Verifikasi

| Pemeriksaan | Cara | Hasil yang diharapkan |
|---|---|---|
| Perilaku tak berubah | `php artisan test` | Semua lulus |
| Batas modul | Uji arsitektur | Gagal bila impor terlarang ditambah |
| Event | `php artisan event:list`, worker | Listener terdaftar dan berjalan |
| Idempotensi | Jalankan listener dua kali | Efek sekali |
| Tenant | Uji isolasi | Tenant A tidak melihat data B |
| Package | `package:discover`, tinker | Layanan tersedia |
| Command | `--dry-run` | Tidak mengubah data |
| Webhook | Tanda tangan salah | 403 |
| Ketahanan | Matikan sumber BFF (fake) | Halaman tetap 200 |
| Operasi | CI, backup, monitoring | Tetap berfungsi |

## Kesalahan Umum dan Pemecahan Masalah

| Gejala | Penyebab | Cara mengenali | Solusi | Pencegahan |
|---|---|---|---|---|
| Refactor sekaligus gagal | Memindahkan semua sekaligus | Banyak uji merah | Satu modul per iterasi | Iterasi kecil |
| Impor lintas-modul kembali | Tak ada penegakan | Uji batas gagal | Perbaiki, pertahankan uji | Uji di CI |
| Data tenant bocor | Query melewati scope | Uji isolasi gagal | Audit query mentah | Uji tiap endpoint |
| Event ganda | Listener tidak idempoten | Efek dua kali | Kunci unik | Desain |
| Over-engineering | Pola tanpa kebutuhan | Banyak kelas kosong | Sederhanakan | ADR beralasan |

## Latihan Praktik

**P1 (dasar).** Tambahkan modul kecil `Categories` dengan kontrak dan provider, serta uji batas.

**P2 (implementasi).** Tambahkan penanganan webhook anti-replay dan idempotensi tersimpan di tabel.

**P3 (tantangan).** Rancang (tanpa membangun) pemisahan modul Search menjadi layanan terpisah: kontrak, ketahanan, data, deploy, biaya, dan kriteria keputusan. *Catatan:* kerjakan mandiri; tidak ada kunci jawaban.

## Daftar Periksa Penyelesaian

- [ ] Seluruh uji hijau dan uji batas modul aktif di CI.
- [ ] Tidak ada impor internal lintas modul.
- [ ] Event listener idempoten dan dispatch setelah commit.
- [ ] Isolasi tenant teruji pada semua model dan endpoint.
- [ ] Integrasi eksternal punya timeout, fallback, dan webhook terverifikasi.
- [ ] ADR dan laporan review tersedia; tidak ada rahasia di repositori.

## Ringkasan

Kamu menutup kurikulum dengan aplikasi modular yang terstruktur, teruji, dan siap tumbuh: batas jelas, komunikasi longgar, operasi matang, dan arah perbaikan terdokumentasi.

## Referensi Resmi

- [Laravel: Service Providers](https://laravel.com/docs/13.x/providers)
- [Laravel: Packages](https://laravel.com/docs/13.x/packages)
- [Laravel: Events](https://laravel.com/docs/13.x/events)
