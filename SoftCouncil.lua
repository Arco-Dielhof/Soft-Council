if SoftCouncil == nil then SoftCouncil = {} end
SoftCouncil.Events = {}
SoftCouncil.Version = 7
local AddOnName = "SoftCouncil"

local UpdateFrame, EventFrame = nil, nil
local MainFrame = nil
local RaidsFrame, RaidsScrollPanel = nil, nil
local EncountersFrame, EncountersScrollPanel = nil, nil
local PlayersFrame, PlayersScrollPanel = nil, nil

local activeEncounter = false

local dataFrameWidth = 670 / 5

local allDateItems, allEncounterItems, allPullItems, allPlayerItems = {Expanded = {},}, {Expanded = {},}, {Expanded = {},}, {Expanded = {},}
local allDataItems = {}

local SelectedRaid, SelectedEncounter = nil, nil

if SoftCouncilDataTable == nil then SoftCouncilDataTable = SoftCouncil.DataTable end

function SoftCouncil:OnLoad()
    EventFrame = CreateFrame("Frame", nil, UIParent)
    SoftCouncil:RegisterEvents("ENCOUNTER_START", function(...) print("OnLoadRegister EncounterStart") SoftCouncil.Events:EncounterStart(...) end)
    SoftCouncil:RegisterEvents("ENCOUNTER_END", function(...) SoftCouncil.Events:EncounterEnd(...) end)
    SoftCouncil:RegisterEvents("COMBAT_LOG_EVENT_UNFILTERED", function(...) SoftCouncil.Events:CombatLogUnfiltered(...) end)
    SoftCouncil:RegisterEvents("ADDON_LOADED", function(...) SoftCouncil.Events:AddonLoaded(...) end)
    SoftCouncil:RegisterEvents("VARIABLES_LOADED", function(...) SoftCouncil.Events:VariablesLoaded(...) end)
    EventFrame:SetScript("OnEvent", function(...)
        SoftCouncil:OnEvent(...)
    end)

    UpdateFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    UpdateFrame:SetPoint("CENTER", 0, 250)
    UpdateFrame:SetSize(250, 300)
    UpdateFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    UpdateFrame:SetBackdropColor(0.25, 0.25, 0.25, 0.80)
    UpdateFrame.header = UpdateFrame:CreateFontString("UpdateFrame", "ARTWORK", "GameFontNormalHuge")
    UpdateFrame.header:SetPoint("TOP", 0, -10)
    UpdateFrame.header:SetText("|cFFFF0000" .. AddOnName .. " out of date!|r")

    local UpdateFrameCloseButton = CreateFrame("Button", nil, UpdateFrame, "UIPanelCloseButton")
    UpdateFrameCloseButton:SetWidth(25)
    UpdateFrameCloseButton:SetHeight(25)
    UpdateFrameCloseButton:SetPoint("TOPRIGHT", UpdateFrame, "TOPRIGHT", 2, 2)
    UpdateFrameCloseButton:SetScript("OnClick", function() UpdateFrame:Hide() end )

    SoftCouncil:CreateMainFrame()

    UpdateFrame:Hide()
end

