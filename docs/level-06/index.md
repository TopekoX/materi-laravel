# Peta Belajar: Pengembangan REST API

Bab utama ini menjawab pertanyaan: *bagaimana aplikasi Laravel melayani program lain, bukan hanya browser?* Kamu akan belajar prinsip REST, merancang endpoint, membangun API dengan controller dan API Resource,
memvalidasi input, menangani galat secara seragam, serta menyediakan paginasi, penyaringan, dan pencarian. Kamu juga mengamankan API dengan Sanctum, membatasi laju, mengelola versi, mendokumentasikan, mengujinya, dan memanggilnya dari frontend.

## Tujuan Pembelajaran

Setelah menyelesaikan bab utama ini, kamu dapat:

- [ ] Membangun endpoint REST dengan routing, controller, dan API Resource.
- [ ] Menerapkan autentikasi dan otorisasi API.
- [ ] Menangani respons JSON dan galat secara konsisten.
- [ ] Menguji endpoint API.

## Prasyarat

- Bab utama [Database dan Eloquent ORM](../level-04/index.md) dan [Validasi, Autentikasi, dan Keamanan](../level-05/index.md).

## Peta Sub Bab

| Sub bab | Yang kamu pelajari | Status |
|---|---|---|
| [Pengantar REST API](06-01-introduction-to-rest-api.md) | API, klien, dan REST dalam ringkasan | Draf |
| [Arsitektur REST](06-02-rest-architecture.md) | Batasan REST, aturan URL, peta endpoint | Draf |
| [Metode HTTP](06-03-http-methods.md) | `GET`, `POST`, `PUT`, `PATCH`, `DELETE`, JSON di request | Draf |
| [Kode Status HTTP](06-04-http-status-codes.md) | Memilih kode status yang tepat | Draf |
| [Format Data JSON](06-05-json-data-format.md) | Sintaks JSON dan konvensi respons | Draf |
| [Routing API](06-06-api-routing.md) | `routes/api.php`, awalan versi, `apiResource` | Draf |
| [Controller API](06-07-api-controllers.md) | Endpoint baca dengan JSON eksplisit | Draf |
| [Controller Resource API](06-08-api-resource-controllers.md) | CRUD API dengan pelindung kunci sementara | Draf |
| [Transformasi API Resource](06-09-api-resource-transformation.md) | `JsonResource`, `whenLoaded`, `toResource` | Draf |
| [Validasi Request API](06-10-api-request-validation.md) | Form Request API dan respons 422 | Draf |
| [Penanganan Error API](06-11-api-error-handling.md) | Format galat seragam dan `request_id` | Draf |
| [Paginasi API](06-12-api-pagination.md) | `links`, `meta`, offset vs kursor | Draf |
| [Penyaringan dan Pencarian API](06-13-api-filtering-and-searching.md) | `filter[...]`, `q`, `sort`, `include` | Draf |
| [Autentikasi API](06-14-api-authentication.md) | Token, Bearer, abilities, Sanctum vs Passport | Draf |
| [Laravel Sanctum](06-15-laravel-sanctum.md) | Pemasangan, `HasApiTokens`, `auth:sanctum` | Draf |
| [Autentikasi Berbasis Token](06-16-token-based-authentication.md) | Login, abilities, logout, pencabutan | Draf |
| [Otorisasi API](06-17-api-authorization.md) | Policy, abilities, 401 vs 403, IDOR | Draf |
| [Pembatasan Laju API](06-18-api-rate-limiting.md) | Pembatas bernama, 429, `Retry-After` | Draf |
| [Konsep Versi API](06-19-api-versioning-concepts.md) | Perubahan merusak, `v1`/`v2`, `Sunset` | Draf |
| [Dokumentasi API](06-20-api-documentation.md) | OpenAPI 3.1 tulis tangan | Draf |
| [Pengujian API dengan Postman](06-21-api-testing-with-postman.md) | Koleksi, variabel, skrip uji | Draf |
| [Integrasi API dengan Frontend](06-22-frontend-api-integration.md) | CORS, `fetch`, penyimpanan token | Draf |
| [Proyek: Article Management REST API](proyek-rest-api-artikel.md) | Perakitan API lengkap | Draf |

!!! info "Status materi"
    Seluruh 22 sub bab dan proyek praktik sudah tersedia (berstatus **DRAFT**). Kode belum dijalankan penulis pada aplikasi Laravel sungguhan; hasil yang diharapkan diturunkan dari dokumentasi dan perlu kamu cocokkan.

## Referensi Resmi

- [Laravel: Routing, API Routes](https://laravel.com/docs/13.x/routing#api-routes)
- [Laravel: Eloquent API Resources](https://laravel.com/docs/13.x/eloquent-resources)
- [Laravel: Sanctum](https://laravel.com/docs/13.x/sanctum)
