-- ~/.config/rex/init.lua — Rex configuration
-- https://www.superlogical.com/rex/docs/customize/config
--
-- Organization:
--   window_mode.lua  the cmd+w "window" mode and its one-shot actions
--   launchers.lua    palette actions that open nvim / opencode / lazygit
--   tabs.lua         reopen last closed tab (cmd+shift+t) + previous-tab toggle (ctrl+tab)
--   scripts/         tooling + the listener process (rex-pick, listener.lua)

-- Enter the window mode with cmd+w; leave it with cmd+[ or after an
-- explicit action (see window_mode.lua).
rex.bind("cmd+w", "client.mode.enter", { name = "window" })
rex.bind("cmd+[", "client.mode.exit")

-- Pane focus works everywhere, inside and outside the mode.
rex.bind("cmd+h", "pane.focus", { direction = "left" })
rex.bind("cmd+l", "pane.focus", { direction = "right" })
rex.bind("cmd+k", "pane.focus", { direction = "up" })
rex.bind("cmd+j", "pane.focus", { direction = "down" })

rex.bind("cmd+e", "client.sidebar.toggle")

require("window_mode")
require("launchers")
require("tabs")

-- Reopen the last closed tab (browser-style), and toggle between the two
-- most recent tabs. State comes from the listener's files.
rex.bind("cmd+shift+t", "tab_reopen_last")
rex.bind("ctrl+tab", "tab_cycle_prev")

-- Rex config listener: names new sessions and tabs (naming.lua), and
-- maintains the tab history backing tabs.lua's actions (tabs.lua). The
-- start script is a singleton — safe to attempt at every config load
-- (server start / reload).
if os.getenv("HOME") then
  rex.exec.start(
    { "/bin/sh", os.getenv("HOME") .. "/.config/rex/scripts/listener_start.sh" },
    { detach = true }
  )
end
