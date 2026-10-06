# Commit Skill — AGY Workspace Skill

Skill AGY untuk menghasilkan **judul commit** dan **deskripsi commit PR-style**
secara otomatis dari `git diff`, tanpa input manual.

## Cara Pakai

Pastikan skill ini berada di `.agents/skills/commit/` pada root repo yang
menggunakannya (atau di `~/.gemini/config/skills/commit/` untuk global).

Panggil dari chat AGY dengan salah satu trigger berikut:

```
/commit
buatkan commit
commit desc
commit message
```

Agen akan:
1. Membaca `git diff --staged` (atau unstaged jika staging kosong).
2. Menganalisis perubahan dan mengelompokkannya per domain fungsional.
3. Menghasilkan judul Conventional Commits + body PR-style dalam Bahasa Indonesia.
4. Menampilkan preview dan menunggu konfirmasi sebelum melakukan `git commit`.

## Struktur

```
.agents/skills/commit/
├── SKILL.md                              ← Instruksi utama agen
├── examples/
│   └── full-commit-example.md           ← Contoh output lengkap
├── references/
│   ├── conventional-commits.md          ← Cheatsheet Conventional Commits
│   └── scope-guide.md                   ← Panduan memilih type & scope
└── scripts/
    └── gen-commit-msg.sh                ← Helper: kumpulkan konteks git
```

## Instalasi Global (semua proyek)

Salin folder `commit/` ke:

```
~/.gemini/config/skills/commit/
```

Atau pada Windows:

```
C:\Users\<username>\.gemini\config\skills\commit\
```

## Lisensi

MIT
