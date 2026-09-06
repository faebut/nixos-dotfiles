-- ============================================================
-- Hyprland Lua Configuration
-- Converted from hyprland.conf (hyprlang → Lua)
-- ============================================================

-- -------------------------
-- Rose Pine Moon colours
-- -------------------------
local base = 0xff232136
local surface = 0xff2a273f
local overlay = 0xff393552
local muted = 0xff6e6a86
local subtle = 0xff908caa
local text_col = 0xffe0def4
local love = 0xffeb6f92
local gold = 0xfff6c177
local rose = 0xffea9a97
local pine = 0xff3e8fb0
local foam = 0xff9ccfd8
local iris = 0xffc4a7e7
local highlightLow = 0xff2a283e
local highlightMed = 0xff44415a
local highlightHigh = 0xff56526e

-- -------------------------
-- Programs
-- -------------------------
local terminal = "kitty"
local emacs = "emacsclient -c"
local mail = "thunderbird"
local browser = "zen"
local fileManager = "nautilus -w"
local menu = "~/.config/rofi/scripts/launcher.sh"
local powermenu = "~/.config/rofi/scripts/powermenu.sh"
local mainMod = "SUPER"

-- -------------------------
-- Monitors
-- eDP-1 is injected by Nix above this file with the host displayScaling value
-- -------------------------
hl.monitor({
	output = "DP-6",
	mode = "3840x2560@60",
	position = "1600x-380",
	scale = 1.60,
})
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto-right",
	scale = "auto",
})

-- -------------------------
-- XWayland
-- -------------------------
hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

-- -------------------------
-- Environment Variables
-- -------------------------
hl.env("GDK_SCALE", "2")
hl.env("XCURSOR_SIZE", "48")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("ELECTRON_ENABLE_WAYLAND", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- -------------------------
-- Autostart
-- -------------------------
hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("~/.config/waybar/launch.sh")
	hl.exec_cmd("pypr")
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("[workspace 9 silent; monitor eDP-1] sleep 5 & " .. mail)
	hl.exec_cmd("[workspace 2 silent; monitor eDP-1] " .. browser)
	hl.exec_cmd("[workspace 1; monitor eDP-1] " .. terminal)
	hl.exec_cmd("ferdium")
	hl.exec_cmd("slack --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland -u")
end)

-- -------------------------
-- Core Config
-- -------------------------
hl.config({
	input = {
		kb_layout = "ch",
		repeat_delay = 500,
		follow_mouse = 1,
		sensitivity = 0.1,
		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
			clickfinger_behavior = true,
		},
	},

	general = {
		gaps_in = 6,
		gaps_out = 12,
		border_size = 1,
		col = {
			active_border = { colors = { rose, iris }, angle = 90 },
			inactive_border = muted,
		},
		layout = "dwindle",
		resize_on_border = true,
		allow_tearing = false,
		extend_border_grab_area = 20,
	},

	decoration = {
		inactive_opacity = 0.8,
		blur = {
			enabled = true,
			size = 5,
			passes = 3,
			ignore_opacity = true,
			vibrancy = 0.1696,
		},
		shadow = {
			range = 8,
			render_power = 3,
			color = 0xee1a1a1a,
		},
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
	},

	misc = {
		force_default_wallpaper = 0,
	},
})

-- -------------------------
-- Animations
-- -------------------------
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "myBezier" })

-- -------------------------
-- Gestures
-- -------------------------
hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

-- ============================================================
-- WINDOW RULES
-- ============================================================

hl.window_rule({
	name = "keymapp",
	match = { class = "keymapp" },
	float = true,
	pin = true,
	size = { 960, 500 },
	border_size = 5,
	rounding = 10,
})

