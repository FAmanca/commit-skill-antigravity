# Antigravity Git Workspace Skills

Specialized agent skills for automated Git commit authoring, dual-format commit drafting, branch management, and remote publishing within the Google Antigravity ecosystem.

---

## Available Skills

### 1. `commit` (`.agents/skills/commit/`)
The primary unified commit skill featuring **intelligent dual-mode selection**:
- **Mode 1: Repo Fork / Branch Pribadi (Default)**: Generates concise, bullet-point commit messages for everyday feature branch development.
- **Mode 2: Repo Utama / Upstream PR**: Activates only when explicitly requested for upstream PRs, generating comprehensive PR-style commit descriptions.

**Triggers**:
- `/commit`
- `commit message`
- `commit desc`
- `create commit`
- `buatkan commit`

---

### 2. `commit-branch` (`.agents/skills/commit-branch/`)
Dedicated skill for everyday commits on personal fork or feature branches. Strictly enforces local exploration (never inspects upstream) and outputs clean Conventional Commit titles with concise bullet points.

**Triggers**:
- `/commit-branch`
- `commit branch`
- `commit-fitur`
- `commit lokal`

---

### 3. `commit-pr` (`.agents/skills/commit-pr/`)
Dedicated skill for Pull Requests to the upstream/main repository. Generates a deep, structured PR description (Summary of Changes, technical breakdown per domain, Testing Instructions, Modified Files, and Test Verification). Enforces raw Markdown rendering in chat UI.

**Triggers**:
- `/commit-pr`
- `commit pr`
- `/commit-repo`
- `commit repo`
- `commit upstream`

---

### 4. `commit-push` (`.agents/skills/commit-push/`)
Automates the full end-to-end delivery lifecycle:
1. Enforces switching to a semantic feature branch via `git switch -c <type>/<description>`. Direct commits or pushes to primary branches (`main`, `master`, `develop`) are forbidden.
2. Analyzes staged/unstaged diffs and drafts a Conventional Commit title with a PR-style body (Bahasa Indonesia or English).
3. Attaches the `Assisted-By: Google Antigravity` trailer.
4. Stages changes and commits via `git commit -F .commit-msg`.
5. Pushes to remote via `git push -u origin <branch>` and outputs the PR creation URL.

**Triggers**:
- `/commit-push`
- `/commit&push`
- `commit and push`
- `commit push`

---

## 2 Format Standar Commit

### 🟢 Format 1: Repo Fork / Branch Pribadi (Poin-Poin Sederhana)
Digunakan secara default oleh `/commit-branch` dan `/commit` untuk pengerjaan harian:

```text
<type>(<scope>): <deskripsi singkat>

- <poin perubahan ringkas 1>
- <poin perubahan ringkas 2>
- <poin perubahan ringkas 3>

Assisted-By: Google Antigravity
```

---

### 🔵 Format 2: Repo Utama / Upstream PR (PR-Style Komprehensif)
Digunakan oleh `/commit-pr` dan `/commit` (jika diminta eksplisit untuk PR upstream).

#### Opsi A: Bahasa Indonesia
```markdown
## Ringkasan Perubahan
<Satu paragraf, 3–6 kalimat yang menjelaskan MENGAPA perubahan dilakukan, konteks arsitektur, dan dampak teknis/bisnisnya.>

---

### 1. <Nama Domain/Fitur> (<berkas utama>)
• **<Komponen/Class/Fungsi>**: <penjelasan teknis dan alasan perubahan>.
• **<Komponen>**: <penjelasan teknis dan alasan perubahan>.

---

## Cara Pengetesan
<Langkah-langkah bernomor untuk reproduksi atau pengujian manual/otomatis.>

---

## Berkas yang Diperbarui (<jumlah> Berkas)
• <daftar path berkas relatif terhadap root>

---

## Pengujian (Testing Done)
[✓] <jenis pengujian / verifikasi yang dijalankan>: <ringkasan hasil>
[✗] <pengujian tertunda / belum dijalankan> — <alasan / pemblokir>

Assisted-By: Google Antigravity
```

#### Opsi B: English
```markdown
## Summary of Changes
<One paragraph, 3–6 sentences explaining WHY the changes were made, architectural context, and business/technical impact.>

---

### 1. <Domain/Feature Name> (<primary files>)
• **<Component/Class/Function>**: <technical reason and nature of the change>.
• **<Component>**: <technical reason and nature of the change>.

---

## Testing Instructions
<Numbered steps for manual or automated reproduction and verification.>

---

## Modified Files (<count> Files)
• <repo-relative file paths>

---

## Test Verification
[✓] <test suite / manual verification executed>: <summary of result>
[✗] <pending verification> — <reason / blocker>

Assisted-By: Google Antigravity
```

---

## Aturan Tampilan Chat UI (PR-Style)

Saat menyajikan deskripsi PR di chat:
- Tampilkan teks deskripsi PR **langsung sebagai teks Markdown rapi**.
- **DILARANG KERAS** membungkus teks deskripsi PR ke dalam satu card/blok kode raksasa (` ``` `) yang memunculkan copy button bertingkat di UI antarmuka chat.

---

## Attribution Trailer Standards

Untuk mencegah GitHub menghubungkan commit ke profil pengguna pihak ketiga yang tidak diinginkan (yang kerap terjadi jika menggunakan `Co-Authored-By` dengan alamat email umum), seluruh skill ini menggunakan standar:

```
Assisted-By: Google Antigravity
```

Format ini mematuhi spesifikasi RFC Git trailer sekaligus menjaga kebersihan grafik kontributor dan commit insights di GitHub.

---

## Branch Naming Standard (`commit-push`)

Cabang fitur yang dibuat secara otomatis oleh `commit-push` mematuhi konvensi semantik:

```
<type>/<kebab-case-description>
```

Contoh:
- `feat/jwt-authentication`
- `fix/table-pagination-overflow`
- `refactor/clean-architecture-storage`
- `chore/update-dependencies`

---

## Repository Structure

```
.agents/
└── skills/
    ├── commit/
    │   ├── SKILL.md
    │   └── scripts/
    │       └── gen-commit-msg.sh
    ├── commit-branch/
    │   └── SKILL.md
    ├── commit-pr/
    │   └── SKILL.md
    └── commit-push/
        ├── SKILL.md
        └── scripts/
            └── gen-commit-msg.sh
```

---

## Installation

### Project Level
Letakkan direktori `.agents/` pada root repositori proyek Anda.

### Global Installation (Semua Proyek)
Salin seluruh folder skill ke direktori konfigurasi global Antigravity:

- **Windows (PowerShell)**:
  ```powershell
  Copy-Item -Recurse -Force .agents\skills\* "$HOME\.gemini\config\skills\"
  ```
- **macOS / Linux**:
  ```bash
  cp -r .agents/skills/* ~/.gemini/config/skills/
  ```

---

## Lisensi

MIT
