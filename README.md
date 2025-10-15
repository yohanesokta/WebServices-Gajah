<div align="center">

# Gajah Webserver

Mengelola Nginx, PHP, MariaDB, Apache ( NEW )* PostgreSQL, dan Redis di Windows melalui aplikasi desktop Flutter.

<!-- Ganti OWNER/REPO di badge berikut setelah repo dipush ke GitHub -->
[![CI – Flutter Tests](https://github.com/yohanesokta/WebServices-Gajah/actions/workflows/flutter-tests.yml/badge.svg)](https://github.com/yohanesokta/WebServices-Gajah/actions/workflows/flutter-tests.yml)

![Flutter](https://img.shields.io/badge/Flutter-stable-%2302569B?logo=flutter&logoColor=white&labelColor=0D1117&style=for-the-badge)
![Windows](https://img.shields.io/badge/Platform-Windows-0078D6?logo=windows&logoColor=white&labelColor=0D1117&style=for-the-badge)
![Nginx](https://img.shields.io/badge/Nginx-%23009639?logo=nginx&logoColor=white&labelColor=0D1117&style=for-the-badge)
![MariaDB](https://img.shields.io/badge/MariaDB-003545?logo=mariadb&logoColor=white&labelColor=0D1117&style=for-the-badge)
![PHP](https://img.shields.io/badge/PHP-%23777BB4?logo=php&logoColor=white&labelColor=0D1117&style=for-the-badge)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?logo=postgresql&logoColor=white&labelColor=0D1117&style=for-the-badge)
![Redis](https://img.shields.io/badge/Redis-%23DD0031?logo=redis&logoColor=white&labelColor=0D1117&style=for-the-badge)

</div>

## Ringkasan
Gajah Webserver adalah panel kontrol desktop untuk Web Stack lokal di Windows. Aplikasi ini mempermudah start/stop service (Nginx, PHP-CGI, MariaDB, PostgreSQL, Redis), mengganti versi PHP, mengelola port, serta menyediakan log terminal terintegrasi.

## Fitur Utama
- Nginx + PHP-CGI starter/stopper (port configurable)
- MariaDB (mysqld) starter/stopper dan shortcut ke phpMyAdmin
- PostgreSQL starter/stopper beserta shortcut psql CLI
- Redis starter/stopper beserta shortcut redis-cli
- XAMPP-sameless: toggle htdocs (C:\\gajahweb\\htdocs <-> C:\\xampp\\htdocs)
- Halaman pengaturan (port & path), dan pembuka file konfigurasi (php.ini, nginx.conf, my.ini)
- Halaman unduhan versi PHP (stable/arsip) dan switcher otomatis
- Log terminal realtime di aplikasi

## Persyaratan
- Windows 10/11 (x64)
- Flutter stable (Dart SDK sesuai pubspec)
- Visual Studio dengan komponen "Desktop development with C++"

## Instalasi Cepat
1. Clone repo ini dan jalankan dependensi:
   ```bash
   flutter pub get
   ```
2. Jalankan bootstrap untuk aset native dan konfigurasi dasar:
   - Klik ganda `setup.bat` (tersedia di root repo)
3. Jalankan aplikasi (Windows desktop):
   ```bash
   flutter run -d windows
   ```

> Catatan: Aplikasi mengandalkan path `C:\gajahweb` untuk binary Nginx/PHP/MariaDB/PostgreSQL/Redis dan resource .bat yang sudah disertakan pada folder `resource/`. Pastikan `setup.bat` selesai tanpa error.

## Konfigurasi
- Port default: Nginx 80, MariaDB 3306, PostgreSQL 5432 (dapat diubah pada halaman Settings)
- Htdocs default: `C:\\gajahweb\\htdocs` (dapat toggle ke `C:\\xampp\\htdocs` via XAMPP-sameless)
- Shortcut untuk membuka `php.ini`, `nginx.conf`, dan `my.ini` via Notepad tersedia di Settings.

## Menjalankan Test
Proyek ini menggunakan unit dan widget test Flutter.
- Jalankan seluruh test:
  ```bash
  flutter test
  ```
- Dengan coverage:
  ```bash
  flutter test --coverage
  ```
- Menjalankan test tertentu (contoh):
  ```bash
  flutter test test/utils/process_test.dart
  ```

Test suite yang tersedia (ringkasan):
- `test/utils/process_test.dart` – cek port/proses/kill/start (Windows-aware)
- `test/utils/runtime_test.dart` – memverifikasi `getConfig()` tidak error
- `test/utils/slide_left_route_test.dart` – `SlideLeftRoute` dapat dibuat
- `test/utils/terminal_context_test.dart` – `Terminalcontext.add()` menyimpan & notif
- `test/model/php_version_test.dart` – `Phpversion.fromMap()`; test network di-skip
- `test/components/mariadb_control_dialog_test.dart` – `showConfirmDialog()` Ya/Tidak
- `test/widget_test.dart` – placeholder aman

## Integrasi CI
Workflow GitHub Actions disertakan untuk menjalankan test otomatis pada push/PR.
- File: `.github/workflows/flutter-tests.yml`
- Matrix: `ubuntu-latest`, `windows-latest`
- Output: mengunggah artifact coverage `coverage/lcov.info`

Tambahkan badge status CI di bagian header README dengan mengganti `OWNER/REPO` sesuai repo GitHub Anda:



## Struktur Proyek (ringkas)
- `lib/components/` – widget kontrol layanan (nginx, mariadb, redis, postgresql)
- `lib/components/part/` – halaman About, Download, Settings
- `lib/utils/` – utilitas proses/port/runtime/route/terminal context
- `lib/model/` – model data versi PHP
- `test/` – unit & widget tests
- `resource/` – skrip .bat dan utilitas pendukung native
- `setup.bat` – bootstrap lingkungan lokal

## Kontribusi
Kontribusi sangat diterima! Buka issue/PR untuk bugfix, fitur, atau peningkatan dokumentasi. Gunakan format pesan commit ala Conventional Commits (feat, fix, docs, style, refactor, chore).

## Lisensi
Dirilis di bawah [MIT License](https://opensource.org/licenses/MIT).
