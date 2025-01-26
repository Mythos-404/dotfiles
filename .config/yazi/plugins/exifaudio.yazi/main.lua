local M = {}

function M:peek(job)
    local cache = ya.file_cache(job)
    if not cache then return end

    local child = Command("exiftool")
        :args({
            "-q",
            "-q",
            "-S",
            "-Title",
            "-SortName",
            "-TitleSort",
            "-TitleSortOrder",
            "-Artist",
            "-SortArtist",
            "-ArtistSort",
            "-PerformerSortOrder",
            "-Album",
            "-SortAlbum",
            "-AlbumSort",
            "-AlbumSortOrder",
            "-AlbumArtist",
            "-SortAlbumArtist",
            "-AlbumArtistSort",
            "-AlbumArtistSortOrder",
            "-Genre",
            "-TrackNumber",
            "-Year",
            "-Duration",
            "-SampleRate",
            "-AudioSampleRate",
            "-AudioBitrate",
            "-AvgBitrate",
            "-Channels",
            "-AudioChannels",
            tostring(job.file.url),
        })
        :stdout(Command.PIPED)
        :stderr(Command.NULL)
        :spawn()

    local limit = job.area.h
    local i, metadata = 0, {}
    repeat
        local next, event = child:read_line()
        if event == 1 then
            return job:fallback_to_builtin()
        elseif event ~= 0 then
            break
        end

        i = i + 1
        if i > job.skip then
            local m_title, m_tag = prettify(next)
            local ti = ui.Span(m_title):bold()
            local ta = ui.Span(m_tag)
            table.insert(metadata, ui.Line({ ti, ta }))
            table.insert(metadata, ui.Line({}))
        end
    until i >= job.skip + limit

    local p = ui.Text(metadata):area(job.area):wrap(ui.Text.WRAP)
    ya.preview_widgets(job, { p })

    local cover_width = job.area.w / 2 - 5
    local cover_height = (job.area.h / 4) + 3

    local bottom_right = ui.Rect({
        x = job.area.right - cover_width,
        y = job.area.bottom - cover_height,
        w = cover_width,
        h = cover_height,
    })

    if self:preload(job) == 1 then ya.image_show(cache, bottom_right) end
end

function prettify(metadata)
    local substitutions = {
        Sortname = "Sort Title:",
        SortName = "Sort Title:",
        TitleSort = "Sort Title:",
        TitleSortOrder = "Sort Title:",
        ArtistSort = "Sort Artist:",
        SortArtist = "Sort Artist:",
        Artist = "Artist:",
        ARTIST = "Artist:",
        PerformerSortOrder = "Sort Artist:",
        SortAlbumArtist = "Sort Album Artist:",
        AlbumArtistSortOrder = "Sort Album Artist:",
        AlbumArtistSort = "Sort Album Artist:",
        AlbumSortOrder = "Sort Album:",
        AlbumSort = "Sort Album:",
        SortAlbum = "Sort Album:",
        Album = "Album:",
        ALBUM = "Album:",
        AlbumArtist = "Album Artist:",
        Genre = "Genre:",
        GENRE = "Genre:",
        TrackNumber = "Track Number:",
        Year = "Year:",
        Duration = "Duration:",
        AudioBitrate = "Bitrate:",
        AvgBitrate = "Average Bitrate:",
        AudioSampleRate = "Sample Rate:",
        SampleRate = "Sample Rate:",
        AudioChannels = "Channels:",
    }

    for k, v in pairs(substitutions) do
        metadata = metadata:gsub(tostring(k) .. ":", v, 1)
    end

    -- Separate the tag title from the tag data
    local t = {}
    for str in string.gmatch(metadata, "([^" .. ":" .. "]+)") do
        table.insert(t, str)
    end

    -- Add back semicolon to title, rejoin tag data if it happened to contain a semicolon
    return t[1] .. ":", table.concat(t, ":", 2)
end

function M:seek(job)
    local h = cx.active.current.hovered
    if h and h.url == job.file.url then
        ya.manager_emit("peek", {
            tostring(math.max(0, cx.active.preview.skip + job.units)),
            only_if = tostring(job.file.url),
        })
    end
end

function M:preload(job)
    local cache = ya.file_cache(job)
    if not cache or fs.cha(cache) then return 1 end

    local output = Command("exiftool")
        :args({ "-b", "-CoverArt", "-Picture", tostring(job.file.url) })
        :stdout(Command.PIPED)
        :stderr(Command.PIPED)
        :output()

    if not output then return 0 end

    return fs.write(cache, output.stdout) and 1 or 2
end

return M
