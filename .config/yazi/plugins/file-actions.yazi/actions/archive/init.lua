local M = {}

--luacheck: ignore output err
function M.init(_, opts)
	local choice_mode
	local compression_mode
	local cancel = false
	local archive_tool
	local archive_ext

	Popup.Menu
		:new(
			{
				"7z Archive",
				"Zip Archive",
			},
			opts.flags.around,
			function(cursor)
				archive_tool = ({
					"7z a",
					"zip -r",
				})[cursor]
				archive_ext = ({
					"7z",
					"zip",
				})[cursor]
			end,
			function()
				cancel = true
			end
		)
		:show()

	-- stylua: ignore
	if cancel then return end

	-- 文件是一个还是多个
	cancel = false
	if #opts.selected == 1 then
		choice_mode = "single"
		compression_mode = "combined"
	else
		choice_mode = "multiple"
		-- 压缩成一个还是分别压缩
		local menuOptions = {
			"Compress to Archive",
			"Compress Each to Archive",
		}
		-- 确认
		local onConfirm = function(cursor)
			compression_mode = (cursor == 1) and "combined" or "separate"
		end
		-- 取消
		-- stylua: ignore
		local onCancel = function() cancel = true end
		-- 菜单
		local menu = Popup.Menu:new(menuOptions, opts.flags.around, onConfirm, onCancel)
		menu:show()
	end

	-- stylua: ignore
	if cancel then return end

	-- The script here won't work without "./"
	-- The script file must have execution permissions
	-- stylua: ignore
	local output, err = Command("./archive.sh")
		:cwd(opts.workpath) -- Enter the directory of the action plugin
		:env("choice_mode", choice_mode)
		:env("compression_mode", compression_mode)
		:env("archive_tool", archive_tool)
		:env("archive_ext", archive_ext)
		-- To avoid issues with spaces in filenames, here we use Tab to separate
		-- Therefore, in the script file, it must declare IFS=$'\t'
		:env("selection", table.concat(opts.selected, "\t"))
		:output()

	if opts.flags.debug then
		ya.err("====debug info====")
		if err ~= nil then
			ya.err("err:" .. tostring(err))
		else
			ya.err("OK? :" .. tostring(output.status:success()))
			ya.err("Code:" .. tostring(output.status:code()))
			ya.err("stdout:" .. output.stdout)
			ya.err("stderr" .. output.stderr)
		end
	end
	--For detailed usage of the 'output' and 'err' variables,
	--please refer to: https://yazi-rs.github.io/docs/plugins/utils#output
end

return M
