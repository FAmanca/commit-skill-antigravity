---
name: commit
description: >-
  Author and create git commits from git diffs. Supports two rules/modes: (1) `/commit-branch` (Default):
  generates concise bullet-point commit messages for everyday personal/branch commits; (2) `/commit-pr`:
  generates full structured PR-style bodies (Summary, domain breakdown, Testing Instructions, Modified
  Files, Test Verification) for PR to the upstream/main repository. Applies the `Assisted-By: Google Antigravity`
  trailer and executes the local commit upon confirmation. Triggers on "/commit", "commit message", "commit desc",
  "create commit", "buatkan commit".
---

# Commit Skill

Automates the git commit authoring workflow from diff analysis to local commit creation, supporting bilingual commit bodies (Bahasa Indonesia and English) and dual commit rules: `/commit-branch` (Repo Fork / Poin-Poin Ringkas) vs. `/commit-pr` (Repo Utama / PR-Style Panjang).

---

## Workflow

### Step 1 — Collect Context

Execute the following commands in sequence to inspect repository state:

```bash
# 1a. Staged diff (primary source)
git diff --staged --stat
git diff --staged

# 1b. Unstaged diff fallback (if staged is empty)
git diff --stat
git diff

# 1c. Repository metadata
git log --oneline -10          # commit history and style
git status --short             # untracked / modified / deleted files
git branch --show-current      # current working branch
```

Read the complete diff output without truncation.

---

### Step 2 — Analyze Changes

Group code changes by **functional domain** (not by folder layout).

Analysis checklist:
- Behavioral shifts vs purely textual changes.
- Breaking changes, deprecations, or contract modifications.
- Database migrations, schema adjustments, or environment variables.
- External side-effects requiring verification.

---

### Step 2.5 — Mode Selection: Repo Pribadi vs. Repo Utama

> [!IMPORTANT]
> **2 ATURAN BAKU PEMILIHAN MODE COMMIT:**
>
> 1. **Aturan 1 / Mode 1: Commit ke Repo Pribadi (DEFAULT — Poin-Poin Sederhana):**
>    - Berlaku jika pengguna meminta commit biasa, misalnya hanya mengetik `/commit`, "commit", "commit message", "buatkan commit", atau commit di branch pribadi/fitur sendiri **TANPA** menyebutkan bahwa commit ini untuk PR ke repo utama.
>    - **Format yang DIBERIKAN:** Pesan commit **ringkas dengan poin-poin sederhana (bullet points)** seperti sebelumnya.
>    - **DILARANG** memberikan format PR-style yang panjang pada mode ini.
>
> 2. **Aturan 2 / Mode 2: Commit ke Repo Utama (HANYA JIKA DIMINTA EKSPLISIT UNTUK PR REPO UTAMA):**
>    - Berlaku **HANYA JIKA** pengguna meminta `/commit` **DAN secara eksplisit menjelaskan** bahwa commit / deskripsi ini ditujukan untuk **Pull Request (PR) ke repositori utama (upstream / main repo)**!
>    - **Format yang DIBERIKAN:** Format PR-style komprehensif panjang (Ringkasan Perubahan, Breakdown per Domain Teknis, Cara Pengetesan, Berkas yang Diperbarui, dan Pengujian).
>    - **ATURAN TAMPILAN CHAT:** Tampilkan teks deskripsi PR **langsung sebagai teks Markdown rapi**. **DILARANG KERAS** membungkus teks deskripsi PR ke dalam card / satu blok kode raksasa (` ``` `) yang memunculkan copy button bertingkat di UI chat.
>

---

### Step 3 — Determine the Commit Title

Format (Conventional Commits):

```
<type>(<scope>): <short description, max 72 chars>
```

- **Bahasa Title:** Gunakan Bahasa Inggris secara default, atau Bahasa Indonesia jika pengguna meminta judul bahasa Indonesia secara eksplisit.
- **Allowed Types:** `feat`, `fix`, `refactor`, `perf`, `style`, `test`, `docs`, `chore`, `build`, `ci`, `revert`.
- **Scope Rules:** Gunakan nama komponen/modul yang terdampak (e.g., `auth`, `doorprize-tv`, `api`). Jika lebih dari 3 modul, gunakan `core` atau hilangkan scope.
- Jangan akhiri title dengan tanda titik. Maksimal 72 karakter.

---

### Step 4 — Build the Commit Body

Berdasarkan hasil seleksi pada **Step 2.5**:

---

#### 🟢 FORMAT ATURAN 1: Commit ke Repo Pribadi (DEFAULT — Poin-poin Sederhana)

Gunakan format ini untuk setiap permintaan commit biasa ke repo pribadi / branch fitur sendiri:

```text
<type>(<scope>): <deskripsi singkat>

- <Poin ringkas perubahan 1>
- <Poin ringkas perubahan 2>
- <Poin ringkas perubahan 3>

Assisted-By: Google Antigravity
```

---

#### 🔵 FORMAT ATURAN 2: Commit ke Repo Utama (HANYA Jika Diminta Eksplisit untuk PR ke Repo Utama)

Gunakan format ini **hanya jika** pengguna secara spesifik meminta deskripsi / commit untuk PR ke repo utama.

##### Template PR Option A: Bahasa Indonesia

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

##### Template PR Option B: English

## Summary of Changes

<One paragraph, 3–6 sentences explaining WHY the changes were made, architectural context, and business/technical impact. Do not repeat verbatim line items from the detailed sections below.>

---

### 1. <Domain/Feature Name> (<primary files>)

• **<Component/Class/Function>**: <technical reason and nature of the change>.
• **<Component>**: <technical reason and nature of the change>.

---

## Testing Instructions

<Numbered steps for manual or automated reproduction and verification. Include specific CLI commands, routes, URLs, or test suites.>

---

## Modified Files (<count> Files)

<Bullet list of repo-relative file paths, sorted alphabetically>

---

## Test Verification

[✓] <test suite / manual verification executed>: <summary of result>
[✗] <pending verification> — <reason / blocker>

Assisted-By: Google Antigravity

---

### Step 5 — Add Trailers

Append the AI attribution trailer to the end of the commit body, separated by an empty line:

```
Assisted-By: Google Antigravity
```

If authentic human co-authors are explicitly identified from repository collaboration, append:

```
Co-Authored-By: Full Name <email@domain.com>
```

Do not use `Co-Authored-By` for AI agents to prevent ghost collaborator linking on GitHub.

---

### Step 6 — Preview and Execute

1. **Display Preview**: Tampilkan pesan commit di chat (dalam format poin-poin jika Mode Standar, atau teks Markdown PR langsung jika Mode PR).
2. **Options**:
   - Confirm and commit: Tulis pesan ke `.commit-msg`, jalankan `git commit -F .commit-msg` (atau `git commit -m "..."`), lalu hapus `.commit-msg`.
   - Modify message: Sesuaikan bagian tertentu atas permintaan pengguna.
   - Save to file only: Simpan ke `.commit-msg` tanpa commit.

---

## Formatting and Quality Standards

- **Tone**: Direct, technical, and objective. Avoid filler words ("berhasil", "dengan baik", "successfully", "properly").
- **Precision**: Reference exact symbol names, routes, configurations, and filenames.
- **No Giant Code Enclosure in Chat for PRs**: Saat menyajikan deskripsi PR di chat, render langsung sebagai teks Markdown murni (bukan dibungkus blok ```markdown) agar mudah dibaca dan tidak merusak UI.
