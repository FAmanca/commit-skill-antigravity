# Contoh Output Commit Lengkap

Dokumen ini menunjukkan output akhir skill `commit` untuk perubahan skala
menengah-besar yang mencakup beberapa domain fungsional.

---

## Input (Simulasi)

```
git diff --staged --stat

 app/Exports/CentralStockExport.php                              | 38 +++++++-
 app/Listeners/KirimNotifikasiTransaksiSparepart.php             | 12 ++-
 app/Livewire/CentralStock/ExportImport.php                      | 55 ++++++++++-
 app/Livewire/CentralStock/TabelBarang.php                       | 22 ++--
 app/Livewire/Dropdown/CariSparepart.php                         | 41 ++++++++-
 app/Support/Tiket/ItTicketType.php                              |  8 +-
 resources/views/sparepart/export-pdf.blade.php                  | 180 +++++++++++++-------
 resources/views/ticket/lihat.blade.php                          | 17 ++-
 resources/views/ticket/update.blade.php                         | 45 +++++++++
 resources/views/livewire/central-stock/dashboard.blade.php      | 30 ++++--
 resources/views/livewire/central-stock/export-import.blade.php  | 68 ++++++++++++
 resources/views/livewire/central-stock/tabel-barang.blade.php   | 19 ++-
 app/Http/Controllers/CentralStock/CentralStockController.php    | 24 +++-
 13 files changed, 447 insertions(+), 58 deletions(-)
```

---

## Output Akhir (siap copy-paste)

