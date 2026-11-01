# Eloquent ORM

**Eloquent** memetakan tabel database menjadi class PHP. Satu baris tabel
menjadi satu objek, sehingga kamu menulis `Materi::find(1)` alih-alih SQL mentah.
Pada bab ini Pustaka Materi beralih dari array ke database dan mendapatkan
fitur tambah, ubah, serta hapus (CRUD).

!!! info "Versi yang dipakai"
    Laravel **13.x**. Rujukan: [Eloquent ORM](https://laravel.com/docs/13.x/eloquent).
    Pada 13.x, konfigurasi model seperti nama tabel dan kolom *fillable* ditulis
    dengan **atribut PHP** (`#[Table]`, `#[Fillable]`), seperti pada dokumentasi resminya.

## Tujuan pembelajaran

- [ ] Membuat model dengan `php artisan make:model`.
- [ ] Menetapkan nama tabel dan kolom yang boleh diisi massal.
- [ ] Membaca data: `get`, `find`, `where`, `orderBy`.
- [ ] Menyimpan, mengubah, dan menghapus data.
- [ ] Memakai *route model binding* dengan kolom `slug`.

## Prasyarat

- Bab [Database dan Migration](database-migration.md): tabel `materi` ada dan berisi tiga baris.
- Mengerti dasar class dan *namespace* PHP.

## Konsep

**ORM** (*Object-Relational Mapper*) menerjemahkan antara dunia objek (PHP) dan
dunia tabel (SQL).

| Tabel `materi` | Eloquent |
|---|---|
| Tabel | Class `App\Models\Materi` |
| Baris | Objek `Materi` |
| Kolom | Properti, mis. `$materi->judul` |

## Langkah 1: membuat model

```bash
php artisan make:model Materi
```

Buka `app/Models/Materi.php` dan ubah menjadi:

```php title="app/Models/Materi.php"
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Table;
use Illuminate\Database\Eloquent\Model;

#[Table('materi')]
#[Fillable(['slug', 'judul', 'ringkasan', 'isi'])]
class Materi extends Model
{
}
```

- `#[Table('materi')]` menetapkan nama tabel. Tanpa ini, Eloquent menebak nama
  jamak bahasa Inggris dari nama class.
- `#[Fillable([...])]` mendaftar kolom yang boleh diisi lewat `create()`/`fill()`.
  Ini perlindungan **mass assignment**: kolom yang tidak terdaftar tidak bisa
  diubah oleh input berbahaya.
- Kolom `id`, `created_at`, dan `updated_at` ditangani otomatis.

## Langkah 2: membaca data

Coba di `php artisan tinker`:

```php
use App\Models\Materi;

Materi::count();                              // jumlah baris
Materi::all();                                // semua baris
Materi::find(1);                              // berdasarkan id
Materi::where('slug', 'controller')->first(); // berdasarkan kondisi
Materi::orderBy('judul')->pluck('judul');     // daftar judul urut abjad
```

Hasil yang diharapkan: `3` untuk `count()` bila hanya seeder bab sebelumnya yang
dijalankan, dan objek `Materi` dengan atribut kolom untuk `find`/`first`.

## Langkah 3: route

Ganti seluruh route `materi.*` dengan:

```php title="routes/web.php"
use App\Http\Controllers\MateriController;
use Illuminate\Support\Facades\Route;

Route::get('/materi', [MateriController::class, 'index'])->name('materi.index');
Route::get('/data/materi', [MateriController::class, 'json'])->name('materi.json');
Route::get('/materi/buat', [MateriController::class, 'create'])->name('materi.create');
Route::post('/materi', [MateriController::class, 'store'])->name('materi.store');

Route::get('/materi/{materi:slug}', [MateriController::class, 'show'])->name('materi.show');
Route::get('/materi/{materi:slug}/ubah', [MateriController::class, 'edit'])->name('materi.edit');
Route::put('/materi/{materi:slug}', [MateriController::class, 'update'])->name('materi.update');
Route::delete('/materi/{materi:slug}', [MateriController::class, 'destroy'])->name('materi.destroy');
```

`{materi:slug}` adalah **route model binding** dengan kunci kustom: Laravel mencari
`Materi` yang kolom `slug`-nya cocok dengan URI dan menyuntikkan objeknya ke
controller. Jika tidak ada, Laravel otomatis menjawab **404**; `abort_if` tidak lagi
diperlukan.

## Langkah 4: controller dengan Eloquent

```php title="app/Http/Controllers/MateriController.php"
<?php

namespace App\Http\Controllers;

use App\Models\Materi;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

class MateriController extends Controller
{
    public function index(Request $request): View
    {
        $q = trim((string) $request->query('q', ''));

        return view('materi.index', [
            'daftarMateri' => $this->cari($q),
            'q' => $q,
        ]);
    }

    public function json(Request $request): JsonResponse
    {
        $q = trim((string) $request->query('q', ''));

        return response()
            ->json($this->cari($q))
            ->header('X-Aplikasi', 'Pustaka Materi');
    }

    public function show(Materi $materi): View
    {
        return view('materi.show', ['materi' => $materi]);
    }

    public function create(): View
    {
        return view('materi.create');
    }

    public function store(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'judul' => ['required', 'string', 'max:100', 'unique:materi,judul'],
            'ringkasan' => ['required', 'string', 'max:255'],
            'isi' => ['required', 'string', 'min:20'],
        ], $this->pesan());

        $materi = Materi::create($validated + [
            'slug' => Str::slug($validated['judul']),
        ]);

        return redirect()
            ->route('materi.show', $materi)
            ->with('status', 'Materi berhasil ditambahkan.');
    }

    public function edit(Materi $materi): View
    {
        return view('materi.edit', ['materi' => $materi]);
    }

    public function update(Request $request, Materi $materi): RedirectResponse
    {
        $validated = $request->validate([
            'judul' => ['required', 'string', 'max:100', Rule::unique('materi', 'judul')->ignore($materi)],
            'ringkasan' => ['required', 'string', 'max:255'],
            'isi' => ['required', 'string', 'min:20'],
        ], $this->pesan());

        $materi->update($validated);

        return redirect()
            ->route('materi.show', $materi)
            ->with('status', 'Materi berhasil diperbarui.');
    }

    public function destroy(Materi $materi): RedirectResponse
    {
        $materi->delete();

        return redirect()
            ->route('materi.index')
            ->with('status', 'Materi dihapus.');
    }

    private function cari(string $q)
    {
        return Materi::query()
            ->when($q !== '', fn ($query) => $query->where('judul', 'like', '%'.$q.'%'))
            ->orderBy('judul')
            ->get();
    }

    private function pesan(): array
    {
        return [
            'required' => 'Kolom :attribute wajib diisi.',
            'max' => 'Kolom :attribute maksimal :max karakter.',
            'min' => 'Kolom :attribute minimal :min karakter.',
            'unique' => 'Nilai :attribute sudah dipakai.',
        ];
    }
}
```

Penjelasan bagian penting:

| Kode | Penjelasan |
|---|---|
| `show(Materi $materi)` | Route model binding: objek diambil otomatis berdasarkan `slug`. |
| `Materi::create($validated + ['slug' => ...])` | Menyimpan baris baru. Kolom harus ada di `#[Fillable]`. |
| `Str::slug('Form dan Validasi')` | Mengubah judul menjadi `form-dan-validasi`. |
| `route('materi.show', $materi)` | Memberi objek model; Laravel memakai kolom `slug` karena route mendefinisikan `{materi:slug}`. |
| `Rule::unique('materi', 'judul')->ignore($materi)` | Judul harus unik, kecuali untuk baris yang sedang diubah. |
| `$materi->update($validated)` | Mengubah dan menyimpan atribut. `slug` sengaja tidak ikut berubah agar URL tetap stabil. |
| `$materi->delete()` | Menghapus baris. |
| `->when($q !== '', ...)` | Menambah kondisi `where` hanya jika kata kunci tidak kosong. |
| `orderBy('judul')->get()` | Mengambil semua hasil sebagai koleksi, urut judul. |

## Langkah 5: menyesuaikan view

Karena data sekarang objek, ganti akses array `$materi['judul']` menjadi `$materi->judul`.

```blade title="resources/views/materi/index.blade.php (bagian daftar)"
@forelse ($daftarMateri as $materi)
    <li>
        <a href="{{ route('materi.show', $materi) }}">{{ $materi->judul }}</a>
        &mdash; {{ $materi->ringkasan }}
    </li>
@empty
    <li>Belum ada materi.</li>
@endforelse
```

```blade title="resources/views/materi/show.blade.php"
<x-layout>
    <x-slot:title>{{ $materi->judul }}</x-slot>

    <h2>{{ $materi->judul }}</h2>
    <p><em>{{ $materi->ringkasan }}</em></p>
    <p>{{ $materi->isi }}</p>

    <p>
        <a href="{{ route('materi.edit', $materi) }}">Ubah</a> |
        <a href="{{ route('materi.index') }}">&larr; Kembali ke daftar</a>
    </p>

    <form method="POST" action="{{ route('materi.destroy', $materi) }}"
          onsubmit="return confirm('Hapus materi ini?')">
        @csrf
        @method('DELETE')
        <button type="submit">Hapus</button>
    </form>
</x-layout>
```

```blade title="resources/views/materi/edit.blade.php"
<x-layout>
    <x-slot:title>Ubah {{ $materi->judul }}</x-slot>

    <h2>Ubah Materi</h2>

    <form method="POST" action="{{ route('materi.update', $materi) }}">
        @csrf
        @method('PUT')

        <p>
            <label for="judul">Judul</label><br>
            <input id="judul" type="text" name="judul" value="{{ old('judul', $materi->judul) }}">
            @error('judul') <br><small style="color: red">{{ $message }}</small> @enderror
        </p>
        <p>
            <label for="ringkasan">Ringkasan</label><br>
            <input id="ringkasan" type="text" name="ringkasan" value="{{ old('ringkasan', $materi->ringkasan) }}">
            @error('ringkasan') <br><small style="color: red">{{ $message }}</small> @enderror
        </p>
        <p>
            <label for="isi">Isi</label><br>
            <textarea id="isi" name="isi" rows="6">{{ old('isi', $materi->isi) }}</textarea>
            @error('isi') <br><small style="color: red">{{ $message }}</small> @enderror
        </p>

        <button type="submit">Simpan</button>
    </form>
</x-layout>
```

- Browser hanya mengirim `GET` dan `POST`. `@method('PUT')` dan `@method('DELETE')`
  menambahkan field tersembunyi `_method` agar Laravel memperlakukan request sebagai
  `PUT`/`DELETE` (*form method spoofing*).
- `old('judul', $materi->judul)` memakai isian lama bila ada, jika tidak nilai dari database.

## Menjalankan dan memverifikasi

1. Pastikan `php artisan migrate` sudah dijalankan dan seeder sudah dipakai.
2. Buka `/materi`: tiga materi dari database, urut abjad.
3. Buka salah satu: judul, ringkasan, isi, serta tombol Ubah dan Hapus.
4. Klik **+ Usulkan materi**, isi form valid: kamu diarahkan ke halaman materi baru
   dengan slug dari judul, dan pesan "Materi berhasil ditambahkan."
5. Ubah materi itu, lalu hapus. Setelah dihapus, `/materi` tidak lagi memuatnya.
6. Periksa di Tinker: `App\Models\Materi::count()`.

## Kesalahan umum dan debugging

| Gejala | Penyebab | Solusi |
|---|---|---|
| `Add [judul] to fillable property to allow mass assignment` | Kolom belum masuk `#[Fillable]` | Tambahkan kolom ke atribut `#[Fillable([...])]`. |
| `no such table: materis` | `#[Table('materi')]` belum dipasang | Tambahkan atribut pada model. |
| 404 pada `/materi/slug-benar` | Route memakai `{materi}` tanpa `:slug` | Gunakan `{materi:slug}`. |
| `Attempt to read property "judul" on array` | View masih memakai sintaks array atau sebaliknya | Samakan dengan `$materi->judul` untuk objek. |
| Ubah/Hapus menghasilkan 405 | `@method` hilang | Tambahkan `@method('PUT')`/`@method('DELETE')`. |
| 419 saat Hapus | `@csrf` hilang | Tambahkan `@csrf`. |
| `Class "App\Models\Materi" not found` | Lupa `use App\Models\Materi;` | Tambahkan `use`. |

## Latihan terpandu

1. Pada Tinker, buat materi lewat `Materi::create([...])`, ubah dengan `->update([...])`,
   lalu hapus dengan `->delete()`.
2. Tambahkan pengurutan terbaru pada `/data/materi` dengan `latest()` alih-alih `orderBy('judul')`.
3. Tampilkan `created_at` di halaman detail dengan format
   `{{ $materi->created_at->format('d-m-Y') }}`.
4. Verifikasi bahwa mengirim field `slug` ekstra pada form tidak mengubah slug materi.

## Pertanyaan review

1. Apa arti ORM dan apa pemetaan tabel/baris/kolom di Eloquent?
2. Mengapa `#[Fillable]` penting bagi keamanan?
3. Apa beda `Materi::all()` dan `Materi::where(...)->first()`?
4. Apa yang dilakukan `{materi:slug}` pada route?
5. Mengapa form ubah/hapus membutuhkan `@method`?

## Ringkasan

- Model `Materi` mewakili tabel `materi`; atribut `#[Table]` dan `#[Fillable]` mengaturnya.
- Query: `all`, `find`, `where`, `orderBy`, `first`, `get`.
- Tulis data: `create`, `update`, `delete`.
- Route model binding menyuntikkan model dan menjawab 404 otomatis.
- Form `PUT`/`DELETE` memakai `@method`.

Bab berikutnya: **Relasi Eloquent**.

## Referensi resmi

- [Eloquent: Getting Started](https://laravel.com/docs/13.x/eloquent)
- [Mass Assignment](https://laravel.com/docs/13.x/eloquent#mass-assignment)
- [Inserting and Updating Models](https://laravel.com/docs/13.x/eloquent#inserts)
- [Route Model Binding](https://laravel.com/docs/13.x/routing#route-model-binding)
- [Form Method Spoofing](https://laravel.com/docs/13.x/routing#form-method-spoofing)
