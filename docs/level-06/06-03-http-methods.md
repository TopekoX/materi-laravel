# Metode HTTP

Metode HTTP adalah "kata kerja" dalam percakapan API. Memakainya dengan benar membuat API mudah ditebak dan aman diulang; memakainya sembarangan melahirkan bug halus seperti data ganda dan aksi berbahaya
yang terpicu `GET`. Sub bab ini membahas `GET`, `POST`, `PUT`, `PATCH`, `DELETE`, `HEAD`, dan `OPTIONS` beserta perilaku Laravel untuk masing-masing, termasuk cara mengirim body JSON.

## Tujuan Pembelajaran

Setelah menyelesaikan sub bab ini, kamu dapat:

- [ ] Memilih metode HTTP yang tepat untuk setiap aksi.
- [ ] Membedakan `PUT` (ganti penuh) dan `PATCH` (ubah sebagian).
- [ ] Mengirim permintaan `POST/PUT/PATCH/DELETE` dengan body JSON memakai `curl`.
- [ ] Membaca body JSON di Laravel dengan `$request->input()` dan `$request->json()`.
- [ ] Menjelaskan `HEAD` dan `OPTIONS` (CORS *preflight*).
- [ ] Menjelaskan mengapa `GET` tidak boleh mengubah data.

## Prasyarat

- [Arsitektur REST](06-02-rest-architecture.md).
- [Routing Dasar](../level-02/02-02-basic-routing.md) dan [Objek Request](../level-02/02-15-request-object.md).
- Proyek `cms-artikel`.

## Pengantar

Klien yang mengirim `DELETE /articles/5` dua kali mengharapkan keadaan akhir sama (artikel hilang). Klien yang mengirim `POST /articles` dua kali bisa membuat dua artikel. Perbedaan perilaku ini bukan
kebetulan; ia ditentukan oleh semantik metode.

## Penjelasan Konsep

### Ringkasan metode

| Metode | Tujuan | Body permintaan | Body respons | Safe | Idempotent | Status sukses umum |
|---|---|---|---|---|---|---|
| `GET` | Baca sumber daya | Tidak | Ya | Ya | Ya | 200 |
| `POST` | Buat sumber daya / aksi | Ya | Ya | Tidak | Tidak | 201 (buat), 200/202 |
| `PUT` | Ganti sumber daya **penuh** | Ya | Opsional | Tidak | Ya | 200, 204 |
| `PATCH` | Ubah **sebagian** | Ya | Opsional | Tidak | Tidak selalu | 200, 204 |
| `DELETE` | Hapus | Biasanya tidak | Opsional | Tidak | Ya | 204, 200 |
| `HEAD` | Seperti `GET` tanpa body | Tidak | Tidak | Ya | Ya | 200 |
| `OPTIONS` | Metode yang diizinkan / CORS | Tidak | Opsional | Ya | Ya | 204/200 |

### `PUT` vs `PATCH`

- `PUT /articles/5` dengan `{"title": "A", "body": "B", ...}`: klien mengirim **representasi lengkap**; kolom yang tak dikirim dianggap dikosongkan atau ditolak.
- `PATCH /articles/5` dengan `{"title": "A"}`: hanya `title` yang berubah.

Di Laravel, resource controller memetakan keduanya ke metode `update`. Pada `PATCH`, gunakan aturan `sometimes` agar hanya kolom yang dikirim yang divalidasi.

### Mengirim dan membaca JSON

Klien:

```bash
curl -i -X POST http://127.0.0.1:8000/uji-api/metode \
  -H "Content-Type: application/json" -H "Accept: application/json" \
  -d '{"judul":"Halo","tags":["php","laravel"]}'
```

Server:

```php-inline
$request->input('judul');             // membaca dari body JSON maupun form
$request->json()->all();              // seluruh body JSON sebagai array
$request->input('tags.0');            // notasi titik
$request->isJson();                   // apakah Content-Type JSON
$request->expectsJson();              // apakah klien menginginkan JSON
```

Header `Content-Type: application/json` wajib saat mengirim JSON; tanpa itu Laravel tidak mengurai body sebagai JSON.

### Method spoofing tidak diperlukan di API

Form HTML hanya mengenal `GET` dan `POST`, jadi butuh `_method`. Klien API dapat mengirim metode HTTP apa pun langsung.

### `HEAD` dan `OPTIONS`

