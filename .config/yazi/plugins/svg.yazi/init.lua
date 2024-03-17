local M = {}

function M:peek()
	local cache = ya.file_cache(self)
	if not cache then
		return
	end

	if self:preload() == 1 then
		ya.image_show(cache, self.area)
		ya.preview_widgets(self, {})
	end
end

function M:seek() end

function M:preload()
	local cache = ya.file_cache(self)
	if not cache or fs.cha(cache) then
		return 1
	end

	local output = Command("rsvg-convert")
		:args({
			tostring(self.file.url),
			"--x-zoom",
			"25",
			"--y-zoom",
			"25",
		})
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()
	if not output then
		return 0
	end

	return fs.write(cache, output.stdout) and 1 or 2
end

return M
