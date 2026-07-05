# GlouOS Settings: the complete guide

**GlouOS Settings** is the one place for everything about your system. It
replaces KDE System Settings in the menu while keeping absolutely every
control KDE offers: the app discovers every installed settings module at
runtime (the same metadata System Settings itself reads), so nothing is
ever missing, and modules added by future updates appear automatically.
Clicking any entry opens the full original page with every slider, button
and checkbox.

- **Search** covers names, descriptions and a large keyword set per page,
  so "mouse" also finds Pointers, and "fps" finds Display Configuration.
- Pages are grouped exactly like upstream KDE, with the GlouOS tools
  pinned at the top.
- Anything the app cannot classify still shows up under **Other**, so no
  setting can ever be lost.

---

## GlouOS

GlouOS's own tools, pinned first.

- **GlouOS Theme**: one-click switch between the light and dark look of
  the whole desktop. For deeper appearance changes (colors, icons,
  wallpaper) use the Appearance & Style section below.
- **Updates**: the full GlouOS update experience.
  - A status header shows whether you are up to date and when the last
    check happened, with a **Check for updates** button.
  - When updates exist, a banner offers **Download & install** with a
    live progress log. Updates are never forced and never nag; there is
    nothing to "pause" because nothing happens without you.
  - **Get the latest updates as soon as they're available** switches to
    the GlouOS beta channel (new features earlier, possibly less stable).
  - **Snapshots** lists the automatic before-update snapshots and can
    restore one with a click (your files in Home are untouched; snapshots
    can also be booted straight from the GRUB menu).
  - After a kernel or driver update, a restart reminder appears. Every
    update also runs the GlouOS safety net: the kernel is checked against
    stock Arch, driver modules are verified for every installed kernel,
    and the boot menu (including the **GlouOS (Debug)** fallback entry
    and Windows, if installed) is refreshed.
- **Secure Boot Setup**: a wizard that creates and enrolls your own
  Secure Boot keys with sbctl and signs the bootloader and kernel. After
  setup, signing stays automatic across kernel updates.
- **Performance Mode**: a toggle that disables CPU security mitigations
  for extra speed. This is a tradeoff (faster, less secure), it is off by
  default, and it takes effect after a restart.

---

## General

- **Quick Settings** (`kcm_landingpage`): a landing page with the most
  common basics in one place: light/dark theme, accent color and similar
  quick picks. Everything here also exists as a full page elsewhere.

## Input & Output

- **Game Controller** (`kcm_gamecontroller`): see every connected
  gamepad, test each button, stick and trigger live, and calibrate analog
  sticks. If a pad acts up in a game, this page tells you whether the
  system sees the inputs correctly.
- **Drawing Tablet** (`kcm_tablet`): map a drawing tablet to the right
  screen area, set pen pressure curves, remap pen and tablet buttons, and
  test the pen.
- **Sound** (`kcm_pulseaudio`): choose output and input devices, set
  per-device and per-application volumes, rename devices, pick the audio
  profile (stereo, surround, HDMI), test speakers, and set what happens
  when a new device is plugged in.
- **Accessibility** (`kcm_access`): visual and audible bells, sticky
  keys, slow keys, bounce keys, mouse navigation via the number pad,
  activation gestures and the screen reader toggle.

### Mouse & Touchpad

- **Mouse** (`kcm_mouse`): pointer speed and acceleration profile (flat
  acceleration matters for aiming precision in shooters), left/right
  handed buttons, scroll speed and direction, and double-click speed.
- **Touchpad** (`kcm_touchpad`): tap-to-click, two-finger right click,
  scrolling style and speed, disable-while-typing, and edge behaviors.

### Keyboard

- **Keyboard** (`kcm_keyboard`): key repeat rate and delay, NumLock at
  login, keyboard model, and keyboard layouts with per-layout switching
  shortcuts.
- **Virtual Keyboard** (`kcm_virtualkeyboard`): pick which on-screen
  keyboard is used on touch devices, or disable it.
- **Shortcuts** (`kcm_keys`): every global keyboard shortcut in the
  system, searchable, remappable, and restorable to defaults. Custom
  shortcuts for launching apps or commands live here too.

### Touchscreen

- **Touchscreen** (`kcm_touchscreen`): map a touchscreen to the correct
  display and rotation.
- **Touchscreen Gestures** (`kcm_kwintouchscreen`): configure what swipes
  from each screen edge do (open the overview, show the desktop, and so
  on).

### Display & Monitor

- **Display Configuration** (`kcm_kscreen`): arrange monitors, set
  resolution, **refresh rate**, scaling (including fractional), rotation,
  primary display, and **Adaptive Sync / VRR** per display. The most
  important page for gaming displays: this is where high refresh rates
  and variable refresh are switched on.
