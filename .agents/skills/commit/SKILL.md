---
name: commit
description: >-
  Author and create git commits from git diffs. Analyzes staged or unstaged
  changes, drafts a Conventional Commits title with a structured PR-style body
  in Bahasa Indonesia or English (Summary of Changes / Ringkasan Perubahan, technical
  breakdown per domain, Testing Instructions / Cara Pengetesan, Modified Files / Berkas
  yang Diperbarui, and Test Verification / Pengujian), applies the `Assisted-By: Google Antigravity`
  trailer, and executes the local commit upon confirmation. Triggers on "/commit",
  "commit message", "commit desc", "create commit", "buatkan commit".
---

# Commit Skill

Automates the git commit authoring workflow from diff analysis to local commit creation, supporting bilingual commit bodies (Bahasa Indonesia and English).

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

Group code changes by **functional domain** (not by folder layout). Each functional group maps to one `###` subsection in the body.

Analysis checklist:
- Behavioral shifts vs purely textual changes.
- Breaking changes, deprecations, or contract modifications.
- Database migrations, schema adjustments, or environment variables.
- External side-effects requiring verification.

---

### Step 3 — Determine the Commit Title

Format (Conventional Commits): Always in **English**.

```
<type>(<scope>): <short description, max 72 chars>
```

**Allowed Types:**

| Type       | Purpose                                                        |
|------------|----------------------------------------------------------------|
| `feat`     | New user-facing feature or capability                          |
| `fix`      | Bug fix                                                        |
| `refactor` | Code restructuring without logic or behavioral change          |
| `perf`     | Performance enhancement                                        |
| `style`    | Formatting, whitespace, linting — zero business logic change   |
| `test`     | Adding or updating unit / integration / e2e tests              |
| `docs`     | Documentation updates only                                     |
| `chore`    | Tooling, configuration, CI/CD, dependencies                    |
| `build`    | Build system or external package updates                       |
| `ci`       | CI/CD pipeline and automation configuration                    |
| `revert`   | Reversion of a previous commit                                 |

**Scope Rules:**
- Use the affected component or module name (e.g., `auth`, `payment`, `api`, `skill`).
- If changes span more than 3 unrelated domains, use `core` or omit scope.
- Priority when multiple types apply: `feat` > `fix` > `refactor` > others.
- Do not end the title with a period.
- Do not exceed 72 characters.

---

### Step 4 — Build the Commit Body (PR-Style)

#### Language Selection Rule:
- **Default / Bahasa Indonesia**: Use if the user prompt is in Indonesian, if requested, or if repository history predominantly uses Indonesian commit bodies.
- **English**: Use if the user prompt is in English, if requested, or if repository history is strictly English.
- Technical identifiers (method names, class names, file paths, variables) remain in their original code format regardless of language.

---

#### Template Option A: Bahasa Indonesia

```markdown
## Ringkasan Perubahan

<Satu paragraf, 3–6 kalimat yang menjelaskan MENGAPA perubahan dilakukan, konteks arsitektur, dan dampak teknis/bisnisnya. Jangan mengulang poin-poin yang sudah dirinci di bawah.>

---

### <Nomor>. <Nama Domain/Fitur> (<berkas utama>)

• **<Komponen/Class/Fungsi>**: <penjelasan teknis dan alasan perubahan>.
• **<Komponen>**: <penjelasan teknis dan alasan perubahan>.
[ulangi per komponen yang diubah dalam domain ini]

[ulangi section ### untuk setiap domain fungsional]

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
```

---

#### Template Option B: English

```markdown
## Summary of Changes

<One paragraph, 3–6 sentences explaining WHY the changes were made, architectural context, and business/technical impact. Do not repeat verbatim line items from the detailed sections below.>

---

### <Number>. <Domain/Feature Name> (<primary files>)

• **<Component/Class/Function>**: <technical reason and nature of the change>.
• **<Component>**: <technical reason and nature of the change>.
[repeat per changed component within this domain]

[repeat ### section for each functional domain]

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
```

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

1. **Display Preview**: Print the full commit title, body, and trailers in the chat.
2. **Options**:
   - Confirm and commit: Write message to `.commit-msg`, run `git commit -F .commit-msg`, then delete `.commit-msg`.
   - Modify message: Adjust specific sections upon request.
   - Save to file only: Save to `.commit-msg` without committing.

---

## Formatting and Quality Standards

- **Title**: Always English (Conventional Commits standard).
- **Tone**: Direct, technical, and objective. Avoid filler words ("berhasil", "dengan baik", "successfully", "properly").
- **Precision**: Reference exact symbol names, routes, configurations, and filenames.
- **Large Diffs**: If diff exceeds 500 lines across disjoint domains, propose splitting into logical commits before committing.
