# Pemrograman Berorientasi Objek

Hampir semua yang kamu lihat di Laravel adalah **objek**: controller, model, request,
response. Bab ini memperkenalkan cara berpikir **pemrograman berorientasi objek**
(*Object-Oriented Programming*, OOP): mengapa ia ada, istilah-istilah dasarnya, dan
bagaimana ia terlihat di Laravel. Sintaks `class` secara rinci dibahas di dua bab berikutnya.

## Tujuan pembelajaran

Setelah menyelesaikan bab ini, kamu dapat:

- [ ] Menjelaskan perbedaan pendekatan prosedural dan berorientasi objek.
- [ ] Menjelaskan arti *class*, *object*, *property*, dan *method*.
- [ ] Menyebutkan empat pilar OOP dan gagasan intinya.
- [ ] Merancang class sederhana untuk sebuah benda di dunia nyata.
- [ ] Mengenali class dan objek pada potongan kode Laravel.

## Prasyarat

- Bab [Fungsi](00-14-functions.md) dan [Array](00-13-arrays.md).
- PHP 8.3 atau lebih baru; folder `belajar-php`.

## Konsep

### Dua cara menyusun program

**Prosedural**: data disimpan di variabel atau array, dan fungsi terpisah mengolahnya. Ini
gaya yang kamu pakai sejauh ini.

**Berorientasi objek**: data dan perilaku yang berkaitan dikemas **bersama** dalam satu
satuan bernama *objek*.

Bayangkan data seorang siswa dan hitungan rata-rata nilainya:

```php-inline
// Prosedural: data dan fungsi terpisah
$siswa = ["nama" => "Budi", "nilai" => [80, 90, 70]];

function rataRata(array $siswa): float
{
    return array_sum($siswa["nilai"]) / count($siswa["nilai"]);
}

echo rataRata($siswa);
```

```php-inline
// Berorientasi objek: data dan perilaku dikemas dalam satu class
class Siswa
{
    public function __construct(
        public string $nama,
        public array $nilai,
    ) {}

    public function rataRata(): float
    {
        return array_sum($this->nilai) / count($this->nilai);
    }
}

$budi = new Siswa("Budi", [80, 90, 70]);
echo $budi->rataRata();
```

(Setiap bagian sintaks `class` di atas dijelaskan pada bab *Classes dan Objects*. Di sini
cukup pahami gambaran besarnya.)

Pada versi OOP, pertanyaan "berapa rata-rata Budi?" dijawab oleh objek `Budi` sendiri.

### Istilah dasar

| Istilah | Arti | Contoh |
|---|---|---|
| **Class** | Cetak biru: menjelaskan data dan perilaku apa yang dimiliki sesuatu | `Siswa` |
| **Object** (objek) | Wujud nyata yang dibuat dari class; juga disebut *instance* | `$budi`, `$sari` |
| **Property** | Data milik objek | `nama`, `nilai` |
| **Method** | Perilaku milik objek (fungsi di dalam class) | `rataRata()` |

!!! tip "Analogi"
    Class seperti **cetakan kue**, objek adalah **kue-kue** yang dihasilkan. Satu cetakan
    bisa membuat banyak kue; setiap kue punya isi (rasa, hiasan) sendiri-sendiri, tetapi
    semuanya berbentuk sama.

Dari satu class `Siswa` kamu bisa membuat banyak objek (`Budi`, `Sari`, `Andi`). Masing-masing
menyimpan data sendiri, sehingga mengubah satu objek tidak memengaruhi yang lain.

### Empat pilar OOP

| Pilar | Gagasan | Analogi |
|---|---|---|
| **Encapsulation** (enkapsulasi) | Data dan cara mengubahnya dikemas bersama; bagian dalam disembunyikan, hanya antarmuka yang dibuka | Remote TV: kamu menekan tombol tanpa perlu tahu rangkaian di dalamnya |
| **Inheritance** (pewarisan) | Class baru mewarisi sifat class lain, lalu menambah atau mengubah | Mobil listrik mewarisi sifat mobil, ditambah baterai |
| **Polymorphism** (polimorfisme) | Satu perintah yang sama dijawab berbeda oleh objek berbeda | Perintah "bunyi": kucing mengeong, anjing menggonggong |
| **Abstraction** (abstraksi) | Menonjolkan hal penting, menyembunyikan detail rumit | Pedal gas: cukup diinjak tanpa mengerti mesin |