hl.window_rule({ name = "quickgui", match = { class = "^(quickgui)$" }, float = true })
hl.window_rule({ name = "amm_tool", match = { class = "^(amm_tool-dev-linux-amd64)$" }, float = true })
hl.window_rule({ name = "totem", match = { class = "^(org.gnome.Totem)$" }, float = true })
hl.window_rule({ name = "mplayer", match = { class = "^(MPlayer)$" }, float = true })
hl.window_rule({ name = "qr-rechnung", match = { class = "^(QR-Rechnung)$" }, float = true })
hl.window_rule({ name = "nm-conn", match = { class = "^(nm-connection-editor)$" }, float = true })
hl.window_rule({ name = "qalculate", match = { title = "^(Qalculate!)$" }, float = true })
hl.window_rule({ name = "pip", match = { title = "^(Picture-in-Picture)$" }, float = true })
hl.window_rule({ name = "media-view", match = { title = "^(Media viewer)$" }, float = true })
hl.window_rule({ name = "fyne", match = { title = "^(fyne)$" }, float = true })
hl.window_rule({ name = "new-doc", match = { title = "^(New Document)$" }, float = true })

hl.window_rule({
	name = "update-sys",
	match = { title = "^(update-sys)$" },
	float = true,
	size = "40% 55%",
})

hl.window_rule({
	name = "swiss-qrbill",
	match = { class = "^(swiss-qrbill-dev-linux-amd64)$" },
	float = true,
	opacity = "1.0 override 1.0 override",
})

hl.window_rule({
	name = "pick-a-file",
	match = { title = "^(Pick a File)$" },
	size = "50% 50%",
})

hl.window_rule({
	name = "signal",
	match = { class = "^(signal)$" },
	float = true,
	size = "50% 50%",
})

hl.window_rule({
	name = "blueman",
	match = { class = "^(blueman-manager)$" },
	float = true,
	size = "30% 52%",
})

hl.window_rule({
	name = "onlyoffice",
	match = { class = "^(ONLYOFFICE)$" },
	tile = true,
	opacity = "1.0 override 1.0 override",
})

hl.window_rule({
	name = "affinity",
	match = { title = "^(Affinity)$" },
	tile = true,
	opacity = "1.0 override 1.0 override",
})

hl.window_rule({
	name = "photo-exe",
	match = { class = "^(photo.exe)$" },
	opacity = "1.0 override 1.0 override",
})
hl.window_rule({
	name = "nvim",
	match = { title = "^nv(.*)$" },
	opacity = "1.0 override 1.0 override",
})
hl.window_rule({
	name = "firefox",
	match = { class = "^(firefox)$" },
	opacity = "1.0 override 1.0 override",
})
hl.window_rule({
	name = "zen",
	match = { class = "^(zen)$" },
	opacity = "1.0 override 1.0 override",
})
hl.window_rule({
	name = "win11-kvm",
	match = { title = "^(Windows11 on QEMU/KVM)$" },
	opacity = "1.0 override 1.0 override",
})

hl.window_rule({
	name = "nautilus",
	match = { class = "^(org.gnome.Nautilus)$" },
	float = true,
	size = "45% 52%",
})

hl.window_rule({
	name = "gnome-calc",
	match = { class = "^(org.gnome.Calculator)$" },
	float = true,
	size = "20% 45%",
})

hl.window_rule({
	name = "open-file",
	match = { title = "^(Open File)$" },
	size = "45% 45%",
})

