# Proyek Praktik: Deploy Laravel to VPS using Nginx, PHP-FPM, MySQL, and Docker

Proyek ini merakit seluruh Level 10: mengamankan VPS, men-deploy `cms-artikel` ke produksi-mirip dengan **dua jalur**, yaitu (A) tumpukan native Nginx + PHP-FPM + MySQL + Supervisor dan (B) tumpukan Docker Compose, lalu menambah HTTPS, CI/CD, backup, dan monitoring.

!!! danger "Belum teruji penulis"
    Penulis tidak menjalankan proyek ini pada VPS atau Docker sungguhan. Yang sudah diperiksa secara lokal hanyalah **sintaks** `compose.yaml` (dengan `docker compose config`) dan dua workflow GitHub Actions (parsing YAML). Selebihnya diturunkan dari dokumentasi resmi. Kerjakan di **server uji/staging**, simpan bukti setiap langkah, dan perlakukan "Hasil yang diharapkan" sebagai target.

## Tujuan Pembelajaran

- [ ] Menyiapkan VPS aman (SSH kunci, firewall, update otomatis).
- [ ] Men-deploy Laravel lewat jalur native dan jalur Docker Compose.
- [ ] Mengonfigurasi HTTPS, worker, jadwal, backup, dan monitoring.
- [ ] Mengotomasi uji dan deploy lewat GitHub Actions dengan kunci terbatas.
- [ ] Melatih rollback, pemulihan backup, dan diagnosis insiden.

## Prasyarat

Semua sub bab 10.01–10.20 dan proyek Level 07–09. Akun penyedia VPS, domain, dan repositori GitHub latihan.

## Masalah yang Diselesaikan

Aplikasi hanya berjalan di laptop. Tim ingin versi produksi yang aman, dapat di-deploy berulang, dapat dipantau, dan bisa dipulihkan.

## Spesifikasi

| Komponen | Jalur A (native) | Jalur B (Docker) |
|---|---|---|
| Web | Nginx di host | Kontainer `web` (Nginx) |
| PHP | PHP-FPM 8.3 di host | Kontainer `app` |
| Database | MySQL di host | Kontainer `db` + volume |
| Antrean | Supervisor | Kontainer `queue` |
| Jadwal | Cron | Kontainer `scheduler` (`schedule:work`) |
| HTTPS | Certbot + Nginx host | Nginx host sebagai reverse proxy ke `127.0.0.1:8080` + Certbot |
| Deploy | `deploy.sh` (rilis + `current`) | `docker compose up -d --build` / pull image |
| Backup | `backup.sh` | `mysqldump` via `docker compose exec` + volume `storage` |

Kerjakan Jalur A terlebih dulu; Jalur B memperlihatkan alternatif. **Jangan menjalankan keduanya di port yang sama pada server yang sama.**

## Langkah demi Langkah

### Tahap 1: persiapan dan keamanan (10.01–10.03)

Buat VPS uji, pengguna `deploy`, kunci SSH, SSH ketat, UFW (22/80/443), pembaruan otomatis. Verifikasi login root dan sandi ditolak.

### Tahap 2: Jalur A, tumpukan native (10.04–10.09)

1. Pasang Nginx, PHP-FPM 8.3 + ekstensi, MySQL; buat database dan akun aplikasi minimal.
2. Siapkan `/var/www/contoh.com/{releases,shared}`, `shared/.env` (izin 640), dan `shared/storage`.
3. Konfigurasikan Nginx (`root` ke `current/public`), FPM, dan izin (`2775` untuk tulis, kode hanya baca).
4. Jalankan `deploy.sh`; verifikasi `/up`.

### Tahap 3: worker, jadwal, HTTPS (10.10–10.12)

Supervisor untuk worker, cron untuk `schedule:run`, Certbot untuk HTTPS (mulai dengan `--dry-run`), HSTS bertahap.

### Tahap 4: Jalur B, Docker Compose (10.13–10.15)

Di server/mesin uji lain (atau setelah menghentikan Jalur A): buat `Dockerfile`, `.dockerignore`, `compose.yaml`, `.env`, dan `.env.app`; `docker compose config -q`, `up -d --build`, `migrate --force`, uji `/up`. Pastikan hanya `web` yang membuka port, ke `127.0.0.1`.

### Tahap 5: CI/CD (10.16–10.17)

Tambahkan `ci.yml` dan `deploy.yml`, environment `production` dengan reviewer, rahasia, kunci SSH terbatas (`restrict,command=`), dan perlindungan cabang.

