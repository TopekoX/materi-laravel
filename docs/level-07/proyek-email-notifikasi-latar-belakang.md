# Proyek Praktik: Background Email and Notification System

Proyek ini merakit sistem pemberitahuan artikel baru: saat artikel terbit, pelanggan menerima email dan notifikasi di aplikasi, semuanya diproses di latar belakang lewat antrean, dengan cache, log, dan (opsional) pembaruan real-time.

!!! warning "Belum dijalankan penulis"
    Kode belum dijalankan pada aplikasi Laravel sungguhan (tanpa PHP di lingkungan penulis). Cocokkan hasil yang diharapkan dengan hasilmu.

## Tujuan Pembelajaran

- [ ] Merakit service, event, listener, job, mailable, dan notification menjadi satu alur.
- [ ] Menjalankan queue worker dan scheduler.
- [ ] Memakai cache dengan invalidasi.
- [ ] Mencatat log berkonteks tanpa data sensitif.
- [ ] Menjaga alur tetap aman dan idempoten.

## Prasyarat

Semua sub bab 07.01–07.21 (Redis dan broadcasting bersifat opsional) serta proyek Level 06.

## Masalah yang Diselesaikan

Pelanggan ingin diberi tahu artikel baru tanpa membuat penulis menunggu, dan tanpa email ganda bila job diulang.

## Spesifikasi Fitur

| Fitur | Perilaku |
|---|---|
| Pelanggan | Tabel `subscriptions` (user_id, unik) dan toggle "Berlangganan" |
| Penerbitan | `ArticlePublisher` men-*dispatch* `ArticlePublished` setelah commit |
| Listener | Antre: membuat satu notification per pelanggan |
| Notification | Kanal `mail` dan `database`, antre |
| Cache | Daftar artikel terbaru beranda 10 menit, dihapus saat terbit |
| Jadwal | Pembersihan token Sanctum kedaluwarsa harian; ringkasan mingguan |
| Log | `info` untuk terbit, `error` untuk gagal, dengan `request_id` |

## Langkah demi Langkah

### Langkah 1: model langganan

```bash
php artisan make:model Subscription -m
```

Migrasi: `user_id` (foreign key, `cascadeOnDelete`), `unique('user_id')`. Tambahkan relasi `subscription()` di `User` dan scope pengambil pelanggan.

### Langkah 2: service dan event

Gunakan `ArticlePublisher` dari 07.07 dan pastikan `ArticlePublished::dispatch($article)` dipanggil **setelah** transaksi (atau event `ShouldDispatchAfterCommit`).

### Langkah 3: listener antre

```bash
php artisan make:listener SendArticleNotifications --event=ArticlePublished
```

Listener `implements ShouldQueue`, mengambil pelanggan dengan `chunkById` dan memanggil `Notification::send($chunk, new ArticlePublishedNotification($event->article))`. Jangan memuat semua pelanggan sekaligus.

### Langkah 4: notification

Pakai `ArticlePublishedNotification` dari 07.15 (kanal `mail` dan `database`, `ShouldQueue`). Pastikan pengiriman idempoten: tambahkan pemeriksaan sederhana (mis. tabel/cache kunci `notified:{article}:{user}`) agar percobaan ulang tidak mengirim ganda.

### Langkah 5: cache beranda

Gunakan `HomeData` dari 07.12 dan listener `ClearHomeCache`.

### Langkah 6: jadwal

Di `routes/console.php`: `sanctum:prune-expired --hours=24` harian, dan command ringkasan mingguan buatanmu sendiri (latihan).

### Langkah 7: log

Tambahkan middleware konteks `request_id` (07.18) dan catat peristiwa penting tanpa data pribadi.

### Langkah 8: halaman notifikasi

Route `GET /notifikasi` (auth) menampilkan `auth()->user()->notifications()->paginate(15)` dan aksi "tandai dibaca" (POST, CSRF).

### Langkah 9 (opsional): real-time

Pasang Reverb dan siarkan `ArticlePublishedBroadcast` ke beranda (07.19–07.20).

### Langkah 10: catat di Git

```bash
git add app database routes resources config
git commit -m "Selesaikan sistem email dan notifikasi latar belakang"
```

Pastikan `.env` tidak ter-*commit*.

## Eksekusi dan Verifikasi

Siapkan mailer `log`, `QUEUE_CONNECTION=database`, dua pengguna berlangganan.

| Skenario | Aksi | Hasil yang diharapkan |
|---|---|---|
| Penerbitan cepat | Terbitkan artikel | Respons segera; job masuk tabel `jobs` |
| Pemrosesan | `php artisan queue:work --stop-when-empty` | Dua email di log dan dua baris `notifications` |
| Percobaan ulang | Ulang job yang sama | Tidak ada email ganda |
| Cache | Muat beranda dua kali, lalu terbitkan | Query kedua dari cache; setelah terbit, daftar diperbarui |
| Keamanan | Pengguna B membuka notifikasi A | Tidak terlihat |
| Jadwal | `php artisan schedule:list` | Tugas tercantum |

## Kesalahan Umum dan Pemecahan Masalah

| Gejala | Penyebab | Cara mengenali | Solusi | Pencegahan |
|---|---|---|---|---|
| Tak ada email | Worker tidak berjalan | `jobs` menumpuk | Jalankan worker | Pantau antrean |
| Email ganda | Job tidak idempoten | Duplikasi | Kunci pengiriman | Rancang idempoten |
| Listener tak jalan | Cache event / tak ditemukan | Tak ada di `event:list` | `event:clear` | Periksa daftar |
| Data basi di beranda | Tak ada invalidasi | Artikel baru tak muncul | `forget` di listener | Daftar kunci |
| Memori habis | Memuat semua pelanggan | Galat memori | `chunkById` | Pemrosesan bertahap |
| Rahasia ter-commit | `.env` di Git | Rahasia di repo | Cabut kunci | `.gitignore` |

## Latihan Praktik

**P1 (dasar).** Tambahkan toggle berlangganan dengan Policy sehingga pengguna hanya mengubah langganannya sendiri. *Perilaku yang diharapkan:* pengguna lain mendapat `403`.

**P2 (implementasi).** Buat command `digest:weekly` yang mengirim ringkasan lima artikel populer dan jadwalkan Senin 08:00. *Perilaku yang diharapkan:* muncul di `schedule:list`; email di log.

**P3 (tantangan).** Tambahkan preferensi per pengguna (email/in-app/keduanya) pada `via()` dan rancang pengujian otomatis untuk Level 08. *Catatan:* kerjakan mandiri; tidak ada kunci jawaban.

## Daftar Periksa Penyelesaian

- [ ] Penerbitan tidak menunggu pengiriman.
- [ ] Tidak ada email ganda saat percobaan ulang.
- [ ] Cache terhapus saat artikel terbit.
- [ ] Notifikasi hanya terlihat oleh pemiliknya.
- [ ] Log tidak memuat data sensitif.
- [ ] Kredensial tidak ter-*commit*.

## Ringkasan

Kamu telah merakit alur latar belakang lengkap: event → listener antre → notification multikanal, dengan cache, jadwal, dan log. Berikutnya bab utama *Testing*.

## Referensi Resmi

- [Laravel: Queues](https://laravel.com/docs/13.x/queues)
- [Laravel: Notifications](https://laravel.com/docs/13.x/notifications)
- [Laravel: Events](https://laravel.com/docs/13.x/events)
