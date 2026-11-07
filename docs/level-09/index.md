# Peta Belajar: Performa dan Skalabilitas

Bab utama ini menjawab pertanyaan: *bagaimana membuat aplikasi tetap cepat saat data dan pengguna bertambah?* Kamu akan belajar mengukur, menemukan bottleneck, mengoptimalkan query dan Eloquent, memakai indeks, cache Redis, HTTP caching, antrean, sesi, Octane, pemantauan, dan merancang skalabilitas.

## Tujuan Pembelajaran

Setelah menyelesaikan bab utama ini, kamu dapat:

- [ ] Mengidentifikasi bottleneck performa dengan pengukuran.
- [ ] Mengoptimalkan query database.
- [ ] Menerapkan cache dengan aman.
- [ ] Memahami skala aplikasi.

## Prasyarat

- Bab utama [Pengujian Laravel](../level-08/index.md) dan sebelumnya.
- Dependensi yang disetujui untuk bab ini: Redis dan Laravel Octane (hanya dipakai pada sub bab yang menyebutnya). Alat opsional seperti Telescope/Pulse tidak diwajibkan.

## Peta Sub Bab

| Sub bab | Yang kamu pelajari | Status |
|---|---|---|
| [Dasar-dasar Performa](09-01-performance-fundamentals.md) | Latensi, persentil, siklus optimasi | Draf |
| [Optimasi Performa Laravel](09-02-laravel-performance-optimization.md) | `optimize`, cache konfigurasi, OPcache | Draf |
| [Optimasi Query Database](09-03-database-query-optimization.md) | Melihat dan memperbaiki query | Draf |
| [Database Indexing](09-04-database-indexing.md) | Indeks komposit dan EXPLAIN | Draf |
| [Eloquent Optimization](09-05-eloquent-optimization.md) | Hidrasi, agregat relasi, operasi massal | Draf |
| [Lazy Loading vs Eager Loading](09-06-lazy-loading-vs-eager-loading.md) | N+1 dan cara mencegahnya | Draf |
| [Redis Cache](09-07-redis-cache.md) | Cache-aside, invalidasi, stampede | Draf |
| [HTTP Caching](09-08-http-caching.md) | `Cache-Control`, ETag, 304 | Draf |
| [Queue Optimization](09-09-queue-optimization.md) | Prioritas, batch, rate limit | Draf |
| [Session Management](09-10-session-management.md) | Driver sesi dan skala | Draf |
| [Laravel Octane](09-11-laravel-octane.md) | Aplikasi di memori, risiko status | Draf |
| [Profiling dan Monitoring](09-12-profiling-and-monitoring.md) | Ukur permintaan, RED/USE | Draf |
| [Application Scalability](09-13-application-scalability.md) | Stateless, load balancer, replika | Draf |
| [Proyek: Performance Optimization for Article Management](proyek-optimasi-performa-artikel.md) | Optimasi berbasis pengukuran | Draf |

!!! info "Status materi"
    Seluruh 13 sub bab dan proyek praktik sudah tersedia (berstatus **DRAFT**). Tidak ada pengukuran yang dilakukan penulis; semua hasil harus kamu ukur sendiri pada mesinmu.

## Referensi Resmi

- [Laravel: Deployment, Optimization](https://laravel.com/docs/13.x/deployment#optimization)
- [Laravel: Octane](https://laravel.com/docs/13.x/octane)
- [Laravel: Cache](https://laravel.com/docs/13.x/cache)
