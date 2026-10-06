# Antigravity Git Workspace Skills

Specialized agent skills for automated Git commit authoring, branch management, and remote publishing within the Google Antigravity ecosystem.

---

## Available Skills

### 1. `commit` (`.agents/skills/commit/`)
Generates Conventional Commits titles (English) and PR-style commit bodies (in Bahasa Indonesia or English) from staged or unstaged diffs, previews the message, and executes local `git commit`.

**Triggers**:
- `/commit`
- `commit message`
- `commit desc`
- `create commit`
- `buatkan commit`

### 2. `commit-push` (`.agents/skills/commit-push/`)
Automates the full delivery flow:
1. Enforces switching to a semantic feature branch via `git switch -c <type>/<description>`. Direct commits to `main`/`master` are disallowed.
2. Analyzes diffs and drafts a Conventional Commit title with a PR-style body in Bahasa Indonesia or English.
3. Attaches the `Assisted-By: Google Antigravity` trailer.
4. Stages changes and commits via `git commit -F .commit-msg`.
5. Pushes the branch to remote via `git push -u origin <branch>` and outputs the PR creation URL.

**Triggers**:
- `/commit-push`
- `/commit&push`
- `commit and push`
- `commit push`

---

## Language Rules

- **Commit Title**: Always English following Conventional Commits (`<type>(<scope>): <subject>`).
- **Commit Body**: Supports both **Bahasa Indonesia** (default when prompt or repo history is in Indonesian) and **English** (when prompt or repo history is in English).
- **Technical identifiers**: Class names, method names, variables, and file paths remain intact in their original code syntax.

---

## Branch Naming Standard (`commit-push`)

All branches created by the `commit-push` skill follow semantic convention:

```
<type>/<kebab-case-description>
```

Examples:
- `feat/jwt-authentication`
- `fix/table-pagination-overflow`
- `refactor/clean-architecture-storage`
- `chore/update-dependencies`

---

## Commit Structure

### Conventional Commit Title (English)
```
<type>(<scope>): <short description, max 72 chars>
```

### Commit Body Option A: Bahasa Indonesia
```markdown
## Ringkasan Perubahan
<Konteks perubahan dan dampak teknis/bisnis.>

---

### 1. <Domain/Fitur> (<berkas>)
• **<Komponen>**: <penjelasan teknis dan alasan perubahan>.

---

## Cara Pengetesan
<Langkah-langkah pengujian bernomor.>

---

## Berkas yang Diperbarui (<jumlah> Berkas)
• <daftar path berkas>

---

## Pengujian (Testing Done)
[✓] <pengujian selesai>: <ringkasan hasil>
[✗] <pengujian tertunda>: <alasan>

Assisted-By: Google Antigravity
```

### Commit Body Option B: English
```markdown
## Summary of Changes
<High-level context and behavioral impact.>

---

### 1. <Domain/Feature> (<files>)
• **<Symbol/Component>**: <technical rationale and details>.

---

## Testing Instructions
<Step-by-step verification instructions.>

---

## Modified Files (<count> Files)
• <file paths>

---

## Test Verification
[✓] <completed test>: <summary>
[✗] <pending verification>: <reason>

Assisted-By: Google Antigravity
```

---

## Attribution Trailer Standards

To avoid GitHub attributing commits to random third-party profiles (which happens when using `Co-Authored-By` with email addresses claimed by external accounts), this skill utilizes:

```
Assisted-By: Google Antigravity
```

This complies with Git trailer RFC specifications while keeping contributor graphs and commit insights clean on GitHub.

---

## Repository Structure

```
.agents/
└── skills/
    ├── commit/
    │   ├── SKILL.md
    │   └── scripts/
    │       └── gen-commit-msg.sh
    └── commit-push/
        ├── SKILL.md
        └── scripts/
            └── gen-commit-msg.sh
```

---

## Installation

### Project Level
Keep the `.agents/` directory at the root of your target repository.

### Global Installation (All Projects)
Copy the `skills/` contents to your global Antigravity config directory:

- **Windows**:
  ```powershell
  Copy-Item -Recurse -Force .agents\skills\* "$HOME\.gemini\config\skills\"
  ```
- **macOS / Linux**:
  ```bash
  cp -r .agents/skills/* ~/.gemini/config/skills/
  ```

---

## License

MIT
