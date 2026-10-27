-- ~/.config/rex/scripts/tabs.lua
-- Tab history listener, required by listener.lua (shares its one attached
-- event stream). Provides the state behind two config actions:
--
--   Reopen Last Closed Tab (cmd+shift+t)
--     Live windows are snapshotted (block flavors) on layout changes; when
--     a window closes, its snapshot is pushed onto scripts/tabs.closed.
--     Reopen pops the newest entry and rebuilds the window — blocks stack
--     side by side — in its original session if that session still exists,
--     else in the session the keypress came from. Because session.view does
--     not expose launch commands, every block reopens as a plain shell.
--
--   Focus Previous Tab (ctrl+tab)
--     active_window_changed fills scripts/tabs.previous
--     (session \t current \t previous); the action re-focuses `previous`,
--     which naturally toggles between the two most recent tabs since each
--     focus change updates the pair.

local layouts = {}  -- window_id -> { session_id = sid, blocks = { {flavor=..} } }
local tab_cur = {}  -- session_id -> active window id
local tab_prev = {} -- session_id -> previously active window id

local base = (os.getenv("HOME") or "") .. "/.config/rex/scripts/"
local closed_path = base .. "tabs.closed"
local prev_path = base .. "tabs.previous"

-- Rolling snapshot of live windows so a later window_closed has a layout.
local function capture_layout(sid, win)
  if not win or not win.window_id then return end
  local blocks = {}
  for _, layer in ipairs(win.layers or {}) do
    for _, blk in ipairs(layer.blocks or {}) do
      if blk.flavor then
        blocks[#blocks + 1] = { flavor = blk.flavor }
      end
    end
  end
  if #blocks > 0 then
    layouts[win.window_id] = { session_id = sid, blocks = blocks }
  else
    layouts[win.window_id] = nil
  end
end

-- Persist the active/previous tab pair for each session.
local function tabs_save()
  local f = io.open(prev_path, "w")
  if not f then return end
  for sid, cur in pairs(tab_cur) do
    f:write(sid .. "\t" .. cur .. "\t" .. (tab_prev[sid] or "-") .. "\n")
  end
  f:close()
end

-- Refresh snapshots of every session's windows, and forget history for
-- sessions and windows that no longer exist.
local function capture_all()
  local ok, list = pcall(function() return rex.call("session.list") end)
  if not ok or type(list) ~= "table" then return end
  local live = {}
  local dirty = false
  for _, sess in ipairs(list.sessions or {}) do
    local sid = sess.session_id
    if sid then
      live[sid] = true
      local ok2, view = pcall(function()
        return rex.session.view{ session_id = sid }
      end)
      if ok2 and type(view) == "table" then
        local seen = {}
        for _, win in ipairs(view.windows or {}) do
          capture_layout(sid, win)
          seen[win.window_id] = true
        end
        if tab_cur[sid] and not seen[tab_cur[sid]] then
          tab_cur[sid] = nil
          dirty = true
        end
        if tab_prev[sid] and not seen[tab_prev[sid]] then
          tab_prev[sid] = nil
          dirty = true
        end
      end
    end
  end

  for sid in pairs(tab_cur) do
    if not live[sid] then tab_cur[sid] = nil; dirty = true end
  end
  for sid in pairs(tab_prev) do
    if not live[sid] then tab_prev[sid] = nil; dirty = true end
  end
  for wid, rec in pairs(layouts) do
    if not live[rec.session_id] then layouts[wid] = nil end
  end
  if dirty then tabs_save() end
end

-- Push a closed window's snapshot onto the reopen stack (max 20 entries).
local function closed_push(rec)
  local f = io.open(closed_path, "a")
  if not f then return end
  f:write((rex.json.encode(rec) or "") .. "\n")
  f:close()
  local lines = {}
  local rf = io.open(closed_path, "r")
  if rf then
    for line in rf:lines() do
      if line ~= "" then lines[#lines + 1] = line end
    end
    rf:close()
  end
  if #lines > 20 then
    local wf = io.open(closed_path, "w")
    if wf then
      for i = #lines - 19, #lines do wf:write(lines[i] .. "\n") end
      wf:close()
    end
  end
end

local function tabs_load()
  local f = io.open(prev_path, "r")
  if not f then return end
  for line in f:lines() do
    local sid, cur, prev = line:match("^(%S+)\t(%S+)\t(%S+)")
    if sid then
      tab_cur[sid] = cur
      if prev ~= "-" then tab_prev[sid] = prev end
    end
  end
  f:close()
end

-- Focus/layout changes refresh snapshots and drive the previous-tab pair.
local pending = {} -- session_id -> true
local function refresh_soon(sid)
  if pending[sid] then return end
  pending[sid] = true
  rex.after(0.3, function()
    pending[sid] = nil
    local ok2, view = pcall(function()
      return rex.session.view{ session_id = sid }
    end)
    if ok2 and type(view) == "table" then
      local seen = {}
      for _, win in ipairs(view.windows or {}) do
        capture_layout(sid, win)
        seen[win.window_id] = true
      end
      for wid in pairs(layouts) do
        if not seen[wid] then
          local l = layouts[wid]
          if l.session_id == sid then layouts[wid] = nil end
        end
      end
      -- Drop history that points at windows this session no longer has.
      local dirty = false
      if tab_cur[sid] and not seen[tab_cur[sid]] then
        tab_cur[sid] = nil
        dirty = true
      end
      if tab_prev[sid] and not seen[tab_prev[sid]] then
        tab_prev[sid] = nil
        dirty = true
      end
      if dirty then tabs_save() end
    end
  end)
end

rex.on("active_window_changed", function(ctx, ev)
  local sid = ctx.session_id
  if ev and ev.window_id and tab_cur[sid] ~= ev.window_id then
    tab_prev[sid] = tab_cur[sid] -- nil on the first change is fine (saved as "-")
    tab_cur[sid] = ev.window_id
    tabs_save()
  end
  refresh_soon(sid)
end)

rex.on("session_view_changed", function(ctx, _ev)
  refresh_soon(ctx.session_id)
end)

rex.on("window_closed", function(_ctx, ev)
  local rec = ev and ev.window_id and layouts[ev.window_id]
  if rec then
    closed_push({ session_id = rec.session_id, blocks = rec.blocks })
    layouts[ev.window_id] = nil
  end
end)

tabs_load()
rex.every(20, capture_all)
capture_all()