function SoftCouncil:CreateMainFrame()
    MainFrame = CreateFrame("Frame", nil, UIParent)
    MainFrame:SetPoint("CENTER", 0, 0)
    MainFrame:SetSize(670, 400)
    MainFrame:EnableMouse(true)
    MainFrame:SetMovable(true)
    MainFrame:RegisterForDrag("LeftButton")
    MainFrame:SetScript("OnDragStart", MainFrame.StartMoving)
    MainFrame:SetScript("OnDragStop", MainFrame.StopMovingOrSizing)

    MainFrame.TopLeftBG     = CreateFrame("Frame", nil, MainFrame, "BackdropTemplate")
    MainFrame.TopBG1        = CreateFrame("Frame", nil, MainFrame, "BackdropTemplate")
    MainFrame.TopBG2        = CreateFrame("Frame", nil, MainFrame, "BackdropTemplate")
    MainFrame.TopRightBG    = CreateFrame("Frame", nil, MainFrame, "BackdropTemplate")
    MainFrame.BotLeftBG     = CreateFrame("Frame", nil, MainFrame, "BackdropTemplate")
    MainFrame.BotBG1        = CreateFrame("Frame", nil, MainFrame, "BackdropTemplate")
    MainFrame.BotBG2        = CreateFrame("Frame", nil, MainFrame, "BackdropTemplate")
    MainFrame.BotRightBG    = CreateFrame("Frame", nil, MainFrame, "BackdropTemplate")

    MainFrame.TopLeftBG :SetSize(200, MainFrame:GetHeight() / 2)
    MainFrame.TopBG1    :SetSize(200, MainFrame:GetHeight() / 2)
    MainFrame.TopBG2    :SetSize(200, MainFrame:GetHeight() / 2)
    MainFrame.TopRightBG:SetSize(100, MainFrame:GetHeight() / 2)
    MainFrame.BotLeftBG :SetSize(200, MainFrame:GetHeight() / 2)
    MainFrame.BotBG1    :SetSize(200, MainFrame:GetHeight() / 2)
    MainFrame.BotBG2    :SetSize(200, MainFrame:GetHeight() / 2)
    MainFrame.BotRightBG:SetSize(100, MainFrame:GetHeight() / 2)

    MainFrame.TopLeftBG :SetPoint("TOPLEFT", 0, 0)
    MainFrame.TopBG1    :SetPoint("LEFT", MainFrame.TopLeftBG, "RIGHT", 0, 0)
    MainFrame.TopBG2    :SetPoint("LEFT", MainFrame.TopBG1, "RIGHT", 0, 0)
    MainFrame.TopRightBG:SetPoint("LEFT", MainFrame.TopBG2, "RIGHT", 0, 0)

    MainFrame.BotLeftBG :SetPoint("TOP", MainFrame.TopLeftBG, "BOTTOM", 0, 0)
    MainFrame.BotBG1    :SetPoint("TOP", MainFrame.TopBG1, "BOTTOM", 0, 0)
    MainFrame.BotBG2    :SetPoint("TOP", MainFrame.TopBG2, "BOTTOM", 0, 0)
    MainFrame.BotRightBG:SetPoint("TOP", MainFrame.TopRightBG, "BOTTOM", 0, 0)

    MainFrame.TopLeftBG :SetBackdrop({bgFile = "Interface/HELPFRAME/HelpFrame-TOPLEFT"})
    MainFrame.TopBG1    :SetBackdrop({bgFile = "Interface/HELPFRAME/HelpFrame-TOP"})
    MainFrame.TopBG2    :SetBackdrop({bgFile = "Interface/HELPFRAME/HelpFrame-TOP"})
    MainFrame.TopRightBG:SetBackdrop({bgFile = "Interface/HELPFRAME/HelpFrame-TOPRIGHT"})
    MainFrame.BotLeftBG :SetBackdrop({bgFile = "Interface/HELPFRAME/HelpFrame-BOTLEFT"})
    MainFrame.BotBG1    :SetBackdrop({bgFile = "Interface/HELPFRAME/HelpFrame-BOTTOM"})
    MainFrame.BotBG2    :SetBackdrop({bgFile = "Interface/HELPFRAME/HelpFrame-BOTTOM"})
    MainFrame.BotRightBG:SetBackdrop({bgFile = "Interface/HELPFRAME/HelpFrame-BOTRIGHT"})

    MainFrame.Title = CreateFrame("FRAME", nil, MainFrame)
    MainFrame.Title:SetSize(300, 65)
    MainFrame.Title:SetPoint("TOP", MainFrame, "TOP", 0, MainFrame.Title:GetHeight() * 0.35 - 4)
    MainFrame.Title:SetFrameStrata("HIGH")

    MainFrame.Title.Text = MainFrame.Title:CreateFontString("MainFrame", "ARTWORK", "GameFontNormalLarge")
    MainFrame.Title.Text:SetPoint("TOP", 0, -MainFrame.Title:GetHeight() * 0.25 + 3)
    MainFrame.Title.Text:SetText(AddOnName .. " - v" .. SoftCouncil.Version)

    MainFrame.Title.Texture = MainFrame.Title:CreateTexture(nil, "BACKGROUND")
    MainFrame.Title.Texture:SetAllPoints()
    MainFrame.Title.Texture:SetTexture("Interface/DialogFrame/UI-DialogBox-Header")

    --RaidsFrame = CreateFrame("ScrollFrame", nil, MainFrame, "UIPanelScrollFrameTemplate BackdropTemplate")
    RaidsFrame = CreateFrame("ScrollFrame", nil, MainFrame, "UIPanelScrollFrameTemplate")
    RaidsFrame:SetSize(MainFrame:GetWidth() / 5, MainFrame:GetHeight() - 80)
    RaidsFrame:SetPoint("TOPLEFT", 15, -42)
    RaidsFrame:SetFrameStrata("HIGH")
    -- RaidsFrame:SetBackdrop({
    --     bgFile = "Interface/BankFrame/Bank-Background",
    --     tile = true,
    --     tileSize = 100;
    -- })
    -- RaidsFrame:SetBackdropColor(1, 0.25, 0.25, 1)

    RaidsScrollPanel = CreateFrame("FRAME")
    RaidsScrollPanel:SetSize(RaidsFrame:GetWidth(), 300)
    RaidsScrollPanel:SetPoint("TOP")

    --EncountersFrame = CreateFrame("ScrollFrame", nil, MainFrame, "UIPanelScrollFrameTemplate BackdropTemplate")
    EncountersFrame = CreateFrame("ScrollFrame", nil, MainFrame, "UIPanelScrollFrameTemplate")
    EncountersFrame:SetSize(MainFrame:GetWidth() / 5, MainFrame:GetHeight() - 80)
    EncountersFrame:SetPoint("TOPLEFT", RaidsFrame, "TOPRIGHT", 25, 0)
    EncountersFrame:SetFrameStrata("HIGH")
    -- EncountersFrame:SetBackdrop({
    --     bgFile = "Interface/BankFrame/Bank-Background",
    --     tile = true,
    --     tileSize = 100;
    -- })
    -- EncountersFrame:SetBackdropColor(0.25, 1, 0.25, 1)

    EncountersScrollPanel = CreateFrame("FRAME")
    EncountersScrollPanel:SetSize(EncountersFrame:GetWidth(), 300)
    EncountersScrollPanel:SetPoint("TOP")

    --PlayersFrame = CreateFrame("ScrollFrame", nil, MainFrame, "UIPanelScrollFrameTemplate BackdropTemplate")
    PlayersFrame = CreateFrame("ScrollFrame", nil, MainFrame, "UIPanelScrollFrameTemplate")
    PlayersFrame:SetSize(MainFrame:GetWidth() * 0.45, MainFrame:GetHeight() - 80)
    PlayersFrame:SetPoint("TOPLEFT", EncountersFrame, "TOPRIGHT", 25, 0)
    PlayersFrame:SetFrameStrata("HIGH")
    -- PlayersFrame:SetBackdrop({
    --     bgFile = "Interface/BankFrame/Bank-Background",
    --     tile = true,
    --     tileSize = 100;
    -- })
    -- PlayersFrame:SetBackdropColor(0.25, 0.25, 1, 1)

    PlayersScrollPanel = CreateFrame("FRAME")
    PlayersScrollPanel:SetSize(PlayersFrame:GetWidth(), 300)
    PlayersScrollPanel:SetPoint("TOP")

    RaidsFrame:SetScrollChild(RaidsScrollPanel)
    EncountersFrame:SetScrollChild(EncountersScrollPanel)
    PlayersFrame:SetScrollChild(PlayersScrollPanel)

    MainFrame.ExtraBG = CreateFrame("FRAME", nil, MainFrame, "BackdropTemplate")
    MainFrame.ExtraBG:SetSize(MainFrame:GetWidth() - 25, MainFrame:GetHeight() - 79)
    MainFrame.ExtraBG:SetPoint("TOP", 2, -41)
    MainFrame.ExtraBG:SetFrameStrata("HIGH")
    MainFrame.ExtraBG:SetBackdrop({
        bgFile = "Interface/BankFrame/Bank-Background",
        tile = true,
        tileSize = 100;
    })
    MainFrame.ExtraBG:SetBackdropColor(0.25, 0.25, 0.25, 1)

    MainFrame.CloseButton = CreateFrame("Button", nil, MainFrame, "UIPanelCloseButton, BackDropTemplate")
    MainFrame.CloseButton:SetSize(24, 24)
    MainFrame.CloseButton:SetPoint("TOPRIGHT", MainFrame, "TOPRIGHT", -3, -3)
    MainFrame.CloseButton:SetScript("OnClick", function() MainFrame:Hide() end)
