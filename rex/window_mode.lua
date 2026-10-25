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

-- The close gesture, now last-pane aware: if the focused pane is one of
-- several, queue the normal pane close; if it's the tab's LAST pane, the
-- server refuses pane.close, so close the whole window (tab) instead —
-- same gesture, tab is gone. Still one-shot (exits window mode).
rex.action({
  name = "window_close_pane",
  title = "Close Pane (exit window mode)",
  category = "Window mode",
  run = function(ctx)
    if not ctx.block_id then
      -- Invoked without block context (palette in an odd spot): plain close.
      rex.client.queue("pane.close")
      rex.client.queue("client.mode.exit")
      return
    end
    local view = rex.session.view{ session_id = ctx.session_id }
    local count, window_id = 0, nil
    for _, win in ipairs(view and view.windows or {}) do
      local total_here = 0
      local holds_focus = false
      for _, layer in ipairs(win.layers or {}) do
        for _, blk in ipairs(layer.blocks or {}) do
          total_here = total_here + 1
          if blk.block_id == ctx.block_id then holds_focus = true end
        end
      end
      if holds_focus then
        count = total_here
        window_id = win.window_id
        break
      end
    end
    if window_id and count == 1 then
      -- Last pane of the tab: closing the window is the tab close.
      rex.session.close_window{ session_id = ctx.session_id, window_id = window_id }
      pcall(function() rex.client.queue("client.mode.exit") end)
      return
    end
    pcall(function() rex.client.queue("pane.close") end)
    pcall(function() rex.client.queue("client.mode.exit") end)
  end,
})
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
