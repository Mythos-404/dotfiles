---@type Action
return {
	info = {
		name = "Quick Archive",
	},

	init = function(opts)
		local archive_commands = {
			{ ["7z Archive"] = { ext = "7z", command = "7z", args = "a" } },
			{ ["Zip Archive"] = { ext = "zip", command = "zip", args = "-r" } },
			{ ["Tar Archive"] = { ext = "tar", command = "tar", args = "acpf" } },
			{ ["ZStd Archive"] = { ext = "tar.zst", command = "tar", args = "acpf" } },
			{ ["Gzip Archive"] = { ext = "tar.gz", command = "tar", args = "acpf" } },
			{ ["Bzip2 Archive"] = { ext = "tar.bz2", command = "tar", args = "acpf" } },
		}

		PopupMenu(
			(function()
				local archive_list = {}
				for _, command in ipairs(archive_commands) do
					local k, _ = next(command)
					table.insert(archive_list, k)
				end
				return archive_list
			end)(),
			{
				on_confirm = function(cursor)
					local _, archive_command = next(archive_commands[cursor])

					local shell_scipt = ([=[
						IFS=$'\t'
						arr_selection=(${selection})

						if [[ ${single} == 'true' ]]; then
							pack_name="${arr_selection[0]%%.*}"
						else
							pack_name="${arr_selection[0]%%/*}"
							pack_name="${pack_name##*/}"
						fi

						%s %s "${pack_name}".%s "${arr_selection[@]}"
					]=]):format(archive_command.command, archive_command.args, archive_command.ext)

					Command("bash")
						:args({ "-c", shell_scipt })
						:cwd(opts.selected[1]:match("^(.+)/"))
						:env("selection", table.concat(opts.selected, "\t"))
						:env("single", #opts.selected == 1 and "true" or "false")
						:output()
				end,
			}
		):show()
	end,
}
