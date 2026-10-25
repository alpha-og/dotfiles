-- ~/.config/rex/scripts/listener.lua
-- The one long-running event listener. Modules register their own handlers
-- into this single attached stream; keep listener count at one — extra
-- attached streams have crashed this server build before.
--
-- Modules:
--   naming.lua  tab/session labels (state: naming.labels)
--   tabs.lua    tab history     (state: tabs.closed, tabs.previous)

rex.call("session.attach_all", { event_scope = "all" })

local base = (os.getenv("HOME") or "") .. "/.config/rex/scripts/"
dofile(base .. "naming.lua")
dofile(base .. "tabs.lua")
