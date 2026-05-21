# Patch 3.0

## 1. Webservice Config Initialization

Kami telah mengoptimalkan semua file konfigurasi dasar (seperti `nginx.conf` dan `php.ini`) untuk meningkatkan penggunaan di tingkat lokal (Local Environment).

Pembaruan yang ditambahkan ke konfigurasi meliputi:
- Peningkatan batas unggahan (Upload Max Filesize, Post Max Size, Client Max Body Size) ke fleksibilitas 512MB (dari default 2M/8M).
- Penambahan placeholder dinamis untuk mempermudah injeksi Path dan Port secara programatik oleh aplikasi. Placeholder yang sekarang didukung meliputi:
  - `__PORT__` / `__nginx_port__` : Port untuk Nginx 
  - `__PHP_PORT__` : Port untuk fastcgi PHP (menggantikan default 9000).
  - `__LOG_DIR__` : Folder untuk access.log dan error.log baik Nginx dan PHP.
  - `__TEMP_DIR__` : Folder temporary untuk service (client_temp, proxy_temp, pid, sessions).
  - `__UPLOAD_DIR__` : Folder temporary uploads untuk PHP.

*Catatan: Semua file pada template bawaan (*.template / *.ini*) tetap dipertahankan penamaannya demi menghindari kerusakan instalasi bawaan.*

## 2. Peningkatan Fitur kontrol pgAdmin 4

Kontrol pgAdmin 4 pada antarmuka aplikasi kini lebih stabil dan canggih:
- **Dukungan Multi-Platform (Linux & Windows)**:
  Skrip bawaan telah dimodifikasi agar dapat berjalan mulus di Windows (di `C:\gajahweb\pgadmin`) maupun pada Linux (di `~/.gajahweb/pgadmin`).
- **Pendeteksian Virtual Environment (Venv)**:
  Sistem kini tidak mengeksekusi pgAdmin secara asal-asalan. Kami mengecek apakah Virtual Environment Python di dalam folder pgadmin sudah terinstal beserta paket `pgadmin4`.
- **Fitur Download Otomatis**:
  Jika deteksi modul pgAdmin4 gagal atau belum ada, tombol sakelar pgAdmin akan berubah menjadi mode Instal/Download (Ikon panah ke bawah). Ketika diklik, sistem akan otomatis:
  1. Membuat direktori root.
  2. Menjalankan modul Python `venv` untuk membuat lingkungan independen.
  3. Menggunakan Pip di dalam venv tersebut untuk menginstal `pgadmin4`.
  4. Semua progres tersebut terlihat pada Konsol internal aplikasi.

*(Selesai dan direvisi tanggal 2026-05-22)*
