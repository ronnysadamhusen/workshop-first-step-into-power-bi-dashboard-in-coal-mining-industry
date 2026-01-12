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

Pastikan Anda menggunakan akun **Administrator** di laptop Anda. Pengaturan Docker dan pembuatan folder di drive `C:/` membutuhkan izin akses penuh.

### 2. Koneksi Internet Stabil

Anda akan mengunduh total sekitar **2 GB** data (Installer Docker, Image SQL Server, dan Power BI Desktop). Pastikan kuota dan sinyal mencukupi.

### 3. Instalasi Power BI Desktop

Unduh dan instal versi terbaru Power BI Desktop melalui tautan resmi:

* [Download Power BI Desktop (Microsoft Store)](https://aka.ms/pbidesktopstore) — **Sangat Direkomendasikan** agar update otomatis.
* [Download Manual (Situs Web)](https://www.microsoft.com/en-us/download/details.aspx?id=58494)

### 4. Eksekusi Skrip Setup Otomatis

Download dan jalankan skrip [Setup_Workshop_PBI.bat](https://github.com/ronnysadamhusen/workshop-first-step-into-power-bi-dashboard-in-coal-mining-industry/blob/main/Setup_Workshop_PBI.bat) sebagai Administrator. Skrip ini akan otomatis:

* Menginstal Docker Desktop.
* Mengonfigurasi Database SQL Server Express.
* Membuat user akses `dec`.

**Cara Menjalankan:**

1. Klik kanan file [Setup_Workshop_PBI.bat](https://github.com/ronnysadamhusen/workshop-first-step-into-power-bi-dashboard-in-coal-mining-industry/blob/main/Setup_Workshop_PBI.bat).
2. Pilih **Run as Administrator**.
3. Ikuti instruksi yang muncul di layar. Jika diminta **Restart**, silakan lakukan dan jalankan ulang skrip setelah restart.
4. Setelah selesai restart pasca install docker, Anda akan dihadapkan dengan window Docker Desktop untuk setup awal. SIlahkan klik tombol Accept dan skip pada halaman login. Silahkan ikuti tutorial yang ada dalam video di youtube ini (menit 2:40 - 2:50) [Setup Docker Desktop](https://youtu.be/fsR8fj7iCNY?si=EclTun7RrIgSlKxX&t=160)

> [!IMPORTANT]
> **Run as Administrator** adalah syarat mutlak agar perintah dalam skrip dapat dijalankan dengan lancar.

---

## 📝 Detail Akses Database (Setelah Setup Selesai)

Setelah skrip selesai dijalankan, Anda akan memiliki akses database lokal dengan detail:

* **Server:** `localhost`
* **Username:** `dec`
* **Password:** `Siapbisa@2026`
* **Port:** `1433`

---

## ❓ FAQ & Troubleshooting

**Q: Docker saya tidak mau start, muncul pesan "WSL 2 installation is incomplete".**
A: Silakan unduh update kernel WSL2 dari Microsoft di [link ini](https://aka.ms/wsl2kernel), instal, lalu coba buka kembali Docker Desktop.

**Q: Apakah saya boleh menggunakan MacOS?**
A: Workshop ini didesain utama untuk pengguna Windows karena Power BI Desktop hanya berjalan secara native di Windows. Pengguna Mac disarankan menggunakan mesin virtual (seperti Parallels atau VMWare).

**Q: Folder `C:\dec\wspbi` boleh saya hapus?**
A: **Jangan dihapus** selama workshop berlangsung, karena semua data database Anda tersimpan secara fisik di folder tersebut.

---

Sampai jumpa di kelas! Mari kita mulai langkah pertama menjadi seorang *Data Storyteller*.

---

**Next Step:** Apakah Anda ingin saya membuatkan **materi pengantar singkat** mengenai cara menghubungkan Power BI ke database SQL Server di Docker tersebut untuk melengkapi dokumen ini?
