local M = {}

local function get_selection()
	local selection_start, selection_end
	selection_start = vim.api.nvim_buf_get_mark(0, "<")
	selection_end = vim.api.nvim_buf_get_mark(0, ">")
	if selection_start[1] > selection_end[1] then
		selection_start, selection_end = selection_end, selection_start
	end
	selection_start[1] = selection_start[1] - 1
	selection_end[1] = selection_end[1] - 1
	selection_end[2] = selection_end[2] + 1
	return selection_start, selection_end
end

M.LazyLog = function()
	local range_start, range_end = get_selection()
	local srow, scol = unpack(range_start)
	local erow, ecol = unpack(range_end)
	local chunk = vim.api.nvim_buf_get_text(0, srow, scol, erow, ecol, {})
	local text = ""
	for _, value in ipairs(chunk) do
		text = text .. " " .. value
	end
	vim.fn.cursor({ erow + 1, 1 })
	vim.api.nvim_buf_set_lines(
		0,
		erow + 1,
		erow + 1,
		true,
		{ "console.log(" .. "`line " .. srow + 1 .. ": " .. text .. "`" .. ", " .. text .. ")" }
	)
end

local setup = function()
	vim.keymap.set("v", "<F2>", "<Esc>: lua require('lazylog').LazyLog()<cr>")
end

---Setup plugin with user options
---@param user_opts table|nil
M.setup = function(user_opts)
	if user_opts then
		-- TODO: Setup plugin with user opts
		print("setup with user opts")
	end
	setup()
end

return M
