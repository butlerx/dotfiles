# Firefox

`firefox/butlerx.default/` holds the two files Firefox reads from a profile
directory:

- `chrome/` — userChrome and userContent CSS
- `user.js` — prefs applied at every startup

The profile path differs per platform, and a pets `when` condition applies to a
whole file, so each source is declared twice:

| Declaration                | Destination                                                        | OS    |
| -------------------------- | ------------------------------------------------------------------ | ----- |
| `chrome/.petsfile`         | `~/.mozilla/firefox/butlerx.default/chrome`                        | linux |
| `chrome.petsfile`          | `~/Library/Application Support/Firefox/Profiles/<profile>/chrome`  | macos |
| modelines inside `user.js` | `~/.mozilla/firefox/butlerx.default/user.js`                       | linux |
| `user.js.petsfile`         | `~/Library/Application Support/Firefox/Profiles/<profile>/user.js` | macos |

The macOS profile directory name is machine specific. Check `profiles.ini` in
`~/Library/Application Support/Firefox` and update both sidecars when setting up
a new Mac; the Linux profile name is fixed by `butlerx.default`.

`userChrome.css` only applies when
`toolkit.legacyUserProfileCustomizations.stylesheets` is true, which `user.js`
sets.
