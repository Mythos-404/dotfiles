local M = {}

function M.setup()
	ps.sub("cd", function()
		local cwd = cx.active.current.cwd
		if cwd:ends_with("Downloads") then
			ya.manager_emit("sort", { "modified", reverse = true, dir_first = false })
			return
		else
			ya.manager_emit("sort", { "natural", reverse = false, dir_first = true, sensitive = true })
		end

		if cwd:ends_with(".dotfile") or cwd:ends_with("mythos_404") then
			ya.manager_emit("hidden", { "show" })
			return
		else
			ya.manager_emit("hidden", { "hide" })
		end
	end)
end

return M
