--- @sync entry
local M = {}
local H = {}

H.selected_or_hovered = ya.sync(function()
    local tab, paths = cx.active, {}
    for _, u in pairs(tab.selected) do
        paths[#paths + 1] = tostring(u)
    end
    if #paths == 0 and tab.current.hovered then paths[1] = tostring(tab.current.hovered.url) end
    return paths
end)

function H.info(content)
    return ya.notify({
        title = "MUtils",
        content = content,
        timeout = 5,
    })
end

H.selected_url = ya.sync(function()
    for _, u in pairs(cx.active.selected) do
        return u
    end
end)

H.hovered_url = ya.sync(function()
    local h = cx.active.current.hovered
    return h and h.url
end)

function H.save_file(file_path, output)
    local file = io.open(file_path, "w+")
    file:write(output)
    file:close()
end

function M.chmod()
    ya.manager_emit("escape", { visual = true })

    local urls = H.selected_or_hovered()
    if #urls == 0 then
        return ya.notify({ title = "Chmod", content = "No file selected", level = "warn", timeout = 5 })
    end

    local value, event = ya.input({
        title = "Chmod:",
        position = { "top-center", y = 3, w = 40 },
    })
    if event ~= 1 then return end

    local status, err = Command("chmod"):arg(value):args(urls):spawn():wait()
    if not status or not status.success then
        ya.notify({
            title = "Chmod",
            content = string.format("Chmod with selected files failed, exit code %s", status and status.code or err),
            level = "error",
            timeout = 5,
        })
    end
end

function M.smart_enter()
    local h = cx.active.current.hovered
    ya.manager_emit(h and h.cha.is_dir and "enter" or "open", {})
end

function M.diff(is_save_file)
    local a, b = H.selected_url(), H.hovered_url()
    if not (a and b) then return H.info("No file selected") end

    local output, err = Command("diff"):arg("-Naur"):arg(tostring(a)):arg(tostring(b)):output()
    if not output then return H.info("Failed to run diff, error: " .. err) end

    if is_save_file ~= "save" then
        ya.clipboard(output.stdout)
        H.info("Diff copied to clipboard")
    end

    local file_name = ya.input({
        title = "Path name(not extension)",
        value = a:stem(),
        position = { "top-center", y = 3, w = 40 },
    })
    H.save_file(("%s/%s.path"):format(a:parent(), file_name), output.stdout)
end

return {
    entry = function(_, job)
        local action = job.args[1]
        M[action](job.args[2])
    end,
}
