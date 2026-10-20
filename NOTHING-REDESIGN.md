# SpotiFLAC — Nothing-inspired edition

Target: Nothing Phone (3a), Android ARM64. Based on upstream commit
`21ee30c46d405aa72dd650d0cc6e3da0df831c12`.

Nothing is the default appearance on a fresh installation. Existing saved
Material and Mornye selections remain available in Appearance settings.
System light/dark mode, AMOLED, custom fonts, localization and accessibility
text scaling remain supported.

The design uses neutral warm-white/charcoal surfaces, restrained red accents,
an original bundled dot-matrix display typeface, Inter reading text, outlined
icons, a disc launcher icon, consistent rounded cards and circular controls.

## Scope

All routes inherit the new theme, including the 99 screen/part files under
`lib/screens`. Shared headers, dialogs, sheets, menus, search, tabs, chips,
switches, progress, text fields and navigation use this design. Custom player
artwork, album/collection palettes, collection placeholders, Rewind, setup,
tutorial, About, service indicators and logs have additional overrides.
Artwork and user-selected lyric-share card content keep their original colors.

Playback, downloads, extensions, network storage, metadata editing, lyrics,
queue operations, equalizer and library logic remain in the existing code.
The original themes can still be selected for their original layout options.

## Build and validation

`.github/workflows/nothing-apk.yml` validates the app and builds the audited
ARM64 APK. It uses the repository's pinned Flutter/Rust/Android toolchains.
The artifact contains the APK, commit ID, SHA-256 and build notes. Crash symbols
are kept separately. This custom build uses Gradle's test signing key unless
the repository's release signing configuration is provided.

The workflow uses the Discord SDK when the existing repository secret is
configured. Without that private SDK it explicitly builds the existing Lite
variant, where Discord presence is unavailable. No other feature is deliberately
removed. This limitation must be disclosed with such an APK.

New widget checks exercise search callbacks, clearing, selection, modal sheets,
large-text headers, theme preference round trips, and text contrast in both
brightness modes. Existing design-system and preference-persistence tests are
also selected. Font structure and Android drawable XML can be checked locally.

Local network access and Flutter/Rust/Android toolchains were unavailable in
the editing workspace. A successful GitHub workflow run and APK audit are
required before treating this source change as an installable, verified build.
