-- ~/.config/rex/launchers.lua
-- Actions that open a program in a new tab of the current session.
-- Available via the fuzzy command palette (Cmd+Shift+P); bind a key if you like.

-- Testing note: launchers were verified by running them in a throwaway
-- session with `rex do -s SESSION open_lazygit`.

local apps = {
  { name = "open_nvim",     title = "Open nvim",     window_label = "nvim",     command = "nvim",     label = "nvim" },
  { name = "open_opencode", title = "Open OpenCode", window_label = "OpenCode", command = "opencode", label = "opencode" },
  { name = "open_lazygit",  title = "Open Lazygit",  window_label = "Lazygit",  command = "lazygit",  label = "lazygit" },
}

for _, app in ipairs(apps) do
  rex.action({
    name = app.name,
    title = app.title,
    category = "Launchers",
    run = function(ctx)
      -- Open in the working directory of the pane the action was run from,
      -- when the terminal reports one.
      local cwd = nil
      local ok, pwd = pcall(function()
        return rex.block.call("com.superlogical.terminal", "pwd",
          { block_id = ctx.block_id })
      end)
      if ok and type(pwd) == "table" and pwd.pwd and pwd.pwd ~= "" then
        cwd = pwd.pwd
        if cwd:sub(1, 7) == "file://" then
          cwd = cwd:sub(8) -- strip the file:// prefix OSC 7 replies use
        end
      end

      -- The shell block starts its program through a login shell, but the
      -- server's PATH may not include Homebrew, so prepend common bin dirs.
      local options = {
        command = { app.command },
        path_prepend = { "/opt/homebrew/bin", "/usr/local/bin" },
      }
      if cwd then
        options.cwd = cwd
      end

      rex.session.new_window({
        window_label = app.window_label,
        layout = {
          block = {
            flavor = "com.superlogical.terminal.shell",
            label = app.label,
            options = options,
          },
        },
      })
    end,
  })
end
