# Peta Belajar: Blade Template dan Integrasi Frontend

Bab utama ini menjawab pertanyaan: *bagaimana Laravel menyusun halaman HTML dari data?* Kamu akan belajar membuat tampilan dinamis dengan Blade, menyusun layout
dan komponen yang dapat dipakai ulang, membuat form yang aman, dan menghubungkan aset CSS dan JavaScript.

## Tujuan Pembelajaran

Setelah menyelesaikan bab utama ini, kamu dapat:

- [ ] Membuat layout Blade yang dapat dipakai ulang.
- [ ] Membuat halaman dinamis dengan direktif kondisional dan perulangan.
- [ ] Mengimplementasikan form, termasuk CSRF dan pesan error.
- [ ] Mengintegrasikan aset frontend dengan Vite.

## Prasyarat

- Bab utama [Routing, Controller, dan Request Handling](../level-02/index.md): route, controller, dan response.
- Dasar HTML dan CSS.

## Peta Sub Bab

| Sub bab | Yang kamu pelajari | Status |
|---|---|---|
| [Pengantar Blade](03-01-introduction-to-blade.md) | Peran Blade, view, `{{ }}`, kompilasi dan cache | Draf |
| [Sintaks Blade](03-02-blade-syntax.md) | Ekspresi, komentar, direktif dasar | Draf |
| [Menampilkan Data](03-03-displaying-data.md) | Escaping, data mentah, JavaScript | Draf |
| [Direktif Kondisional](03-04-conditional-directives.md) | `@if`, `@switch`, dan lainnya | Draf |
| [Direktif Perulangan](03-05-loop-directives.md) | `@foreach`, `@forelse`, variabel `$loop` | Draf |
| [Layout Blade](03-06-blade-layouts.md) | Kerangka halaman bersama | Draf |
| [Pewarisan Template](03-07-template-inheritance.md) | `@extends`, `@section`, `@yield` | Draf |
| [Komponen Blade](03-08-blade-components.md) | Komponen berbasis class | Draf |
| [Komponen Anonim](03-09-anonymous-components.md) | Komponen satu berkas | Draf |
| [Mengirim Data ke Komponen](03-10-passing-data-to-components.md) | Props, atribut, slot | Draf |
| [Blade Include](03-11-blade-include.md) | Memecah tampilan | Draf |
| [Form Blade](03-12-blade-forms.md) | Membuat form | Draf |
| [Method Spoofing](03-13-form-method-spoofing.md) | `PUT`, `PATCH`, `DELETE` dari form | Draf |
| [Proteksi CSRF](03-14-csrf-protection.md) | Token pada form | Draf |
| [Pesan Error Form](03-15-form-error-messages.md) | Menampilkan kesalahan | Draf |
| [Manajemen Aset](03-16-asset-management.md) | Folder `public` dan `resources` | Draf |
| [Integrasi Vite](03-17-vite-integration.md) | Membangun aset | Draf |
| [Integrasi CSS dan JavaScript](03-18-css-javascript-integration.md) | Memuat aset di layout | Draf |

### Proyek Praktik

| Proyek | Hasil akhir | Status |
|---|---|---|
| [Admin Dashboard dengan Blade](proyek-admin-dashboard.md) | Dashboard admin dengan layout, komponen, form, dan aset Vite | Draf |

## Kriteria Penyelesaian

- [ ] Mampu membuat layout Blade yang dapat dipakai ulang.
- [ ] Mampu membuat halaman dinamis.
- [ ] Mampu membuat form.
- [ ] Mampu mengintegrasikan aset frontend.

## Cara Belajar yang Disarankan

1. Buka dokumentasi Laravel versi **13.x** saat mencari referensi.
2. Gunakan satu proyek, `belajar-blade`, yang dibuat pada sub bab pertama, dan commit di Git setiap selesai satu sub bab.
3. Buka sumber halaman di browser (Ctrl+U) untuk melihat HTML yang dihasilkan Blade.

!!! info "Status materi"
    Semua delapan belas sub bab pada bab utama ini sudah tersedia (berstatus **DRAFT**). Proyek praktik penutup juga sudah tersedia.

## Referensi Resmi

- [Laravel: Blade Templates](https://laravel.com/docs/13.x/blade)
- [Laravel: Views](https://laravel.com/docs/13.x/views)
- [Laravel: Asset Bundling (Vite)](https://laravel.com/docs/13.x/vite)