end

function SoftCouncil:FillScrollPanel()
    SoftCouncil:HideAllFrames()
    local allRaidFrames = {}
    local allEncounterFrames = {}
    local allPlayerFrames = {}

    local lastFrame = nil

    local Data = SoftCouncilDataTable
    local allDates = Data["Dates"]
    for curDate = 1, #allDates do
        local curDateListItem = allDateItems[curDate]
        if curDateListItem == nil then
            curDateListItem = SoftCouncil:CreateDateListItem()
            allDateItems[curDate] = curDateListItem
        end
        local year, month, date = string.sub(allDates[curDate], 1, 4), string.sub(allDates[curDate], 5, 6), string.sub(allDates[curDate], 7, 8)
        curDateListItem.Label:SetText(string.format("%s/%s/%s", date, month, year))
        curDateListItem.Key = allDates[curDate]
        table.insert(allRaidFrames, curDateListItem)
    end

    lastFrame = RaidsScrollPanel
    for i, frame in ipairs(allRaidFrames) do
        if lastFrame == RaidsScrollPanel then
            frame:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0)
        else
            frame:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
        end
        frame:Show()
        lastFrame = frame
    end

    if SelectedRaid ~= nil then
        local DateData = Data[SelectedRaid]
        local allEncounters = DateData.Encounters
        for curEncounter = 1, #allEncounters do
            local EncounterData = DateData[allEncounters[curEncounter]]
            local allPulls = EncounterData.Pulls
            for curPull = 1, #allPulls do
                local curEncounterKey = string.format("%s:%d\nPull %d", SelectedRaid, allEncounters[curEncounter], curPull)
                local curEncounterListItem = allEncounterItems[curEncounterKey]
                if curEncounterListItem == nil then
                    curEncounterListItem = SoftCouncil:CreateEncounterListItem()
                    allEncounterItems[curEncounterKey] = curEncounterListItem
                end
                local EncounterInfo = SoftCouncil.InfoTable.Encounters[allEncounters[curEncounter]]
                curEncounterListItem.Label:SetText(string.format("%s\nPull %d", EncounterInfo.EncounterName, curPull))
                curEncounterListItem.Key = {allEncounters[curEncounter], curPull}
                table.insert(allEncounterFrames, curEncounterListItem)
            end
        end
    end

    lastFrame = EncountersScrollPanel
    for i, frame in ipairs(allEncounterFrames) do
        if lastFrame == EncountersScrollPanel then
            frame:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0)
        else
            frame:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
        end
        frame:Show()
        lastFrame = frame
    end

    if SelectedEncounter ~= nil then
        local curEncounter, curPull = SelectedEncounter[1], SelectedEncounter[2]
        local EncounterData = Data[SelectedRaid][curEncounter][curPull]
        local allPlayers = EncounterData.Players
        for curPlayer = 1, #allPlayers do
            local curPlayerKey = string.format("%s:%s:%s", SelectedEncounter[1], SelectedEncounter[2], allPlayers[curPlayer])
            local curPlayerListItem = allPlayerItems[curPlayerKey]
            if curPlayerListItem == nil then
                curPlayerListItem = SoftCouncil:CreatePlayerListItem()
                allPlayerItems[curPlayerKey] = curPlayerListItem
            end
            local PlayerInfo = EncounterData[allPlayers[curPlayer]]
            curPlayerListItem.Label:SetText(PlayerInfo.Name)
            curPlayerListItem.Key = curPlayerKey
            table.insert(allPlayerFrames, curPlayerListItem)
            curPlayerListItem:SetHeight(75)
            SoftCouncil:AddDataToPlayerFrame(curPlayerListItem, PlayerInfo)
        end
    end

    lastFrame = PlayersScrollPanel
    for i, frame in ipairs(allPlayerFrames) do
        if lastFrame == PlayersScrollPanel then
            frame:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0)
        else
            frame:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
        end
        frame:Show()
        lastFrame = frame
    end