- **Night Light** (`kcm_nightlight`): warm the screen colors on a
  schedule or by sunrise/sunset location, with adjustable temperature.
- **Screen Edges** (`kcm_kwinscreenedges`): assign actions to screen
  corners and edges (overview, show desktop, tile windows) and tune how
  hard you must push to trigger them.

## Connected Devices

- **Bluetooth** (`kcm_bluetooth`): pair, trust, rename, connect and
  remove Bluetooth devices (controllers, headsets), toggle adapter power
  and visibility, and send files.

### Disks & Cameras

- **Device Actions** (`kcm_solid_actions`): what the system offers to do
  when you plug in a phone, camera or drive (open in file manager, play,
  download).
- **Device Auto-Mount** (`kcm_device_automounter`): whether removable
  drives mount automatically on login and on plug-in, per device or for
  all devices.

## Networking

- **Cellular Network** (`kcm_cellular_network`): mobile broadband (APN,
  data) for machines with a modem.
- **Wi-Fi** (`kcm_mobile_wifi`): the touch-friendly Wi-Fi network picker.
- **Wired Network** (`kcm_mobile_wired`): the touch-friendly wired
  settings page.
- **Hotspot** (`kcm_mobile_hotspot`): share this machine's connection as
  a Wi-Fi hotspot (name, password, band).

### Wi-Fi & Internet

- **Wi-Fi & Networking** (`kcm_networkmanagement`): the full connection
  editor: every saved Wi-Fi, wired, VPN and mobile connection with all
  details (IPv4/IPv6, DNS, routes, security, MAC address, auto-connect
  priorities).
- **Proxy** (`kcm_proxy`): system proxy configuration (none, auto-detect,
  PAC URL, or manual per-protocol servers with exceptions).
- **Connection Preferences** (`kcm_netpref`): timeouts for network
  operations and passive FTP mode.

## Appearance & Style

- **Wallpaper** (`kcm_wallpaper`): wallpaper per desktop and screen:
  single image, slideshow, plain color or picture-of-the-day, with
  positioning options.
- **Animations** (`kcm_animations`): a global animation speed slider
  (or off entirely) plus the style of individual transitions like window
  open/close, maximize and virtual desktop switching. Turning animations
  down makes the desktop feel snappier on slower GPUs.

### Colors & Themes

- **Global Theme** (`kcm_lookandfeel`): apply a complete look (colors,
  icons, cursors, splash, panel layout) in one go. GlouOS ships its own
  look here.
- **Colors** (`kcm_colors`): pick a color scheme, set the **accent
  color**, and switch between light and dark schemes (the GlouOS Theme
  quick toggle drives this page underneath).
- **Application Style** (`kcm_style`): the widget style used by apps,
  toolbar label style, and how GTK/GNOME apps are themed to match.
- **Plasma Style** (`kcm_desktoptheme`): the look of the panel, widgets
  and tray (the "shell" skin, independent of app colors).
- **Window Decorations** (`kcm_kwindecoration`): titlebar theme, border
  size, and which buttons appear on titlebars (drag to reorder).
- **Icons** (`kcm_icons`): the icon theme used everywhere, with per-size
  overrides.
- **Pointers** (`kcm_cursortheme`): the mouse pointer theme and size.
- **System Sounds** (`kcm_soundtheme`): the sound theme used for alerts
  and notifications, with previews.
- **Splash Screen** (`kcm_splashscreen`): the loading screen shown while
  the desktop starts (GlouOS ships its branded one), or none for the
  fastest visual login.

### Text & Fonts

- **Fonts** (`kcm_fonts`): the interface fonts (general, fixed width,
  toolbar, window title), global font size, anti-aliasing including
  sub-pixel rendering and hinting, and forced DPI.
- **Font Management** (`kcm_fontinst`): preview, install and remove
  fonts, per-user or system-wide, and organize them into groups.

## Apps & Windows

- **Notifications** (`kcm_notifications`): do-not-disturb behavior,
  popup position and timeout, notification sounds, progress reporting,
  badges, and per-application notification rules. Worth a visit if game
  sessions get interrupted by popups (GlouOS already quiets background
  noise while a game runs).
- **Activities** (`kcm_activities`): create and manage Activities
  (separate workspaces with their own wallpaper and history), switching
  shortcuts and privacy per Activity.

### Default Applications

- **Default Applications** (`kcm_componentchooser`): which browser, file
  manager, email client, terminal, music and video player handle their
  respective jobs.
- **File Associations** (`kcm_filetypes`): which application opens each
  file type, per MIME type, with per-type embedding rules and priority
  order.

### Window Management

- **Window Behavior** (`kcm_kwinoptions`): focus policy (click or hover),
  raising, snap zones, what double-clicking a titlebar does, titlebar
  button actions, and window placement for new windows.
