-- ~/.config/rex/init.lua — Rex configuration
-- https://www.superlogical.com/rex/docs/customize/config
--
-- Organization:
--   window_mode.lua  the cmd+w "window" mode and its one-shot actions
--   launchers.lua    palette actions that open nvim / opencode / lazygit
--   scripts/         tooling (rex-pick: fzf session/tab/pane picker)

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
