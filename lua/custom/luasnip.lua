local ls = require("luasnip")
local types = require("luasnip.util.types")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local r = ls.restore_node
local d = ls.dynamic_node
local f = ls.function_node
local c = ls.choice_node
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	delete_check_events = "TextChanged",
	enable_autosnippets = true,
	override_builtin = false,
	-- Highlights!!
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "", "Error" } },
			},
		},
		ext_opts = 300,
	},
})

-- some shorthands...

local current_nsid = vim.api.nvim_create_namespace("LuaSnipChoiceListSelections")
local current_win = nil

local function window_for_choiceNode(choiceNode)
	local buf = vim.api.nvim_create_buf(false, true)
	local buf_text = {}
	local row_selection = 0
	local row_offset = 0
	local text
	for _, node in ipairs(choiceNode.choices) do
		text = node:get_docstring()
		-- find one that is currently showing
		if node == choiceNode.active_choice then
			-- current line is starter from buffer list which is length usually
			row_selection = #buf_text
			-- finding how many lines total within a choice selection
			row_offset = #text
		end
		vim.list_extend(buf_text, text)
	end

	vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, buf_text)
	local w, h = vim.lsp.util._make_floating_popup_size(buf_text, {})

	-- adding highlight so we can see which one is been selected.
	local extmark = vim.api.nvim_buf_set_extmark(
		buf,
		current_nsid,
		row_selection,
		0,
		{ hl_group = "incsearch", end_line = row_selection + row_offset }
	)

	-- shows window at a beginning of choiceNode.
	local win = vim.api.nvim_open_win(buf, false, {
		relative = "win",
		width = w,
		height = h,
		bufpos = choiceNode.mark:pos_begin_end(),
		style = "minimal",
		border = "rounded",
	})

	-- return with 3 main important so we can use them again
	return { win_id = win, extmark = extmark, buf = buf }
end

function choice_popup(choiceNode)
	-- build stack for nested choiceNodes.
	if current_win then
		vim.api.nvim_win_close(current_win.win_id, true)
		vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
	end
	local create_win = window_for_choiceNode(choiceNode)
	current_win = {
		win_id = create_win.win_id,
		prev = current_win,
		node = choiceNode,
		extmark = create_win.extmark,
		buf = create_win.buf,
	}
end

function update_choice_popup(choiceNode)
	vim.api.nvim_win_close(current_win.win_id, true)
	vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
	local create_win = window_for_choiceNode(choiceNode)
	current_win.win_id = create_win.win_id
	current_win.extmark = create_win.extmark
	current_win.buf = create_win.buf
end

function choice_popup_close()
	vim.api.nvim_win_close(current_win.win_id, true)
	vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
	-- now we are checking if we still have previous choice we were in after exit nested choice
	current_win = current_win.prev
	if current_win then
		-- reopen window further down in the stack.
		local create_win = window_for_choiceNode(current_win.node)
		current_win.win_id = create_win.win_id
		current_win.extmark = create_win.extmark
		current_win.buf = create_win.buf
	end
end

vim.cmd([[
            augroup choice_popup
            au!
            au User LuasnipChoiceNodeEnter lua choice_popup(require("luasnip").session.event_node)
            au User LuasnipChoiceNodeLeave lua choice_popup_close()
            au User LuasnipChangeChoice lua update_choice_popup(require("luasnip").session.event_node)
            augroup END
            ]])

vim.snippet.expand = ls.lsp_expand

-- vscodes behaviour for nested placeholder
local util = require("luasnip.util.util")
local node_util = require("luasnip.nodes.util")