### Tahap 6: backup (10.18)

Backup harian database dan unggahan, terenkripsi, salinan luar server; lakukan **uji pemulihan** ke database lain.

### Tahap 7: monitoring dan insiden (10.19–10.20)

Uptime monitor eksternal pada `/up`, `healthcheck.sh`, peringatan, runbook. Latih tiga kerusakan buatan dan satu rollback.

### Tahap 8: dokumentasi dan catatan Git

Lengkapi `docs-deploy.md` (arsitektur, perintah, kontak, RPO/RTO, runbook). Pastikan tidak ada rahasia.

```bash
git add Dockerfile .dockerignore compose.yaml .github docker docs-deploy.md
git commit -m "Selesaikan penyiapan deploy produksi"
```

## Eksekusi dan Verifikasi

| Pemeriksaan | Cara | Hasil yang diharapkan |
|---|---|---|
| Akses server | `ssh root@host`, login sandi | Ditolak |
| Port terbuka | `ufw status`, `nmap` dari luar | Hanya 22/80/443; 3306/6379 tertutup |
| Situs | `curl -I https://contoh.com` | 200, HTTPS valid |
| `.env` terlindungi | `curl -I https://contoh.com/.env` | Bukan 200 berisi berkas |
| Health | `curl https://contoh.com/up` | 200 |
| Worker | `supervisorctl status` / `docker compose ps` | RUNNING |
| Jadwal | `schedule:list` + log | Berjalan tiap menit |
| CI | PR gagal uji | Merge diblokir |
| Deploy | Merge ke `main` + persetujuan | Rilis baru aktif; `/up` 200 |
| Rollback | Alihkan ke rilis lama | Pulih dalam menit |
| Backup | Pulihkan ke DB lain | Jumlah baris sama |
| Monitoring | Hentikan worker | Peringatan terkirim |

## Kesalahan Umum dan Pemecahan Masalah

| Gejala | Penyebab | Cara mengenali | Solusi | Pencegahan |
|---|---|---|---|---|
| Terkunci dari server | Salah ubah SSH/UFW | Tak bisa login | Konsol penyedia | Sesi kedua |
| 502 | FPM/soket/`app` mati | `error.log` | 10.20 | Healthcheck |
| 500 setelah deploy | `.env`/izin/cache | `laravel.log` | 10.07, 10.09 | Skrip + staging |
| Sertifikat gagal | DNS/port 80 | Pesan Certbot | Perbaiki, `--dry-run` | Uji dulu |
| Deploy CI gagal SSH | known_hosts/kunci | Log Actions | 10.17 | Uji manual |
| Backup tak bisa dipulihkan | Tak diuji | Gagal saat uji | Perbaiki skrip | Uji berkala |
| Rahasia ter-commit | `.env*`/kunci di Git | `git ls-files` | Putar kunci | `.gitignore`, pemindaian |

## Latihan Praktik

**P1 (dasar).** Tambahkan header keamanan tambahan di Nginx dan buktikan dengan `curl -I`.

**P2 (implementasi).** Tambahkan deploy otomatis ke staging pada setiap merge `main` dan produksi lewat tag dengan persetujuan.

**P3 (tantangan).** Tulis rencana migrasi ke dua server aplikasi di belakang load balancer (sesi, cache, antrean, berkas, jadwal, database) dan perkirakan biaya. *Catatan:* kerjakan mandiri; tidak ada kunci jawaban.

## Daftar Periksa Penyelesaian

- [ ] VPS aman: kunci SSH, tanpa root/sandi, firewall minimal.
- [ ] Aplikasi berjalan lewat HTTPS; `/.env` tidak terjangkau.
- [ ] Worker dan jadwal berjalan dan terbukti.
- [ ] Deploy berulang dan rollback dilatih.
- [ ] CI memblokir PR gagal; deploy butuh persetujuan; kunci SSH terbatas.
- [ ] Backup terenkripsi di luar server dan pemulihan teruji.
- [ ] Monitoring eksternal + peringatan; runbook ada.
- [ ] Tidak ada rahasia di repositori.

## Ringkasan

Kamu telah mengerjakan siklus produksi penuh: server aman, aplikasi ter-deploy (native dan Docker), HTTPS, antrean, jadwal, CI/CD, backup, dan monitoring. Berikutnya bab utama *Arsitektur Laravel Profesional*.

## Referensi Resmi

- [Laravel: Deployment](https://laravel.com/docs/13.x/deployment)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
