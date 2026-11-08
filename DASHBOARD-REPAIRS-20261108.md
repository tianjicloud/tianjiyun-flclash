# Dashboard repairs — 2026-11-08

## Scope and adjudications

Branch: tianjiyun-dev. Baseline: 018dcb38 (v0.9.15). Pulled with
`git pull --ff-only` before work and again before publishing; no incoming changes.

This delivery implements the user's P1–P10 decisions of 2026-11-08.
P4/P9 are no longer awaiting approval. P2/P3/P5/P6/P10 follow the explicit
adjudications, including keeping exit verification active while running.

| Item | Status / commits | Result |
| --- | --- | --- |
| P1 | 3d15d4ec | Normal residential card keeps only the bypass sentence, selected line and actions. Removed the extra active-state description. Necessary unavailable/failure messages remain honest. |
| P2 | 411e497b, cd99d03d | Stopped business hero hides stale IP, organization and quality; shows the selected line. Running verification continues. Fresh probe failure is explicit with retry; confirming has a 15-second presentation deadline. Timers stop when not observed and restart on resubscription. |
| P3 | e19ea90d | Unavailable scene notice is a 40px single-line dismissible strip. Dismissal is persisted in the current profile's overrides; another profile remains independent. Available scene groups supersede the notice. |
| P4 | ec3b36d8 | Residential quick entries open the same residential sheet as the card. Their tap never calls ordinary changeProxy. Their selected state reads residential policy, including the configured exit; ordinary selectedMap cannot mark them selected. Recognition uses the existing residential group constants and catalog choices, not names containing “home”. |
| P5 | 4e213bc8, ef23e0ee | Business ring center is “本月大陆直连”; “其他直连” becomes “直连（地区未确认）”. Seven ARBs and generated translations synchronized. Center label wraps without ellipsis; adaptive byte formatting and all accounting calculations unchanged. Local/month scope note retained. |
| P6 | 2616c3ad, fdc19dda | Dashboard keeps full expiry/usage detail. Renewal and secondary actions share a row; usage uses compact complete numeric text. Sidebar keeps only subscription name and days remaining, without usage percent/progress. |
| P7 | bfec4745 | Light cards gain visible depth; light sidebar selection uses the theme primary. Light quality-label contrast test enforces at least 4.5:1. Dark card parameters preserved. |
| P8 | eb4ea480 | Light business top bar is opaque with a separator. Opt-in scaffold behavior leaves other pages unchanged. Mid-scroll Flutter screenshot checked without text showing through. |
| P9 | 51c51810 | Neutral CPU glyph plus “内核状态” and running/not-running label replace the green success check. Label remains visible on mobile; compact two-line layout avoids narrow-toolbar overflow. Restart confirmation and lifecycle action unchanged. |
| P10 | d0f53bc1 | Only existing minimum heights and gaps changed. Metadata is closer together; speeds are closer to the connection control. No structural rebuild, color/radius/background/planet changes. |

## Verification

- `flutter pub get`: passed.
- `dart run build_runner build`, `dart run intl_utils:generate`: passed; generated files were not manually edited.
- `dart format lib test tool plugins setup.dart`: clean.
- `flutter analyze --no-fatal-infos`: No issues found.
- `dart run tool/test.dart` (repository runner invoking flutter test): final unique coverage
  **5,148 passed, 6 skipped**. Initial bundled pass: 5,145 passed, 3 failed,
  6 skipped. The filled-button glyph lint was corrected (CPU fill); the two
  edit_test failures were shared-isolate periodic-timer state and passed the
  runner's isolated rerun. Both affected files passed on rerun.
- Final focused `flutter test` for traffic_savings, filled_button_glyphs and
  core_status_button: **9 passed**.
- Flutter raster fixture checks: **7 previews passed**, desktop 1568×1024 and
  1280×800, mobile 390×844, including dark/light and 1.6× text. Traffic checks
  plus final preview run: **10 passed**.
- Screenshot review checked full ring title, centered values, subscription actions,
  sidebar summary, neutral core label, dark hero layout, and light mid-scroll header.
  Fixtures are synthetic; no customer subscription credentials were used.
- Profile dismissal serialization/isolation, available-scene hiding, residential
  shortcut routing/selection, timeout/failure/retry, stopped exit hiding and
  narrow/large-text layouts are covered by automated tests.

Local environment: cargo is not on PATH. Verification temporarily disabled native
asset-build hooks and used the existing cached Rust library for tests, restoring
pubspec afterward. These checks do not claim a new native core/helper build.
Windows installation, real network takeover and online-update acceptance remain
for the Windows package/CI and the user's machine.

## Review and limits

Reviewed the new timeout lifecycle and shared residential entry ownership; no
new parallel selection writer or widget import cycle remains. Mechanical text,
generated output and local layout changes skipped extra structural review.

Diff reviewed: no changes to Go/Mihomo, subscription authentication, traffic
accounting/reporting contracts, platform IDs, signing keys, icon assets or v3
dark visual tokens. Version/changelog/tag changes are separately authorized by
the deployment request. No unresolved design approvals remain.

No development servers were started. 起过的端口已全部关闭（本轮未启动监听端口）.