Tiga pilar pertama dipraktikkan pada bab 00.19 dan 00.20. Cukup kenali gagasannya dulu.

### Mengapa OOP penting untuk Laravel?

Laravel dirancang berorientasi objek dari ujung ke ujung:

| Di Laravel | Berupa |
|---|---|
| Controller | Class, mis. `MateriController` |
| Model Eloquent | Class yang mewakili tabel, mis. `Materi` |
| Request dan Response | Objek yang membungkus request dan response HTTP |
| Middleware, Mail, Job | Class dengan tugas masing-masing |
| `Route`, `Schema`, `DB` | *Facade*: jalan pintas ke objek di balik layar |

Kamu tidak bisa membaca kode Laravel tanpa memahami class dan objek.

### Mengenali OOP pada kode Laravel

```php-inline
Route::get('/materi/{slug}', [MateriController::class, 'show']);

$materi = Materi::where('slug', $slug)->first();

return view('materi.show', ['materi' => $materi]);
```

Dari potongan ini:

- `MateriController` dan `Materi` adalah **class**.
- `$materi` adalah **objek** hasil query.
- `->first()` adalah **method** yang dipanggil pada hasil `where`.
- Tanda `->` berarti "panggil method atau ambil property dari objek ini".

### Kapan OOP, kapan tidak?

OOP bukan keharusan untuk setiap program. Skrip pendek dengan satu tugas cukup ditulis
secara prosedural. OOP terasa manfaatnya pada aplikasi besar dengan banyak bagian yang
saling berkaitan, tempat pengemasan data dan perilaku menjaga kode tetap rapi.

## Praktik

### Langkah 1: bandingkan dua gaya

```php title="belajar-php/siswa-prosedural.php"
<?php

$siswa = ["nama" => "Budi", "nilai" => [80, 90, 70]];

function rataRata(array $siswa): float
{
    return array_sum($siswa["nilai"]) / count($siswa["nilai"]);
}

echo $siswa["nama"], ": ", rataRata($siswa), "\n";
```

```php title="belajar-php/siswa-oop.php"
<?php

class Siswa
{
    public function __construct(
        public string $nama,
        public array $nilai,
    ) {}

    public function rataRata(): float
    {
        return array_sum($this->nilai) / count($this->nilai);
    }
}

$budi = new Siswa("Budi", [80, 90, 70]);
$sari = new Siswa("Sari", [95, 85]);

echo $budi->nama, ": ", $budi->rataRata(), "\n";
echo $sari->nama, ": ", $sari->rataRata(), "\n";

$budi->nama = "Budi Santoso";
echo $budi->nama, "\n";
echo $sari->nama, "\n";
```

```bash
cd belajar-php
php siswa-prosedural.php
php siswa-oop.php
```

**Yang seharusnya terlihat:**

`siswa-prosedural.php`:

```text
Budi: 80
```

`siswa-oop.php`:

```text
Budi: 80
Sari: 90
Budi Santoso
Sari
```

Kamu perlu mencocokkan sendiri hasil di terminalmu dengan keluaran di atas. Perhatikan
bahwa mengubah nama `$budi` tidak memengaruhi `$sari`: setiap objek menyimpan datanya
sendiri.

### Langkah 2: rancang class di atas kertas

Pilih sistem **perpustakaan** dan rancang tiga class. Contoh jawaban untuk satu class:

| Class | Property (data) | Method (perilaku) |
|---|---|---|
| `Buku` | `judul`, `penulis`, `tahun`, `tersedia` | `pinjam()`, `kembalikan()` |

Lengkapi sendiri untuk `Anggota` dan `Peminjaman`. Ajukan pertanyaan: "Apa yang *dimiliki*
benda ini?" (property) dan "Apa yang *dilakukan* benda ini?" (method).

### Langkah 3: kenali OOP di Laravel

