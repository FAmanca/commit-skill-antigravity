# Panduan Scope & Tipe — Pengambilan Keputusan

Panduan ini membantu agen memilih `type` dan `scope` yang tepat ketika diff
mencakup banyak perubahan.

---

## Memilih Type

### Pohon Keputusan

```
Apakah ada fitur baru yang terlihat pengguna?
  → YA  → feat

Apakah ada bug yang diperbaiki?
  → YA  → fix

Apakah perubahan hanya mengubah struktur internal tanpa mengubah perilaku?
  → YA  → refactor

Apakah perubahan meningkatkan kecepatan / efisiensi tanpa mengubah API?
  → YA  → perf

Apakah perubahan hanya test?
  → YA  → test

Apakah perubahan hanya dokumentasi?
  → YA  → docs

Apakah perubahan hanya konfigurasi / tooling / dependency?
  → YA  → chore / build / ci
```

### Prioritas Ketika Banyak Type Berlaku

```
feat > fix > refactor > perf > test > style > docs > chore
```

Pilih type tertinggi yang berlaku. Satu commit = satu type.

---

## Memilih Scope

### Aturan Umum

| Situasi                                 | Scope                          |
|-----------------------------------------|--------------------------------|
| 1 modul / fitur saja                    | nama modul (mis. `ticket-it`)  |
| 2–3 modul yang berkaitan erat           | nama gabungan (mis. `ticket-it,kartu-stok`) atau parent domain |
| > 3 modul tidak berkaitan               | `core` atau kosongkan scope    |
| Perubahan seluruh codebase              | kosongkan scope                |

### Daftar Scope Umum per Domain

Sesuaikan dengan proyek Anda. Contoh untuk proyek Laravel Central Stock:

| Domain                    | Scope Disarankan       |
|---------------------------|------------------------|
| Trouble Ticket IT         | `ticket-it`            |
| Central Stock umum        | `central-stock`        |
| Kartu Stok / PDF export   | `kartu-stok`           |
| Export / Import data      | `export-import`        |
| Master Data               | `master-data`          |
| Livewire dropdown         | `livewire-dropdown`    |
| Notifikasi Telegram       | `telegram-notif`       |
| Autentikasi               | `auth`                 |
| Dashboard                 | `dashboard`            |

---

## Kapan Merekomendasi Split Commit

Rekomendasikan split jika **semua** kondisi berikut terpenuhi:

1. Diff > 500 baris perubahan **dan**
2. Perubahan mencakup ≥ 2 dari: (a) skema database, (b) fitur UI baru,
   (c) hotfix/bug, (d) refactor arsitektur **dan**
3. Setiap kelompok bisa ditest secara **independen**.

Jika hanya kondisi 1 yang terpenuhi tanpa 2 dan 3, tidak perlu split.

### Format Rencana Split

```
Saya rekomendasikan split menjadi N commit:

1. feat(ticket-it): ... — mencakup file A, B, C
2. fix(kartu-stok): ... — mencakup file D, E
3. refactor(master-data): ... — mencakup file F, G

Konfirmasi untuk lanjut buat pesan masing-masing secara berurutan.
```
