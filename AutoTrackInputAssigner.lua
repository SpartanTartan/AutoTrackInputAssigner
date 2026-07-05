-- REAPER Auto-Input Map Configuration
-- MONO AUDIO:   Use the physical input number minus 1 (e.g., Input 1 = 0)
-- STEREO AUDIO: Use 1024 + (Starting physical input number minus 1)
-- MIDI DEVICES: Use 4096 + (MIDI Device ID * 32) + MIDI Channel (0 = All Channels)
--               *Note: Use Device ID 63 for "All MIDI Inputs"
local rules = {
    ["monotrack"]   = { input = 0,                    auto_arm = true, monitor = 1 }, -- Mono Hardware Input 1
    ["stereotrack"] = { input = 1024 + 0,             auto_arm = true, monitor = 1 }, -- Stereo Hardware Inputs 1 & 2
    ["miditrack"]   = { input = 4096 + (63 * 32) + 0, auto_arm = true, monitor = 1 }  -- MIDI: All Inputs, All Channels
}

local function autoConfigureTracks()
    local track_count = reaper.CountTracks(0)
    for i = 0, track_count - 1 do
        local track = reaper.GetTrack(0, i)
        local _, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
        track_name = track_name:lower()

        -- Scan through rules to find a text match
        for trigger, settings in pairs(rules) do
            if track_name:find(trigger) then
                -- Get current track settings to avoid constantly spamming the undo history
                local current_input = reaper.GetMediaTrackInfo_Value(track, "I_RECINPUT")
                local current_arm = reaper.GetMediaTrackInfo_Value(track, "I_RECARM")
                local current_mon = reaper.GetMediaTrackInfo_Value(track, "I_RECMON")

                -- Change input if it isn't already set correctly
                if current_input ~= settings.input then
                    reaper.SetMediaTrackInfo_Value(track, "I_RECINPUT", settings.input)
                end
                
                -- Arm if it isn't already armed
                if settings.auto_arm and current_arm ~= 1 then
                    reaper.SetMediaTrackInfo_Value(track, "I_RECARM", 1)
                end

                -- Enable Record Monitoring if it isn't already set
                if settings.monitor and current_mon ~= settings.monitor then
                    reaper.SetMediaTrackInfo_Value(track, "I_RECMON", settings.monitor)
                end
            end
        end
    end
    -- Loop seamlessly in the background
    reaper.defer(autoConfigureTracks)
end

-- Start the script loop
autoConfigureTracks()