Baca potongan berikut, lalu tuliskan semua class, objek, dan method yang kamu temukan:

```php-inline
class MateriController extends Controller
{
    public function index(Request $request)
    {
        $daftar = Materi::where('judul', 'like', '%laravel%')
            ->orderBy('judul')
            ->get();

        return view('materi.index', ['daftar' => $daftar]);
    }
}
```

??? success "Jawaban"
    - **Class:** `MateriController` (mewarisi `Controller`), `Request`, `Materi`.
    - **Objek:** `$request` (objek `Request`), `$daftar` (hasil query).
    - **Method:** `index()` (milik `MateriController`), `where()`, `orderBy()`, `get()`
      (dirangkai pada query Materi).

    Tanda `->` menunjukkan pemanggilan method pada objek; `::` memanggil method milik
    class itu sendiri (dibahas di bab berikutnya).

## Kesalahan umum dan debugging

| Gejala | Kemungkinan penyebab | Solusi |
|---|---|---|
| Menyamakan class dengan objek | Class adalah cetakan; objek adalah hasilnya | Ingat analogi cetakan kue. |
| `Class "Siswa" not found` | Class belum didefinisikan atau berkas belum dimuat | Definisikan class sebelum dipakai, atau muat berkasnya. |
| `Call to undefined method` | Nama method salah atau tidak ada di class | Periksa ejaan dan definisi class. |
| `Undefined property` | Property tidak ada di class | Periksa nama property. |
| `Using $this when not in object context` | `$this` dipakai di luar method class | `$this` hanya berlaku di dalam method. |
| Bingung memakai `->` | `->` dipakai untuk objek | Objek: `$budi->nama`. |
| Berpikir semuanya harus OOP | Kebutuhan tiap program berbeda | Pilih sesuai kebutuhan; skrip kecil boleh prosedural. |

## Latihan terpandu

1. Ubah `siswa-oop.php`: buat objek ketiga `Andi` dengan nilai `[60, 70]` dan cetak rata-ratanya.
2. Tambahkan method `terbaik(): int` yang mengembalikan nilai tertinggi (`max($this->nilai)`)
   lalu panggil pada `Budi`.
3. Rancang di atas kertas class `Produk` untuk toko online: tulis property dan method-nya.
4. Dari sistem berikut tentukan class yang mungkin: aplikasi pesan antar makanan
   (minimal empat class), dan tulis satu property serta satu method untuk tiap class.
5. Jelaskan dengan kata-katamu perbedaan class dan objek menggunakan analogimu sendiri.
6. Cari satu contoh polimorfisme di dunia nyata di luar contoh bab ini.

## Pertanyaan review

1. Apa beda pemrograman prosedural dan berorientasi objek?
2. Apa itu class, objek, property, dan method?
3. Sebutkan empat pilar OOP dan satu gagasan inti tiap pilar.
4. Apa arti tanda `->` dalam kode PHP?
5. Mengapa dua objek dari class yang sama tidak saling memengaruhi datanya?
6. Sebutkan tiga hal di Laravel yang berupa class atau objek.
7. Kapan OOP tidak perlu dipakai?

## Ringkasan

- OOP mengemas data (property) dan perilaku (method) dalam objek.
- Class adalah cetak biru; objek adalah hasil nyata dari class.
- Empat pilar: enkapsulasi, pewarisan, polimorfisme, abstraksi.
- Setiap objek menyimpan datanya sendiri.
- Laravel dibangun dari class dan objek, jadi OOP adalah keterampilan wajib.

Selanjutnya: **Classes dan Objects**.

## Referensi resmi

- [PHP Manual: Classes and Objects](https://www.php.net/manual/en/language.oop5.php)
- [PHP Manual: Introduction (OOP)](https://www.php.net/manual/en/oop5.intro.php)
- [PHP Manual: The basics](https://www.php.net/manual/en/language.oop5.basic.php)
- [PHP Manual: Constructors and destructors](https://www.php.net/manual/en/language.oop5.decon.php)
- [Laravel: Controllers](https://laravel.com/docs/13.x/controllers)
- [Laravel: Eloquent ORM](https://laravel.com/docs/13.x/eloquent)
