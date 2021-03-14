local myFrame = CreateFrame("Frame")
myFrame:RegisterEvent("VARIABLES_LOADED")

BC_SavedVars = {}
previousLineId = -1
filterPreviousLine = false

local function chatFilter(_, event, msg, player, _, _, _, flag, channelId, _, _, _, lineId, guid)
    if lineId ~= previousLineId then
        previousLineId = lineId

        if event == "CHAT_MSG_CHANNEL" and (channelId == 0 or type(channelId) ~= "number") then return end

        local lowMsg = msg:lower()
        for i=1, #BC_SavedVars["filters"] do
            if lowMsg:find(BC_SavedVars["filters"][i]) then
                --print("Filtering message "..msg)
                filterPreviousLine = true
            end
        end
    end

    return filterPreviousLine
end

myFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "VARIABLES_LOADED" then
        if not BC_SavedVars["filters"] then
            BC_SavedVars["filters"] = { ".*wts.*boost.*" }
        end

        ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", chatFilter)
    end
end)