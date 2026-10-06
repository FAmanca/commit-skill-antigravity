# Conventional Commits — Cheatsheet

Referensi cepat. Spec lengkap: https://www.conventionalcommits.org/en/v1.0.0/

---

## Format Dasar

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

---

## Tipe

| Tipe       | SemVer Bump | Keterangan                                         |
|------------|-------------|----------------------------------------------------|
| `feat`     | MINOR       | Fitur baru yang terlihat oleh pengguna akhir       |
| `fix`      | PATCH       | Perbaikan bug                                      |
| `refactor` | —           | Perubahan kode tanpa perubahan perilaku eksternal  |
| `perf`     | PATCH       | Perubahan yang meningkatkan performa               |
| `style`    | —           | Formatting, whitespace; tidak ada logika baru      |
| `test`     | —           | Penambahan atau koreksi test                       |
| `docs`     | —           | Dokumentasi saja                                   |
| `chore`    | —           | Tooling, konfigurasi, dependency update            |
| `build`    | —           | Perubahan sistem build (webpack, vite, dll.)       |
| `ci`       | —           | Pipeline CI/CD                                     |
| `revert`   | —           | Revert commit sebelumnya                           |

**BREAKING CHANGE**: Tambahkan `!` setelah type/scope, atau tuliskan
`BREAKING CHANGE: <deskripsi>` di footer. Ini memicu bump MAJOR.

Contoh: `feat(api)!: drop support for Node 14`

---

## Scope

- Tulis dalam huruf kecil, pisah kata dengan `-`.
- Gunakan nama modul atau area yang berubah.
- Contoh valid: `auth`, `ticket-it`, `kartu-stok`, `central-stock`, `pdf-export`.
- Jika lintas > 3 modul berbeda: gunakan `core` atau hilangkan scope.

---

## Rules

1. Judul (description) harus **imperatif, present tense**: "add" bukan "added".
   - Untuk Bahasa Indonesia di judul: tetap pakai English karena Conventional
     Commits adalah standar internasional.
2. Tidak ada titik di akhir judul.
3. Baris pertama maks **72 karakter**.
4. Pisah judul dan body dengan **satu baris kosong**.
5. Footer `Co-Authored-By` selalu menjadi baris **paling akhir**.

---

## Contoh Judul

```
feat(ticket-it): add sparepart stock deduction on IT ticket progress update
fix(kartu-stok): correct zero-stock indicator on combined PDF export
refactor(cari-sparepart): unify departemen filter mapping to id_departemen
chore(deps): upgrade laravel-livewire to v3.5.2
docs(readme): add setup instructions for Central Stock module
test(ticket-it): add unit tests for ItTicketType departemen resolution
```
