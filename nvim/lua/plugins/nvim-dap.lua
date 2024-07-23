return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
	},
	lazy = false,
	config = function()
		-- bring up dap ui windows when dap is invoked
		local dap = require("dap")
		local dapui = require("dapui")
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
		-- setup lldb adapter
		dap.adapters.lldb = {
			type = "executable",
			command = "/usr/bin/lldb",
			name = "lldb",
		}
		-- configure dap for rust debugging
		dap.configurations.rust = {
			{
				-- ... the previous config goes here ...,
				initCommands = function()
					-- Find out where to look for the pretty printer Python module
					local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

					local script_import = 'command script import "'
						.. rustc_sysroot
						.. '/lib/rustlib/etc/lldb_lookup.py"'
					local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

					local commands = {}
					local file = io.open(commands_file, "r")
					if file then
						for line in file:lines() do
							table.insert(commands, line)
						end
						file:close()
					end
					table.insert(commands, 1, script_import)

					return commands
				end,
				-- ...,
			},
		}
		-- keymaps
		vim.keymap.set(
			"n",
			"<leader>db",
			"<cmd>DapToggleBreakpoint<CR>",
			{ noremap = true, silent = true, desc = "Toggle breakpoint" }
		)
		vim.keymap.set("n", "<leader>dc", "<cmd>DapContinue<CR>", { noremap = true, silent = true, desc = "Continue" })

		vim.keymap.set(
			"n",
			"<leader>dsi",
			"<cmd>DapStepInto<CR>",
			{ noremap = true, silent = true, desc = "Step Into" }
		)
		vim.keymap.set("n", "<leader>dso", "<cmd>DapStepOut<CR>", { noremap = true, silent = true, desc = "Step Out" })
		vim.keymap.set(
			"n",
			"<leader>dss",
			"<cmd>DapStepOver<CR>",
			{ noremap = true, silent = true, desc = "Step Over" }
		)
	end,
}