ls.setup({
	parser_nested_assembler = function(_, snippetNode)
		local select = function(snip, no_move, dry_run)
			if dry_run then
				return
			end
			snip:focus()
			-- make sure the inner nodes will all shift to one side when the
			-- entire text is replaced.
			snip:subtree_set_rgrav(true)
			-- fix own extmark-gravities, subtree_set_rgrav affects them as well.
			snip.mark:set_rgravs(false, true)

			-- SELECT all text inside the snippet.
			if not no_move then
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
				node_util.select_node(snip)
			end
		end

		local original_extmarks_valid = snippetNode.extmarks_valid
		function snippetNode:extmarks_valid()
			-- the contents of this snippetNode are supposed to be deleted, and
			-- we don't want the snippet to be considered invalid because of
			-- that -> always return true.
			return true
		end

		function snippetNode:init_dry_run_active(dry_run)
			if dry_run and dry_run.active[self] == nil then
				dry_run.active[self] = self.active
			end
		end

		function snippetNode:is_active(dry_run)
			return (not dry_run and self.active) or (dry_run and dry_run.active[self])
		end

		function snippetNode:jump_into(dir, no_move, dry_run)
			self:init_dry_run_active(dry_run)
			if self:is_active(dry_run) then
				-- inside snippet, but not selected.
				if dir == 1 then
					self:input_leave(no_move, dry_run)
					return self.next:jump_into(dir, no_move, dry_run)
				else
					select(self, no_move, dry_run)
					return self
				end
			else
				-- jumping in from outside snippet.
				self:input_enter(no_move, dry_run)
				if dir == 1 then
					select(self, no_move, dry_run)
					return self
				else
					return self.inner_last:jump_into(dir, no_move, dry_run)
				end
			end
		end

		-- this is called only if the snippet is currently selected.
		function snippetNode:jump_from(dir, no_move, dry_run)
			if dir == 1 then
				if original_extmarks_valid(snippetNode) then
					return self.inner_first:jump_into(dir, no_move, dry_run)
				else
					return self.next:jump_into(dir, no_move, dry_run)
				end
			else
				self:input_leave(no_move, dry_run)
				return self.prev:jump_into(dir, no_move, dry_run)
			end
		end

		return snippetNode
	end,
})

-- jump into/select node under the cursor
local select_next = false
vim.keymap.set({ "i" }, "<C-g>", function()
	-- the meat of this mapping: call ls.activate_node.
	-- strict makes it so there is no fallback to activating any node in the
	-- snippet, and select controls whether the text associated with the node is
	-- selected.
	local ok, _ = pcall(ls.activate_node, {
		strict = true,
		-- select_next is initially unset, but set within the first second after
		-- activating the mapping, so activating it again in that timeframe will
		-- select the text of the found node.
		select = select_next,
	})
	-- ls.activate_node throws on failure.
	if not ok then
		print("No node.")
		return
	end

	-- once the node is activated, we are either done (if text is SELECTed), or
	-- we briefly highlight the text associated with the node so one can know
	-- which node was activated.
	-- TODO: this highlighting does not show up if the node has no text
	-- associated (ie ${1:asdf} vs $1), a cool extension would be to also show
	-- something if there was no text.
	if select_next then
		return
	end

	local curbuf = vim.api.nvim_get_current_buf()
	local hl_duration_ms = 100

	local node = ls.session.current_nodes[curbuf]
	-- get node-position, raw means we want byte-columns, since those are what
	-- nvim_buf_set_extmark expects.
	local from, to = node:get_buf_position({ raw = true })

	-- highlight snippet for 1000ms
	local id = vim.api.nvim_buf_set_extmark(curbuf, ls.session.ns_id, from[1], from[2], {
		-- one line below, at col 0 => entire last line is highlighted.
		end_row = to[1],
		end_col = to[2],
		hl_group = "Visual",
	})
	-- disable highlight by removing the extmark after a short wait.
	vim.defer_fn(function()
		vim.api.nvim_buf_del_extmark(curbuf, ls.session.ns_id, id)
	end, hl_duration_ms)

	-- set select_next for the next second.
	select_next = true
	vim.uv.new_timer():start(1000, 0, function()
		select_next = false
	end)
end)

--@diagnostic disable-next-line: duplicate-set-field
vim.snippet.active = function(filter)
	filter = filter or {}
	filter.direction = filter.direction or 1

	if filter.direction == 1 then
		return ls.expand_or_jumpable()
	else
		return ls.jumpable(filter.direction)
	end
end

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.jump = function(direction)
	if direction == 1 then
		if ls.expandable() then
			return ls.expand_or_jump()
		else
			return ls.jumpable(1) and ls.jump(1)
		end
	else
		return ls.jumpable(-1) and ls.jump(-1)
	end
end

for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/custom/snippets", [[v:val =~ '\.lua$']])) do
	require("custom.snippets." .. file:gsub("%.lua$", ""))
end

-- require("custom.snippets")

vim.keymap.set({ "i", "s", "n" }, "<c-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

vim.keymap.set("i", "<c-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end)