```
feat(ticket-it,kartu-stok): integrate IT sparepart stock cut & overhaul PDF export

## Ringkasan Perubahan

PR ini mengonsolidasikan seluruh rangkaian revisi dan penambahan fitur yang
mencakup integrasi suku cadang pada Trouble Ticket IT, perombakan format
Laporan Kartu Stok PDF, serta penyempurnaan Master Data Acuan & Export Master
Central Stock. Perubahan ini menutup gap pencatatan mutasi OUT atas nama
departemen IT, memperbaiki keterbacaan laporan PDF satuan maupun gabungan, dan
menyederhanakan navigasi master data di dashboard Central Stock.

---

### 1. Trouble Ticket IT — Integrasi Pengambilan Sparepart Central Stock

• **`ItTicketType::sparepartDepartemenId()`**: Menambahkan method baru yang
  mengembalikan `1` (Information Technology) agar pemotongan stok fisik dan
  riwayat mutasi OUT tercatat otomatis atas nama departemen IT.
• **`update.blade.php`**: Menambahkan blok form pencarian Livewire
  `dropdown.cari-sparepart` (filter kategori IT) dan input `qty_part` dengan
  peringatan stok berlebih secara real-time.
• **`CariSparepart.php`**: Memetakan filter pencarian langsung ke
  `id_departemen` Central Stock (IT: 1, DS: 13, RM: 14) dan mendukung
  pencarian via nama maupun `no_part` — mengatasi master barang IT yang kolom
  string legacy-nya masih terisi RM.
• **`KirimNotifikasiTransaksiSparepart.php`**: Mengarahkan bot Telegram MITA
  ke grup `ticket_it` dengan fallback `null` agar mutasi departemen non-teknis
  tidak mengotori grup RM.
• **`lihat.blade.php`**: Menambahkan kode tiket IT pada kondisi pengecekan
  Blade sehingga badge "Ganti part" dan kartu "Data Pergantian Sparepart"
  aktif untuk tiket IT.

---

### 2. Laporan Kartu Stok PDF

• **Mode Satuan (1 barang)** — `export-pdf.blade.php`: Header formal dengan
  Kotak Identitas Barang 2 kolom (Nama Barang, No. Part, Plant, Departemen,
  Kategori, Lokasi Rak, Spesifikasi, Satuan). Tabel riwayat mutasi
  disederhanakan menjadi 5 kolom lega: Tanggal, Keterangan, Pengguna, Masuk,
  Keluar. Footer mutasi periode, saldo akhir stok, dan blok tanda tangan PIC
  dipertahankan.
• **Mode Gabungan (> 1 barang)**: Transformasi menjadi 1 Tabel Ringkasan 10
  kolom — No, No. Part, Nama Sparepart, Departemen, Plant, Kategori, Satuan,
  Masuk, Keluar, Stok Saat Ini. Log mutasi per item dihilangkan; blok tanda
  tangan PIC diganti timestamp cetak. Indikator `0 (Habis)` ditambahkan jika
  stok kosong; border footer TOTAL MUTASI PERIODE membentang penuh.

---

### 3. Lokasi Rak Opsional untuk Departemen IT

• **`TabelBarang.php` & `ExportImport.php`**: Menghapus mekanisme `auto-hide`
  pada Form Tambah/Edit Barang dan Filter Export Master. Input Lokasi Rak
  selalu ditampilkan; khusus Departemen IT (`id = 1`), label diberi badge
  *(Opsional)* dan nilai tetap tersimpan ke database jika diisi.

---

### 4. Konsolidasi Master Data Acuan & Filter Export Master

• **`dashboard.blade.php`**: Menyatukan tombol master data yang tersebar ke
  dalam satu dropdown terpusat "Master Data Acuan" (Master Kategori, Master
  Satuan UoM, Master Rak).
• **`export-import.blade.php` & `CentralStockExport.php`**: Form filter
  terintegrasi (Plant, Departemen, Kategori dinamis, Rak, UoM) sebelum
  unduhan Excel; kolom `LOKASI RAK` ditambahkan pada berkas hasil unduhan.
  Fitur pemilihan multi-sparepart untuk batch cetak Kartu Stok PDF gabungan
  ditambahkan ke portal export-import.

---

## Cara Pengetesan

1. **Pemotongan Stok Tiket IT**: Buka `/tiket?tipe=IT`, pilih tiket, klik
   "Update Progress". Cari part IT (SSD/RAM/Mouse), verifikasi dropdown
   menampilkan sisa stok. Input qty melebihi stok → badge peringatan kuning
   muncul. Input qty valid → submit. Buka detail tiket: badge "Ganti part"
   muncul di timeline dan kartu "Data Pergantian Sparepart" tampil di sidebar.
   Buka Central Stock → Kartu Stok: stok berkurang 1, mutasi OUT tercatat
   dengan referensi nomor tiket IT.

2. **Cetak Kartu Stok PDF**: Buka `/central-stock/export-import`. Pilih 1
   barang → cetak PDF satuan: periksa kotak identitas 2 kolom di header dan
   tabel 5 kolom. Pilih > 1 barang → cetak PDF gabungan: periksa tabel
   ringkasan 10 kolom, indikator `0 (Habis)`, border footer penuh, tidak ada
   blok PIC.

3. **Rak Opsional IT & Master Data Acuan**: Buka Form Tambah Barang, pilih
   Departemen IT → input Lokasi Rak tetap muncul dengan badge *(Opsional)* dan
   tersimpan saat diisi. Buka Dashboard Central Stock → tombol master data
   sudah dalam satu dropdown. Buka Export Master Sparepart → dropdown kategori
   reaktif per departemen, file Excel memiliki kolom LOKASI RAK.

---

## Berkas yang Diperbarui (13 Berkas)

• `app/Exports/CentralStockExport.php`
• `app/Http/Controllers/CentralStock/CentralStockController.php`
• `app/Listeners/KirimNotifikasiTransaksiSparepart.php`
• `app/Livewire/CentralStock/ExportImport.php`
• `app/Livewire/CentralStock/TabelBarang.php`
• `app/Livewire/Dropdown/CariSparepart.php`
• `app/Support/Tiket/ItTicketType.php`
• `resources/views/livewire/central-stock/dashboard.blade.php`
• `resources/views/livewire/central-stock/export-import.blade.php`
• `resources/views/livewire/central-stock/tabel-barang.blade.php`
• `resources/views/sparepart/export-pdf.blade.php`
• `resources/views/ticket/lihat.blade.php`
• `resources/views/ticket/update.blade.php`

---

## Pengujian (Testing Done)

[✓] Automated Mock & Unit Tests (21/21 PASS): Resolusi tipe tiket IT,
    pencarian barang via Livewire `CariSparepart`, verifikasi saldo stok,
    simulasi routing Telegram mock gateway, pengecekan kondisi Blade template.
[✓] Functional Database Test: Submit progress tiket IT #22 berhasil menyimpan
    mutasi OUT pada tabel `sparepart_histori` dengan `id_departemen = 1`,
    memotong stok fisik secara real-time, dan tampil di detail tiket.
[✓] Export & PDF Test: Cetak PDF Kartu Stok satuan dan gabungan terverifikasi
    rapi dan proporsional. Unduhan Excel Master Data menyertakan kolom Lokasi
    Rak dan terfilter sesuai pilihan.

Co-Authored-By: Google Antigravity <antigravity@google.com>
```