end

function SoftCouncil:HideDataFrames(curPlayerListItem)
    curPlayerListItem:SetHeight(20)
    for _, curBuffFrame in ipairs(curPlayerListItem.Buffs) do
        curBuffFrame:Hide()
    end
    for _, curConsumableFrame in ipairs(curPlayerListItem.Consumables) do
        curConsumableFrame:Hide()
    end
    if curPlayerListItem.BuffLabel ~= nil then curPlayerListItem.BuffLabel:Hide() end
    if curPlayerListItem.ConsumableLabel ~= nil then curPlayerListItem.ConsumableLabel:Hide() end
end

function SoftCouncil:HideAllFrames()
    for _, frame in ipairs(allDateItems) do
        frame:Hide()
    end
    for _, frame in pairs(allEncounterItems) do
        if frame ~= allEncounterItems.Expanded then
            frame:Hide()
        end
    end
    for _, frame in pairs(allPullItems) do
        if frame ~= allPullItems.Expanded then
            frame:Hide()
        end
    end
    for _, frame in pairs(allPlayerItems) do
        if frame ~= allPlayerItems.Expanded then
            frame:Hide()
        end
    end
    for _, frame in pairs(allDataItems) do
        if frame ~= allDataItems.Expanded then
            frame:Hide()
        end
    end
