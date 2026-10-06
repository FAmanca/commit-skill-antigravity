---
name: commit
description: >-
  Gunakan skill ini setiap kali pengguna ingin membuat git commit, baik judul
  maupun deskripsi/body lengkap. Skill ini membaca git diff --staged (dan
  unstaged jika belum di-stage), menganalisis seluruh perubahan, lalu
  menghasilkan: (1) judul commit singkat ber-prefix Conventional Commits,
  (2) body PR-style dalam Bahasa Indonesia yang mencakup Ringkasan Perubahan,
  detail teknis per section, Cara Pengetesan, daftar Berkas yang Diperbarui,
  dan status Pengujian. Aktifkan juga ketika pengguna menyebut "/commit",
  "buatkan commit", "commit desc", "commit message", atau "commit description".
---

# Commit Skill

Skill ini mengotomasi seluruh alur pembuatan git commit — dari analisis diff
hingga pesan commit final siap pakai — tanpa memerlukan input manual dari
pengguna selain memilih scope/konteks jika ambigu.

---

## Alur Kerja (Wajib Diikuti Berurutan)

### Langkah 1 — Kumpulkan Konteks

Jalankan perintah berikut secara berurutan. Berhenti di step pertama yang
menghasilkan output bermakna:

```bash
# 1a. Diff staged (prioritas utama)
git diff --staged --stat
git diff --staged

# 1b. Jika staged kosong, ambil unstaged
git diff --stat
git diff

# 1c. Metadata tambahan
git log --oneline -10          # gaya commit historis di repo ini
git status --short             # berkas baru / deleted / renamed
git branch --show-current      # nama branch aktif
```

Baca output sepenuhnya. Jangan lewati atau truncate diff.

---

### Langkah 2 — Analisis Perubahan

Kelompokkan perubahan berdasarkan **domain fungsional** (bukan berdasarkan
direktori semata). Tiap kelompok akan menjadi satu section di body commit.

Pertanyaan panduan:
- Apa yang **berubah secara perilaku** (bukan hanya teks)?
- Adakah perubahan yang **breaking** atau **deprecating**?
- Adakah perubahan pada **skema database / migrasi**?
- Apa **side-effect** yang perlu diuji?

---

### Langkah 3 — Tentukan Judul Commit

Format wajib (Conventional Commits):

```
<type>(<scope>): <deskripsi singkat maks 72 karakter>
```

**Tabel tipe yang diizinkan:**

| Tipe       | Kapan Dipakai                                                  |
|------------|----------------------------------------------------------------|
| `feat`     | Fitur baru yang terlihat pengguna                              |
| `fix`      | Perbaikan bug                                                  |
| `refactor` | Refaktor tanpa perubahan perilaku                              |
| `perf`     | Optimasi performa                                              |
| `style`    | Formatting, whitespace, tidak ada logika baru                  |
| `test`     | Penambahan / perubahan unit test atau integration test         |
| `docs`     | Dokumentasi saja                                               |
| `chore`    | Konfigurasi, tooling, CI/CD, dependency                        |
| `build`    | Perubahan sistem build atau dependencies eksternal             |
| `ci`       | Perubahan pipeline CI/CD                                       |
| `revert`   | Mengembalikan commit sebelumnya                                |

**Aturan scope:**
- Gunakan nama modul / fitur yang diubah (contoh: `ticket-it`, `kartu-stok`,
  `central-stock`, `auth`).
- Jika perubahan lintas > 3 modul berbeda, gunakan scope `core` atau hilangkan
  scope.
- Jika > 1 tipe dominan, pilih tipe yang paling tinggi nilai bisnis-nya
  (urutan: `feat` > `fix` > `refactor` > sisanya).

**Judul TIDAK boleh:**
- Diakhiri tanda titik.
- Mengandung kata "Update", "Change", "Modify" tanpa konteks spesifik.
- Melebihi 72 karakter.

---

### Langkah 4 — Buat Body Commit (PR-Style)

