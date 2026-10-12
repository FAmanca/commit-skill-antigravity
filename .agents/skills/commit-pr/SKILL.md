---
name: commit-pr
description: >-
  Author comprehensive PR-style commit descriptions for Pull Requests submitted to the
  upstream / main repository. Formats full structured bodies: Summary of changes, Technical domain
  breakdown, Testing instructions, Modified files list, and Test verification checklist with
  the `Assisted-By: Google Antigravity` trailer. Triggers on "/commit-pr", "commit pr", "/commit-repo",
  "commit repo", "commit upstream".
---

# Commit PR Skill (Repo Utama / Pull Request Upstream)

Digunakan khusus saat fitur telah selesai dan siap diajukan untuk **Pull Request (PR) ke repositori utama (upstream / main repo)**. Format yang dihasilkan sangat komprehensif, terstruktur, dan mendalam.

---

## Aturan Tampilan Chat (WAJIB)
> [!IMPORTANT]
> Tampilkan teks deskripsi PR **langsung sebagai teks Markdown rapi**.
> **DILARANG KERAS** membungkus teks deskripsi PR ke dalam satu card/blok kode raksasa (` ``` `) yang memunculkan copy button bertingkat di UI chat.

---

## Alur Kerja (Workflow)

### Langkah 1 — Kumpulkan Konteks Lokal
Periksa perubahan pada branch saat ini:
```bash
git diff --staged --stat
git diff --staged
git diff --stat
git diff
git log --oneline -10
git status --short
git branch --show-current
```

---

### Langkah 2 — Analisis Menyeluruh
Analisis perubahan secara detail:
- Alasan perubahan, konteks arsitektur, dan dampak sistem.
- Komponen, controller, view, service, atau model yang terpengaruh.
- Skenario pengujian (manual maupun otomatis).

---

### Langkah 3 — Judul Commit
```
<type>(<scope>): <deskripsi jelas dan profesional>
```

---

### Langkah 4 — Format PR Komprehensif

Sajikan dalam format PR terstruktur berikut:

## Ringkasan Perubahan

<Satu paragraf, 3–6 kalimat yang menjelaskan MENGAPA perubahan dilakukan, konteks arsitektur, dan dampak teknis/bisnisnya. Jangan mengulang poin-poin yang sudah dirinci di bawah.>

---

### 1. <Nama Domain/Fitur> (<berkas utama>)

• **<Komponen/Class/Fungsi>**: <penjelasan teknis dan alasan perubahan>.
• **<Komponen>**: <penjelasan teknis dan alasan perubahan>.

---

## Cara Pengetesan

<Langkah-langkah bernomor untuk reproduksi atau pengujian manual/otomatis. Sertakan perintah CLI, rute URL, atau alur pengujian terkait.>

---

## Berkas yang Diperbarui (<jumlah> Berkas)

<Daftar bullet path berkas relatif terhadap root repositori, diurutkan alfabetis>

---

## Pengujian (Testing Done)

[✓] <jenis pengujian / verifikasi yang dijalankan>: <ringkasan hasil>
[✗] <pengujian tertunda / belum dijalankan> — <alasan / pemblokir>

Assisted-By: Google Antigravity

---

### Langkah 5 — Konfirmasi & Simpan
1. Sajikan teks PR di chat agar pengguna dapat meninjau atau menyalinnya untuk deskripsi PR di GitHub.
2. Jika pengguna meminta untuk membuat commit lokal dengan pesan ini, gunakan file temporary `.commit-msg` lalu `git commit -F .commit-msg`.
3. **Peringatan:** AI dilarang melakukan `git push` kecuali atas perintah eksplisit pengguna.