- `HEAD`: Laravel otomatis menjawab `HEAD` untuk route `GET` (header tanpa body); berguna untuk memeriksa keberadaan dan ukuran.
- `OPTIONS`: dipakai browser sebagai *preflight* CORS untuk permintaan lintas asal tertentu. Laravel menangani CORS lewat konfigurasi (dibahas pada sub bab integrasi frontend).

### Keamanan

- `GET` tidak boleh mengubah data (rentan prefetch, cache, dan CSRF).
- Aksi destruktif selalu dengan `DELETE` + otorisasi, bukan `GET`.
- Validasi body sama ketatnya dengan form; JSON tidak otomatis aman.
- Batasi ukuran body (konfigurasi server) untuk mencegah muatan raksasa.

## Cara Kerja

```mermaid
flowchart LR
    C["curl -X PATCH /articles/5 -d '{\"title\":\"Baru\"}'"] --> R["Route PATCH → update()"]
    R --> V["Validasi: sometimes"]
    V --> U["Model::update(['title'=>'Baru'])"]
    U --> S["200 + JSON artikel"]
```

## Contoh Praktik

Kamu membuat route sementara yang menjawab semua metode dengan mencerminkan metode dan body yang diterima, lalu menjalankan `curl` untuk tiap metode, termasuk body JSON dan `HEAD`.

## Penjelasan Kode

File: `routes/web.php` (sementara)

```php-inline
use Illuminate\Http\Request;

Route::match(['get', 'post', 'put', 'patch', 'delete', 'options'], '/uji-api/metode', function (Request $request) {
    return response()->json([
        'metode' => $request->method(),
        'json' => $request->isJson(),
        'body' => $request->all(),
    ]);
})->withoutMiddleware(\Illuminate\Foundation\Http\Middleware\PreventRequestForgery::class);
```

Pada `routes/web.php`, `PreventRequestForgery` akan menolak `POST` tanpa token; `withoutMiddleware` hanya dipakai sementara agar `curl` dapat dicoba (route API pada sub bab 06.06 tidak memakai
CSRF karena tidak berada pada grup `web`). **Hapus route ini setelah latihan.** Jika nama kelas middleware di versimu berbeda, gunakan `->withoutMiddleware('web')` atau tunda latihan sampai route API tersedia.

## Implementasi Langkah demi Langkah

### Langkah 1: tambah route sementara

Tambahkan route di atas dan jalankan `php artisan serve`.

### Langkah 2: coba tiap metode

```bash
curl -s -X GET     http://127.0.0.1:8000/uji-api/metode
curl -s -X POST    -H "Content-Type: application/json" -d '{"judul":"Halo"}' http://127.0.0.1:8000/uji-api/metode
curl -s -X PUT     -H "Content-Type: application/json" -d '{"judul":"Ganti penuh"}' http://127.0.0.1:8000/uji-api/metode
curl -s -X PATCH   -H "Content-Type: application/json" -d '{"judul":"Ubah sebagian"}' http://127.0.0.1:8000/uji-api/metode
curl -s -X DELETE  http://127.0.0.1:8000/uji-api/metode
curl -s -I http://127.0.0.1:8000/uji-api/metode
```

### Langkah 3: coba tanpa `Content-Type`

```bash
curl -s -X POST -d '{"judul":"Halo"}' http://127.0.0.1:8000/uji-api/metode
```

Bandingkan nilai `json` dan `body` dengan permintaan yang memakai header.

### Langkah 4: coba JSON rusak

```bash
curl -s -X POST -H "Content-Type: application/json" -d '{"judul":' http://127.0.0.1:8000/uji-api/metode
```

Catat respons galat (umumnya `400`/`500` bergantung versi dan konfigurasi).

### Langkah 5: hapus route sementara

Hapus route; tidak ada yang di-*commit*.

## Eksekusi dan Verifikasi

| Langkah | Cara memverifikasi |
|---|---|
| 2 | Field `metode` mencerminkan metode; `HEAD` hanya header |
| 3 | `json: false` dan body tidak terurai sebagai JSON |
| 4 | Respons galat, bukan data |

## Hasil yang Diharapkan

| Permintaan | Hasil |
|---|---|
| `POST` + `Content-Type: application/json` | `{"metode":"POST","json":true,"body":{"judul":"Halo"}}` |
| `POST` tanpa header | `json: false` |
| `HEAD` | `200` tanpa body |

Hasil ini diturunkan dari dokumentasi dan belum dijalankan oleh penulis materi; cocokkan dengan hasilmu.

## Kesalahan Umum dan Pemecahan Masalah

