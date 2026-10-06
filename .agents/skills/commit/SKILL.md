---
name: commit
description: >-
  Use this skill whenever the user wants to create a git commit — title and/or
  full body description. It reads git diff --staged (or unstaged if nothing is
  staged), analyzes all changes, and produces: (1) a short Conventional Commits
  title, (2) a PR-style body in Bahasa Indonesia covering Ringkasan Perubahan,
  per-domain technical details, Cara Pengetesan, Berkas yang Diperbarui, and
  Pengujian status. Also activate when the user says "/commit", "buatkan commit",
  "commit desc", "commit message", or "commit description".
---

# Commit Skill

Automates the full git commit authoring workflow — from diff analysis to a
final commit message — with no manual input required beyond scope clarification
if the diff is ambiguous.

---

## Workflow (Follow in Order)

### Step 1 — Collect Context

Run the following commands in sequence. Stop at the first one that returns
meaningful output:

```bash
# 1a. Staged diff (primary)
git diff --staged --stat
git diff --staged

# 1b. If staged is empty, fall back to unstaged
git diff --stat
git diff

# 1c. Additional metadata
git log --oneline -10          # historical commit style in this repo
git status --short             # new / deleted / renamed files
git branch --show-current      # active branch name
```

Read the full output. Do not skip or truncate the diff.

---

### Step 2 — Analyze Changes

Group changes by **functional domain**, not by directory structure. Each group
becomes one `###` section in the commit body.

Guiding questions:
- What changed **behaviorally** (not just textually)?
- Are any changes **breaking** or **deprecating** something?
- Are there **database schema / migration** changes?
- What **side-effects** need to be tested?

---

### Step 3 — Determine the Commit Title

Required format (Conventional Commits):

```
<type>(<scope>): <short description, max 72 chars>
```

**Allowed types:**

| Type       | When to Use                                                    |
|------------|----------------------------------------------------------------|
| `feat`     | New user-facing feature                                        |
| `fix`      | Bug fix                                                        |
| `refactor` | Restructuring without behavior change                          |
| `perf`     | Performance improvement                                        |
| `style`    | Formatting, whitespace — no logic change                       |
| `test`     | Adding or updating unit / integration tests                    |
| `docs`     | Documentation only                                             |
| `chore`    | Configuration, tooling, CI/CD, dependency updates              |
| `build`    | Build system or external dependency changes                    |
| `ci`       | CI/CD pipeline changes                                         |
| `revert`   | Reverts a previous commit                                      |

**Scope rules:**
- Use the module or feature name being changed (e.g., `ticket-it`,
  `kartu-stok`, `central-stock`, `auth`).
- If changes span > 3 unrelated modules, use `core` or omit the scope.
- When multiple types apply, pick the highest business-value type:
  `feat` > `fix` > `refactor` > everything else.

**Title must NOT:**
- End with a period.
- Use vague verbs like "update", "change", or "modify" without specific context.
- Exceed 72 characters.

---

### Step 4 — Build the Commit Body (PR-Style)

Use the template below. Fill each section based on the analysis. Remove any
section that is entirely irrelevant — do not leave it empty.

```markdown
## Ringkasan Perubahan

<one paragraph, 3–6 sentences explaining WHY this change was made and its
primary business/technical impact. Do not repeat what the ### sections cover.>

---

### <Number>. <Domain/Feature Name> (<main files>)

• **<Component/Class/Method>**: <explanation of change and technical reason>.
• **<Component>**: <explanation>.
[repeat per changed component within this domain]

[repeat ### section for each functional domain]

---

## Cara Pengetesan

<numbered steps for manual testing, detailed enough for a reviewer who has not
read the code. Include URLs, menu paths, or CLI commands where relevant.>

---

## Berkas yang Diperbarui (<count> Berkas)

<bullet list of file paths relative to repo root, sorted alphabetically by
directory>

---

## Pengujian (Testing Done)

[✓] <test type>: <result summary>
[✗] <test not yet run> — <reason / TODO>
```

---

### Step 5 — Add Trailers

Always append the following trailer at the **end of the body**, separated by
one blank line from the last content line:

```
Co-Authored-By: Google Antigravity <antigravity@google.com>
```

If additional human co-authors are identified from `git log`, add them too:

```
Co-Authored-By: Full Name <email@domain.com>
```

---

### Step 6 — Preview then Commit

**Default: preview mode — output the message first, do not commit immediately.**

Output the full message (title + body + trailers) directly into chat with no
wrapper or extra annotation. The user can read, copy, or request edits before
proceeding.

After displaying the preview, offer three options:
1. Run `git commit` immediately using that message.
2. Edit a specific section the user requests.
3. Save to `.commit-msg` at the repo root.

If the user confirms the commit, write the message to `.commit-msg` using
`write_to_file`, run `git commit -F .commit-msg`, then delete `.commit-msg`.

---

## Additional Rules

### Language
- **Title**: English (Conventional Commits is an international standard).
- **Body**: Bahasa Indonesia. Technical names (class, method, variable, file
  path) remain in their original form.

### Length & Density
- Title: max 72 characters.
- Each body bullet: max 2 lines wrapped at 100 characters.
- `Ringkasan Perubahan` section: 3–6 sentences, not bullet points.

### Information Quality
- Use **concrete names**: method names, class names, routes, column names —
  never "some functions" or "several components".
- For each technical change, explain **why**, not just **what**.
- Avoid filler words in the body: "berhasil", "dengan baik", "sudah", "telah",
  "sekarang".

### Multi-Commit (Squash Candidates)
If the diff exceeds 500 lines AND spans truly independent domains (e.g.,
database migration + new UI feature + auth hotfix), recommend splitting into
separate commits. Present a split plan before drafting each message.

---

## Internal References

- [Conventional Commits Cheatsheet](./references/conventional-commits.md)
- [Scope & Type Decision Guide](./references/scope-guide.md)
