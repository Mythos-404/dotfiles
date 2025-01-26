---@type Action
return {
    info = {
        name = "Rename to Md5",
        mime = {
            disables = {
                "inode/directory",
            },
        },
    },

    init = function(opts)
        local shell_scipt = [[
			IFS=$'\0'
			for file in ${selection}; do
			    digest=$(md5sum "$file" | cut -d' ' -f1)
			    mv "$file" "${file%/*}/${digest%% *}.${file##*.}"
			done
		]] --> INJECT: bash
		-- stylua: ignore
		Command("bash")
			:args({
				"-c",
				shell_scipt
			})
			:cwd(opts.workpath)
			:env("selection", table.concat(opts.selected, "\0"))
			:output()
    end,
}