Gunakan template di bawah. Isi setiap section berdasarkan hasil analisis.
Hapus section yang benar-benar tidak relevan (jangan kosongkan, hapus saja).

```markdown
## Ringkasan Perubahan

<satu paragraf 3–6 kalimat yang menjelaskan MENGAPA perubahan ini dibuat
dan dampak bisnis / teknis utamanya. Hindari menjelaskan ulang isi
section berikutnya.>

---

### <Nomor>. <Nama Domain/Fitur> (<berkas utama>)

• **<Komponen/Class/Method>**: <penjelasan perubahan dan alasan teknis>.
• **<Komponen>**: <penjelasan>.
[ulangi per komponen yang berubah dalam domain ini]

[ulangi section ### untuk setiap domain fungsional]

---

## Cara Pengetesan

<nomor urut langkah pengujian manual yang cukup detail untuk direview oleh
orang lain tanpa membaca kode. Sebutkan URL, menu, atau CLI command jika
relevan.>

---

## Berkas yang Diperbarui (<jumlah> Berkas)

<daftar bullet berisi path berkas relatif dari root repo, diurutkan
alfabet per direktori>

---

## Pengujian (Testing Done)

[✓] <jenis test>: <ringkasan hasil>
[✗] <jenis test yang belum dilakukan> — <alasan / TODO>
```

---

### Langkah 5 — Tambahkan Trailer

Selalu sertakan trailer berikut di **akhir body**, dipisah satu baris kosong
dari konten terakhir:

```
Co-Authored-By: Google Antigravity <antigravity@google.com>
```

Jika ada co-author manusia lain yang teridentifikasi dari `git log`, tambahkan
juga:

```
Co-Authored-By: Nama Lengkap <email@domain.com>
```

---

### Langkah 6 — Commit atau Preview

**Default: tampilkan dulu (preview mode).**

Tampilkan hasil akhir dalam format yang bisa langsung dicopy-paste ke terminal:

````
```
<judul commit>

<body commit>

Co-Authored-By: Google Antigravity <antigravity@google.com>
```
````

Setelah menampilkan preview, tanya apakah pengguna ingin:
1. Langsung `git commit` menggunakan pesan tersebut.
2. Edit bagian tertentu.
3. Simpan ke file `.commit-msg` di root repo.

Jika pengguna mengonfirmasi commit, jalankan:

```bash
git commit -F .commit-msg
```

(tulis dulu pesan ke `.commit-msg` menggunakan `write_to_file`, lalu commit,
lalu hapus file `.commit-msg`.)

---

## Aturan Tambahan

### Bahasa
- **Judul**: Bahasa Inggris (Conventional Commits standar internasional).
- **Body**: Bahasa Indonesia, kecuali nama teknis (class, method, variabel,
  path file) tetap dalam bahasa aslinya.

### Panjang & Kepadatan
- Judul: maks 72 karakter.
- Setiap bullet point body: maks 2 baris wrapped di 100 karakter.
- Section `Ringkasan Perubahan`: 3–6 kalimat, bukan poin-poin.

### Kualitas Informasi
- Sebutkan **nama konkret**: nama method, nama class, nama route, nama kolom
  database — bukan "beberapa fungsi" atau "beberapa komponen".
- Untuk setiap perubahan teknis, sertakan **mengapa** bukan hanya **apa**.
- Hindari kata-kata filler: "berhasil", "dengan baik", "sudah", "telah",
  "sekarang".

### Multi-Commit (Squash Candidates)
Jika diff sangat besar (> 500 baris) dan mencakup domain yang benar-benar
terpisah (contoh: migrasi database + fitur UI + hotfix auth), rekomendasikan
split commit. Tampilkan rencana split sebelum membuat pesan masing-masing.

---

## Referensi Internal

- [Contoh Output Commit Lengkap](./examples/full-commit-example.md)
- [Conventional Commits Cheatsheet](./references/conventional-commits.md)
- [Panduan Scope & Tipe](./references/scope-guide.md)
