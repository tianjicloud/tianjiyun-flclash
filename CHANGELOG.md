# Changelog

## v0.9.26 (2026-11-14)

**Bug Fixes**

- **profiles** Keep profiles whose rows have a bad optional column (56b7876)
- **profiles** Finish every import with a saved profile or an error (8fd4624)
- **profiles** Align the subscription page cards' content (c1a39c9)
- **profiles** Leave one import entry on the desktop subscription page (d32d02d)
- **profiles** Stop the business add form source cards overflowing (73d7cde)

## v0.9.25 (2026-11-14)

Internal improvements only.

## v0.9.24 (2026-11-14)

**Bug Fixes**

- **dashboard** Keep the layout still while live values change (f1f10d8)
- **ui** Show the cloud brand mark inside the window (9d9c82d)
- **dashboard** Keep the power button pulse inside its card (afce2a1)

## v0.9.23 (2026-11-13)

**Features**

- **macos** Add the app menu bar and window dragging (ffec66e)
- **macos** Fade between pages and sheets instead of jumping (ccb103a)
- **macos** One set of page, card and row metrics (b4f146d)
- **macos** Flatten the lines and settings navigation (7b2bb4b)
- **dashboard** Lead the macOS home with one state-driven hero (c7fc488)

**Bug Fixes**

- **ui** Speak the user's language on everyday pages (a3602a1)

## v0.9.22 (2026-11-13)

**Features**

- **macos** The AppIcon set is now the classic macOS template (824px rounded plate on transparency, deep-space art) so macOS 15 and earlier render a native rounded icon instead of a sharp full-bleed square. Alongside it, AppIcon.icon (Icon Composer, same name as the icon set) carries the full-bleed layered version: macOS 26 uses it and falls back to the set on earlier systems. The pairing and the hand-authored icon.json need the CI build to confirm actool accepts them; if it does not, removing AppIcon.icon restores the classic set alone. (bcc7f25)
- **macos** Add localized InfoPlist.strings (zh-Hans: 天机云, en: TianjiCloud) and register them in the Xcode project; the bundle stays TianjiCloud.app so packaging and update paths are unchanged. (54f3987)

**Bug Fixes**

