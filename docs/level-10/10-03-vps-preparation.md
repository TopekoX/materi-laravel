# VPS Preparation

VPS (*Virtual Private Server*) yang baru dibuat langsung diserbu pemindai otomatis dari internet dalam hitungan menit. Sebelum memasang aplikasi, amankan dasar-dasarnya: akun non-root, kunci SSH, firewall, pembaruan otomatis. Ini adalah langkah paling penting dan paling sering dilewati.

!!! danger "Belum teruji penulis — dan berisiko mengunci dirimu"
    Penulis tidak menjalankan langkah ini pada VPS nyata. Mengubah konfigurasi SSH atau firewall yang salah dapat **mengunci aksesmu ke server**. Lakukan hanya pada server uji, **jangan menutup sesi SSH yang sedang aktif** sampai kamu berhasil login dari sesi kedua, dan pastikan penyedia VPS-mu punya konsol darurat (web console). Contoh memakai Ubuntu LTS; sesuaikan dengan distribusimu.

## Tujuan Pembelajaran

- [ ] Memilih spesifikasi dan sistem operasi VPS yang wajar.
- [ ] Membuat pengguna non-root dengan `sudo`.
- [ ] Membuat dan memakai kunci SSH, lalu menonaktifkan login sandi dan root.
- [ ] Mengonfigurasi firewall (UFW) dengan prinsip deny-by-default.
- [ ] Mengaktifkan pembaruan keamanan otomatis dan zona waktu.
- [ ] Memahami fungsi fail2ban (opsional) dan jebakan penguncian akses.

## Prasyarat

- [Linux Server Fundamentals](10-02-linux-server-fundamentals.md).
- Akun penyedia VPS dan satu server uji (Ubuntu LTS), akses terminal dengan `ssh`.

## Pengantar

Server baru biasanya hanya punya login `root` dengan sandi dari penyedia. Bot mencoba menebak sandi root segera. Kunci SSH dan firewall menutup pintu utama itu.

## Penjelasan Konsep

### Memilih VPS

| Aspek | Pedoman awal untuk aplikasi kecil |
|---|---|
| OS | Ubuntu LTS (dukungan jangka panjang) |
| RAM | ≥ 1–2 GB (PHP-FPM + MySQL + worker) |
| Disk | SSD; sisakan ruang untuk log dan backup |
| Wilayah | Dekat pengguna |
| Backup/snapshot | Fitur penyedia sebagai lapisan tambahan |

Angka dasar ini wajar untuk belajar; produksi nyata ditentukan oleh pengukuran (Level 09).

### Pengguna non-root

Sebagai root (sekali saja):

```bash
adduser deploy
usermod -aG sudo deploy
```

`adduser` meminta sandi; gunakan sandi kuat. Pengguna `deploy` memakai `sudo` untuk tindakan administratif.

### Kunci SSH

Di **komputer lokal**:

```bash
ssh-keygen -t ed25519 -C "deploy@contoh"
ssh-copy-id deploy@IP_SERVER
```

`ssh-keygen` membuat pasangan kunci (privat tetap di komputermu, **jangan dibagikan**; beri *passphrase*). `ssh-copy-id` menaruh kunci publik di server. Uji login **sebelum** menonaktifkan sandi:

```bash
ssh deploy@IP_SERVER
sudo whoami     # harus 'root'
```

### Mengeraskan SSH

Edit `/etc/ssh/sshd_config` (atau berkas di `/etc/ssh/sshd_config.d/`):

```text
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
```

Uji sintaks lalu muat ulang:

```bash
sudo sshd -t
sudo systemctl reload ssh      # di beberapa distro: sshd
```

**Pertahankan sesi lama terbuka**, buka sesi baru dan pastikan masih bisa login dengan kunci. Bila gagal, perbaiki dari sesi lama.

Opsional: ubah port SSH. Itu mengurangi derau log tetapi bukan pengamanan sejati.

### Firewall UFW

