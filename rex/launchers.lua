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
      -- Working directory of the pane the action was run from. NOTE: shells
      -- here don't report OSC-7 pwd, so use the foreground process's cwd.
      local cwd = nil
      local ok, proc = pcall(function()
        return rex.block.call("com.superlogical.terminal", "process",
          { block_id = ctx.block_id })
      end)
      if ok and type(proc) == "table" and proc.foreground
          and proc.foreground.cwd and proc.foreground.cwd ~= "" then
        cwd = proc.foreground.cwd
        if cwd:sub(1, 7) == "file://" then
          cwd = cwd:sub(8) -- strip the file:// prefix OSC 7 replies use
        end
      end

      -- NOTE: this server build ignores the shell flavor's `cwd` option, so
      -- the directory is honored by cd-ing inside the command instead.
      local options = {
        path_prepend = { "/opt/homebrew/bin", "/usr/local/bin" },
      }
      if cwd and cwd ~= "" then
        options.command = { "/bin/zsh", "-c",
          string.format("cd %q; exec %s", cwd, app.command) }
      else
        options.command = { app.command }
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
