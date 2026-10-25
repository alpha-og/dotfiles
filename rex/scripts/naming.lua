-- ~/.config/rex/scripts/naming.lua
-- Auto-naming for Rex sessions and tabs. (Loaded by listener.lua.)
-- Auto-naming for Rex sessions and tabs. Run with: rex do <this file>
-- (started automatically at config load; see listener_start.sh / init.lua)
--
-- Sessions created *after this script starts* are renamed once, the first
-- time a program in them reports a working directory: main repo name via
-- git, else the directory's name. Later renames by you or an agent win
-- forever.
--
-- Tabs are named from the *focused* pane of the tab, using whatever is
-- available (no process needed): foreground program, else the shell child
-- behind it, else the OSC-7 pwd, plus git branch and directory where they
-- apply. Program names get Title Case ("Nvim"); branches and directories
-- keep the exact casing on disk ("dev", "RPL", "feature login ui") with
-- separators turned into spaces.
--
-- Labels this script set survive restarts via scripts/naming.labels.
-- Anything human-named (default "Window <hex>", lowercase legacy labels,
-- and state-file entries) is fair game; anything else is never touched.

rex.call("session.attach_all", { event_scope = "all" })

local windows_named = {}    -- window_id -> last label we set
local sessions_pending = {} -- session_id -> true (created after we started)
local label_history = {}    -- label -> true (labels we are known to have set)
-- Record a label as ours (ownership proof for future sweeps) and persist.
local function remember_label(label)
  if not label or label == "" then return end
  label_history[label] = true
end

local state_path = (os.getenv("HOME") or "")
  .. "/.config/rex/scripts/naming.labels"

-- Load/save the state. Two record kinds:
--   K\t<window_id>\t<label>  last label we set on a window
--   H\t<label>               every label we have EVER set (ownership proof)
-- Old-format lines (window:...\tlabel) are still accepted as K records.
local function load_state()
  local f = io.open(state_path, "r")
  if not f then return end
  for line in f:lines() do
    local k_wid, k_label = line:match("^K\t(window:%S+)\t(.+)$")
    if k_wid and k_label then
      windows_named[k_wid] = k_label
    else
      local wid, label = line:match("^(window:%S+)\t(.+)$")
      if wid and label then windows_named[wid] = label end
    end
    local h_label = line:match("^H\t(.+)$")
    if h_label and h_label ~= "" then remember_label(h_label) end
  end
  f:close()
end

local function save_state()
  local f = io.open(state_path, "w")
  if not f then return end
  for wid, label in pairs(windows_named) do
    f:write("K\t" .. wid .. "\t" .. label .. "\n")
  end
  for label in pairs(label_history) do
    if label ~= "" then f:write("H\t" .. label .. "\n") end
  end
  f:close()
end

local function url_path(u)
  if type(u) ~= "string" or u == "" then return nil end
  return u:match("^file://[^/]+(/.*)$") or (u:sub(1, 1) == "/" and u) or nil
end

local function basename(p)
  return (p:match("[^/]+/?$") or ""):gsub("/$", "")
end

local function is_default_window_label(s)
  return type(s) == "string" and s:match("^Window [0-9a-f]+$") ~= nil
end

-- Manageable means: the generated default, a label this script set (state
-- file), or a leftover plain lowercase label an older version wrote here.
-- Anything with an uppercase letter is treated as human-authored.
local function is_manageable_label(s)
  if is_default_window_label(s) then return true end
  if type(s) ~= "string" or s == "" then return false end
  return s:find("%u") == nil
end

local function shellish(name)
  return name == "login" or name == "zsh" or name == "bash"
    or name == "sh" or name == "fish" or name == "rex"
end

local HOME = (os.getenv("HOME") or "") .. "/"

-- Capitalize word starts only; existing uppercase stays (RPL stays RPL).
local function title_case(s)
  if type(s) ~= "string" or s == "" then return "" end
  return string.gsub(
    string.gsub(s, "[_-]+", " "),
    "(%a)([%a%d']*)",
    function(a, rest) return string.upper(a) .. rest end)
end

-- Replace path/branch separators with spaces WITHOUT touching the letters'
-- casing. Kept on hand, but branch and folder names go verbatim per user
-- preference.
local function prettify(s)
  if type(s) ~= "string" or s == "" then return "" end
  return string.gsub(s, "[/_-]+", " ")
end