Prinsip: tolak semua masuk, izinkan hanya yang perlu.

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH           # atau: sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
sudo ufw status verbose
```

**Izinkan SSH sebelum `enable`**, atau kamu terkunci. Port MySQL (3306) dan Redis (6379) **tidak dibuka** ke publik.

### Pembaruan otomatis dan waktu

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades
sudo timedatectl set-timezone Asia/Jakarta
```

Pembaruan keamanan otomatis menutup kerentanan tanpa menunggumu. Zona waktu konsisten penting untuk log dan jadwal.

### fail2ban (opsional)

`fail2ban` memblokir IP yang berulang kali gagal login. Dengan SSH berkunci dan tanpa sandi, manfaatnya lebih ke mengurangi derau. Pasang bila ingin: `sudo apt install fail2ban`.

### Keamanan lanjutan

- Aktifkan 2FA pada akun penyedia VPS.
- Jangan simpan kunci privat di server.
- Catat siapa punya akses; cabut kunci orang yang keluar.
- Backup sebelum perubahan besar (snapshot).

## Cara Kerja

```mermaid
flowchart LR
    I["Internet"] --> F["UFW: hanya 22/80/443"]
    F --> S["sshd: kunci saja, tanpa root"]
    S --> U["Pengguna deploy (+sudo)"]
```

## Contoh Praktik

Kamu menyiapkan satu VPS uji: pengguna `deploy`, kunci SSH, SSH ketat, UFW, dan pembaruan otomatis, dan memverifikasi bahwa login root/sandi ditolak.

## Penjelasan Kode

Semua perintah dijelaskan di bagian konsep. Perhatikan urutan: buat pengguna → pasang kunci → uji login → barulah mengetatkan SSH → firewall dengan SSH diizinkan lebih dulu.

## Implementasi Langkah demi Langkah

### Langkah 1: buat server uji

Buat VPS Ubuntu LTS di penyedia pilihanmu; catat IP. Aktifkan snapshot/backup penyedia bila ada.

### Langkah 2: masuk sebagai root pertama kali

```bash
ssh root@IP_SERVER
```

### Langkah 3: perbarui dan buat pengguna

```bash
apt update && apt upgrade -y
adduser deploy
usermod -aG sudo deploy
```

### Langkah 4: pasang kunci (dari komputer lokal)

```bash
ssh-copy-id deploy@IP_SERVER
```

### Langkah 5: uji login kunci

Buka terminal baru: `ssh deploy@IP_SERVER` lalu `sudo whoami`.

### Langkah 6: ketatkan SSH

Edit konfigurasi, jalankan `sudo sshd -t`, `sudo systemctl reload ssh`. **Jangan tutup sesi lama.** Uji login dari sesi baru.

### Langkah 7: firewall

Jalankan perintah UFW di atas (SSH diizinkan sebelum `enable`).

### Langkah 8: pembaruan otomatis dan zona waktu

Jalankan perintah di atas.

### Langkah 9: verifikasi dari luar

Dari komputer lokal:

```bash
ssh root@IP_SERVER            # harus ditolak
ssh -o PubkeyAuthentication=no deploy@IP_SERVER   # harus ditolak
```

## Eksekusi dan Verifikasi

| Langkah | Hasil yang diharapkan |
|---|---|
| 5 | Login `deploy` berhasil dengan kunci |
| 6 | Sesi baru tetap bisa login |
| 7 | `ufw status` menunjukkan 22, 80, 443 diizinkan |
| 9 | Login root dan sandi ditolak (`Permission denied`) |

## Daftar periksa verifikasi

- [ ] Pengguna `deploy` memakai kunci SSH dan `sudo`.
- [ ] Login root dan login sandi nonaktif.
- [ ] UFW aktif; hanya 22/80/443 terbuka.
- [ ] Port 3306/6379 tidak terbuka dari luar (`nmap` dari mesin lain, bila tersedia).
- [ ] Pembaruan keamanan otomatis aktif.

## Hasil yang Diharapkan

