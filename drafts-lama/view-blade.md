# View dan Blade

Sampai bab ini, aplikasi hanya mengembalikan teks dan JSON. Sekarang kamu
menampilkan halaman HTML memakai **view** dan template engine **Blade**.

!!! info "Versi yang dipakai"
    Laravel **13.x**. Rujukan: [Views](https://laravel.com/docs/13.x/views) dan
    [Blade Templates](https://laravel.com/docs/13.x/blade).

## Tujuan pembelajaran

- [ ] Menjelaskan fungsi view dan letak file view.
- [ ] Mengembalikan view dari controller dengan data.
- [ ] Menampilkan data memakai `{{ }}` dan memahami *escaping*.
- [ ] Memakai `@if`, `@forelse`, dan `@empty`.
- [ ] Membuat layout bersama dengan komponen Blade (`<x-layout>`).

## Prasyarat

- Bab [Controller](controller.md) selesai: `MateriController` dengan `index` dan `show`.
- Pengetahuan dasar HTML.

## Konsep

**Masalah.** Menyusun HTML sebagai string di PHP cepat berantakan dan rawan salah.

**Solusi.** Pisahkan tampilan ke file **view** di `resources/views`. File berakhiran
`.blade.php` otomatis diproses Blade, yang mengizinkan sintaks ringkas seperti
`{{ $variabel }}` dan `@foreach`.

!!! tip "Analogi"
    View adalah cetakan surat berisi kolom kosong. Controller mengisi kolom
    dengan data, Blade mencetak hasil akhirnya.

## Langkah 1: layout bersama

Semua halaman memakai kerangka yang sama. Buat komponen layout:

```blade title="resources/views/components/layout.blade.php"
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ $title ?? 'Pustaka Materi' }}</title>
</head>
<body>
    <header>
        <h1><a href="{{ url('/') }}">Pustaka Materi</a></h1>
        <nav>
            <a href="{{ route('materi.index') }}">Materi</a> |
            <a href="{{ route('tentang') }}">Tentang</a>
        </nav>
    </header>

    <main>
        {{ $slot }}
    </main>
</body>
</html>
```

- File di `resources/views/components/` dipanggil sebagai `<x-nama-file>`; jadi
  `layout.blade.php` menjadi `<x-layout>`.
- `{{ $slot }}` adalah tempat isi halaman disisipkan.
- `{{ $title ?? 'Pustaka Materi' }}` memakai judul dari slot `title`; bila tidak ada,
  dipakai teks bawaan.
- `route('materi.index')` memakai nama route dari bab 1 dan 2.

## Langkah 2: view daftar materi

```blade title="resources/views/materi/index.blade.php"
<x-layout>
    <x-slot:title>Daftar Materi</x-slot>

    <h2>Daftar Materi</h2>

    <ul>
        @forelse ($daftarMateri as $materi)
            <li>
                <a href="{{ route('materi.show', ['slug' => $materi['slug']]) }}">
                    {{ $materi['judul'] }}
                </a>
                &mdash; {{ $materi['ringkasan'] }}
            </li>
        @empty
            <li>Belum ada materi.</li>
        @endforelse
    </ul>
</x-layout>
```

| Kode | Arti |
|---|---|
| `<x-layout>` ... `</x-layout>` | Membungkus isi dengan komponen layout. |
| `<x-slot:title>` | Mengisi variabel `$title` pada layout. |
| `@forelse ... @empty ... @endforelse` | Perulangan yang menjalankan blok `@empty` jika data kosong. |
| `{{ $materi['judul'] }}` | Mencetak nilai **dengan escaping HTML**. |

## Langkah 3: view detail materi

```blade title="resources/views/materi/show.blade.php"
<x-layout>
    <x-slot:title>{{ $materi['judul'] }}</x-slot>

    <h2>{{ $materi['judul'] }}</h2>
    <p>{{ $materi['ringkasan'] }}</p>

    <p><a href="{{ route('materi.index') }}">&larr; Kembali ke daftar</a></p>
</x-layout>
```

## Langkah 4: controller mengembalikan view

Ubah `index` dan `show` pada controller (method `daftar()` tidak berubah):

```php title="app/Http/Controllers/MateriController.php"
use Illuminate\View\View;

public function index(): View
{
    return view('materi.index', ['daftarMateri' => $this->daftar()]);
}

public function show(string $slug): View
{
    $materi = collect($this->daftar())->firstWhere('slug', $slug);

    abort_if($materi === null, 404);

    return view('materi.show', ['materi' => $materi]);
}
```

- `view('materi.index', [...])` memuat `resources/views/materi/index.blade.php`.
  Titik pada nama view mewakili subfolder.
- Array kedua adalah data; kuncinya menjadi nama variabel di view
  (`'daftarMateri'` → `$daftarMateri`).
- Jangan lupa `use Illuminate\View\View;` di bagian atas file.

!!! note "Mengapa tidak memakai `@vite`?"
    Contoh ini tidak memakai CSS/JS yang dikompilasi, jadi `npm` tidak dibutuhkan.
    Tampilan sengaja polos agar fokus pada Blade.

## Escaping dan keamanan

`{{ $teks }}` otomatis mengubah karakter HTML (mis. `<` menjadi `&lt;`) sehingga
sisipan skrip berbahaya tidak dijalankan browser. Sintaks `{!! $teks !!}`
mencetak apa adanya.

!!! danger "Hindari `{!! !!}` untuk data dari pengguna"
    Memakai `{!! !!}` pada input pengguna membuka celah XSS. Gunakan hanya untuk
    HTML yang kamu percaya sepenuhnya.

## Menjalankan dan memverifikasi

1. Buka `/materi`: tiga tautan materi, dengan judul tab "Daftar Materi".
2. Klik salah satu: halaman detail, dengan tautan kembali.
3. Buka `/materi/tidak-ada`: 404.
4. Uji `@empty`: sementara kosongkan array pada `daftar()` (`return [];`),
   muat ulang `/materi`, lalu kembalikan isinya.

## Kesalahan umum dan debugging

| Gejala | Penyebab | Solusi |
|---|---|---|
| `View [materi.index] not found` | Nama atau lokasi file salah | Pastikan `resources/views/materi/index.blade.php`. |
| `Undefined variable $daftarMateri` | Kunci array di controller berbeda dengan variabel di view | Samakan ejaan. |
| `Unable to locate a class or view for component [layout]` | File komponen tidak di `resources/views/components/` | Pindahkan ke folder yang benar. |
| Layout tidak tampil, isi mentah | Lupa membungkus dengan `<x-layout>` | Periksa tag pembuka dan penutup. |
| Tag `<x-...>` tertulis apa adanya | Ekstensi file bukan `.blade.php` | Ganti ekstensi. |
| `Route [tentang] not defined` | Route `/tentang` belum bernama | Pastikan ada `->name('tentang')`. |

## Latihan terpandu

1. Tambahkan nomor urut pada daftar memakai `$loop->iteration`.
2. Tampilkan jumlah materi di atas daftar: `Total: {{ count($daftarMateri) }} materi`.
3. Tambahkan tautan "Beranda" pada navigasi layout yang mengarah ke `url('/')`.
4. Verifikasi bahwa mengubah layout satu kali memengaruhi `/materi` dan `/materi/controller`.

## Pertanyaan review

1. Di folder mana view disimpan, dan apa arti ekstensi `.blade.php`?
2. Apa beda `{{ }}` dan `{!! !!}`?
3. Bagaimana data dikirim dari controller ke view?
4. Untuk apa `$slot` dan `<x-slot:title>`?
5. Apa kegunaan `@forelse` dibanding `@foreach`?

## Ringkasan

- View ada di `resources/views`; `view('folder.nama', $data)` memuatnya.
- Blade: `{{ }}` (aman), `@if`, `@forelse`, dan komponen `<x-...>`.
- Komponen layout menghindari pengulangan kerangka HTML.
- Hindari `{!! !!}` pada data pengguna.

Bab berikutnya: **Request dan Response**.

## Referensi resmi

- [Views](https://laravel.com/docs/13.x/views)
- [Blade Templates](https://laravel.com/docs/13.x/blade)
- [Layouts Using Components](https://laravel.com/docs/13.x/blade#layouts-using-components)
- [Displaying Data](https://laravel.com/docs/13.x/blade#displaying-data)
