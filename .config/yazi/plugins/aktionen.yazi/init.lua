local M = {}
local H = {
	flags = {},
	state = {},
}

---@class ActionInfo
---@field name string
---@field mime? { disables?: string[], enables?: string[] }
---@field single? boolean

---@class Action
---@field info ActionInfo
---@field init fun(opts: {workpath: string, selected: string[], flags: string[]}): nil

---@class PopupMenuOpt
---@field scroll_offset? integer
---@field window_size? integer
---@field around? boolean
---@field on_confirm? fun(cursor: integer): nil
---@field on_cancel? fun(): nil

---@class PopupMenuClass
---@field private items string[]
---@field private scroll_offset integer
---@field private window_size integer
---@field private around boolean
---@field private on_confirm fun(cursor: integer): nil
---@field private on_cancel fun(): nil
---@overload fun(items: string[], opt: PopupMenuOpt): self
PopupMenu = {
	keybind = {
		cands = {
			{ on = "j", desc = "下一项" },
			{ on = "<Down>", desc = "下一项" },
			{ on = "k", desc = "上一项" },
			{ on = "<Up>", desc = "上一项" },
			{ on = "G", desc = "最后一项" },
			{ on = "g", desc = "第一项" },
			{ on = "<Esc>", desc = "取消" },
			{ on = "<Enter>", desc = "确认" },
			{ on = "y", desc = "确认" },
		},
		key_to_action = {
			[1] = "next", -- on = "j"
			[2] = "next", -- on = "<Down>"
			[3] = "prev", -- on = "k"
			[4] = "prev", -- on = "<up>"
			[5] = "last", -- on = "G"
			[6] = "first", -- on = "gg"
			[7] = "cancel", -- on = "<Esc>"
			[8] = "confirm", -- on = "<Enter>"
		},
	},
}

---@diagnostic disable-next-line: param-type-mismatch
setmetatable(PopupMenu, {
	---@private
	__call = function(self, ...)
		return self:_new(...)
	end,
})

---@private
function PopupMenu:_new(items, opts)
	opts = opts or {}
	local obj = {
		scroll_offset = opts.scroll_offset or 3,
		window_size = opts.window_size or 10,
		around = opts.around or false,
		items = items,
		on_confirm = opts.on_confirm or function(cursor)
			return cursor
		end,
		on_cancel = opts.on_cancel or function()
			return nil
		end,
	}
	self.__index = self
	setmetatable(obj, self)
	return obj
end

