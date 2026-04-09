# Task: Optimasi Monitoring Proses Windows

## Deskripsi
Mengubah cara pengecekan status proses di Windows dari pemanggilan `winproc_scan.exe` setiap kali `checkProcess` dipanggil menjadi sistem monitoring periodik (latar belakang) yang memperbarui data secara kolektif.

## Sub-Tasks
1.  **Definisi Daftar Proses**: Menentukan daftar lengkap executable yang akan dipantau oleh `winproc_scan.exe`.
2.  **Inisialisasi Data**: Menyiapkan variabel `processData` agar terinisialisasi dengan benar sejak awal aplikasi.
3.  **Implementasi Periodic Timer**: Membuat fungsi untuk menjalankan `listenPrograms` secara berkala (misalnya setiap 2 detik) menggunakan `Timer.periodic`.
4.  **Refaktorisasi `listenPrograms`**: Memastikan fungsi ini menerima daftar proses dan memperbarui variabel global `processData`.
5.  **Optimasi `checkProcess`**: Mengubah logika `checkProcess` untuk hanya mencari di dalam `processData` yang sudah ada, alih-alih menjalankan proses eksternal baru.
6.  **Integrasi Start/Stop Monitoring**: Memastikan monitoring dimulai saat aplikasi berjalan dan berhenti saat aplikasi ditutup (opsional jika dibutuhkan).

## Target File
- `lib/utils/process.dart`
- `lib/main.dart` (untuk inisialisasi)