- **dashboard** Push the business dashboard content down (703c867)
- **theme** Draw background choices from the raw assets (97fbea4)
- **macos** default_view must be 'icon-view' (dmgbuild's key); with 'icon' the icon-view settings block, including the background, would have been skipped entirely. Also pin text_size to Finder's 12pt so icon labels land on the plates as measured, and resolve the fallback background path lazily. (b79ee73)
- **macos** appdmg writes the installer background as a legacy alias record that current Finder versions no longer resolve, leaving the DMG window plain white even though the image is inside the image file. setup.dart now repackages the built .app with dmgbuild (settings in macos/packaging/dmg/dmgbuild_settings.py, same window, positions and background art) and replaces the distributor's DMG before checksums are generated. (2b2f0f9)
- **macos** Name the DMG volume in ASCII so Finder shows its background (ead41c2)
- **macos** Register the Icon Composer icon as a project resource (ef543f9)
- **macos** Let Finder show the localized app name (de03d12)
- **macos** The icon artwork floated on transparency, so Launchpad and the apps view padded it with the system grey tile. Bake the brand deep-space background into every icon size so the tile is ours. (d722dfb)
- **macos** Finder draws icon labels black in light appearance and white in dark appearance; on the dark installer background the black labels were unreadable. Semi-transparent plates (measured brightness ~131-137) keep both label colours legible. (6820b2f)
- **macos** Replace the near-white installer background with the dark deep-space design (brand gradient, orbit ring, icon stage glows) so the drag-to-install window matches the app (0f1e016)

**Performance**

- **theme** Decode background thumbnails at thumbnail size (fcbbf49)

## v0.9.21 (2026-11-13)

**Features**

- Add the deferred startup, provider, user agent, DNS route, memory and support items (df54e3c)

## v0.9.20 (2026-11-13)

**Features**

- **desktop** Add the custom profile side panel, the macOS dashboard layout and a macOS residential page (346041c)
- **dashboard** Make the tianjicloud dashboard editable and regroup settings like the design (228d015)
- **diagnostics** Check whether IPv6 can bypass the lines and offer a background residential check (053a1cb)
- **settings** Add the on-demand switch, hotkey reset and conflicts, provider health and TUN auto-route (4dbcb1e)
- **macos** Size type, controls and cards like a native Mac app (9854691)
- Fill in the small design gaps on lines, logs, profiles and about (01f3611)

**Bug Fixes**

- **navigation** Keep the classic sidebar toggle without patching prism_ui (c782742)
- **dashboard** Keep the exit chips on one row (0134602)
- **tray** Say why the macOS menu bar scenes are greyed out (082795a)
- **settings** Align appearance rows with their card titles (ddbeb06)
- **tray** Let the macOS menu bar connect and disconnect (fdd6821)

## v0.9.19 (2026-11-12)

**Features**

- **tray** Draw the macOS menu bar speed row and scene and mode switches natively (d563127)
- **android** Open the right page from notifications and alert on residential failures and expiry (05e3c1c)
- **dashboard** Verify the exit against the tianjicloud egress and nodes APIs (f24c6c7)
- **android** Name the current line in the notification and quick tile (1fe4e95)
- **tray** Order the tianjicloud tray and menu bar like the design (f6b1480)
- **ui** Finish the android tools, DNS, about and windows TUN pages (aacfb13)
- **desktop** Add the GNOME title bar, macOS sidebar and DNS resources page (d747c13)
- **onboarding** Show the expired subscription step on mobile (97a1fdf)
- **android** Match profile edit, DNS and resources, and advanced network (437bae6)
- **android** Match per-app proxy, onboarding failure and scan pages (9934944)
- **tools** Match the android tools, appearance and about pages (3588a54)
- **settings** Add a system service page for the desktop helper (d2fb1da)
- **ui** Explain core startup failures and add a core detail page (61af78e)
- **ui** Match onboarding, disclaimer and dashboard editor styling (7a0c285)
- **providers** Match providers and DNS query detail to the design (509c841)
- **profiles** Match the config preview and profile ordering sheet (e9683a2)
- **profiles** Match the overrides and scripts page to the design (1c742dc)
- **profiles** Match the custom groups, rules and providers tabs (4ae7f49)
- **profiles** Frame the custom profile editor and its proxies tab (768362a)
- **settings** Match MITM, icons and UA, developer and about pages (1c24a31)
- **settings** Match inbound, TUN, DNS and rules settings pages (c8aa9c4)
- **settings** Match hotkeys, on-demand and backup settings pages (e6f762f)
- **settings** Match the settings shell, general and appearance pages (771f94f)
- **proxies** Add a list view to the tianjicloud lines page (8613cd6)
- **profiles** Match the subscription editor to the tianjicloud design (8cd8c9b)
- **profiles** Add subscriptions from one tianjicloud dialog (0954d1c)
- **diagnostics** Match android diagnostics and align page titles (f563add)
- **logs** Match the windows logs and diagnostics page to the design (8cc2add)
- **connections** Match connection detail and android connections (1164080)
- **connections** Match the windows connections page to the design (ac97f8b)
- **profiles** Match the subscription page to the tianjicloud design (1c104e9)
- **proxies** Match the android lines page and residential sheet (1e7f4df)
- **proxies** Match the windows lines page to the tianjicloud design (b6ee016)
- **navigation** Size the sidebar to the window and move android mode (b14b4f8)
- **dashboard** Explain each scene and show the exit city (a575b45)
- **dashboard** Warn above the hero when the exit cannot be trusted (6971b20)
- **dashboard** Show an amber dial when the exit probe fails (5717f74)
- **dashboard** Match the android home to the tianjicloud design (5c52c11)
- **dashboard** Match the windows dashboard to the tianjicloud design (dae91e8)

**Bug Fixes**

- **ui** Size the about mark, provider metadata and service card to the design (804a743)

## v0.9.18 (2026-11-09)

**Bug Fixes**

- **scenes** Report failed scene switches and load complete scene rules without changing another subscription (285e655)
- **dashboard** Improve card spacing and keep line names and actions readable in narrow windows (f914262)
- **navigation** Extend backgrounds behind the sidebar and vertically align navigation labels (d5b7558)
- **macos** Replace the old macOS menu bar logo in monochrome and color modes (8fce7cf)
- **macos** Add a branded macOS installer background and larger installation icons (bf63ed1)

## v0.9.17 (2026-11-09)

**Features**

- **ui** Refresh Tianji dashboards, navigation, subscription management, and diagnostics. (23956e7)

## v0.9.16 (2026-11-08)

**Bug Fixes**

- **dashboard** Label core runtime status without a success check (51c5181)
- **dashboard** Route residential shortcuts through the exit selector (ec3b36d)
- **dashboard** Tighten hero spacing without changing visual tokens (d0f53bc)
- **dashboard** Reduce the sidebar subscription to one summary line (fdc19dd)
- **dashboard** Remember dismissed scene notices per subscription (e19ea90)
- **dashboard** Name mainland direct traffic explicitly (4e213bc)
- **dashboard** Bound exit confirmation and expose probe failures (cd99d03)
- **dashboard** Keep the normal residential card concise with one bypass explanation. (3d15d4e)
- **dashboard** Prevent scrolling content from showing through the light dashboard header. (eb4ea48)
- **dashboard** Improve light dashboard card separation and use the theme primary color for selected navigation. (bfec474)
- **dashboard** Align renewal and subscription actions, and show complete usage totals on their own line. (2616c3a)
- **dashboard** Hide cached exit IP, quality and verification notices while stopped, and retain the selected line name. (411e497)

## v0.9.15 (2026-11-08)

**Bug Fixes**

- **dashboard** Cut the residential card copy, slim the scene notice (8115b0f)

## v0.9.14 (2026-11-08)

**Bug Fixes**

- **dashboard** Fix desktop text scaling overflow, restore failed exit-check retries, and show the exact selected line instead of an automatic-group alias. (baf8ede)

## v0.9.13 (2026-11-08)

**Features**

- **dashboard** Redesigned desktop and mobile home screens with V3 layouts, matching navigation, clearer line names and compact controls. (c3a6f0c)

**Bug Fixes**

- **proxies** Drop group card corners one notch to lose the beak (276a2c4)

## v0.9.12 (2026-11-08)

**Features**

- **dashboard** Phone home matches the v3 mockup rows (8b66495)
- **dashboard** Deep-space glass cards per the v3 design (1394774)
- **dashboard** V3 home — real scene switch, quick lines, merged control bar (68c2610)
- **theme** Deep-space defaults, photo backgrounds, livelier start button (e3dda58)

**Bug Fixes**

- **dashboard** Scene bar crashed the phone home when scenes exist (c63766f)
- **dashboard** Equal height for the three home cards (928558d)
- **dashboard** Restart the idle pulse once the start morph settles (3f4cb29)
- **theme** Extend preset backgrounds across the sidebar and page as one continuous image while preserving page state. (d2a20b3)

## v0.9.11 (2026-11-07)

**Features**

- **theme** Choose solid, orbit or mountain backgrounds across application pages without resetting page state. (5f1efed)

**Bug Fixes**

- **windows** Replace the remaining FlClash tray icons with TianjiCloud icons for all Windows states. (893345f)
- **traffic** Show VPN, mainland direct and other direct shares with a centered savings total. (43b0922)
- **dashboard** Compact the Windows dashboard, follow the app palette and animate connection state transitions. (d37bff5)
- **update** Show update progress and installation controls on the Tianji dashboard and About page (842345d)

## v0.9.10 (2026-11-07)

**Features**

- **dashboard** Explain bulk routing on residential cards and line selection sheets (3346651)
- **residential** Route listed video and downloads through ordinary lines while preserving direct traffic (a258c72)
- **dashboard** Explain manual exit verification states (b709c66)
- **proxies** Preserve manual choices and verify default-route exits (d9383e9)
- **dashboard** Add the deep-space dashboard, orbital connection control, traffic savings ring and subscription expiry reminder. (52ea7a2)
- **theme** Use the new TianjiCloud brand color for new installations and preserve saved theme colors during upgrades. (ee87b08)

**Bug Fixes**

- **dashboard** Show available default lines and the current node while preserving subscription routing rules. (4c2f5ae)

## v0.9.9 (2026-11-07)

**Features**

- **dashboard** Show ordinary line controls for standard subscriptions and enable TUN for new desktop installs (d8c6938)

## v0.9.8 (2026-11-07)

Internal improvements only.

## v0.9.7 (2026-11-07)

Internal improvements only.

## v0.9.6 (2026-11-07)

Internal improvements only.

## v0.9.5 (2026-11-07)

**Features**

- **residential** Simplified Tianji dashboard with residential exit selection and fail-safe routing (85199bb)
- **traffic** Show traffic savings and automatically sync usage summaries for Tianji subscriptions (94df77e)
- Guide a new user from pasting a subscription to a verified connection (76d799e)
- Drop the disclaimer from startup and the tools page (b82d7ed)
- **desktop** Give the desktop builds their own identity (3cce975)
- **android** Replace the app icons with the 天机云 brand mark (781ea74)
- **android** Give the Android build its own identity and update source (19db3a7)

**Bug Fixes**

- **core** Keep the previous core configuration when a replacement is rejected (731ed7a)

## v0.9.3 (2026-11-04)

**Features**

- **connections** Merged requests and connections; quick edit lists (52b975f)
- **ui** iOS 27 transitions, press and text selection; smoother pages (bb47f2c)
- **update** Download and install updates in the app (b8f84b3)
- **core** One delay test timeout; VPN crash and startup fixes (2a5a42c)

**Bug Fixes**

- **core** Auto-select leaves an unusable first node at once (7d5db7e)
- **access** Keep selections a filter hides (63aaf6d)

## v0.9.2 (2026-10-24)

**Features**

- **access** Access control state shown in a bar at the bottom (e8aac17)
- **config** Optional general overrides; settings apply sooner (5d6552d)
- **dashboard** IP quality cached for 3 days; simpler Android dashboard (8176cce)
- Update the core to mihomo v1.19.33 (0817c3b)
- **tray** Colored tray status icons; monochrome option on macOS (bbfafde)
- **desktop** Sidebar blur; Windows fixes; keeps system proxies FlClash didn't set (6928521)
- **profiles** Profile QR codes, phone-to-TV links, more proxy fields (eaaf3e3)
- **proxies** Add proxies to local proxies; adjustable delay test timeout (0f9f89c)
- **theme** Higher-contrast dark mode and a refreshed app icon (a4fc067)
- **ui** iOS-style docked search and menus; bar buttons lift on hover (0d98a9d)
- **ui** iOS-style switches, stretchy sheets, menus and long-press reordering (ae902ed)
- **ui** Pages scroll under the Android navigation bar (4837fb3)
- **core** Clear the DNS cache by hand or on network change (09e7e56)

**Bug Fixes**

- **android** Opening the app no longer reloads a running VPN (99b3381)

**Performance**

- **editor** Smoother editor for large files and in sheets (7035edd)

## v0.9.1 (2026-10-17)

**Breaking Changes**

- **network** Desktop TUN keys follow the profile unless picked; changed values carry over (cb08088)

**Features**

- **l10n** French, Spanish and Korean translations (f43755c)
- **android** No more Firebase analytics or crash reporting (bc72bba)
- **network** Per-key desktop TUN settings; system proxy and tray fixes (cb08088)
- **theme** Redesigned theme colors and color styles (5eafd7a)
- **dashboard** A redesigned dashboard around the current exit (9bd258f)
- **profiles** Profile-detail resources and include-all in custom groups (0bac500)
- **proxies** Proxy groups as cards, group tabs as chips (2ea52fd)
- **views** Sortable tables for connections, requests and DNS (da6fb0a)
- **ui** Optional two-tier Liquid Glass and slide-to-pick menus (7c9627f)
- **ui** iOS-style surfaces, alerts and sheets; clearer TV focus (9bd2286)

**Bug Fixes**

- **ui** Fix pasting and Chinese input in text fields (5607f70)
- **core** Large profiles no longer crash; downloads trust core CAs (5984c16)

**Performance**

- **android** Smoother Android UI while the proxy is busy (2201c19)

## v0.9.0 (2026-10-14)

**Breaking Changes**

- **views** DNS and NTP override toggles are removed; picked keys apply to every profile (491fae1)
- **database** Custom overwrites are removed; rebuild them as custom profiles (1677024)

**Features**

- **views** Per-key DNS, NTP, sniffer and TUN settings (491fae1)
- **profiles** Custom profiles (3abda78)
- **ui** Stacked sheets, context menus and a sort mode (8c43053)
- **providers** DNS, Hosts and ports apply without a restart (532ebf0)
- **android** Launcher shortcuts and one-step on-demand access (d3fa225)
- **core** Share link import and mrs rule sets (2fa2f7f)

**Bug Fixes**

- **database** Unreadable settings no longer block startup or restores (1677024)
- **desktop** Windows and Linux desktop fixes (94a25f4)
- **core,helper** The elevated Core only answers its owner (d780cb8)

## v0.8.99 (2026-10-03)

**Features**

- **editor** Editor word wrap and snippets (e131675)
- **dashboard** More dashboard cards (e62afb7)
- **views** Hide timed-out nodes and search every list (8378c70)
- **ui** Sidebar, floating dock and drag to go back (841d603)
- **ui** New app glyphs, empty states and theme page (ee6a497)
- **overwrite** Invalid override warnings and rule presets (46fb7fe)
- **config** DNS query log and per-key DNS/NTP overrides (a390a42)
- **core** Proxied service checks and outbound IP risk (8068e68)
- **platform** Tray hotkeys, node delays and a delay test (1e97716)

**Bug Fixes**

- **core** A changed resource link is now used by the next sync and by auto update (ff23f30)
- **core** DNS lookups no longer fail on networks that report no DNS servers (e55f6d1)
- **proxies** Smaller icons in icon-only group headers (786a6ab)
- **core,android** Push notifications reconnect in Doze (1e9955d)
- **backup,database** Restores never apply halfway (bee8f24)

## v0.8.98 (2026-09-14)

**Bug Fixes**

- **resources** Refresh the geo file size and time after an update finishes (c5bf5bd)
- **core** Keep the core running while Windows sleeps with the app suspended (60f371a)

## v0.8.97 (2026-09-10)

**Features**

- **ui** Rework the app UI and refresh the localization (26cfbaf)
- **app** Rework the app layer and window handling, and add proxy authentication (aaf934c)
- **desktop** Rework the desktop runners, packaging, and native build (c0fcbc0)
- **android** Rework the Android VPN service and lifecycle handling (ae29f38)
- **plugins** Rework the desktop plugins and add the Helper service and Rust bridge (adf715f)
- **core** Rework the core IPC and process lifecycle (c6eaa0a)

<!-- changelog:frozen -->
<!-- Entries below predate the structured pipeline. Their wording is kept as written; only the heading and list style were normalized. -->

## v0.8.96 (2026-08-17)

- Optimize commented policy
- Fix whole group delay test failing on Windows
- Optimize package icon loading and connections polling

## v0.8.95 (2026-08-14)

- Optimize core service
- Optimize Android TV launcher icon
- Optimize back navigation
- Optimize more details
- Fix some issues
- Optimize app layout
- Optimize focus control
- Adjust android process

## v0.8.94 (2026-07-11)

- Fix macos performance issue
- Support custom global-ua
- Update core
- Optimize some details
- Fix linux silent launching not working

## v0.8.93 (2026-05-29)

- Support custom overwrite
- Support run on demand
- Optimize windows ipc
- Optimize windows arm64
- Optimize build
- Optimize some details
- Update core

## v0.8.92 (2026-02-02)

- Add sqlite store
- Optimize android quick action
- Optimize backup and restore
- Optimize more details

## v0.8.91 (2025-12-12)

- Fix windows some issues
- Optimize overwrite handle
- Optimize access control page
- Optimize some details

## v0.8.90 (2025-10-08)

- Fix android tile service
- Support append system DNS
- Fix some issues
- Update changelog

## v0.8.89 (2025-09-27)

- Fix some issues
- Optimize Windows service mode
- Update core
- Update changelog

## v0.8.88 (2025-09-23)

- Add android separates the core process
- Support core status check and force restart
- Optimize proxies page and access page
- Update flutter and pub dependencies
- Update go version
- Optimize more details
- Update changelog

## v0.8.87 (2025-07-29)

- Optimize desktop view
- Optimize logs, requests, connection pages
- Optimize windows tray auto hide
- Optimize some details
- Update core
- Update changelog

## v0.8.86 (2025-06-15)

- Fix windows tun issues
- Optimize android get system dns
- Optimize more details
- Update changelog

## v0.8.85 (2025-06-07)

- Support override script
- Support proxies search
- Support svg display
- Optimize config persistence
- Add some scenes auto close connections
- Update core
- Optimize more details

## v0.8.84 (2025-05-01)

- Fix windows service verify issues
- Update changelog

## v0.8.83 (2025-05-01)

- Add windows server mode start process verify
- Add linux deb dependencies
- Add backup recovery strategy select
- Support custom text scaling
- Optimize the display of different text scale
- Optimize windows setup experience
- Optimize startTun performance
- Optimize android tv experience
- Optimize default option
- Optimize computed text size
- Optimize hyperOS freeform window
- Add developer mode
- Update core
- Optimize more details
- Add issues template
- Update changelog

## v0.8.82 (2025-04-18)

- Optimize android vpn performance
- Add custom primary color and color scheme
- Add linux nad windows arm release
- Optimize requests and logs page
- Fix map input page delete issues
- Update changelog

## v0.8.81 (2025-04-08)

- Add rule override
- Update core
- Optimize more details
- Update changelog

## v0.8.80 (2025-03-10)

- Optimize dashboard performance
- Fix some issues
- Fix unselected proxy group delay issues
- Fix asn url issues
- Update changelog

## v0.8.79 (2025-03-07)

- Fix tab delay view issues
- Fix tray action issues
- Fix get profile redirect client ua issues
- Fix proxy card delay view issues
- Add Russian, Japanese adaptation
- Fix some issues
- Update changelog

## v0.8.78 (2025-03-05)

- Fix list form input view issues
- Fix traffic view issues
- Update changelog

## v0.8.77 (2025-03-05)

- Optimize performance
- Update core
- Optimize core stability
- Fix linux tun authority check error
- Fix some issues
- Fix scroll physics error
- Update changelog

## v0.8.75 (2025-02-09)

- Add windows storage corruption detection
- Fix core crash caused by windows resource manager restart
- Optimize logs, requests, access to pages
- Fix macos bypass domain issues
- Update changelog

## v0.8.74 (2025-02-03)

- Fix some issues
- Update changelog

## v0.8.73 (2025-02-02)

- Update popup menu
- Add file editor
- Fix android service issues
- Optimize desktop background performance
- Optimize android main process performance
- Optimize delay test
- Optimize vpn protect
- Update changelog

## v0.8.72 (2025-01-10)

- Update core
- Fix some issues
- Update changelog

## v0.8.71 (2025-01-09)

- Remake dashboard
- Optimize theme
- Optimize more details
- Update flutter version
- Update changelog

## v0.8.70 (2024-12-09)

- Support better window position memory
- Add windows arm64 and linux arm64 build script
- Optimize some details

## v0.8.69 (2024-12-06)

- Remake desktop
- Optimize change proxy
- Optimize network check
- Fix fallback issues
- Optimize lots of details
- Update change.yaml
- Fix android tile issues
- Fix windows tray issues
- Support setting bypassDomain
- Update flutter version
- Fix android service issues
- Fix macos dock exit button issues
- Add route address setting
- Optimize provider view
- Update changelog
- Update CHANGELOG.md

## v0.8.67 (2024-11-09)

- Add android shortcuts
- Fix init params issues
- Fix dynamic color issues
- Optimize navigator animate
- Optimize window init
- Optimize fab
- Optimize save

## v0.8.66 (2024-10-26)

- Fix the collapse issues
- Add fontFamily options

## v0.8.65 (2024-10-26)

- Update core version
- Update flutter version
- Optimize ip check
- Optimize url-test

## v0.8.64 (2024-10-12)

- Update release message
- Init auto gen changelog
- Fix windows tray issues
- Fix urltest issues
- Add auto changelog
- Fix windows admin auto launch issues
- Add android vpn options
- Support proxies icon configuration
- Optimize android immersion display
- Fix some issues
- Optimize ip detection
- Support android vpn ipv6 inbound switch
- Support log export
- Optimize more details
- Fix android system dns issues
- Optimize dns default option
- Fix some issues
- Update readme

## v0.8.60 (2024-09-17)

- Fix build error2
- Fix build error
- Support desktop hotkey
- Support android ipv6 inbound
- Support android system dns
- fix some bugs

## v0.8.59 (2024-09-09)

- Fix delete profile error

## v0.8.58 (2024-09-08)

- Fix submit error 2
- Fix submit error
- Optimize DNS strategy
- Fix the problem that the tray is not displayed in some cases
- Optimize tray
- Update core
- Fix some error

## v0.8.57 (2024-09-02)

- Fix tun update issues
- Add DNS override
- Fixed some bugs
- Optimize more detail
- Add Hosts override

## v0.8.56 (2024-08-26)

- fix android tip error
- fix windows auto launch error

## v0.8.55 (2024-08-25)

- Fix windows tray issues
- Optimize windows logic
- Optimize app logic
- Support windows administrator auto launch
- Support android close vpn

## v0.8.53 (2024-08-15)

- Change flutter version
- Support profiles sort
- Support windows country flags display
- Optimize proxies page and profiles page columns

## v0.8.52 (2024-08-11)

- Update flutter version
- Update version
- Update timeout time
- Update access control page
- Fix bug

## v0.8.51 (2024-08-05)

- Optimize provider page
- Optimize delay test
- Support local backup and recovery
- Fix android tile service issues

## v0.8.49 (2024-07-31)

- Fix linux core build error
- Add proxy-only traffic statistics
- Update core
- Optimize more details
- Merge pull request #140 from txyyh/main
- 添加自建 F-Droid 仓库相关 workflow
- Rename readme fingerprint
- Rename workflow deploy repo name
- Add download guide to README
- Add push release files to fdroid-repo

## v0.8.48 (2024-07-25)

- Optimize proxies page
- Fix ua issues
- Optimize more details

## v0.8.47 (2024-07-22)

- Fix windows build error

## v0.8.46 (2024-07-22)

- Update app icon
- Fix desktop backup error
- Optimize request ua
- Change android icon
- Optimize dashboard

## v0.8.44 (2024-07-18)

- Remove request validate certificate
- Sync core

## v0.8.43 (2024-07-18)

- Fix windows error

## v0.8.42 (2024-07-18)

- Fix setup.dart error
- Fix android system proxy not effective
- Add macos arm64

## v0.8.41 (2024-07-17)

- Optimize proxies page
- Support mouse drag scroll
- Adjust desktop ui
- Revert "Fix android vpn issues"
- This reverts commit 891977408e6938e2acd74e9b9adb959c48c79988.

## v0.8.40 (2024-07-15)

- Fix android vpn issues
- Fix android vpn issues
- Rollback partial modification

## v0.8.39 (2024-07-15)

- Fix the problem that ui can't be synchronized when android vpn is occupied by an external
- Override default socksPort,port

## v0.8.38 (2024-07-14)

- Fix fab issues

## v0.8.37 (2024-07-14)

- Update version
- Fix the problem that vpn cannot be started in some cases
- Fix the problem that geodata url does not take effect

## v0.8.36 (2024-07-13)

- Update ua
- Fix change outbound mode without check ip issues
- Separate android ui and vpn
- Fix url validate issues 2
- Add android hidden from the recent task
- Add geoip file
- Support modify geoData URL

## v0.8.35 (2024-07-07)

- Fix url validate issues
- Fix check ip performance problem
- Optimize resources page

## v0.8.34 (2024-07-04)

- Add ua selector
- Support modify test url
- Optimize android proxy
- Fix the error that async proxy provider could not selected the proxy

## v0.8.33 (2024-07-01)

- Fix android proxy error
- Fix submit error
- Add windows tun
- Optimize android proxy
- Optimize change profile
- Update application ua
- Optimize delay test

## v0.8.32 (2024-06-28)

- Fix android repeated request notification issues

## v0.8.31 (2024-06-28)

- Fix memory overflow issues

## v0.8.30 (2024-06-27)

- Optimize proxies expansion panel 2
- Fix android scan qrcode error

## v0.8.29 (2024-06-27)

- Optimize proxies expansion panel
- Fix text error

## v0.8.28 (2024-06-26)

- Optimize proxy
- Optimize delayed sorting performance
- Add expansion panel proxies page
- Support to adjust the proxy card size
- Support to adjust proxies columns number
- Fix autoRun show issues
- Fix Android 10 issues
- Optimize ip show

## v0.8.26 (2024-06-22)

- Add intranet IP display
- Add connections page
- Add search in connections, requests
- Add keyword search in connections, requests, logs
- Add basic viewing editing capabilities
- Optimize update profile

## v0.8.25 (2024-06-19)

- Update version
- Fix the problem of excessive memory usage in traffic usage.
- Add lightBlue theme color
- Fix start unable to update profile issues
- Fix flashback caused by process

## v0.8.23 (2024-06-16)

- Add build version
- Optimize quick start
- Update system default option

## v0.8.22 (2024-06-16)

- Update build.yml
- Fix android vpn close issues
- Add requests page
- Fix checkUpdate dark mode style error
- Fix quickStart error open app
- Add memory proxies tab index
- Support hidden group
- Optimize logs
- Fix externalController hot load error

## v0.8.21 (2024-06-13)

- Add tcp concurrent switch
- Add system proxy switch
- Add geodata loader switch
- Add external controller switch
- Add auto gc on trim memory
- Fix android notification error

## v0.8.20 (2024-06-12)

- Fix ipv6 error
- Fix android udp direct error
- Add ipv6 switch
- Add access all selected button
- Remove android low version splash

## v0.8.19 (2024-06-10)

- Update version
- Add allowBypass
- Fix Android only pick .text file issues

## v0.8.18 (2024-06-09)

- Fix search issues

## v0.8.17 (2024-06-09)

- Fix LoadBalance, Relay load error
- Fix build.yml4
- Fix build.yml3
- Fix build.yml2
- Fix build.yml
- Add search function at access control
- Fix the issues with the profile add button to cover the edit button
- Adapt LoadBalance and Relay
- Add arm
- Fix android notification icon error

## v0.8.16 (2024-06-08)

- Add one-click update all profiles
- Add expire show

## v0.8.15 (2024-06-06)

- Temp remove tun mode
- Remove macos in workflow
- Change go version

## v0.8.14 (2024-06-06)

- Update Version
- Fix tun unable to open

## v0.8.13 (2024-06-06)

- Optimize delay test2
- Optimize delay test
- Add check ip
- add check ip request

## v0.8.12 (2024-06-06)

- Fix the problem that the download of remote resources failed after GeodataMode was turned on, which caused the
  application to flash back.
- Fix edit profile error
- Fix quickStart change proxy error
- Fix core version

## v0.8.10 (2024-06-05)

- Fix core version

## v0.8.9 (2024-06-05)

- Update file_picker
- Add resources page
- Optimize more detail
- Add access selected sorted
- Fix notification duplicate creation issue
- Fix AccessControl click issue

## v0.8.7 (2024-05-31)

- Fix Workflow
- Fix Linux unable to open
- Update README.md 3
- Create LICENSE
- Update README.md 2
- Update README.md
- Optimize workFlow

## v0.8.6 (2024-05-31)

- optimize checkUpdate

## v0.8.5 (2024-05-30)

- Fix submit error

## v0.8.4 (2024-05-30)

- add WebDAV
- add Auto check updates
- Optimize more details
- optimize delayTest

## v0.8.2 (2024-05-15)

- upgrade flutter version

## v0.8.1 (2024-05-15)

- Update kernel
- Add import profile via QR code image

## v0.8.0 (2024-05-11)

- Add compatibility mode and adapt clash scheme.

## v0.7.14 (2024-05-07)

- update Version
- Reconstruction application proxy logic

## v0.7.13 (2024-05-06)

- Fix Tab destroy error

## v0.7.12 (2024-05-06)

- Optimize repeat healthcheck

## v0.7.11 (2024-05-06)

- Optimize Direct mode ui

## v0.7.10 (2024-05-06)

- Optimize Healthcheck
- Remove proxies position animation, improve performance
- Add Telegram Link
- Update healthcheck policy
- New Check URLTest
- Fix the problem of invalid auto-selection

## v0.7.8 (2024-05-05)

- New Async UpdateConfig
- add changeProfileDebounce
- Update Workflow
- Fix ChangeProfile block
- Fix Release Message Error

## v0.7.7 (2024-05-04)

- Update Selector 2

## v0.7.6 (2024-05-04)

- Update Version
- Fix Proxies Select Error

## v0.7.5 (2024-05-03)

- Fix the problem that the proxy group is empty in global mode.
- Fix the problem that the proxy group is empty in global mode.

## v0.7.4 (2024-05-03)

- Add ProxyProvider2

## v0.7.3 (2024-05-03)

- Add ProxyProvider
- Update Version
- Update ProxyGroup Sort
- Fix Android quickStart VpnService some problems

## v0.7.1 (2024-05-01)

- Update version
- Set Android notification low importance
- Fix the issue that VpnService can't be closed correctly in special cases
- Fix the problem that TileService is not destroyed correctly in some cases
- Adjust tab animation defaults
- Add Telegram in README_zh_CN.md
- Add Telegram

## v0.7.0 (2024-04-30)

- update mobile_scanner
- Initial commit