end

function SoftCouncil:CreateStandardListItem(ParentScrollFrame)
    local curFrame = CreateFrame("Frame", nil, ParentScrollFrame, "BackDropTemplate")
    curFrame:SetSize(dataFrameWidth - 5, 35)
    curFrame:SetPoint("TOPRIGHT", 0, 0)
    curFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 8,
        insets = {left = 2, right = 2, top = 2, bottom = 2},
    })
    curFrame:SetBackdropColor(0.25, 0.25, 0.25, 1)

    curFrame.Label = curFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    curFrame.Label:SetSize(curFrame:GetWidth(), curFrame:GetHeight())
    curFrame.Label:SetPoint("LEFT", 5, 0)
    curFrame.Label:SetJustifyH("LEFT")
    curFrame.Label:SetTextColor(1, 1, 1, 1)

    return curFrame
end

function SoftCouncil:CreateDateListItem()
    local curFrame = SoftCouncil:CreateStandardListItem(RaidsScrollPanel)
    curFrame:SetScript("OnMouseDown", function() SelectedRaid = curFrame.Key SoftCouncil:FillScrollPanel() end)
    curFrame.Type = "Date"

    return curFrame
end

function SoftCouncil:CreateEncounterListItem()
    local curFrame = SoftCouncil:CreateStandardListItem(EncountersScrollPanel)
    curFrame:SetScript("OnMouseDown", function() SelectedEncounter = curFrame.Key SoftCouncil:FillScrollPanel() end)
    curFrame.Type = "Encounter"

    local curFont, curSize, curFlags = curFrame.Label:GetFont()
    curFrame.Label:SetFont(curFont, curSize - 2, curFlags)

    return curFrame
end

function SoftCouncil:CreatePlayerListItem()
    local curFrame = SoftCouncil:CreateStandardListItem(PlayersScrollPanel)
    curFrame:SetScript("OnMouseDown", function() allPlayerItems.Expanded[curFrame.Key] = not allPlayerItems.Expanded[curFrame.Key] SoftCouncil:FillScrollPanel() end)
    curFrame.Type = "Player"

    curFrame:SetSize(MainFrame:GetWidth() * 0.45 , 50)
    curFrame.Label:SetSize(curFrame:GetWidth() - 5, 25)
    curFrame.Label:SetPoint("TOPLEFT", 5, 0)

    curFrame.Buffs = {}
    curFrame.Consumables = {}

    curFrame.BuffLabel = nil
    curFrame.ConsumableLabel = nil

    return curFrame
end

