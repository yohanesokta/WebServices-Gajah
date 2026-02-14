<div align="center">

# Gajah Webserver

**Manajemen Web Stack Lokal untuk Windows dan Linux Menjadi Mudah.**

<p>Sebuah panel kontrol desktop modern berbasis Flutter untuk mengelola Nginx, PHP, MariaDB, PostgreSQL, dan Redis di lingkungan Windows dan Linux.</p>


[![CI – Flutter Tests](https://github.com/yohanesokta/WebServices-Gajah/actions/workflows/flutter-tests.yml/badge.svg)](https://github.com/yohanesokta/WebServices-Gajah/actions/workflows/flutter-tests.yml)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Platform: Windows](https://img.shields.io/badge/Platform-Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.linux.org/)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?style=for-the-badge&logo=conventionalcommits)](https://conventionalcommits.org)

</div>

---

###  Mengapa Gajah Webserver?

Bagi developer yang bekerja di Windows atau Linux, mengelola beberapa layanan web secara terpisah seringkali merepotkan. Proses start/stop service, mengganti versi PHP, atau sekadar melihat log membutuhkan banyak intervensi manual melalui command line atau skrip yang tersebar.

**Gajah Webserver** lahir untuk menyelesaikan masalah ini dengan menyediakan satu antarmuka grafis (GUI) yang intuitif dan terpusat, memungkinkan developer untuk fokus pada coding, bukan pada administrasi environment lokal.

### Demo Aplikasi

<div align="center">

![App Demo Placeholder](https://raw.githubusercontent.com/yohanesokta/WebServices-Gajah/refs/heads/main/pages/example.jpg)

*Contoh demo aplikasi*

</div>

### Instalasi & Setup

#### 1. Prasyarat

Pastikan perangkat Anda telah terinstall:
- **Windows 10/11 (x64)** atau **Distro Linux modern (x64)**
- **[Flutter SDK](https://flutter.dev/docs/get-started/)** (versi stabil)
- **Untuk Windows:** **[Visual Studio](https://visualstudio.microsoft.com/downloads/)** dengan komponen "Desktop development with C++"
- **Untuk Linux:** Pastikan dependensi build yang diperlukan untuk Flutter di Linux sudah terinstal.

#### 2. Proses Instalasi

1.  **Clone Repository:**
    ```bash
    git clone https://github.com/yohanesokta/WebServices-Gajah.git
    cd WebServices-Gajah
    ```

2.  **Install Dependensi Flutter:**
    ```bash
    flutter pub get
    ```

3.  **Setup Environment:**

    *   **Untuk Windows:**
        Klik ganda file `setup.bat`. Skrip ini akan mengunduh binary yang diperlukan dan membuat struktur direktori di `C:\gajahweb`.

        > **Penting:** Pastikan skrip `setup.bat` berjalan hingga selesai tanpa error.

    *   **Untuk Linux:**
        Jalankan skrip `linux.sh` dari direktori `pages`. Skrip ini akan mengunduh binary yang diperlukan dan membuat struktur direktori di `/opt/gajahweb`.

        ```bash
        sudo bash pages/linux.sh
        ```
        > **Penting:** Pastikan skrip `linux.sh` berjalan hingga selesai tanpa error.

4.  **Jalankan Aplikasi:**

    *   **Untuk Windows:**
        ```bash
        flutter run -d windows
        ```
    *   **Untuk Linux:**
        ```bash
        flutter run -d linux
        ```

### Menjalankan Test

- **Jalankan semua test:**
  ```bash
  flutter test
  ```

- **Jalankan test dengan coverage:**
  ```bash
  flutter test --coverage
  ```


Test suite yang tersedia (ringkasan):
- `test/utils/process_test.dart` – cek port/proses/kill/start (Windows-aware)
- `test/utils/runtime_test.dart` – memverifikasi `getConfig()` tidak error
- `test/utils/slide_left_route_test.dart` – `SlideLeftRoute` dapat dibuat
- `test/utils/terminal_context_test.dart` – `Terminalcontext.add()` menyimpan & notif
- `test/model/php_version_test.dart` – `Phpversion.fromMap()`; test network di-skip
- `test/components/mariadb_control_dialog_test.dart` – `showConfirmDialog()` Ya/Tidak
- `test/widget_test.dart` – placeholder aman

### 🤝 Kontribusi

Kontribusi sangat kami harapkan! Silakan buka [Issue](https://github.com/yohanesokta/WebServices-Gajah/issues) atau [Pull Request](https://github.com/yohanesokta/WebServices-Gajah/pulls).


### 📄 Lisensi

Dirilis di bawah [Lisensi MIT](https://opensource.org/licenses/MIT).


## SUPPORT

<div align="center">

<img width="110" src="https://riset-tif.sakera.id/www/logo-tif.png"> 

Kami mengundang Anda untuk mencoba aplikasi ini dan lainya yang dikembangkan sebagai proyek kampus. Lihat [Riset TIF TRUNOJOYO](https://riset-tif.sakera.id)
</div>
