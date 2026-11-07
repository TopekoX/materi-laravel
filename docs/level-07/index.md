# Peta Belajar: Fitur Laravel Lanjutan

Bab utama ini menjawab pertanyaan: *bagaimana aplikasi Laravel diorganisasi dan dijalankan di latar belakang?* Kamu akan memahami service container, provider, dan dependency injection; memisahkan logika lewat repository dan service layer; lalu memakai event, antrean, jadwal, cache, Redis, email, notifikasi, penyimpanan berkas, log, broadcasting real-time, dan lokalisasi.

## Tujuan Pembelajaran

Setelah menyelesaikan bab utama ini, kamu dapat:

- [ ] Menerapkan dependency injection dan memahami service container.
- [ ] Menjalankan pekerjaan latar belakang dengan job dan queue.
- [ ] Memakai cache dan Redis secara aman.
- [ ] Mengirim email dan notifikasi.
- [ ] Mengelola berkas, log, dan teks multibahasa.

## Prasyarat

- Bab utama [Pengembangan REST API](../level-06/index.md) dan sebelumnya.
- Dependensi tambahan yang disetujui untuk bab ini: Redis (server + klien PHP) dan Laravel Reverb. Keduanya digunakan hanya pada sub bab yang menyebutnya.

## Peta Sub Bab

| Sub bab | Yang kamu pelajari | Status |
|---|---|---|
| [Service Container](07-01-service-container.md) | Penyuntikan otomatis, binding, singleton | Draf |
| [Service Providers](07-02-service-providers.md) | `register()` vs `boot()`, `make:provider` | Draf |
| [Dependency Injection](07-03-dependency-injection.md) | Injeksi constructor dan method | Draf |
| [Contracts dan Interface](07-04-contracts-and-interfaces.md) | Kontrak, driver lewat konfigurasi | Draf |
| [Facades](07-05-facades.md) | Proxy statis ke container | Draf |
| [Repository Pattern](07-06-repository-pattern.md) | Query bernama di balik contract | Draf |
| [Service Layer Pattern](07-07-service-layer-pattern.md) | Aturan bisnis di service | Draf |
| [Events dan Listeners](07-08-events-and-listeners.md) | Event, listener, event discovery | Draf |
| [Jobs dan Queues](07-09-jobs-and-queues.md) | Job, antrean, percobaan, gagal | Draf |
| [Queue Workers](07-10-queue-workers.md) | `queue:work`, restart, Supervisor | Draf |
| [Task Scheduling](07-11-task-scheduling.md) | Jadwal di kode, satu entri cron | Draf |
| [Cache Management](07-12-cache-management.md) | `remember`, TTL, invalidasi, lock | Draf |
| [Redis Integration](07-13-redis-integration.md) | Redis untuk cache, antrean, sesi | Draf |
| [Mail Configuration](07-14-mail-configuration.md) | Mailer, Mailable, antrean | Draf |
| [Notifications](07-15-notifications.md) | Kanal mail dan database | Draf |
| [File Storage](07-16-file-storage.md) | Disk publik/privat, unduhan aman | Draf |
| [Laravel Filesystem](07-17-laravel-filesystem.md) | API `Storage` lengkap | Draf |
| [Logging](07-18-logging.md) | Channel, level, konteks | Draf |
| [Broadcasting](07-19-broadcasting.md) | Reverb, channel, otorisasi | Draf |
| [Real-Time Events](07-20-real-time-events.md) | Laravel Echo di browser | Draf |
| [Localization dan Translation](07-21-localization-and-translation.md) | `__()`, jamak, locale aman | Draf |
| [Proyek: Background Email and Notification System](proyek-email-notifikasi-latar-belakang.md) | Perakitan alur latar belakang | Draf |

!!! info "Status materi"
    Seluruh 21 sub bab dan proyek praktik sudah tersedia (berstatus **DRAFT**). Kode belum dijalankan penulis pada aplikasi Laravel sungguhan; hasil yang diharapkan diturunkan dari dokumentasi dan perlu kamu cocokkan.

## Referensi Resmi

- [Laravel: Service Container](https://laravel.com/docs/13.x/container)
- [Laravel: Queues](https://laravel.com/docs/13.x/queues)
- [Laravel: Events](https://laravel.com/docs/13.x/events)