-- Join parts with " · ", skipping empties and duplicates. NOTE: pairs on
-- purpose — ipairs would die on a nil hole in the parts array.
local function join_unique(parts)
  local seen, out = {}, {}
  for _, p in pairs(parts) do
    if p and p ~= "" and not seen[p] then
      seen[p] = true
      out[#out + 1] = p
    end
  end
  return table.concat(out, " · ")
end

-- Git identity of a directory: branch and main-repo name (casing kept
-- exactly as on disk, separators prettified).
-- `repo` is the common (main) repository, so a worktree of rpl_erp reads
-- "Rpl Erp" instead of the worktree directory's name.
local function git_info(path)
  local info = {}
  if not path then return info end
  local b = rex.exec{ "git", "-C", path, "rev-parse", "--abbrev-ref", "HEAD" }
  if b and b.ok and b.stdout then
    local branch = b.stdout:gsub("%s+$", "")
    if branch ~= "" and branch ~= "HEAD" then
      info.branch = branch
    end
  end
  local c = rex.exec{ "git", "-C", path, "rev-parse", "--git-common-dir" }
  if c and c.ok and c.stdout then
    local common = c.stdout:gsub("%s+$", "")
    if common ~= "" then
      if common:sub(1, 1) ~= "/" then common = path .. "/" .. common end
      info.repo = basename((common:gsub("/+%.git$", "")))
    end
  end
  return info
end

-- Project name for a session: main repo name, else the directory's own.
-- Verbatim: casing and separators exactly as they are on disk.
local function project_name(path)
  local git = git_info(path)
  if git.repo and git.repo ~= "" then return git.repo end
  return basename(path)
end

-- Find the window that holds a block, with its current label.
local function window_for_block(session_id, block_id)
  local view = rex.session.view{ session_id = session_id }
  if type(view) ~= "table" or not view.windows then return nil end
  for _, w in ipairs(view.windows or {}) do
    for _, layer in ipairs(w.layers or {}) do
      for _, blk in ipairs(layer.blocks or {}) do
        if blk.block_id == block_id then return w end
      end
    end
  end
  return nil
end

local function record_window_label(wid, label)
  windows_named[wid] = label
  remember_label(label)
  save_state()
end

-- Anything Title Cased is treated as human-authored UNLESS it is a label we
-- know we set (state file) or an obvious product of this script ("·"-joined
-- labels are seeded as ours on first sight).
local function owns_label(wid, label)
  if label and label_history[label] then return true end
  local ours = windows_named[wid] == label
  if ours then remember_label(label) return true end
  if type(label) == "string" and label:find(" · ", 1, true) then
    remember_label(label)
    return true
  end
  return false
end

-- Everything knowable about a pane without relying on a foreground program:
-- 1. the foreground process (name + cwd),
-- 2. else the shell child behind it (a shell at its prompt still has a cwd),
-- 3. else the OSC-7 pwd report.
local function pane_info(session_id, block_id)
  local info = {}
  if not block_id then return info end
  local ok, proc = pcall(function()
    return rex.block.call("com.superlogical.terminal", "process",
      { session_id = session_id, block_id = block_id })
  end)
  if ok and type(proc) == "table" then
    local fg = proc.foreground
    if fg and fg.name and fg.name ~= "" then
      info.prog = fg.name
      if fg.cwd then info.cwd = fg.cwd end
    elseif proc.child and proc.child.name and proc.child.name ~= "" then
      info.prog = proc.child.name
      if proc.child.cwd then info.cwd = proc.child.cwd end
    end
  end
  if not info.cwd or info.cwd == "" then
    local ok2, pwd = pcall(function()
      return rex.block.call("com.superlogical.terminal", "pwd",
        { session_id = session_id, block_id = block_id })
    end)
    if ok2 and type(pwd) == "table" and pwd.pwd and pwd.pwd ~= "" then
      info.cwd = pwd.pwd
    end
  end
  return info
end

-- Compose a tab label from whatever pane info is available. Returns "" when
-- there is nothing to say. Program name is skipped for shells.
local function compose_label(info)
  if not info then return "" end
  local path = url_path(info.cwd or "")
  local git = git_info(path)
  -- Build a hole-free array (a nil entry in a table constructor stops
  -- ipairs inside join_unique).
  local parts = {}
  if info.prog and not shellish(info.prog) then
    parts[#parts + 1] = title_case(info.prog)
  end
  if git.branch and git.branch ~= "" then
    parts[#parts + 1] = git.branch
  end
  local dir = path and basename(path) or ""
  if dir ~= "" then
    -- Verbatim: folders keep the exact casing and separators on disk.
    parts[#parts + 1] = dir
  end
  return join_unique(parts)
end

-- Sessions ---------------------------------------------------------------

rex.on("session_created", function(_ctx, ev)
  local s = ev.session or {}
  if s.session_id then sessions_pending[s.session_id] = true end
end)

-- Any rename ends the naming window for that session, ours included.
rex.on("session_label_changed", function(ctx, _ev)
  sessions_pending[ctx.session_id] = nil
end)

rex.on("terminal.pwd_changed", function(ctx, ev)
  local id = ctx.session_id
  if not sessions_pending[id] then return end
  local path = url_path(ev.pwd)
  if not path or path .. "/" == HOME or path == HOME:sub(1, -2) then return end
  local name = project_name(path)
  if name == "" then return end
  rex.session.set_label{ session_id = id, label = name }
  sessions_pending[id] = nil
end)

-- Tabs -------------------------------------------------------------------

-- Shells often don't report OSC-7 pwd, so a program's cwd on process change
-- is the reliable naming source. pwd_changed is kept as a fallback.
rex.on("terminal.process_changed", function(ctx, ev)
  if not ctx.block_id then return end

  -- Prefer the event's foreground data; fill gaps by asking the pane.
  local info = {}
  local fg = ev and ev.foreground
  if fg and fg.name and fg.name ~= "" then
    info.prog = fg.name
    if fg.cwd then info.cwd = fg.cwd end
  end
  if not info.cwd or info.cwd == "" then
    local pi = pane_info(ctx.session_id, ctx.block_id)
    if not info.prog then info.prog = pi.prog end
    info.cwd = info.cwd or pi.cwd
  end

  -- Session naming: any pane's cwd names a fresh session once. A cad still
  -- sitting at $HOME is noise, so leave it pending for real info.
  if sessions_pending[ctx.session_id] then
    local path = url_path(info.cwd or "")
    if path and path .. "/" ~= HOME and path ~= HOME:sub(1, -2) then
      local name = project_name(path)
      if name ~= "" then
        rex.session.set_label{ session_id = ctx.session_id, label = name }
        sessions_pending[ctx.session_id] = nil
      end
    end
  end

  local w = window_for_block(ctx.session_id, ctx.block_id)
  if not w or w.focused_block_id ~= ctx.block_id then return end
  if not (is_manageable_label(w.label) or owns_label(w.window_id, w.label)) then
    return
  end

  local label = compose_label(info)
  if label == "" or label == w.label then return end

  rex.session.set_window_label{
    session_id = ctx.session_id,
    window_id = w.window_id,
    label = label,
  }
  record_window_label(w.window_id, label)
end)

-- A manual rename un-manages the tab.
rex.on("window_label_changed", function(_ctx, ev)
  local wid = ev.window_id
  if windows_named[wid] and ev.label ~= windows_named[wid] then
    windows_named[wid] = nil
    save_state()
  end
end)

-- A started program exited: revert the tab to its directory name. Only
-- reached when the window and block still exist (blocks running a single
-- command just close, which we also accept).
rex.on("terminal.child_exited", function(ctx, _ev)
  local w = window_for_block(ctx.session_id, ctx.block_id)
  if not w or not windows_named[w.window_id] then return end

  -- Not managed by us, leave it.
  if not (is_manageable_label(w.label) or owns_label(w.window_id, w.label)) then
    return
  end

  local info = pane_info(ctx.session_id, ctx.block_id)
  local label = compose_label(info)
  if label == "" then return end

  rex.session.set_window_label{
    session_id = ctx.session_id,
    window_id = w.window_id,
    label = label,
  }
  record_window_label(w.window_id, label)
end)

-- Startup sweep -----------------------------------------------------------

-- Name every manageable window of ONE session from its active panes.
local function sweep_session(sid)
  local view = rex.session.view{ session_id = sid }
  if not view or not view.windows then return end
  for _, w in ipairs(view.windows) do
    -- Manageable = default/lowercase; owned = label we've ever set (state
    -- file plus '·'-heuristic). Those must keep updating, never freeze.
    if (is_manageable_label(w.label) or owns_label(w.window_id, w.label))
        and w.focused_block_id then
      -- Active pane only: the window's focused block decides the name.
      local info = pane_info(sid, w.focused_block_id)
      local label = compose_label(info)
      if label ~= "" and label ~= w.label then
        rex.session.set_window_label{
          session_id = sid, window_id = w.window_id, label = label,
        }
        record_window_label(w.window_id, label)
      end
    end
  end
end

-- process_changed only fires on the next process switch, so existing tabs
-- otherwise keep stale names. Sweep every window once shortly after start,
-- then periodically, naming whatever is manageable.
local function sweep()
  local ok, list = pcall(function() return rex.call("session.list") end)
  if not ok or type(list) ~= "table" then
    rex.log("naming sweep: session.list failed: " .. tostring(list))
    return
  end
  for _, sess in ipairs(list.sessions or {}) do
    if sess.session_id then sweep_session(sess.session_id) end
  end
end

-- Pane focus, window focus, splits, closes — a knob the user just turned.
-- Fire a short, debounced sweep of that session so the tab immediately
-- tracks the active pane (the 20s cycle is the fallback for `cd`, which
-- has no event at all).
local sweep_scheduled = {}  -- session_id -> true
local function sweep_soon(sid)
  if not sid or sweep_scheduled[sid] then return end
  sweep_scheduled[sid] = true
  rex.after(0.3, function()
    sweep_scheduled[sid] = nil
    sweep_session(sid)
  end)
end
rex.on("active_window_changed", function(ctx, _ev) sweep_soon(ctx.session_id) end)
rex.on("session_view_changed", function(ctx, _ev) sweep_soon(ctx.session_id) end)

rex.after(1, sweep)
-- Short cycle on purpose: there is no event for `cd` (shells here don't
-- report OSC-7), so this re-read of the active pane's cwd/branch is the only
-- way directory and worktree-specific info keeps tracking reality.
rex.every(20, sweep)
