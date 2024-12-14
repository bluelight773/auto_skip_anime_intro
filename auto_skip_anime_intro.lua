-- Importing mpv module
local mp = require('mp')

-- Store the chapter ranges that need to be skipped
local skip_ranges = {}

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

    -- Find all chapters that are 88-92 seconds long
    for i = 0, chapter_count - 1 do
        local chapter_start = mp.get_property_number(string.format("chapter-list/%d/time", i))
        local chapter_end
        
        -- Handle last chapter specially
        if i == chapter_count - 1 then
            chapter_end = total_time
        else
            chapter_end = mp.get_property_number(string.format("chapter-list/%d/time", i + 1))
        end

        -- Calculate chapter duration
        local chapter_duration = chapter_end - chapter_start
        
        -- Debug output
        mp.msg.info(string.format("Chapter %d: Start=%f, End=%f, Duration=%f", 
                                 i, chapter_start, chapter_end, chapter_duration))

        -- If chapter is 88-92 seconds, add it to skip ranges
        if chapter_duration >= 88 and chapter_duration <= 92 then
            table.insert(skip_ranges, {start = chapter_start, end_ = chapter_end})
            mp.msg.info(string.format("Added skip range: %f to %f (duration: %f)", 
                                     chapter_start, chapter_end, chapter_duration))
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
