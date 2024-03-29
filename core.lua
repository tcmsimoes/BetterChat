local myFrame = CreateFrame("Frame")
myFrame:RegisterEvent("VARIABLES_LOADED")

BC_SavedVars = {}
local previousLineId = -1
local filterPreviousLine = false

local function chatFilter(_, event, msg, player, _, _, _, flag, channelId, _, _, _, lineId, guid)
    if lineId ~= previousLineId then
        previousLineId = lineId

        if event == "CHAT_MSG_CHANNEL" and (channelId == 0 or type(channelId) ~= "number") then return end

        local lowMsg = msg:lower()
        for i=1, #BC_SavedVars["filters"] do
            if lowMsg:find(BC_SavedVars["filters"][i]) then
                if BC_SavedVars["debug"] == "on" then
                    print("BC Filtering message: "..msg)
                end
                filterPreviousLine = true
            end
        end
    end

    return filterPreviousLine
end

local function setFilterPatterns()
    BC_SavedVars["filters"] = {
        ".*wts.*boost.*",
        ".*wts.*vip trader.*",
        ".*sell.*vip trader.*",
        ".*offer.*vip trader.*",
        ".*<%s*n%s*o%s*v%s*a%s*>.*",
        ".*nova.*wts.*",
        ".*nova.*offer.*",
        ".*nova.*sell.*",
        ".*nova.*armor stack.*",
        ".*<%s*s%s*y%s*l%s*v%s*a%s*n%s*a%s*s%s*>.*",
        ".*sylvanas.*wts.*",
        ".*sylvanas.*offer.*",
        ".*sylvanas.*sell.*",
        ".*sylvanas.*armor stack.*",
        ".*<%s*d%s*a%s*w%s*n%s*>.*",
        ".*dawn.*wts.*",
        ".*dawn.*offer.*",
        ".*dawn.*sell.*",
        ".*dawn.*armor stack.*"
    }
end

myFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "VARIABLES_LOADED" then
        if not BC_SavedVars["filters"] then
            setFilterPatterns()
        end
        if not BC_SavedVars["debug"] then
            BC_SavedVars["debug"] = "off"
        end

        ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", chatFilter)
    end
end)

SLASH_BC1 = "/bc"
SlashCmdList["BC"] = function(msg)
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")

    if cmd == "add" and args ~= "" then
        table.insert(BC_SavedVars["filters"], args)
    elseif cmd == "remove" and args ~= "" then
        table.remove(BC_SavedVars["filters"], args)
    elseif cmd == "debug" then
        BC_SavedVars["debug"] = args
    elseif cmd == "reset" then
        setFilterPatterns()
    else
        print("Available commands are: /bc add/remove <regex> /bc debug on/off /bc reset")
    end

    print("BetterChat debug: "..BC_SavedVars["debug"])
    print("BetterChat filters:")
    for i=1, #BC_SavedVars["filters"] do
        print("    "..i..": '"..BC_SavedVars["filters"][i].."'")
    end
end 