| Gejala | Penyebab | Cara mengenali | Solusi | Pencegahan |
|---|---|---|---|---|
| `419` pada `curl` | Route berada di grup `web` (CSRF) | Status 419 | Gunakan route API | Letakkan API di `routes/api.php` |
| Body kosong di server | Lupa `Content-Type: application/json` | `body: []` | Tambahkan header | Selalu kirim header |
| `405 Method Not Allowed` | Route tidak mendukung metode | Header `Allow` | Gunakan metode yang benar | Periksa `route:list` |
| `PUT` menghapus kolom tak terkirim | Salah paham semantik | Data hilang | Gunakan `PATCH` | Pahami `PUT` vs `PATCH` |
| Klien mengulang `POST` dan data ganda | Tidak idempotent | Duplikat | Kunci idempotensi / kunci unik | Rancang pencegahan duplikat |
| Respons HTML bukan JSON | Tidak mengirim `Accept` | Halaman HTML | Kirim `Accept: application/json` | Wajibkan header di klien |

## Latihan Praktik

### Latihan dasar

**D1. Pilih metode**
- *Masalah:* tentukan metode.
- *Persyaratan:* untuk (a) lihat daftar komentar, (b) tambah komentar, (c) ganti seluruh data artikel, (d) ubah judul saja, (e) hapus komentar, pilih metode.
- *Perilaku yang diharapkan:* GET, POST, PUT, PATCH, DELETE.
- *Tujuan belajar:* memilih metode.

### Latihan implementasi

**I1. Eksperimen idempotensi**
- *Masalah:* ingin merasakan idempotensi.
- *Persyaratan:* buat route sementara penambah penghitung di cache (`POST`) dan pengatur nilai (`PUT`), panggil masing-masing tiga kali, dan bandingkan hasil akhir.
- *Perilaku yang diharapkan:* `PUT` stabil, `POST` bertambah.
- *Tujuan belajar:* memahami idempotensi.

**I2. Body JSON bersarang**
- *Masalah:* membaca data bersarang.
- *Persyaratan:* kirim `{"artikel":{"judul":"X","tags":["a","b"]}}` dan tampilkan `artikel.judul` serta `artikel.tags.1`.
- *Perilaku yang diharapkan:* `X` dan `b`.
- *Tujuan belajar:* membaca JSON bersarang.

### Latihan tantangan

**T1. Kunci idempotensi**
- *Masalah:* klien seluler sering mengulang `POST` saat jaringan buruk.
- *Persyaratan:* rancang mekanisme header `Idempotency-Key` (simpan kunci dan respons di cache) agar pengulangan `POST` tidak membuat data ganda; jelaskan kapan kunci kedaluwarsa.
- *Perilaku yang diharapkan:* rancangan konsisten (implementasi sederhana boleh).
- *Tujuan belajar:* membuat `POST` aman diulang.
- *Catatan:* kerjakan mandiri; tidak ada kunci jawaban.

## Uji Pemahaman

1. Apa beda `PUT` dan `PATCH`?
2. Metode mana yang idempotent?
3. Mengapa `Content-Type: application/json` wajib saat mengirim JSON?
4. Apa fungsi `OPTIONS` pada browser?
5. Mengapa `GET` tidak boleh mengubah data?
6. Bagaimana Laravel menjawab `HEAD`?

??? success "Kunci jawaban singkat"
    1. `PUT` mengganti penuh; `PATCH` mengubah sebagian.
    2. `GET`, `PUT`, `DELETE` (dan `HEAD`, `OPTIONS`).
    3. Agar server mengurai body sebagai JSON.
    4. Preflight CORS dan menanyakan metode yang diizinkan.
    5. `GET` dianggap aman; bisa terpicu prefetch/cache.
    6. Otomatis untuk route `GET`, tanpa body.

## Ringkasan

- Pilih metode menurut semantik: `GET` baca, `POST` buat, `PUT` ganti, `PATCH` ubah sebagian, `DELETE` hapus.
- Kirim JSON dengan `Content-Type: application/json`; baca dengan `$request->input()`/`json()`.
- Pahami safe dan idempotent untuk keandalan.
- `GET` tidak mengubah data.

Selanjutnya: *Kode Status HTTP*, menyampaikan hasil dengan jelas.

## Referensi Resmi

- [Laravel: Request](https://laravel.com/docs/13.x/requests)
- [Laravel: Retrieving JSON Input](https://laravel.com/docs/13.x/requests#retrieving-json-input-values)
- [MDN: HTTP request methods](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods)
