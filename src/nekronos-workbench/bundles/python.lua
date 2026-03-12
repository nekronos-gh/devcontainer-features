return {
	-- Tree-sitter parsers for Python
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"python",
				"requirements", -- requirements.txt (if parser available)
			})
		end,
	},

	-- Mason tools: LSP, linters, formatters
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				-- LSP
				"pyright", -- static type checker + LSP (Microsoft)
				"ruff-lsp", -- fast linter/formatter LSP (replaces flake8, isort, etc.)

				-- Formatters
				"black", -- opinionated code formatter
				"isort", -- import sorter
				"ruff", -- also used as standalone formatter

				-- Linters
				"mypy", -- static type checker
				"pylint", -- comprehensive linter (optional, ruff covers most cases)

				-- DAP
				"debugpy", -- Python debug adapter
			})
		end,
	},

	-- LSP configuration for Python
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				pyright = {
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "basic",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								diagnosticMode = "workspace",
								autoImportCompletions = true,
							},
						},
					},
				},
				ruff_lsp = {
					on_attach = function(client, _)
						-- Disable hover in favor of Pyright
						client.server_capabilities.hoverProvider = false
					end,
					init_options = {
						settings = {
							args = {},
						},
					},
				},
			},
		},
	},

	-- Formatter: add Python formatters to conform.nvim
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters_by_ft.python = {
				"isort", -- sort imports first
				"black", -- then format code
			}
		end,
	},

	-- Linter: add Python linters to nvim-lint
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = lint.linters_by_ft or {}

			-- Extend existing linters
			lint.linters_by_ft.python = {
				"mypy", -- type checking
				"ruff", -- fast linting (covers flake8, pyflakes, pycodestyle, etc.)
			}
		end,
	},

	-- Python venv selector
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-telescope/telescope.nvim",
		},
		branch = "regexp", -- use the newer regexp branch
		event = "VeryLazy",
		opts = {
			settings = {
				options = {
					notify_user_on_venv_activation = true,
				},
			},
		},
		keys = {
			{ "<leader>pv", "<cmd>VenvSelect<cr>", desc = "Select Python venv" },
			{ "<leader>pc", "<cmd>VenvSelectCached<cr>", desc = "Select cached venv" },
		},
	},

	-- DAP: debug adapter protocol for Python
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"mfussenegger/nvim-dap-python", -- Python-specific DAP config
			"rcarriga/nvim-dap-ui", -- UI for DAP
			"nvim-neotest/nvim-nio", -- async IO (required by dap-ui)
		},
		config = function()
			local dap = require("dap")
			local dap_python = require("dap-python")
			local dapui = require("dapui")

			-- Point to the debugpy installed by Mason
			local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			dap_python.setup(mason_path)

			-- Auto-open/close DAP UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			dapui.setup()
		end,
		keys = {
			{ "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle breakpoint" },
			{ "<leader>dc", "<cmd>DapContinue<cr>", desc = "Continue" },
			{ "<leader>di", "<cmd>DapStepInto<cr>", desc = "Step into" },
			{ "<leader>do", "<cmd>DapStepOver<cr>", desc = "Step over" },
			{ "<leader>dO", "<cmd>DapStepOut<cr>", desc = "Step out" },
			{ "<leader>dr", "<cmd>DapToggleRepl<cr>", desc = "Open REPL" },
			{
				"<leader>dt",
				function()
					require("dap-python").test_method()
				end,
				desc = "Debug test method",
			},
		},
	},
}
