# Belajar Laravel

Materi belajar **Laravel 13.x** berbahasa Indonesia untuk pemula, dibangun dengan [MkDocs](https://www.mkdocs.org/) + [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/). Situs: <https://topekox.github.io/materi-laravel/>

Kurikulum terdiri dari **12 bab utama (Level 00–11)** dan **235 sub bab**, dari dasar web dan PHP sampai arsitektur profesional. Setiap bab menjelaskan masalah dulu, lalu solusi, contoh kode dengan path berkas, cara menjalankan dan memverifikasi, kesalahan umum, latihan, uji pemahaman, dan referensi resmi.

## Status materi

Semua bab utama berstatus **VERIFIED** atas persetujuan pemilik kurikulum. Catatan transparansi:

- Penulis materi **tidak menjalankan kode PHP/Laravel**. "Hasil yang diharapkan" diturunkan dari dokumentasi resmi Laravel 13.x. Cocokkan dengan hasilmu sendiri.
- **Level 10** (server, Nginx, PHP-FPM, MySQL, Docker, CI/CD) belum diuji pada VPS atau Docker sungguhan. Hanya sintaks `compose.yaml` dan workflow GitHub Actions yang diperiksa secara lokal. Kerjakan di server uji milikmu.
- Belum berstatus **PUBLISHED**.

## Daftar bab

| Level | Bab utama | Sub bab | Proyek praktik |
|---|---|---|---|
| 00 | Web Development and PHP Fundamentals | 24 | Ya |
| 01 | Introduction to Laravel | 15 | Ya |
| 02 | Routing, Controller, and Request Handling | 20 | Ya |
| 03 | Blade Template and Frontend Integration | 18 | Admin Dashboard |
| 04 | Database and Eloquent ORM | 28 | Sistem Manajemen Artikel |
| 05 | Form Validation, Authentication, and Security | 25 | Dashboard Artikel Berbasis Peran |
| 06 | REST API Development | 22 | Article Management REST API |
| 07 | Advanced Laravel Features | 21 | Background Email and Notification System |
| 08 | Laravel Testing | 14 | Automated Testing for Article Management |
| 09 | Performance and Scalability | 13 | Performance Optimization |
| 10 | Deployment and DevOps | 20 | Deploy ke VPS (Nginx, PHP-FPM, MySQL, Docker) |
| 11 | Professional Laravel Architecture | 15 | Modular Laravel Enterprise Application |

Urutan dan isi bab ditentukan oleh `CURRICULUM.md` dan tidak boleh diubah tanpa persetujuan.

## Dokumen proyek

| Berkas | Isi |
|---|---|
| `CURRICULUM.md` | Sumber kebenaran kurikulum dan status per level |
| `CONTENT_STANDARDS.md` | Aturan penulisan dan contoh kode |
| `PRD.md` | Kebutuhan proyek dan versi Laravel |
| `PROJECT_AUDIT.md` | Struktur repositori yang terverifikasi |
| `CLAUDE.md` | Instruksi kerja untuk asisten penulisan |
| `TECHNICAL_DESIGN.md`, `VALIDATION_REPORT.md` | Desain dan validasi template MkDocs |

## Dependensi tambahan pada materi

Materi sengaja memakai dependensi seminimal mungkin. Yang disetujui dan dibahas: Laravel Sanctum (Level 06), Redis, Laravel Octane, dan Laravel Reverb (Level 07–09). Pest, Telescope, Pulse, Horizon, dan paket tenancy hanya disebut sebagai opsi, tidak diwajibkan.

## Menjalankan situs secara lokal

Windows PowerShell:

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r requirements.txt
mkdocs serve              # http://127.0.0.1:8000, muat ulang otomatis
mkdocs build --strict     # build ke site/; gagal bila ada tautan rusak atau peringatan
```

macOS/Linux: `python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt`.

Template diuji dengan Python 3.14; rentang dependensi dimaksudkan untuk Python 3.12+. Material menampilkan pemberitahuan "MkDocs 2.0" pada tiap build. Itu pengumuman upstream, bukan peringatan proyek, dan tidak menggagalkan `--strict`. `requirements.txt` membatasi `mkdocs<2`.

## Struktur repositori

```
mkdocs.yml                 identitas situs, tema, navigasi, ekstensi
requirements.txt
docs/
  index.md, getting-started/, curriculum/, authoring/, examples/
  level-00/ … level-11/    materi per bab utama (index.md, NN-NN-*.md, proyek-*.md)
  stylesheets/extra.css    penyesuaian tema
  javascripts/             konfigurasi MathJax dan Mermaid
  assets/vendor/mermaid/   Mermaid yang di-vendor (tanpa jaringan)
examples/                  sumber contoh yang tidak dipublikasikan (snippets)
```

## Menulis atau mengubah materi

1. Baca `CURRICULUM.md` dan `CONTENT_STANDARDS.md`. Kerjakan **satu bab per tugas**.
2. Berkas bab: `docs/level-NN/NN-MM-nama-bab.md`, diawali satu `# Judul`. Ikuti urutan bagian standar (Tujuan Pembelajaran, Prasyarat, Pengantar, Penjelasan Konsep, Cara Kerja, Praktik, Eksekusi dan Verifikasi, Kesalahan Umum, Latihan, Uji Pemahaman, Ringkasan, Referensi Resmi).
3. Daftarkan bab di `nav:` pada `mkdocs.yml` dan di `docs/level-NN/index.md`.
4. Jangan mengarang keluaran perintah atau mengklaim kode lulus uji bila tidak dijalankan. Jangan menyarankan commit `.env` atau rahasia.
5. Jalankan `mkdocs build --strict` sebelum commit.

Fitur penulisan (blok kode dengan `title`/`hl_lines`, tab, admonition, tabel, MathJax, diagram Mermaid) didokumentasikan di `docs/authoring/`. Tema Terang/Gelap/Sistem mengikuti palet Material; CSS kustom memakai variabel `var(--md-*)`.

## Deploy ke GitHub Pages

1. Pastikan `site_url` dan `repo_url` di `mkdocs.yml` benar.
2. Jalankan `mkdocs gh-deploy --strict` (membangun dan mendorong ke cabang `gh-pages`), atau gunakan workflow deploy repositori bila ada.
3. Di GitHub: **Settings → Pages → Deploy from a branch → `gh-pages` / root**.

## Dependensi jaringan saat dijalankan

| Dependensi | Kapan | Catatan |
|---|---|---|
| `cdn.jsdelivr.net` (MathJax 3.2.2) | Setiap halaman | Dibutuhkan untuk persamaan |
| `api.github.com` | Setiap halaman bila `repo_url` diisi | Material menampilkan info repositori di header |
| Google Fonts | Tidak pernah | `theme.font: false` memakai font sistem |
| Mermaid | Tidak pernah | Di-vendor |

## Lisensi

[MIT](LICENSE). Pustaka Mermaid yang di-vendor di `docs/assets/vendor/mermaid/` juga berlisensi MIT dan menyertakan `LICENSE` sendiri.
