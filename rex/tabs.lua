-- ~/.config/rex/tabs.lua
-- Tab actions backed by the listener's state files (scripts/tabs.closed and
-- scripts/tabs.previous, maintained by scripts/tabs.lua):
--   Reopen Last Closed Tab  cmd+shift+t
--   Focus Previous Tab      ctrl+tab

local HOME = os.getenv("HOME") or ""
local closed_path = HOME .. "/.config/rex/scripts/tabs.closed"
local prev_path = HOME .. "/.config/rex/scripts/tabs.previous"

rex.action({
  name = "tab_reopen_last",
  title = "Reopen Last Closed Tab",
  category = "Tabs",
  run = function(ctx)
    local f = io.open(closed_path, "r")
    if not f then return end
    local lines = {}
    for line in f:lines() do
      if line ~= "" then lines[#lines + 1] = line end
    end
    f:close()

    local last = table.remove(lines) -- newest entry
    if not last then return end
    local wf = io.open(closed_path, "w")
    if wf then
      for _, l in ipairs(lines) do wf:write(l .. "\n") end
      wf:close()
    end

    local rec = rex.json.decode(last)
    if type(rec) ~= "table" or type(rec.blocks) ~= "table"
        or #rec.blocks == 0 then
      return
    end

    -- Reopen into the original session when it still exists, else here.
    local sid = ctx.session_id
    if rec.session_id and rec.session_id ~= ctx.session_id then
      local ok, list = pcall(function() return rex.call("session.list") end)
      if ok and type(list) == "table" then
        for _, s in ipairs(list.sessions or {}) do
          if s.session_id == rec.session_id then sid = rec.session_id end
        end
      end
    end

    -- One block comes back whole; several stack as chained splits.
    local function build_layout(i)
      local one = rex.layout.block{ flavor = rec.blocks[i].flavor }
      if i == #rec.blocks then return one end
      return rex.layout.horizontal(0.5, one, build_layout(i + 1))
    end
    return rex.session.new_window{ session_id = sid, layout = build_layout(1) }
  end,
})

rex.action({
  name = "tab_cycle_prev",
  title = "Focus Previous Tab",
  category = "Tabs",
  run = function(ctx)
    local f = io.open(prev_path, "r")
    if not f then return end
    local prev
    for line in f:lines() do
      local sid, _cur, _prev = line:match("^(%S+)\t(%S+)\t(%S+)")
      if sid == ctx.session_id then prev = _prev end
    end
    f:close()

    -- Only target a live window in this session. If history is missing or
    -- points at a closed tab, do nothing: falling back to another action can
    -- jump to a different session.
    local live = false
    if prev and prev ~= "" and prev ~= "-" then
      local ok, view = pcall(function()
        return rex.session.view{ session_id = ctx.session_id }
      end)
      if ok and type(view) == "table" then
        for _, win in ipairs(view.windows or {}) do
          if win.window_id == prev then live = true; break end
        end
      end
    end

    if live then
      -- Client action on purpose: it moves the app's visible tab (a plain
      -- server focus_window flips state the client UI ignores).
      rex.client.queue("session.select", { session_id = ctx.session_id, window_id = prev })
    end
  end,
})