function PopupMenu:show()
	local window_start = 1
	local window_height = math.min(self.window_size, #self.items)
	local window_end = window_height
	local window_cursor = 1
	local cursor = 1

	self.switch_keymap = {
		next = function()
			if window_cursor < (window_height - self.scroll_offset) or window_end == #self.items then
				if self.around and window_cursor == window_height then
					self.switch_keymap["first"]()
				else
					window_cursor = math.min(window_cursor + 1, window_height)
					cursor = math.min(cursor + 1, #self.items)
				end
			elseif window_cursor == (window_height - self.scroll_offset) then
				window_start = window_start + 1
				window_end = window_end + 1
				cursor = cursor + 1
			end
		end,
		prev = function()
			if window_cursor > (1 + self.scroll_offset) or window_start == 1 then
				if self.around and window_cursor == 1 then
					self.switch_keymap["last"]()
				else
					window_cursor = math.max(window_cursor - 1, 1)
					cursor = math.max(cursor - 1, 1)
				end
			elseif window_cursor == (1 + self.scroll_offset) then
				window_start = window_start - 1
				window_end = window_end - 1
				cursor = cursor - 1
			end
		end,
		last = function()
			window_cursor = window_height
			window_start = #self.items - window_height + 1
			window_end = #self.items
			cursor = #self.items
		end,
		first = function()
			window_cursor = 1
			window_start = 1
			window_end = window_height
			cursor = 1
		end,
	}

	while true do
		self._render(true, self.items, window_height, window_cursor)

		local key = ya.which({ cands = PopupMenu.keybind.cands, silent = true })
		local key_action = PopupMenu.keybind.key_to_action[key]

		if key_action == "confirm" then
			self._render(false)
			self.on_confirm(cursor)
			break
		end

		if key_action == "cancel" or key_action == nil then
			self._render(false)
			self.on_cancel()
			break
		end

		self.switch_keymap[key_action]()
	end
end

---@private
PopupMenu._render = ya.sync(function(state, display, items, height, cursor)
	Root.render = function(self)
		if not display then
			return state.old_render(self)
		end

		local list_items = {}
		for i, item in ipairs(items) do
			table.insert(list_items, ui.Line(item):style(i == cursor and THEME.manager.hovered or nil))
		end

		local area = H.center_layout(self._area, height)
		return ya.list_merge(state.old_render(self), {
			ui.Clear(area),
			ui.Border(ui.Bar.ALL):area(area):type(ui.Border.ROUNDED):style(THEME.tasks.border),
			ui.List(list_items):area(area:padding(ui.Padding.xy(1, 1))),
		})
	end
	ya.render()
end)

M.entry = function(_, args)
	H.state = H.sync_init()
	H.flags = H.set_args(args)

	H.init_action()
end

--------------------------------------------------------------------------------

H.set_args = ya.sync(function(_, args)
	H.flags = { around = false, debug = false }
	for _, arg in pairs(args) do
		if H.flags[arg] ~= nil then
			H.flags[arg] = true
		end
	end
	return H.flags
end)

H.sync_init = ya.sync(function(state)
	if state.old_render == nil then
		state.old_render = Root.render
	end

	H.state.actions_path = ("%s/aktionen.yazi/actions"):format(BOOT.plugin_dir)

	H.state.cursor_files = {}
	local hovered = cx.active.current.hovered
	if hovered and not hovered.url.is_archive then
		table.insert(H.state.cursor_files, tostring(hovered.url))
	end

	H.state.selected_files = {}
	for _, url in pairs(cx.active.selected) do
		if not url.is_archive then
			table.insert(H.state.selected_files, tostring(url))
		end
	end

	return H.state
end)

H.init_action = function()
	if #H.state.cursor_files == 0 and #H.state.selected_files == 0 then
		return
	end

	if #H.state.selected_files == 0 then
		H.state.selected_files = H.state.cursor_files
	end

	-- stylua: ignore
	local file_child, file_err =
		Command("file")
			:args({ "-bL", "--mime-type" })
			:args(H.state.selected_files)
			:stdout(Command.PIPED)
			:spawn()
	if H.flags.debug and file_err then
		ya.err("Aktionen load selected mime err" .. tostring(file_err))
	end

	local selected_mimetype_set = {}
	while true do
		local line, event = file_child:read_line()
		if event ~= 0 then
			break
		end
		local mimetype = string.gsub(line, "%s$", "")
		selected_mimetype_set[mimetype] = true
	end

	-- stylua: ignore
	local action_child, action_err =
		Command("ls")
			:cwd(ya.quote(H.state.actions_path))
			:stdout(Command.PIPED)
			:spawn()
	if H.flags.debug and action_err then
		ya.err("Aktionen load action err:" .. tostring(action_err))
	end

	local action_infos = {
		names = {},
		mod = {},
	}
	while true do
		local line, event = action_child:read_line()
		if event ~= 0 then
			break
		end

		local action_path = string.gsub(line, "\n$", "")
		local action = dofile(("%s/%s/init.lua"):format(H.state.actions_path, action_path)) --[[ @as Action ]]

		if action.info.single and #H.state.selected_files ~= 1 then
			goto continue_get_action
		end

		if action.info.mime then
			if action.info.mime.disables then
				for _, minietype in ipairs(action.info.mime.disables) do
					if selected_mimetype_set[minietype] then
						goto continue_get_action
					end
				end
			end
			if action.info.mime.enables and #action.info.mime.enables ~= 0 then
				local mime_enable_set = {}
				for _, mimetype in pairs(action.info.mime.enables) do
					mime_enable_set[mimetype] = true
				end
				for selected_mimetype in pairs(selected_mimetype_set) do
					if not mime_enable_set[selected_mimetype] then
						goto continue_get_action
					end
				end
			end
		end

		table.insert(action_infos.names, action.info.name)
		table.insert(action_infos.mod, { init = action.init, path = action_path })
		::continue_get_action::
	end

	if #action_infos.names == 0 then
		ya.notify({
			title = "Aktionen",
			content = "No action script available for this file type.",
			timeout = 6.0,
			level = "warn",
		})
		return
	end

	PopupMenu(action_infos.names, {
		around = H.flags.around,
		on_confirm = function(cursor)
			local mod = action_infos.mod[cursor]
			mod.init({
				workpath = ya.quote(H.state.actions_path .. "/" .. mod.path),
				selected = H.state.selected_files,
				flags = H.flags,
			})
		end,
	}):show()
end

function H.center_layout(area, height)
	local _, current_layout, _ = table.unpack(ui.Layout()
		:direction(ui.Layout.HORIZONTAL)
		:constraints({
			ui.Constraint.Ratio(MANAGER.ratio.parent, MANAGER.ratio.all),
			ui.Constraint.Ratio(MANAGER.ratio.current, MANAGER.ratio.all),
			ui.Constraint.Ratio(MANAGER.ratio.preview, MANAGER.ratio.all),
		})
		:split(area))

	local _, centered_content_layout, _ = table.unpack(ui.Layout()
		:direction(ui.Layout.HORIZONTAL)
		:constraints({
			ui.Constraint.Ratio(1, 4),
			ui.Constraint.Ratio(2, 4),
			ui.Constraint.Ratio(1, 4),
		})
		:split(current_layout))

	local _, centered_ontent = table.unpack(ui.Layout()
		:direction(ui.Layout.VERTICAL)
		:constraints({
			ui.Constraint.Length(1),
			ui.Constraint.Length(height + 2),
		})
		:split(centered_content_layout))

	return centered_ontent
end

return M
