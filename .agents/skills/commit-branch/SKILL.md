---
name: commit-branch
description: >-
  Author and create git commits for everyday work on personal fork / feature branches.
  Generates concise bullet-point commit messages matching the user's fork style: Conventional
  Commit title followed by clean bullet points summarizing changes, and the `Assisted-By: Google Antigravity`
  trailer. Executes local commit upon confirmation. Triggers on "/commit-branch", "commit branch",
  "commit-fitur", "commit lokal".
---

# Commit Branch Skill (Repo Fork / Branch Pribadi)

Otomatisasi pembuatan commit harian untuk pengerjaan di branch fitur atau fork pribadi. Menghasilkan pesan commit yang **ringkas dengan poin-poin sederhana (*bullet points*)**, tanpa format panjang PR-style.

---

## Aturan Eksplorasi
> [!IMPORTANT]
> **HANYA EKSPLORASI FORK / LOKAL:**
> Jangan pernah mengakses atau memeriksa repositori utama (`upstream`). Semua analisis diff dan riwayat commit diambil murni dari lingkungan lokal / fork pengguna saat ini.

---

## Alur Kerja (Workflow)

### Langkah 1 — Kumpulkan Konteks Lokal
Jalankan perintah berikut secara berurutan untuk memeriksa status repositori lokal:

```bash
# 1a. Staged diff (sumber utama)
git diff --staged --stat
git diff --staged

# 1b. Unstaged diff fallback (jika belum ada yang di-stage)
git diff --stat
git diff

# 1c. Metadata repositori lokal
git log --oneline -10          # melihat riwayat gaya commit di fork pengguna
git status --short             # berkas yang diubah / ditambah
git branch --show-current      # branch aktif saat ini
```

---

### Langkah 2 — Analisis Perubahan
Kelompokkan perubahan kode berdasarkan fungsionalitas dan dampaknya:
- Perubahan logic / controller / model.
- Perubahan tampilan Blade / CSS / JS / UI.
- Penambahan atau perbaikan bug / fitur.

---

### Langkah 3 — Tentukan Judul Commit (Conventional Commits)
Format:
```
<type>(<scope>): <deskripsi ringkas, maks 72 karakter>
```
- **Bahasa:** Bahasa Indonesia (atau Bahasa Inggris jika ada preferensi spesifik).
- **Tipe:** `feat`, `fix`, `refactor`, `perf`, `style`, `test`, `docs`, `chore`.
- **Scope:** Nama modul/fitur yang terpengaruh (misal: `e-trial`, `central-stock`, `nas`, `auth`).

---

### Langkah 4 — Susun Isi Pesan Commit (Format Ringkas Poin-Poin)

Gunakan format ringkas berikut (mengikuti pola riwayat fork pengguna):

```text
<type>(<scope>): <deskripsi singkat>

- <poin perubahan ringkas 1>
- <poin perubahan ringkas 2>
- <poin perubahan ringkas 3>

Assisted-By: Google Antigravity
```

**Ketentuan:**
1. Gunakan bullet points `- ` yang padat dan jelas.
2. DILARANG membuat format panjang (jangan sertakan Ringkasan Paragraf, Breakdown Teknis, Cara Pengetesan, Berkas Diperbarui, atau Checklist PR di mode ini).
3. Sertakan trailer `Assisted-By: Google Antigravity` di baris terakhir.

---

### Langkah 5 — Pratinjau & Eksekusi Commit Lokal

1. **Tampilkan Pratinjau:** Tampilkan teks commit kepada pengguna di chat.
2. **Eksekusi:** Tanyakan atau lakukan konfirmasi ke pengguna sebelum commit:
   ```bash
   git add <berkas-terkait>
   git commit -m "<pesan-commit>"
   ```
   *(Atau simpan ke `.commit-msg` lalu `git commit -F .commit-msg` kemudian hapus file temporary tersebut).*
3. **Peringatan Push:** JANGAN menjalankan `git push` kecuali ada perintah eksplisit dari pengguna.
