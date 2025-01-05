-- plugin for autocompletion

return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = {
		"rafamadriz/friendly-snippets",
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
		},
		"onsails/lspkind-nvim",
	},

	-- use a release tag to download pre-built binaries
	version = "v0.*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	opts = {
		keymap = { preset = "default" },

		appearance = {
			use_nvim_cmp_as_default = true,
			-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "Nerd Font",
		},

		-- experimental signature help support
		signature = { enabled = true },
		completion = {
			ghost_text = {
				enabled = false,
			},
			menu = {
				draw = {
					columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
					treesitter = { "lsp" },
				},
				-- border = "rounded",
			},
		},
	},
}
