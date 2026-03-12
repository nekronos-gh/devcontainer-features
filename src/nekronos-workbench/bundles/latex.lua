return {
	-- Tree-sitter parsers for LaTeX
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"latex",
				"bibtex",
			})
			opts.highlight = {
				enable = true,
				disable = { "latex" }, -- let vimtex handle LaTeX highlighting
				additional_vim_regex_highlighting = { "latex", "markdown" },
			}
		end,
	},

	-- Mason tools: LSP, linters, formatters
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				-- LSP
				"texlab", -- feature-rich LaTeX LSP (build, forward search, completions)

				-- Formatters
				"latexindent", -- LaTeX indentation and formatting
			})
		end,
	},

	-- LSP configuration for LaTeX
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				texlab = {
					settings = {
						texlab = {
							build = {
								executable = "latexmk",
								args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
								onSave = true, -- auto-build on save
								forwardSearchAfter = true,
							},
							chktex = {
								onOpenAndSave = true,
								onEdit = false, -- can be noisy; enable if you want live linting
							},
							diagnosticsDelay = 300,
							latexFormatter = "latexindent",
							latexindent = {
								modifyLineBreaks = false,
							},
							bibtexFormatter = "texlab",
							formatterLineLength = 120,
						},
					},
				},
			},
		},
	},

	-- Formatter: add LaTeX formatters to conform.nvim
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters_by_ft.tex = { "latexindent" }
			opts.formatters_by_ft.bib = { "texlab" } -- texlab handles BibTeX formatting
		end,
	},

	-- Linter: add LaTeX linters to nvim-lint
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = lint.linters_by_ft or {}
			lint.linters_by_ft.tex = { "chktex" }
		end,
	},

	-- vimtex: the gold standard LaTeX plugin
	-- Compilation, TOC, motions, text objects, synctex, concealment
	{
		"lervag/vimtex",
		lazy = false, -- must load at startup to initialise filetype detection
		init = function()
			-- Use latexmk as the compiler
			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.vimtex_compiler_latexmk = {
				build_dir = "build", -- keep root dir clean
				callback = 1,
				continuous = 1, -- watch for changes
				executable = "latexmk",
				options = {
					"-pdf",
					"-shell-escape",
					"-verbose",
					"-file-line-error",
					"-synctex=1",
					"-interaction=nonstopmode",
				},
			}

			-- Concealment: show rendered symbols in normal mode
			vim.g.vimtex_syntax_conceal = {
				accents = 1,
				ligatures = 1,
				cites = 1,
				fancy = 1,
				greek = 1,
				math_bounds = 1,
				math_delimiters = 1,
				math_fracs = 1,
				math_super_sub = 1,
				math_symbols = 1,
				sections = 0,
				styles = 1,
			}

			vim.g.vimtex_quickfix_mode = 0 -- don't auto-open quickfix on warnings
			vim.g.vimtex_fold_enabled = 1 -- enable folding by section
			vim.g.vimtex_toc_config = {
				name = "TOC",
				layers = { "content", "todo", "include" },
				split_width = 35,
				todo_sorted = 0,
				show_help = 1,
				show_numbers = 1,
			}
		end,
		keys = {
			{ "<leader>ll", "<cmd>VimtexCompile<cr>", desc = "Compile (toggle)" },
			{ "<leader>lv", "<cmd>VimtexView<cr>", desc = "Forward search / view PDF" },
			{ "<leader>lt", "<cmd>VimtexTocToggle<cr>", desc = "Toggle TOC" },
			{ "<leader>le", "<cmd>VimtexErrors<cr>", desc = "Show errors" },
			{ "<leader>lc", "<cmd>VimtexClean<cr>", desc = "Clean auxiliary files" },
			{ "<leader>lC", "<cmd>VimtexClean!<cr>", desc = "Clean all (incl. PDF)" },
			{ "<leader>lk", "<cmd>VimtexStop<cr>", desc = "Stop compiler" },
			{ "<leader>lK", "<cmd>VimtexStopAll<cr>", desc = "Stop all compilers" },
			{ "<leader>li", "<cmd>VimtexInfo<cr>", desc = "VimTeX info" },
			{ "<leader>lx", "<cmd>VimtexReload<cr>", desc = "Reload VimTeX" },
		},
	},
}