- **Task Switcher** (`kcm_kwintabbox`): the Alt+Tab experience: visual
  style, ordering, whether minimized windows show, and a separate
  alternative switcher.
- **Desktop Effects** (`kcm_kwin_effects`): every compositor effect with
  on/off toggles and per-effect settings (wobbly windows, blur, zoom,
  dim inactive and many more). Fullscreen games bypass the compositor on
  GlouOS, so effects do not cost frames in game.
- **Window Rules** (`kcm_kwinrules`): per-window overrides matched by
  application or title: force size/position, keep above, skip switcher,
  disable compositing, and dozens more properties. Powerful for stubborn
  game launchers.
- **KWin Scripts** (`kcm_kwin_scripts`): enable, configure and install
  window manager scripts (tiling helpers and similar).
- **Virtual Desktops** (`kcm_kwin_virtualdesktops`): how many desktops,
  their layout in rows, names, and navigation behavior (GlouOS ships two
  by default).

## Workspace

- **General Behavior** (`kcm_workspace`): single vs double click to open
  files, tooltip visibility, and other whole-workspace behaviors.

### Search

- **File Search** (`kcm_baloofile`): the file indexer: which folders are
  indexed (or excluded), whether file contents are indexed, and index
  status. GlouOS pauses this automatically while a game is running.
- **Plasma Search** (`kcm_plasmasearch`): which providers feed the
  application launcher's search (files, apps, calculator, web keywords)
  and their order.

## Security & Privacy

- **Screen Locking** (`kcm_screenlocker`): lock on resume, lock after
  inactivity, the lock shortcut, and the lock screen's own appearance
  and wallpaper.
- **Recent Files** (`kcm_recentFiles`): whether recently used files are
  remembered, for which applications, and a one-click history wipe.
- **User Feedback** (`kcm_feedback`): how much anonymous usage data KDE
  components may report. GlouOS itself sends nothing.

### Application Permissions

- **Legacy X11 App Support** (`kcm_kwinxwayland`): which key events
  legacy X11 apps may see globally (a Wayland security control), and
  whether X11 apps may capture the screen.

## Language & Time

- **Region & Language** (`kcm_regionandlang`): display language plus
  per-category formats (numbers, currency, dates, measurement units).
- **Spell Check** (`kcmspellchecking`): dictionaries, personal word list
  and automatic language detection for text fields.
- **Date & Time** (`kcm_clock`): set the clock manually or via automatic
  time synchronization, and pick the time zone by map or search.
- **Day-Night Cycle** (`kcm_nighttime`): define when "day" and "night"
  are for features that follow them (like Night Light and dark mode
  switching).

## System

- **Energy** (`kcm_mobile_power`): the compact power page: screen
  timeout, sleep and lock behavior.
- **Power Management** (`kcm_powerdevilprofilesconfig`): full power
  profiles for AC, battery and low battery: screen brightness and
  dimming, sleep and hibernate timings, lid and power button actions,
  battery charge limit on supported laptops, and per-profile performance
  mode. GlouOS switches the CPU into performance while a game runs
  regardless of these settings, and back afterwards.
- **Users** (`kcm_users`): create and delete accounts, change names,
  passwords, avatars and administrator rights, and enroll fingerprints
  on supported hardware.
- **Autostart** (`kcm_autostart`): applications, scripts and login/logout
  scripts that run with your session, with add/remove and per-entry
  toggles.

### Session

- **Desktop Session** (`kcm_smserver`): whether the previous session's
  windows are restored at login, logout confirmation, default
  logout/shutdown behavior, and a button to reboot straight into the
  firmware (UEFI) setup.
- **Locations** (`kcm_desktoppaths`): where Desktop, Documents,
  Downloads, Music, Pictures and Videos actually live on disk. Handy for
  pointing Downloads at a bigger game drive.

## Other

Anything the catalog cannot place lands here rather than disappearing.
On a current install that is:

- **Plasma Renderer** (`kcm_qtquicksettings`): which graphics backend
  renders the desktop shell and whether its rendering is forced to
  software. A troubleshooting page: leave it alone unless the desktop
  itself misrenders.
- **Background Services** (`kcm_kded`): start/stop the desktop's
  background helper services and control which start at login. Also a
  troubleshooting page.
- **Web Search Keywords** (`kcm_webshortcuts`): the "dd duckduckgo"
  style search keywords usable from the launcher and address bars,
  fully editable.

---

## Tips

- The search bar is the fastest route: it matches far more words than
  what is printed on screen (every page ships dozens of hidden keywords).
- Settings pages open in their own window, so you can keep several open
  side by side.
- If a page you expect is missing, it belongs to an application that is
  not installed; installing it (for example via the GlouOS Package
  Manager) makes its settings appear here automatically after a restart
  of GlouOS Settings.
