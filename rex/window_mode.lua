-- ~/.config/rex/window_mode.lua
-- The "window" key mode (entered with cmd+w): splits, resize, close.
--
-- Close and split are one-shot actions: they queue the real pane action,
-- then leave the mode, so `.` / `v` / `s` don't leave you stuck in window
-- mode afterwards. Resize stays in the mode on purpose, for repeated nudges.
-- Every one-shot action is also searchable in the command palette (Cmd+Shift+P).

local function one_shot(name, title, act, args)
  rex.action({
    name = name,
    title = title,
    category = "Window mode",
    run = function()
      rex.client.queue(act, args)
      rex.client.queue("client.mode.exit")
    end,
  })
end

one_shot("window_close_pane", "Close Pane (exit window mode)",
  "pane.close", {})
one_shot("window_split_right", "Split Right (exit window mode)",
  "pane.split", { direction = "right" })
one_shot("window_split_down", "Split Down (exit window mode)",
  "pane.split", { direction = "down" })

rex.bind("window/.", "window_close_pane")

rex.bind("window/v", "window_split_right")
rex.bind("window/s", "window_split_down")

rex.bind("window/=", "pane.balance")

rex.bind("window/shift+h", "pane.resize", { direction = "left" })
rex.bind("window/shift+l", "pane.resize", { direction = "right" })
rex.bind("window/shift+k", "pane.resize", { direction = "up" })
rex.bind("window/shift+j", "pane.resize", { direction = "down" })
