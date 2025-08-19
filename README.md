
<div align="center">
  
# Gajah Webserver

![commit](https://img.shields.io/github/commits-since/yohanesokta/WebServices-Gajah/latest) ![release](https://img.shields.io/github/release-date/yohanesokta/WebServices-Gajah) ![GitHub License](https://img.shields.io/github/license/yohanesokta/WebServices-Gajah)

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white) ![Visual Studio](https://img.shields.io/badge/Visual%20Studio-5C2D91.svg?style=for-the-badge&logo=visual-studio&logoColor=white) ![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)	![MariaDB](https://img.shields.io/badge/MariaDB-003545?style=for-the-badge&logo=mariadb&logoColor=white) ![PHP](https://img.shields.io/badge/php-%23777BB4.svg?style=for-the-badge&logo=php&logoColor=white)  	![Redis](https://img.shields.io/badge/redis-%23DD0031.svg?style=for-the-badge&logo=redis&logoColor=white)

</div>

Selamat datang di **Gajah Webserver** Proyek ini menyediakan paket web server yang mudah digunakan untuk pengembangan lokal, yang mencakup Nginx, PHP 8.4, dan MariaDB (MySQL). Proyek ini juga terintegrasi dengan Flutter untuk pengembangan aplikasi web dan desktop.

## ✨ Fitur Unggulan

  * **Nginx**: Server web berkinerja tinggi, ringan, dan andal.
  * **PHP 8.4**: Versi terbaru PHP untuk performa optimal dan fitur modern.
  * **MariaDB**: Sistem manajemen database relasional yang cepat dan sepenuhnya kompatibel dengan MySQL.
  * **Integrasi Flutter**: Lingkungan yang sudah dikonfigurasi untuk menjalankan aplikasi web dan desktop Flutter dengan mudah di Windows.

-----

## 🚀 Memulai

Ikuti langkah-langkah sederhana di bawah ini untuk segera memulai. diperlukan visual studio dan runtime Desktop Development with C++ wajib!

### Langkah 1: Pengaturan Awal

1.  Pastikan Anda telah mengunduh atau mengkloning repositori ini.
2.  Jalankan `setup.bat` dengan mengklik dua kali. Skrip ini akan secara otomatis menginstal dan mengonfigurasi semua komponen yang diperlukan.

### Langkah 2: Memverifikasi Instalasi

Setelah skrip selesai, verifikasi instalasi Flutter Anda:

```bash
flutter doctor
```

Jika ada masalah, ikuti instruksi yang diberikan oleh **`flutter doctor`** untuk menyelesaikannya.

### Langkah 3: Menjalankan Aplikasi

Jalankan aplikasi Flutter Anda di lingkungan Windows:

```bash
flutter run -d windows
```

Aplikasi desktop Flutter Anda akan segera diluncurkan di jendela baru.

-----

## 🤝 Kontribusi

Kami sangat menghargai setiap bentuk kontribusi, baik berupa perbaikan bug, fitur baru, atau dokumentasi. Kontribusi Anda membuat proyek ini lebih baik!

### ⚙️ Alur Kontribusi

1.  **Fork** repositori ini ke akun GitHub Anda.
2.  **Clone** repositori yang telah Anda *fork* ke komputer lokal Anda:
    ```bash
    git clone https://github.com/your-username/gajah-webserver.git
    ```
3.  Buat **branch baru** untuk fitur atau perbaikan Anda:
    ```bash
    git checkout -b feature/nama-fitur-anda
    ```
4.  Lakukan perubahan yang Anda inginkan.
5.  **Commit** perubahan Anda dengan pesan yang jelas dan deskriptif:
    ```bash
    git commit -m "feat: tambahkan fitur baru untuk ..."
    ```
6.  **Push** perubahan ke repositori Anda:
    ```bash
    git push origin feature/nama-fitur-anda
    ```
7.  Buka repositori yang Anda *fork* di GitHub dan buat **Pull Request** ke *branch* utama (biasanya `main` atau `master`) dari repositori ini.

### 📝 Panduan Pesan Commit

Untuk menjaga riwayat *commit* tetap bersih dan terstruktur, mohon gunakan standar [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) dalam pesan Anda, misalnya:

  * `feat`: Menambahkan fitur baru.
  * `fix`: Perbaikan bug.
  * `docs`: Perubahan dokumentasi saja.
  * `style`: Perubahan format kode (spasi, *linting*, dll).
  * `refactor`: Perubahan kode yang tidak menambah fitur atau perbaikan bug.
  * `chore`: Perubahan pada proses build, alat bantu, dll.

-----

## 📝 Lisensi

Proyek ini dirilis di bawah lisensi [**MIT License**](https://opensource.org/licenses/MIT). Anda dapat menemukan detail selengkapnya di file `LICENSE`.

-----