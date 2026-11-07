# Peta Belajar: Pengujian Laravel

Bab utama ini menjawab pertanyaan: *bagaimana aku tahu perubahan kode tidak merusak yang sudah berfungsi?* Kamu akan menulis uji unit dan fitur, menguji autentikasi, otorisasi, dan API, memakai fake dan factory secara efektif, mengukur cakupan, dan mendiagnosis galat secara sistematis.

## Tujuan Pembelajaran

Setelah menyelesaikan bab utama ini, kamu dapat:

- [ ] Menulis uji unit dan fitur.
- [ ] Menguji endpoint API.
- [ ] Memverifikasi perilaku autentikasi dan otorisasi.
- [ ] Memakai fake, factory, dan cakupan secara bijak.

## Prasyarat

- Bab utama [Fitur Laravel Lanjutan](../level-07/index.md) dan sebelumnya.
- Pest bersifat opsional (dependensi dev tambahan); materi memakai PHPUnit bawaan. Pengukuran cakupan memerlukan Xdebug atau PCOV.

## Peta Sub Bab

| Sub bab | Yang kamu pelajari | Status |
|---|---|---|
| [Pengantar Software Testing](08-01-introduction-to-software-testing.md) | Mengapa dan jenis pengujian | Draf |
| [Dasar Pengujian](08-02-testing-fundamentals.md) | `phpunit.xml`, lingkungan, menjalankan uji | Draf |
| [PHPUnit dan Pest](08-03-phpunit-and-pest.md) | Dua gaya, asersi, data provider | Draf |
| [Unit Testing](08-04-unit-testing.md) | Uji terisolasi, kasus batas | Draf |
| [Feature Testing](08-05-feature-testing.md) | Permintaan HTTP utuh dengan factory | Draf |
| [HTTP Testing](08-06-http-testing.md) | Metode, asersi respons, redirect | Draf |
| [Database Testing](08-07-database-testing.md) | Reset DB dan asersi database | Draf |
| [Authentication Testing](08-08-authentication-testing.md) | `actingAs`, login, verifikasi | Draf |
| [Authorization Testing](08-09-authorization-testing.md) | Matriks peran, Policy, IDOR | Draf |
| [API Testing](08-10-api-testing.md) | JSON, Sanctum, kontrak | Draf |
| [Mocking](08-11-mocking.md) | Fake, mock, waktu | Draf |
| [Factories in Testing](08-12-factories-in-testing.md) | State, relasi, data deterministik | Draf |
| [Test Coverage](08-13-test-coverage.md) | Mengukur dan menafsirkan cakupan | Draf |
| [Debugging dan Diagnosis Error](08-14-debugging-and-error-diagnosis.md) | Alur diagnosis dan uji regresi | Draf |
| [Proyek: Automated Testing for Article Management](proyek-pengujian-otomatis-artikel.md) | Suite pengujian lengkap | Draf |

!!! info "Status materi"
    Seluruh 14 sub bab dan proyek praktik sudah tersedia (berstatus **DRAFT**). Kode uji belum dijalankan penulis pada aplikasi Laravel sungguhan; hasil yang diharapkan diturunkan dari dokumentasi dan perlu kamu cocokkan.

## Referensi Resmi

- [Laravel: Testing](https://laravel.com/docs/13.x/testing)
- [Laravel: HTTP Tests](https://laravel.com/docs/13.x/http-tests)
- [Laravel: Mocking](https://laravel.com/docs/13.x/mocking)