hl.window_rule({
	name = "suppress-maximize",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Border colour overrides for scratchpad/tool windows
hl.window_rule({
	name = "border-dropterm",
	match = { class = "^(kitty-dropterm)$" },
	border_color = "rgb(41a6b5)",
})
hl.window_rule({
	name = "border-dropmc",
	match = { class = "^(kitty-dropmc)$" },
	border_color = "rgb(41a6b5)",
})
hl.window_rule({
	name = "border-pavuctl",
	match = { class = "^(org.pulseaudio.pavucontrol)$" },
	border_color = "rgb(41a6b5)",
})
hl.window_rule({
	name = "border-spotify",
	match = { class = "^(kitty-spotify)$" },
	border_color = "rgb(41a6b5)",
})

-- Scratchpad / pypr windows
hl.window_rule({ name = "hyprpwcenter", match = { class = "^(hyprpwcenter)$" }, float = true })
hl.window_rule({ name = "pavucontrol", match = { class = "^(pavucontrol)$" }, float = true })

hl.window_rule({
	name = "kitty-dropterm",
	match = { class = "^(kitty-dropterm)$" },
	float = true,
	opacity = "0.8 0.8",
})

hl.window_rule({
	name = "kitty-dropmc",
	match = { class = "^(kitty-dropmc)$" },
	float = true,
})

hl.window_rule({
	name = "kitty-spotify",
	match = { class = "^(kitty-spotify)$" },
	float = true,
	opacity = "0.8 0.8",
})

-- ============================================================
-- LAYER RULES
-- ============================================================

hl.layer_rule({
	name = "waybar-blur",
	match = { namespace = "waybar" },
	blur = true,
	ignore_alpha = 0.5,
})

-- ============================================================
-- KEYBINDINGS
-- ============================================================

-- Apps
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(emacs))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd(terminal .. " --hold tmux"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl kill"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(powermenu))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)"'))
hl.bind(mainMod .. " + ALT + S", hl.dsp.exec_cmd("hyprpicker -f hex -a -r"))
hl.bind(
	mainMod .. " + SHIFT + V",
	hl.dsp.exec_cmd("rofi -modi clipboard:~/.config/rofi/scripts/clipboard -show clipboard -show-icons")
)
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("gnome-calculator"))
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.exec_cmd("~/.config/waybar/launch.sh"))

-- Focus movement (vim-style)
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Workspace navigation
hl.bind(mainMod .. " + CTRL + l", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + CTRL + h", hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "previous" }))

-- Resize windows (repeating)
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.resize({ x = 40, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.resize({ x = -40, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.resize({ x = 0, y = 40 }), { repeating = true })
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.resize({ x = 0, y = -40 }), { repeating = true })

-- Swap / layout
hl.bind(mainMod .. " + SHIFT + x", hl.dsp.window.swap({ next = true }))
hl.bind(mainMod .. " + SHIFT + x", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + CTRL + SHIFT + x", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + CTRL + SHIFT + d", hl.dsp.layout("swapsplit"))
hl.bind(mainMod .. " + CTRL + SHIFT + b", hl.dsp.layout("movetoroot"))
hl.bind(mainMod .. " + CTRL + SHIFT + M", hl.dsp.exec_cmd("bash " .. os.getenv("HOME") .. "/.config/hypr/scripts/swap-monitors.sh"))

-- Switch workspaces 1-9
for i = 1, 9 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
-- Workspace 10 on key 0
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Move window to relative workspace
hl.bind(mainMod .. " + SHIFT + CTRL + l", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod .. " + SHIFT + CTRL + h", hl.dsp.window.move({ workspace = "r-1" }))

-- Scroll through workspaces with mouse wheel
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move / resize windows with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize({ x = 0, y = 0 }), { mouse = true })

-- Hardware keys – Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness.sh --inc"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness.sh --dec"), { repeating = true })

-- Hardware keys – Speaker Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --inc"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --dec"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pamixer --default-source -t"))

-- Hardware keys – Mic Volume
hl.bind(
	mainMod .. " + XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --mic-inc"),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + XF86AudioLowerVolume",
	hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --mic-dec"),
	{ repeating = true }
)
hl.bind(mainMod .. " + XF86AudioMute", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --toggle-mic"))
hl.bind(mainMod .. " + SHIFT + XF86AudioMute", hl.dsp.exec_cmd("pulseaudio-equalizer toggle"))

-- Media controls
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause -a"))

-- Scratchpads (pypr)
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("pypr toggle volume"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("pypr toggle term"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("pypr toggle mc"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("pypr toggle spotify"))

-- Special workspaces
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + 0", hl.dsp.workspace.toggle_special())
