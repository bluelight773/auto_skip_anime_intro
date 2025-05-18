-- Importing mpv module
local mp = require('mp')

-- Store the chapter ranges that need to be skipped
local skip_ranges = {}

-- Names that indicate a chapter should be skipped
local skip_names = {
    "op",
    "opening",
    "ed",
    "credits",
    "logo",
    "commercial",
    "previously"
}

-- Function to check if a chapter name matches skip criteria
local function is_skip_name(name)
    if not name then return false end
    name = name:lower()
    for _, skip_name in ipairs(skip_names) do
        if name == skip_name then
            return true
        end
    end
    return false
end

-- Function to initialize skip ranges
local function initialize_skip_ranges()
    -- Get total number of chapters
    local chapter_count = mp.get_property_number("chapter-list/count")
    if not chapter_count or chapter_count == 0 then
        return
    end

    -- Get total duration
    local total_time = mp.get_property_number("duration")
    if not total_time then
        return
    end

    -- Clear existing ranges
    skip_ranges = {}

    -- Find chapters to skip based on duration or name
    for i = 0, chapter_count - 1 do
        local chapter_start = mp.get_property_number(string.format("chapter-list/%d/time", i))
        local chapter_end
        local chapter_title = mp.get_property(string.format("chapter-list/%d/title", i))
        
        -- Handle last chapter specially
        if i == chapter_count - 1 then
            chapter_end = total_time
        else
            chapter_end = mp.get_property_number(string.format("chapter-list/%d/time", i + 1))
        end

        -- Calculate chapter duration
        local chapter_duration = chapter_end - chapter_start
        
        -- Debug output
        mp.msg.info(string.format("Chapter %d: Title='%s', Start=%f, End=%f, Duration=%f", 
                                 i, chapter_title or "nil", chapter_start, chapter_end, chapter_duration))

        -- If chapter matches duration criteria or name criteria, add it to skip ranges
        if (chapter_duration >= 88 and chapter_duration <= 92) or is_skip_name(chapter_title) then
            table.insert(skip_ranges, {start = chapter_start, end_ = chapter_end})
            mp.msg.info(string.format("Added skip range: %f to %f (duration: %f, title: %s)", 
                                     chapter_start, chapter_end, chapter_duration, chapter_title or "nil"))
        end
    end
end

-- Function to check and skip if within a range
local function check_and_skip()
    local current_time = mp.get_property_number("time-pos")
    if not current_time then
        return
    end

    -- Check if current time is within any skip range
    for _, range in ipairs(skip_ranges) do
        if current_time >= range.start and current_time < range.end_ then
            mp.msg.info(string.format("Current time %f is within skip range %f to %f - skipping", 
                                     current_time, range.start, range.end_))
            mp.set_property_number("time-pos", range.end_)
            return
        end
    end
end

-- Initialize skip ranges when file is loaded
mp.register_event("file-loaded", initialize_skip_ranges)

-- Check for skips when time position changes
mp.observe_property("time-pos", "number", check_and_skip)
