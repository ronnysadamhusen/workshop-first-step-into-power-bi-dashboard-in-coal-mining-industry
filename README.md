# Workshop First Step Into Power BI Dashboard in Coal Mining Industry
Selamat datang! Workshop ini akan mengenalkan dasar Microsoft Power BI dan bagaimana penggunaannya di industri tambang batu bara yang menggunakan teknologi FMS (Fleet Management System).

Pada workshop ini akan dijelaskan tentang:
1. Apa itu Power BI.
2. Kapan menggunakan aplikasi Power BI.
3. Skema lisensi apa saja yang tersedia untuk menggunakan Power BI.
4. Bagaimana Power BI digunakan dalam industri tambang batu bara yang menggunakan FMS.
5. Hands-on menghubungkan Power BI ke database FMS (dummy)
6. Hands-on menyiapkan data FMS menggunakan Power Query di Power BI
7. Hands-on melakukan modeling data di Power BI
8. Hands-on membuat measure menggunakan DAX (Data Analysis Expression)
9. Hands-on membuat chart di Power BI
10. Hands-on membuat slicer atau filter di Power BI

---

# Panduan Persiapan Peserta

Agar workshop berjalan lancar dan Anda dapat mengikuti sesi praktik secara langsung, harap pastikan perangkat laptop/PC Anda memenuhi spesifikasi berikut dan lakukan persiapan sebelum hari pelaksanaan.

---

## 💻 Persyaratan Sistem (System Requirements)

Workshop ini menggunakan **Docker Desktop** untuk menjalankan database dan **Power BI Desktop** untuk visualisasi. Berikut adalah spesifikasi minimum yang diperlukan:

| Komponen | Spesifikasi Minimum | Spesifikasi Rekomendasi |
| --- | --- | --- |
| **Sistem Operasi** | Windows 10/11 (64-bit) Home/Pro | Windows 11 (64-bit) Pro |
| **Processor** | Intel Core i3 / AMD Ryzen 3 | Intel Core i5 / AMD Ryzen 5 ke atas |
| **RAM** | 8 GB | 16 GB (Sangat disarankan) |
| **Penyimpanan** | 10 GB ruang kosong (SSD lebih baik) | 20 GB ruang kosong |
| **Fitur BIOS** | **Hardware Virtualization** Aktif | **Hardware Virtualization** Aktif |

> [!IMPORTANT]
> **Virtualization** adalah syarat mutlak agar Docker bisa berjalan. Pastikan fitur ini sudah aktif di BIOS laptop Anda. Anda bisa mengeceknya di *Task Manager > Performance > CPU > Virtualization: Enabled*.

---

## 🛠️ Hal-Hal yang Harus Disiapkan

Harap selesaikan langkah-langkah di bawah ini **sebelum workshop dimulai**:

### 1. Hak Akses Administrator

Pastikan Anda menggunakan akun **Administrator** di laptop Anda. Pengaturan Docker, instalasi software, dan pembuatan folder di drive `C:/` membutuhkan izin akses penuh.

### 2. Koneksi Internet Stabil

Anda akan mengunduh total sekitar **1.5 - 2 GB** data (Installer Docker, Image Database, dan Power BI Desktop). Pastikan kuota dan sinyal mencukupi.

### 3. Eksekusi Skrip Setup Otomatis

Saya telah menyediakan skrip **All-in-One** untuk memudahkan persiapan Anda. Download dan jalankan skrip [Setup_Workshop_PBI.bat](https://github.com/ronnysadamhusen/workshop-first-step-into-power-bi-dashboard-in-coal-mining-industry/blob/main/Setup_Workshop_PBI.bat) sebagai Administrator.

**Apa yang dilakukan skrip ini?**
* Mengecek dan **Menginstal Power BI Desktop** (jika belum ada).
* Menginstal **Docker Desktop**.
* Menjalankan **Azure SQL Edge** (Database Engine yang ringan & stabil).
* Menyiapkan user akses `dec` dan database latihan.

**Cara Menjalankan:**

1.  Download file skrip [Setup_Workshop_PBI.bat](https://github.com/ronnysadamhusen/workshop-first-step-into-power-bi-dashboard-in-coal-mining-industry/blob/main/Setup_Workshop_PBI.bat)
2.  Klik kanan file tersebut.
3.  Pilih **Run as Administrator**.
4.  Ikuti instruksi yang muncul di layar hitam (CMD).
5.  **PENTING:** Jika diminta **Restart**, silakan lakukan, lalu jalankan ulang skrip tersebut setelah laptop menyala kembali.
6.  Setelah instalasi Docker selesai, jika muncul jendela *Docker Desktop Subscription Service Agreement*, silakan klik **Accept** (Anda bisa *Skip* bagian login/sign-up).

> [!TIP]
> Jika skrip gagal menginstal Power BI secara otomatis karena kendala jaringan, Anda dapat mengunduhnya secara manual melalui [Microsoft Store Link](https://aka.ms/pbidesktopstore).

---

## 📝 Detail Akses Database (Setelah Setup Selesai)

Setelah skrip menampilkan pesan **"SETUP BERHASIL"**, Anda akan memiliki akses database lokal dengan detail berikut untuk digunakan di Power BI:

* **Server:** `localhost`
* **Database Engine:** Azure SQL Edge
* **Username:** `dec`
* **Password:** `Siapbisa@2026`
* **Port:** `1433`

---

## ❓ FAQ & Troubleshooting

**Q: Docker saya tidak mau start, muncul pesan "WSL 2 installation is incomplete".**
A: Silakan unduh update kernel WSL2 dari Microsoft di [link ini](https://aka.ms/wsl2kernel), instal, lalu coba buka kembali Docker Desktop.

**Q: Apakah data saya akan hilang jika saya mematikan laptop?**
A: **Tidak.** Skrip versi terbaru menggunakan fitur *Docker Named Volume* (`sql_volume_wspbi`). Data Anda tersimpan aman di dalam sistem Docker dan akan dimuat kembali secara otomatis saat Anda menyalakan Docker.

**Q: Folder `C:\dec\wspbi` boleh saya hapus?**
A: Folder ini berisi konfigurasi peluncur (`docker-compose.yml`). Sebaiknya **jangan dihapus** selama periode workshop agar Anda mudah melakukan *troubleshooting* atau *restart* layanan jika diperlukan.

**Q: Saya pengguna MacOS, bagaimana?**
A: Workshop ini didesain utama untuk pengguna Windows karena Power BI Desktop hanya berjalan secara native di Windows. Pengguna Mac disarankan menggunakan mesin virtual (seperti Parallels Desktop) untuk menjalankan Windows.

---

**Created by Ronny Sadam Husen**
* [LinkedIn](https://linkedin.com/in/ronnysadamhusen)
* [GitHub](https://github.com/ronnysadamhusen)

Sampai jumpa di kelas! Mari kita mulai langkah pertama menjadi seorang *Data Storyteller*.
