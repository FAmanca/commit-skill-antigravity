---
name: commit-push
description: >-
  Automates the complete git branch, commit, and remote push workflow.
  Enforces branching off to a new semantic branch (`git switch -c <type>/<description>`),
  stages changes, drafts a Conventional Commits title with a PR-style body in
  Bahasa Indonesia or English and `Assisted-By: Google Antigravity` trailer, commits the
  work, and pushes to the remote repository (`git push -u origin <branch>`). Triggers
  on "/commit-push", "/commit&push", "commit and push", "commit push", or when asked
  to commit and push changes.
---

# Commit & Push Skill

Automates end-to-end version control lifecycle: branch creation, change analysis, commit authoring (Bahasa Indonesia or English), commit execution, and remote pushing.

---

## Workflow

### Step 1 — Inspect Repository State

Run the following commands to assess the workspace:

```bash
git branch --show-current          # current branch
git status --short                 # uncommitted, staged, and untracked files
git diff --staged --stat           # staged diff summary
git diff --staged                  # staged diff full
git diff --stat                    # unstaged diff summary
git diff                           # unstaged diff full
git remote -v                      # remote configuration
git log --oneline -5               # recent commit history
```

If there are no changes (`git status` is clean), terminate immediately and report that there are no changes to commit.

---

### Step 2 — Determine Branch Name and Switch

**Rule: Direct commits or pushes to primary/base branches (`main`, `master`, `develop`, `dev`, `staging`) are strictly forbidden.**

1. **Format**:
   ```
   <type>/<kebab-case-description>
   ```
   - `<type>`: Conventional Commits type (`feat`, `fix`, `refactor`, `perf`, `chore`, `docs`, `test`, `build`, `ci`).
   - `<kebab-case-description>`: Concise, lowercase, hyphen-separated summary (e.g., `feat/export-csv-reports`, `fix/auth-token-refresh`, `refactor/api-client-service`).

2. **Branch Switching**:
   - If the current branch is `main`, `master`, `develop`, or an unrelated branch, create and switch to the new branch:
     ```bash
     git switch -c <branch-name>
     ```
     *(Fallback if `git switch` is unsupported: `git checkout -b <branch-name>`)*
   - If already on an active, appropriately named feature branch matching the current scope, retain the existing branch.

---

### Step 3 — Determine Commit Message

Format (Conventional Commits): Always in **English**.

```
<type>(<scope>): <short description, max 72 chars>
```

#### Language Selection Rule:
- **Default / Bahasa Indonesia**: Use if the user prompt is in Indonesian, if requested, or if repository history predominantly uses Indonesian commit bodies.
- **English**: Use if the user prompt is in English, if requested, or if repository history is strictly English.
- Technical identifiers remain in their original code format regardless of language.

---

#### Template Option A: Bahasa Indonesia

```markdown
## Ringkasan Perubahan

<Satu paragraf, 3–6 kalimat yang menjelaskan MENGAPA perubahan dilakukan, konteks arsitektur, dan dampak teknis/bisnisnya.>

---

### <Nomor>. <Nama Domain/Fitur> (<berkas utama>)

• **<Komponen/Class/Fungsi>**: <penjelasan teknis dan alasan perubahan>.
• **<Komponen>**: <penjelasan teknis dan alasan perubahan>.

---

## Cara Pengetesan

<Langkah-langkah bernomor untuk reproduksi atau pengujian manual/otomatis dengan perintah CLI, URL, atau rute.>

---

## Berkas yang Diperbarui (<jumlah> Berkas)

<Daftar bullet path berkas relatif terhadap root repositori, diurutkan alfabetis>

---

## Pengujian (Testing Done)

[✓] <jenis pengujian / verifikasi yang dijalankan>: <ringkasan hasil>
[✗] <pengujian tertunda / belum dijalankan> — <alasan / pemblokir>
```

---

#### Template Option B: English

```markdown
## Summary of Changes

<One paragraph, 3–6 sentences explaining WHY the changes were made, architectural context, and business/technical impact.>

---

### <Number>. <Domain/Feature Name> (<primary files>)

• **<Component/Class/Function>**: <technical reason and nature of the change>.
• **<Component>**: <technical reason and nature of the change>.

---

## Testing Instructions

<Numbered steps for manual or automated reproduction and verification with commands, routes, or tests.>

---

## Modified Files (<count> Files)

<Bullet list of repo-relative file paths, sorted alphabetically>

---

## Test Verification

[✓] <test suite / manual verification executed>: <summary of result>
[✗] <pending verification> — <reason / blocker>
```

---

**Trailer**:
Always append:
```
Assisted-By: Google Antigravity
```
Do not use `Co-Authored-By` for AI agents to prevent ghost collaborator linking on GitHub.

---

### Step 4 — Preview to User

Display the execution plan clearly:
1. **Target Branch**: `<branch-name>` (and whether switching is needed).
2. **Commit Message**: Full title, body, and trailer.
3. **Target Remote**: `origin/<branch-name>`.

---

### Step 5 — Stage, Commit, and Push

Upon user confirmation (or when direct execution is explicitly requested):

1. **Switch Branch** (if not already switched):
   ```bash
   git switch -c <branch-name>
   ```
2. **Stage Changes**:
   ```bash
   git add -A
   ```
   *(Or stage specific modified files if requested).*
3. **Commit**:
   - Write message to `.commit-msg` in repo root.
   - Run:
     ```bash
     git commit -F .commit-msg
     ```
   - Delete `.commit-msg`.
4. **Push to Remote**:
   ```bash
   git push -u origin <branch-name>
   ```
5. **Report Result**:
   - Print commit SHA, current branch, and remote tracking status.
   - If remote is GitHub/GitLab, display the PR creation URL.
