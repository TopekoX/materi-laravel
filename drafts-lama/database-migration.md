# Database dan Migration

Data di array controller hilang setiap kali kode berubah. Pada bab ini kamu
menyiapkan **database**, membuat struktur tabel dengan **migration**, dan mengisi data
awal dengan **seeder**.

!!! info "Versi yang dipakai"
    Laravel **13.x**. Rujukan: [Database](https://laravel.com/docs/13.x/database),
    [Migrations](https://laravel.com/docs/13.x/migrations), dan
    [Seeding](https://laravel.com/docs/13.x/seeding).

## Tujuan pembelajaran

- [ ] Menjelaskan fungsi database dan migration.
- [ ] Memeriksa konfigurasi database di `.env`.
- [ ] Membuat dan menjalankan migration untuk tabel `materi`.
- [ ] Memakai `migrate:status` dan `migrate:rollback`.
- [ ] Mengisi data awal dengan seeder.

## Prasyarat

- Bab [Form dan Validasi](form-validasi.md) selesai.
- Mengerti konsep tabel, kolom, dan baris.

## Konsep

**Migration** adalah "riwayat versi" struktur database dalam bentuk kode PHP.
Dibanding membuat tabel manual lewat aplikasi database, migration:

- bisa disimpan di Git dan dibagikan ke seluruh tim,
- bisa dijalankan ulang di mesin lain dengan satu perintah,
- bisa dibatalkan (*rollback*).

!!! tip "Analogi"
    Migration seperti catatan renovasi rumah: "tambah kamar", "pindahkan dapur".
    Siapa pun dapat membangun rumah yang sama dengan mengikuti catatan itu berurutan.

## Langkah 1: memeriksa konfigurasi database

Proyek Laravel baru memakai **SQLite** secara bawaan: satu file di
`database/database.sqlite`, tanpa server tambahan. Periksa `.env`:

```ini title=".env"
DB_CONNECTION=sqlite
```

Untuk MySQL/MariaDB/PostgreSQL, kamu membuat database terlebih dulu lalu mengisi
`DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, dan `DB_PASSWORD`.

!!! danger "Jangan commit `.env`"
    `.env` berisi rahasia (kata sandi database, `APP_KEY`). File ini sudah ada di
    `.gitignore`; jangan dihapus dari sana. Bagikan `.env.example`
    tanpa nilai rahasia.

Cek status migration:

```bash
php artisan migrate:status
```

Perintah ini menampilkan daftar migration bawaan (tabel pengguna, cache, antrean) beserta
statusnya. Bila database belum siap, Laravel akan menawarkan atau menampilkan pesan error
yang menjelaskan masalahnya.

## Langkah 2: membuat migration

```bash
php artisan make:migration create_materi_table
```

File baru muncul di `database/migrations/` dengan awalan tanggal-waktu. Isi dengan:

```php title="database/migrations/xxxx_xx_xx_xxxxxx_create_materi_table.php"
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('materi', function (Blueprint $table) {
            $table->id();
            $table->string('slug')->unique();
            $table->string('judul');
            $table->string('ringkasan');
            $table->text('isi');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('materi');
    }
};
```

| Kode | Penjelasan |
|---|---|
| `up()` | Dijalankan saat `migrate`: membuat tabel. |
| `down()` | Dijalankan saat `rollback`: membatalkan perubahan `up()`. |
| `$table->id()` | Kolom `id` auto-increment sebagai primary key. |
| `$table->string('slug')->unique()` | Teks pendek yang tidak boleh kembar. |
| `$table->text('isi')` | Teks panjang. |
| `$table->timestamps()` | Kolom `created_at` dan `updated_at`. |

!!! note "Mengapa nama tabel `materi`?"
    Konvensi Laravel menebak nama tabel dari nama model dalam bentuk jamak bahasa
    Inggris. Untuk kata bahasa Indonesia, kita menetapkan nama tabel secara
    eksplisit agar tidak ambigu (dilakukan di model pada bab Eloquent).

## Langkah 3: menjalankan migration

```bash
php artisan migrate
php artisan migrate:status
```

Setelah `migrate`, status `create_materi_table` seharusnya tercatat sebagai sudah
dijalankan (*Ran*).

Untuk membatalkan batch terakhir:

```bash
php artisan migrate:rollback
```

Jalankan `migrate` lagi setelah mencoba rollback agar tabel kembali ada.

!!! warning "Hati-hati dengan `migrate:fresh`"
    `php artisan migrate:fresh` **menghapus semua tabel** lalu membuatnya ulang. Aman
    di mesin pengembangan, berbahaya jika diarahkan ke database berisi data penting.

## Langkah 4: seeder (data awal)

```bash
php artisan make:seeder MateriSeeder
```

```php title="database/seeders/MateriSeeder.php"
<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class MateriSeeder extends Seeder
{
    public function run(): void
    {
        $sekarang = now();

        DB::table('materi')->insert([
            [
                'slug' => 'routing-dasar',
                'judul' => 'Routing Dasar',
                'ringkasan' => 'Memetakan URL ke kode.',
                'isi' => 'Route menghubungkan metode HTTP dan URI dengan aksi.',
                'created_at' => $sekarang,
                'updated_at' => $sekarang,
            ],
            [
                'slug' => 'controller',
                'judul' => 'Controller',
                'ringkasan' => 'Memindahkan logika dari closure ke class.',
                'isi' => 'Controller mengelompokkan logika yang saling berkaitan.',
                'created_at' => $sekarang,
                'updated_at' => $sekarang,
            ],
            [
                'slug' => 'view-dan-blade',
                'judul' => 'View dan Blade',
                'ringkasan' => 'Menampilkan HTML dengan template.',
                'isi' => 'Blade adalah template engine bawaan Laravel.',
                'created_at' => $sekarang,
                'updated_at' => $sekarang,
            ],
        ]);
    }
}
```

`DB::table('materi')->insert([...])` memakai *query builder* untuk menyisipkan
banyak baris sekaligus. Jalankan:

```bash
php artisan db:seed --class=MateriSeeder
```

!!! warning "Jalankan seeder ini sekali"
    Karena `slug` bersifat `unique`, menjalankan seeder kedua kali gagal dengan
    error *UNIQUE constraint*. Itu perilaku yang benar. Untuk mengulang dari awal di
    mesin lokal: `php artisan migrate:fresh` lalu seed lagi.

## Memverifikasi data

```bash
php artisan tinker
```

Di dalam Tinker (konsol interaktif):

```php
DB::table('materi')->count();
DB::table('materi')->pluck('judul');
```

Hasil yang diharapkan: jumlah `3` dan tiga judul yang kamu seed. Keluar dengan
`exit`.

## Kesalahan umum dan debugging

| Gejala | Penyebab | Solusi |
|---|---|---|
| `could not find driver` | Ekstensi PHP `pdo_sqlite` (atau driver DB lain) belum aktif | Aktifkan di `php.ini`, lalu restart. |
| `SQLSTATE ... no such table: materi` | Migration belum dijalankan | `php artisan migrate`. |
| `Table 'materi' already exists` | Tabel dibuat manual atau migration terduplikasi | Cek `migrate:status`; hapus tabel manual atau gunakan `migrate:fresh` (lokal saja). |
| `UNIQUE constraint failed: materi.slug` | Seeder dijalankan dua kali | Normal; reset dengan `migrate:fresh`. |
| `Connection refused` (MySQL) | Server DB mati atau kredensial salah | Periksa `.env` dan server database. |
| Perubahan `.env` tidak terbaca | Konfigurasi ter-cache | `php artisan config:clear`. |

## Latihan terpandu

1. Buat migration baru `add_tingkat_to_materi_table` yang menambah kolom
   `tingkat` (`string`, default `pemula`) memakai `Schema::table('materi', ...)`.
   Tulis `down()` yang menghapusnya (`dropColumn`).
2. Jalankan `migrate`, cek `migrate:status`, lalu `migrate:rollback`, dan jalankan lagi.
3. Verifikasi kolom di Tinker: `DB::table('materi')->first()` menampilkan `tingkat`.

??? success "Petunjuk"
    ```php
    public function up(): void
    {
        Schema::table('materi', function (Blueprint $table) {
            $table->string('tingkat')->default('pemula');
        });
    }

    public function down(): void
    {
        Schema::table('materi', function (Blueprint $table) {
            $table->dropColumn('tingkat');
        });
    }
    ```

## Pertanyaan review

1. Apa keuntungan migration dibanding membuat tabel manual?
2. Apa beda `up()` dan `down()`?
3. Apa fungsi `migrate:status` dan `migrate:rollback`?
4. Mengapa `.env` tidak boleh masuk repository?
5. Mengapa `migrate:fresh` berbahaya di produksi?

## Ringkasan

- Database dikonfigurasi di `.env`; SQLite adalah bawaan.
- Migration menyimpan riwayat struktur tabel sebagai kode.
- `migrate` menjalankan, `migrate:rollback` membatalkan, `migrate:status` melapor.
- Seeder mengisi data awal.

Bab berikutnya: **Eloquent ORM**, cara memakai tabel `materi` sebagai objek PHP.

## Referensi resmi

- [Database: Getting Started](https://laravel.com/docs/13.x/database)
- [Migrations](https://laravel.com/docs/13.x/migrations)
- [Running Migrations](https://laravel.com/docs/13.x/migrations#running-migrations)
- [Seeding](https://laravel.com/docs/13.x/seeding)
- [Installation: Databases](https://laravel.com/docs/13.x/installation#databases-and-migrations)
