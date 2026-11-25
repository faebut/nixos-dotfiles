return {
	{
		"nvim-orgmode/orgmode",
		event = "VeryLazy",
		ft = { "org" },
		config = function()
			require("orgmode").setup({
				org_agenda_files = "~/org/**/*",
				org_default_notes_file = "~/org/notes.org",
				org_todo_keywords = { "TODO(t)", "NEXT(n)", "WAIT(w)", "|", "DONE(d)", "CANCELLED(c)" },
				org_log_done = "time",
				org_log_into_drawer = "LOGBOOK",
				org_startup_indented = true,
				org_hide_emphasis_markers = true,
				org_capture_templates = {
					t = {
						description = "Todo",
						template = "* TODO %?\n%U",
						target = "~/org/todo.org",
						headline = "Inbox",
					},
					n = {
						description = "Note",
						template = "* %?\n%U",
						target = "~/org/notes.org",
						headline = "Inbox",
					},
				},
				mappings = {
					org = {
						org_refile = false,
						org_insert_link = false,
					},
				},
			})
		end,
	},
	{
		"nvim-orgmode/org-bullets.nvim",
		dependencies = { "nvim-orgmode/orgmode" },
		ft = { "org" },
		opts = {},
	},
	{
		"nvim-orgmode/telescope-orgmode.nvim",
		dependencies = {
			"nvim-orgmode/orgmode",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{ "<leader>of", function() require("telescope").extensions.orgmode.search_headings() end, desc = "Org find headline" },
			{ "<leader>oF", function() require("telescope").extensions.orgmode.search_headings({ mode = "orgfiles" }) end, desc = "Org find file" },
			{ "<leader>oT", function() require("telescope").extensions.orgmode.search_tags() end, desc = "Org find by tag" },
			{ "<leader>or", function() require("telescope").extensions.orgmode.refile_heading() end, desc = "Org refile" },
			{ "<leader>oli", function() require("telescope").extensions.orgmode.insert_link() end, desc = "Org insert link" },
			{ "<leader>o/", function() require("telescope.builtin").live_grep({ cwd = "~/org" }) end, desc = "Org grep" },
		},
		config = function()
			require("telescope").load_extension("orgmode")
		end,
	},
	{
		"chipsenkbeil/org-roam.nvim",
		dependencies = { "nvim-orgmode/orgmode" },
		event = "VeryLazy",
		config = function()
			require("org-roam").setup({
				directory = "~/org/roam",
				bindings = {
					add_origin = "<prefix>Oa",
					remove_origin = "<prefix>Or",
				},
				extensions = {
					dailies = {
						bindings = {
							capture_date = "<prefix>jD",
							capture_today = "<prefix>jN",
							capture_tomorrow = "<prefix>jT",
							capture_yesterday = "<prefix>jY",
							find_directory = "<prefix>j.",
							goto_date = "<prefix>jd",
							goto_next_date = "<prefix>jf",
							goto_prev_date = "<prefix>jb",
							goto_today = "<prefix>jn",
							goto_tomorrow = "<prefix>jt",
							goto_yesterday = "<prefix>jy",
						},
					},
				},
			})
		end,
	},
	{
		"hamidi-dev/org-super-agenda.nvim",
		dependencies = { "nvim-orgmode/orgmode" },
		cmd = "OrgSuperAgenda",
		keys = {
			{ "<leader>os", "<cmd>OrgSuperAgenda<cr>", desc = "Org super agenda" },
			{ "<leader>oS", "<cmd>OrgSuperAgenda!<cr>", desc = "Org super agenda (fullscreen)" },
		},
		config = function()
			local function open(item)
				return item.todo_state ~= "DONE" and item.todo_state ~= "CANCELLED"
			end
			local fields = { "filename", "todo", "headline", "priority", "date", "tags" }

			require("org-super-agenda").setup({
				todo_states = {
					{ name = "TODO", keymap = "ot", color = "#FF5555", fields = fields },
					{ name = "NEXT", keymap = "on", color = "#FFAA00", fields = fields },
					{ name = "WAIT", keymap = "ow", color = "#BD93F9", fields = fields },
					{ name = "DONE", keymap = "od", color = "#50FA7B", strike_through = true, fields = fields },
					{ name = "CANCELLED", keymap = "oc", color = "#6272A4", strike_through = true, fields = fields },
				},
				groups = {
					{
						name = "Overdue",
						matcher = function(item)
							return open(item)
								and ((item.deadline and item.deadline:is_past())
									or (item.scheduled and item.scheduled:is_past()))
						end,
						sort = { by = "date_nearest", order = "asc" },
					},
					{
						name = "Today",
						matcher = function(item)
							return open(item)
								and ((item.scheduled and item.scheduled:is_today())
									or (item.deadline and item.deadline:is_today()))
						end,
						sort = { by = "scheduled_time", order = "asc" },
					},
					{
						name = "Next actions",
						matcher = function(item)
							return item.todo_state == "NEXT"
						end,
						sort = { by = "priority", order = "desc" },
					},
					{
						name = "Waiting",
						matcher = function(item)
							return item.todo_state == "WAIT"
						end,
					},
					{
						name = "Upcoming",
						matcher = function(item)
							local deadline_days = item.deadline and item.deadline:days_from_today()
							local scheduled_days = item.scheduled and item.scheduled:days_from_today()
							return open(item)
								and ((deadline_days and deadline_days > 0 and deadline_days <= 14)
									or (scheduled_days and scheduled_days > 0 and scheduled_days <= 14))
						end,
						sort = { by = "date_nearest", order = "asc" },
					},
					{
						name = "Inbox",
						matcher = function(item)
							return item.todo_state == "TODO" and not item.scheduled and not item.deadline
						end,
					},
				},
			})
		end,
	},
}
