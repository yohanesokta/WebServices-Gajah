# Panduan Kontribusi (CONTRIBUTING)

Terima kasih sudah tertarik berkontribusi pada Gajah Webserver! Dokumen ini menjelaskan alur kerja, standar coding, cara menjalankan test, serta checklist sebelum membuka Pull Request (PR).

## Cara Berkontribusi
- Laporkan bug atau usulan fitur baru melalui Issues (sertakan langkah reproduksi/tujuan).
- Buat perbaikan atau fitur melalui Pull Request.
- Perbaiki dokumentasi (README, panduan, contoh penggunaan, dsb.).

## Alur Kerja (Workflow)
1. Fork repository ini ke akun GitHub Anda.
2. Clone hasil fork ke mesin lokal:
   ```bash
   git clone https://github.com/yohanesokta/WebServices-Gajah.git
   cd WebServices-Gajah
   ```
3. Buat branch baru untuk perubahan Anda:
   ```bash
   git checkout -b feat/nama-fitur-anda
   # atau
   git checkout -b fix/bug-yang-diperbaiki
   ```
4. Siapkan lingkungan pengembangan:
   - Pastikan Flutter (stable) terpasang dan terdeteksi: `flutter doctor`
   - Install dependensi: `flutter pub get`
   - (Opsional, disarankan) Jalankan `setup.bat` untuk bootstrap asset native & konfigurasi Windows lokal.
5. Lakukan perubahan kode. Ikuti standar coding & style (lihat bagian di bawah).
6. Tambahkan/ubah unit test/widget test yang relevan.
7. Format & lint:
   ```bash
   dart format .
   flutter analyze
   ```
8. Jalankan seluruh test dan pastikan sukses:
   ```bash
   flutter test
   # atau dengan laporan cakupan (coverage)
   flutter test --coverage
   ```
9. Commit perubahan Anda dengan format Conventional Commits (lihat bagian Commit Message).
10. Push branch ke fork Anda lalu buka Pull Request (PR) ke branch utama repo ini.
11. Pastikan CI (GitHub Actions) lulus di PR Anda.

## Standar Coding & Struktur Proyek
- Proyek ini menggunakan `flutter_lints`. Pastikan `flutter analyze` bebas error.
- Format kode dengan `dart format .` sebelum commit.
- Struktur direktori ringkas:
  - `lib/components/` – widget kontrol layanan (nginx, mariadb, redis, postgresql)
  - `lib/components/part/` – halaman About, Download, Settings
  - `lib/utils/` – utilitas proses/port/runtime/route/terminal context
  - `lib/model/` – model data (mis. versi PHP)
  - `test/` – unit & widget tests
  - `resource/` – skrip .bat & utilitas native
- Hindari menyimpan file besar/biner yang tidak perlu ke repo.
- Jangan commit credential/secrets. Gunakan variabel lingkungan bila diperlukan.

## Menulis Test
- Tambahkan unit test untuk utilitas/logika (mis. `lib/utils` & `lib/model`).
- Tambahkan widget test untuk UI/komponen interaktif bila memungkinkan.
- Contoh perintah:
  ```bash
  # Semua test
  flutter test

  # Coverage
  flutter test --coverage

  # File tertentu
  flutter test test/utils/process_test.dart
  ```
- Test yang menyentuh proses Windows sudah diberi pengaman `Platform.isWindows`. Pastikan test baru yang spesifik Windows juga diberi guard serupa.
- Hindari ketergantungan jaringan dalam unit test. Bila perlu, gunakan skip atau mock.

## Commit Message (Conventional Commits)
Gunakan format berikut:
```
<type>(optional-scope): <deskripsi singkat>

<body opsional>
<footer opsional>
```
Tipe yang umum digunakan:
- feat: fitur baru
- fix: perbaikan bug
- docs: perubahan dokumentasi
- style: perubahan gaya (formatting, whitespace) tanpa mengubah logika
- refactor: perubahan kode tanpa fitur/bugfix
- test: menambah/memperbaiki test
- chore: pembaruan tooling, build, CI, dsb.

Contoh:
- `feat(nginx): tambah tombol reload konfigurasi`
- `fix(mariadb): perbaiki deteksi status proses mysqld.exe`
- `test: tambahkan test untuk SlideLeftRoute`

## Pull Request Checklist
Sebelum membuka PR, pastikan:
- [ ] Kode sudah diformat (dart format .)
- [ ] Lint lulus (`flutter analyze`)
- [ ] Test relevan ditambahkan/diubah
- [ ] Semua test lulus (`flutter test`)
- [ ] Deskripsi PR jelas (tujuan, perubahan kunci, dampak)
- [ ] Tidak ada secrets atau file biner yang tidak perlu

## Continuous Integration (CI)
- PR akan memicu workflow GitHub Actions untuk menjalankan `flutter test --coverage` di Ubuntu & Windows.
- Pastikan semua job CI lulus sebelum PR direview/di-merge.

## Lisensi & Hak Cipta
Dengan mengirim kontribusi, Anda setuju bahwa kontribusi tersebut dirilis di bawah lisensi proyek ini (MIT). Lihat file LICENSE untuk detail.

Terima kasih atas kontribusinya! 🙌

