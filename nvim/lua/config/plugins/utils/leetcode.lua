return {
	"kawre/leetcode.nvim",
	build = ":TSUpdate html",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		injector = {
			cpp = {
				before = function()
					return {
						"#include <bits/stdc++.h>",
						"using namespace std;",
						"",
					}
				end,
			},
		},
	},
}