Pesan persisnya bergantung distribusi. Penulis belum menjalankan langkah-langkah ini.

## Kesalahan Umum dan Pemecahan Masalah

| Gejala | Penyebab | Cara mengenali | Solusi | Pencegahan |
|---|---|---|---|---|
| Terkunci dari server | SSH/UFW salah ubah | Tidak bisa login | Konsol darurat penyedia; perbaiki | Sesi kedua & izinkan SSH dulu |
| `Permission denied (publickey)` | Kunci tak terpasang/izin `.ssh` salah | Gagal login | `chmod 700 ~/.ssh`, `chmod 600 ~/.ssh/authorized_keys` | `ssh-copy-id` |
| `sshd -t` galat | Sintaks salah | Pesan galat | Perbaiki sebelum reload | Selalu uji |
| UFW memblokir web | 80/443 tak diizinkan | Situs tak terbuka | `ufw allow` | Daftar port |
| Kunci privat bocor | Disalin ke server/repo | Kunci di lokasi tak aman | Cabut dari `authorized_keys`, buat baru | Passphrase, jangan bagikan |
| Jam server salah | Zona waktu | Log aneh | `timedatectl` | Atur di awal |

## Latihan Praktik

### Latihan dasar

**D1. Port**
- *Masalah:* menentukan port.
- *Persyaratan:* tentukan port yang dibuka untuk server web + SSH, dan yang tidak boleh dibuka (MySQL, Redis).
- *Perilaku yang diharapkan:* buka 22, 80, 443; tutup 3306, 6379.
- *Tujuan belajar:* permukaan serangan minimum.

### Latihan implementasi

**I1. Pengguna kedua**
- *Masalah:* rekan perlu akses.
- *Persyaratan:* tulis prosedur menambah pengguna dengan kunci SSH-nya dan mencabutnya saat keluar.
- *Perilaku yang diharapkan:* prosedur lengkap.
- *Tujuan belajar:* manajemen akses.

**I2. Audit login**
- *Masalah:* ingin tahu percobaan login gagal.
- *Persyaratan:* baca `journalctl -u ssh` (atau `/var/log/auth.log`) dan ringkas IP penyerang teratas.
- *Perilaku yang diharapkan:* daftar IP.
- *Tujuan belajar:* membaca log keamanan.

### Latihan tantangan

**T1. Rencana pemulihan akses**
- *Masalah:* kunci SSH hilang.
- *Persyaratan:* rancang prosedur pemulihan (konsol penyedia, pemasangan kunci baru) dan pencegahan.
- *Perilaku yang diharapkan:* rencana jelas.
- *Tujuan belajar:* ketahanan akses.
- *Catatan:* kerjakan mandiri; tidak ada kunci jawaban.

## Uji Pemahaman

1. Mengapa tidak memakai root untuk pekerjaan harian?
2. Mengapa menjaga sesi SSH lama terbuka saat mengubah konfigurasi?
3. Mengapa SSH diizinkan sebelum `ufw enable`?
4. Mengapa port MySQL tidak dibuka ke publik?

??? success "Kunci jawaban singkat"
    1. Mengurangi risiko dan memberi jejak audit lewat sudo.
    2. Agar bisa memperbaiki bila konfigurasi baru salah.
    3. Agar tidak terkunci.
    4. Database tak boleh dijangkau langsung dari internet.

## Ringkasan

- Amankan VPS sebelum memasang aplikasi: non-root, kunci SSH, firewall, update otomatis.
- Ubah konfigurasi akses dengan sesi cadangan dan konsol darurat.
- Tutup semua port yang tidak perlu.

Selanjutnya: *Nginx Configuration*.

## Referensi Resmi

- [Ubuntu: OpenSSH Server](https://ubuntu.com/server/docs/openssh-server)
- [Ubuntu: UFW](https://ubuntu.com/server/docs/firewalls)
- [Ubuntu: Automatic Updates](https://ubuntu.com/server/docs/automatic-updates)