function SoftCouncil:AddDataToPlayerFrame(curFrame, playerInfo)
    if curFrame.BuffLabel == nil then
        curFrame.BuffLabel = curFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        curFrame.BuffLabel:SetSize(75, 25)
        curFrame.BuffLabel:SetPoint("TOPLEFT", 40, 0)
        curFrame.BuffLabel:SetTextColor(1, 1, 1, 1)
        curFrame.BuffLabel:SetJustifyH("RIGHT")
        curFrame.BuffLabel:SetText("Buffs:")
    end
    curFrame.BuffLabel:Show()

    if curFrame.ConsumableLabel == nil then
        curFrame.ConsumableLabel = curFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        curFrame.ConsumableLabel:SetSize(75, 25)
        curFrame.ConsumableLabel:SetPoint("TOP", curFrame.BuffLabel, "BOTTOM", 0, -25)
        curFrame.ConsumableLabel:SetTextColor(1, 1, 1, 1)
        curFrame.ConsumableLabel:SetJustifyH("RIGHT")
        curFrame.ConsumableLabel:SetText("Consumables:")
    end
    curFrame.ConsumableLabel:Show()

    local curFont, curSize, curFlags = curFrame.BuffLabel:GetFont()
    curFrame.BuffLabel      :SetFont(curFont, 10, curFlags)
    curFrame.ConsumableLabel:SetFont(curFont, 10, curFlags)

    for i = 1, #playerInfo.Buffs do
        local curBuffFrame = curFrame.Buffs[i]
        if curBuffFrame == nil then
            curBuffFrame = SoftCouncil:CreateDataListItem(curFrame)
            curBuffFrame.Texture = curBuffFrame:CreateTexture(nil, "BACKGROUND")
            curBuffFrame.Texture:SetAllPoints()
            curFrame.Buffs[i] = curBuffFrame
        end
        curBuffFrame.Texture:SetColorTexture(1, 1, 1, 1)
        local curBuff = playerInfo.Buffs[i]
        local _, _, curBuffIcon = GetSpellInfo(curBuff)
        curBuffFrame.Texture:SetTexture(curBuffIcon)
        if i <= 10 then
            curBuffFrame:SetPoint("TOPLEFT", 18 * i + 100, -3)
        elseif i >= 11 then
            curBuffFrame:SetPoint("TOPLEFT", 18 * (i - 10)  + 100, -21)
        end
        curBuffFrame:Show()
    end

    for i = 1, #playerInfo.Consumables do
        local curConsumableFrame = curFrame.Consumables[i]
        if curConsumableFrame == nil then
            curConsumableFrame = SoftCouncil:CreateDataListItem(curFrame)
            curConsumableFrame.Texture = curConsumableFrame:CreateTexture(nil, "BACKGROUND")
            curConsumableFrame.Texture:SetAllPoints()
            curFrame.Consumables[i] = curConsumableFrame
        end
        curConsumableFrame.Texture:SetColorTexture(1, 1, 1, 1)
        local curConsumable = playerInfo.Consumables[i]
        local curConsumableInfo = SoftCouncil.InfoTable.Consumables[curConsumable]
        if curConsumableInfo ~= nil then
            local curConsumableItemID = curConsumableInfo[2][1]
            local _, _, _, _, _, _, _, _, _, curConsumableIcon = GetItemInfo(curConsumableItemID)
            curConsumableFrame.Texture:SetTexture(curConsumableIcon)
            if i <= 10 then
                curConsumableFrame:SetPoint("TOPLEFT", curFrame.Class, "TOPRIGHT", 25 * i + 75, -53)
            end
            curConsumableFrame:Show()
        end
    end
end

function SoftCouncil:CreateDataListItem(curFrame)
    local curDataFrame = CreateFrame("Frame", nil, curFrame, "BackDropTemplate")
    curDataFrame:SetSize(16, 16)
    curDataFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 8,
        insets = {left = 2, right = 2, top = 2, bottom = 2},
    })
    curDataFrame:SetBackdropColor(0.25, 0.25, 0.25, 1)

    return curDataFrame
end

