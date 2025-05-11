local M = {}

function M.setup()
    ps.sub("cd", function()
        local cwd = cx.active.current.cwd
        if cwd:ends_with("Downloads") then
            ya.mgr_emit("sort", { "mtime", reverse = false })
            ya.mgr_emit("linemode", { "mtime" })
        else
            ya.mgr_emit("sort", { "natural", reverse = false, dir_first = true, sensitive = true })
            ya.mgr_emit("linemode", { "none" })
        end

        if cwd:ends_with(".dotfiles") then
            ya.mgr_emit("hidden", { "show" })
        else
            ya.mgr_emit("hidden", { "hide" })
        end
    end)
end

return M
