---@type Action
return {
	info = {
		name = "Video Convert",
		mime = {
			enables = {
				"video/mp4",
				"video/ogg",
				"video/webm",
				"video/x-matroska",
			},
		},
	},

	init = function(opts)
		local video_commands = {
			{ ["To MP4"] = { ext = "mp4", hwaccel = "-c:v hevc_nvenc" } },
			{ ["To MKV"] = { ext = "mkv", hwaccel = "-c:v hevc_nvenc" } },
			{ ["To Webm"] = { ext = "webm", hwaccel = "-c:v hevc_nvenc" } },
		}

		PopupMenu(
			(function()
				local video_list = {}
				for _, video_command in ipairs(video_commands) do
					local name, _ = next(video_command)
					table.insert(video_list, name)
				end
				return video_list
			end)(),
			{
				on_confirm = function(cursor)
					local _, command = next(video_commands[cursor])
					local shell_scipt = [[
						echo "${selection}" | tr '\t' '\0' | xargs -0 -P4 -I{} bash -c 'input="$(basename "{}")"; ffmpeg -i "${input}" %s "${input%%.*}.%s"'
					]] --> INJECT: bash

					ya.dbg(
						Command("bash")
							:args({ "-c", shell_scipt:format(command.hwaccel, command.ext) })
							:cwd(opts.selected[1]:match("^(.+)/"))
							:env("selection", table.concat(opts.selected, "\t"))
							:output().stderr
					)
				end,
			}
		):show()
	end,
}