function SoftCouncil:RegisterEvents(event, func)
    local handlers = SoftCouncil.RegisteredEvents[event]
    if handlers == nil then
        handlers = {}
        SoftCouncil.RegisteredEvents[event] = handlers
        EventFrame:RegisterEvent(event)
    end
    handlers[#handlers + 1] = func
end

function SoftCouncil:GetDateTime()
    local DateTimeString = SoftCouncil:GetDateTimeWithOffset(-2)
    local year, month, date, day, time = nil, nil, nil, nil, nil
    if string.find(DateTimeString, "  ") then
        day, month, _, date, time, year = strsplit(" ", DateTimeString)
    else
        day, month, date, time, year = strsplit(" ", DateTimeString)
    end
    day = SoftCouncil:GetFullDayName(day)
    month = SoftCouncil:GetNumericMonth(month)
    date = SoftCouncil:GetNumericDay(date)
    year = tonumber(year)
    return year, month, date
end

function SoftCouncil:GetDateTimeWithOffset(offset)
    local nowTimeString = time()
    local DateTimeWithOffsetString = nowTimeString + (60 * 60 * offset)
    return date("%c", DateTimeWithOffsetString);
end

function SoftCouncil:GetFullDayName(day)
    local dayF
    if day == "Mon" or day == "mon" then dayF =    "Monday" end
    if day == "Tue" or day == "tue" then dayF =   "Tuesday" end
    if day == "Wed" or day == "wed" then dayF = "Wednesday" end
    if day == "Thu" or day == "thu" then dayF =  "Thursday" end
    if day == "Fri" or day == "fri" then dayF =    "Friday" end
    if day == "Sat" or day == "sat" then dayF =  "Saturday" end
    if day == "Sun" or day == "sun" then dayF =    "Sunday" end
    return dayF
end

function SoftCouncil:GetNumericMonth(month)
    local monthN
    if month == "Jan" or month == "jan" then monthN = "01" end
    if month == "Feb" or month == "feb" then monthN = "02" end
    if month == "Mar" or month == "mar" then monthN = "03" end
    if month == "Apr" or month == "apr" then monthN = "04" end
    if month == "May" or month == "may" then monthN = "05" end
    if month == "Jun" or month == "jun" then monthN = "06" end
    if month == "Jul" or month == "jul" then monthN = "07" end
    if month == "Aug" or month == "aug" then monthN = "08" end
    if month == "Sep" or month == "sep" then monthN = "09" end
    if month == "Oct" or month == "oct" then monthN = "10" end
    if month == "Nov" or month == "nov" then monthN = "11" end
    if month == "Dec" or month == "dec" then monthN = "12" end
    return monthN
end

function SoftCouncil:GetNumericDay(day)
    if tonumber(day) < 10 then day = "0" .. tostring(day) end
    return day
end

function SoftCouncil:SaveEncounterPull(encounterID)
    local year, month, date = SoftCouncil:GetDateTime()
    local dateString = year .. month .. date
    local DataTable = SoftCouncil.DataTable

    local Dates = DataTable.Dates

    if DataTable[dateString] == nil then DataTable[dateString] = {} end
    local curDate = DataTable[dateString]
    local datePresent = false
    for i = 1, #Dates do
        if Dates[i] == dateString then datePresent = true end
    end
    if datePresent == false then
        Dates[#Dates + 1] = dateString
    end

    if curDate.Encounters == nil then curDate.Encounters = {} end
    local Encounters = curDate.Encounters
    if curDate[encounterID] == nil then curDate[encounterID] = {} end
    local curEncounter = curDate[encounterID]
    local curEnouncterTable = SoftCouncil.InfoTable.Encounters[encounterID]
    curEncounter.Name = curEnouncterTable.EncounterName
    curEncounter.RaidID = curEnouncterTable.RaidID
    curEncounter.RaidName = curEnouncterTable.RaidName
    local encounterPresent = false
    for i = 1, #Dates do
        if Encounters[i] == encounterID then encounterPresent = true end
    end
    if encounterPresent == false then
        Encounters[#Encounters + 1] = encounterID
    end
    curDate.Encounters = Encounters

    if curEncounter.Pulls == nil then curEncounter.Pulls = {} curEncounter[1] = {} end
    local Pulls = curEncounter.Pulls
    local curPullNumber = #Pulls + 1
    if curEncounter[curPullNumber] == nil then curEncounter[curPullNumber] = {} end
    local curPull = curEncounter[curPullNumber]
    Pulls[#Pulls + 1] = curPullNumber

    curPull.Players = {}
    local RaiderList = SoftCouncil:SaveRaiders()

    for i = 1, #RaiderList do
        curPull.Players[i] = RaiderList[i][1]
    end

    for i = 1, 40 do
        local curGUID = UnitGUID("Raid" .. i, j)
        local curGUIDInPlayerList = false
        for indexPlayers = 1, #SoftCouncil.DataTable.Players do
            if SoftCouncil.DataTable.Players[indexPlayers] == curGUID then curGUIDInPlayerList = true end
        end
        if curGUIDInPlayerList == false then SoftCouncil.DataTable.Players[#SoftCouncil.DataTable.Players + 1] = curGUID end
        if curGUID ~= nil then
            curPull[curGUID] = {}
            local Buffs = {}
            for j = 1, 40 do
                local _, _, _, _, _, _, _, _, _, buffID = UnitAura("Raid" .. i, j)
                Buffs[j] = buffID
            end
            curPull[curGUID].Index = i
            curPull[curGUID].Buffs = Buffs
            curPull[curGUID].Consumables = {}
            curPull[curGUID].Name = RaiderList[i][2]
            curPull[curGUID].Class = RaiderList[i][3]
            curPull[curGUID].Online = RaiderList[i][4]
            curPull[curGUID].SubGroup = RaiderList[i][5]
        end
    end
    SoftCouncilDataTable = SoftCouncil.DataTable
end

function SoftCouncil:SaveRaiders()
    local RaidersList = {}
    for i = 1, 40 do
        if UnitGUID("Raid" .. i) ~= nil then
            RaidersList[i] = {}
            RaidersList[i][1] = UnitGUID("Raid" .. i)
            RaidersList[i][2] = UnitName("Raid" .. i)
            RaidersList[i][3] = UnitClass("Raid" .. i)
            RaidersList[i][4] = UnitIsConnected("Raid" .. i)
            RaidersList[i][5] = SoftCouncil:CalculateSubGroup(i)
        end
    end
    return RaidersList
end

function SoftCouncil:CalculateSubGroup(index)
    return math.ceil(index / 5)
end

function SoftCouncil:OnEvent(_, event, ...)
    for _, handler in pairs(SoftCouncil.RegisteredEvents[event]) do
        handler(...)
    end
end

function SoftCouncil.Events:EncounterStart(encounterID)
    if SoftCouncil.InfoTable.Encounters[encounterID] ~= nil then
        activeEncounter = encounterID
        SoftCouncil:SaveEncounterPull(encounterID)
    end
end

function SoftCouncil.Events:EncounterEnd()
    activeEncounter = false
end

function SoftCouncil.Events:CombatLogUnfiltered()
    if activeEncounter ~= nil then
        local year, month, date = SoftCouncil:GetDateTime()
        local dateString = year .. month .. date
        local v1, combatEvent, v3, UnitGUID, casterName, v6, v7, destGUID, destName, v10, v11, spellID, v13, v14, v15 = CombatLogGetCurrentEventInfo()
        if SoftCouncil.InfoTable.Consumables[spellID] ~= nil and combatEvent == "SPELL_CAST_SUCCESS" then
            for indexPlayers = 1, #SoftCouncilDataTable.Players do
                if SoftCouncilDataTable.Players[indexPlayers] == UnitGUID then
                    local pullNumber = #SoftCouncilDataTable[dateString][activeEncounter].Pulls
                    local curPlayer = SoftCouncilDataTable[dateString][activeEncounter][pullNumber][UnitGUID]
                    if curPlayer.Consumables == nil then curPlayer.Consumables = {} end
                    curPlayer.Consumables[#curPlayer.Consumables + 1] = spellID
                end
            end
        end
    end
end

function SoftCouncil.Events:AddonLoaded(...)
    if ... == "SoftCouncil" then
        SoftCouncil.DataTable = SoftCouncilDataTable
    end
end

function SoftCouncil.Events:VariablesLoaded(...)
    for _, data in pairs(SoftCouncil.InfoTable.Consumables) do
        GetItemInfo(data[2][1])
    end
    SoftCouncil:FillScrollPanel()
end

SoftCouncil:OnLoad()

SoftCouncil.SlashCommands["show"] = function(value)
    MainFrame:Show()
end
