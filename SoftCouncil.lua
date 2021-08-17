if SoftCouncil == nil then SoftCouncil = {} end
SoftCouncil.events = {}
SoftCouncil.Version = 5
local AddOnName = "SoftCouncil"

local UpdateFrame, EventFrame = nil, nil
local MainFrame, ScrollPanel = nil, nil

local activeEncounter = false

local dataFrameWidth = 625

local allDateItems, allEncounterItems, allPullItems, allPlayerItems = {Expanded = {},}, {Expanded = {},}, {Expanded = {},}, {Expanded = {},}
local allDataItems = {}

if SoftCouncilDataTable == nil then SoftCouncilDataTable = {} end

function SoftCouncil:OnLoad()
    EventFrame = CreateFrame("Frame", nil, UIParent)
    SoftCouncil:RegisterEvents("ENCOUNTER_START", function(...) print("OnLoadRegister EncounterStart") SoftCouncil.events:EncounterStart(...) end)
    SoftCouncil:RegisterEvents("ENCOUNTER_END", function(...) SoftCouncil.events:EncounterEnd(...) end)
    SoftCouncil:RegisterEvents("COMBAT_LOG_EVENT_UNFILTERED", function(...) SoftCouncil.events:CombatLogUnfiltered(...) end)
    SoftCouncil:RegisterEvents("ADDON_LOADED", function(...) SoftCouncil.events:AddonLoaded(...) end)
    SoftCouncil:RegisterEvents("VARIABLES_LOADED", function(...) SoftCouncil.events:VariablesLoaded(...) end)
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

    local scrollFrame = CreateFrame("ScrollFrame", nil, MainFrame, "UIPanelScrollFrameTemplate BackdropTemplate");
    scrollFrame:SetSize(MainFrame:GetWidth() - 45, MainFrame:GetHeight() - 77)
    scrollFrame:SetPoint("TOP", -11, -40)
    scrollFrame:SetFrameStrata("HIGH")

    ScrollPanel = CreateFrame("Frame")
    ScrollPanel:SetSize(scrollFrame:GetWidth(), 300)
    ScrollPanel:SetPoint("TOP")

    MainFrame.Header = CreateFrame("Frame", nil, MainFrame, "BackdropTemplate")
    MainFrame.Header:SetPoint("TOP", -11, -20)
    MainFrame.Header:SetSize(ScrollPanel:GetWidth(), 50)

    MainFrame.Header.Selector = CreateFrame("Frame", nil, MainFrame.Header, "BackdropTemplate")
    MainFrame.Header.Selector:SetSize(80, 24)
    MainFrame.Header.Selector:SetPoint("TOPLEFT", 5, 0)
    MainFrame.Header.Selector:SetBackdrop({
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 10,
        insets = {left = 2, right = 2, top = 2, bottom = 2},
    })
    MainFrame.Header.Selector:SetBackdropColor(1, 1, 1, 1)

    MainFrame.Header.Selector.Text = MainFrame.Header.Selector:CreateFontString("MainFrame.Header.Selector.Text", "ARTWORK", "GameFontNormal")
    MainFrame.Header.Selector.Text:SetSize(MainFrame.Header.Selector:GetWidth(), MainFrame.Header.Selector:GetHeight())
    MainFrame.Header.Selector.Text:SetPoint("CENTER", 0, 0)
    MainFrame.Header.Selector.Text:SetTextColor(1, 1, 1, 1)
    MainFrame.Header.Selector.Text:SetText("Selectors")

    MainFrame.Header.Name = CreateFrame("Frame", nil, MainFrame.Header, "BackdropTemplate")
    MainFrame.Header.Name:SetSize(100, 24)
    MainFrame.Header.Name:SetPoint("LEFT", MainFrame.Header.Selector, "RIGHT", -4, 0)
    MainFrame.Header.Name:SetBackdrop({
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 10,
        insets = {left = 2, right = 2, top = 2, bottom = 2},
    })
    MainFrame.Header.Name:SetBackdropColor(1, 1, 1, 1)

    MainFrame.Header.Name.Text = MainFrame.Header.Name:CreateFontString("MainFrame.Header.Name.Text", "ARTWORK", "GameFontNormal")
    MainFrame.Header.Name.Text:SetSize(MainFrame.Header.Name:GetWidth(), MainFrame.Header.Name:GetHeight())
    MainFrame.Header.Name.Text:SetPoint("CENTER", 0, 0)
    MainFrame.Header.Name.Text:SetTextColor(1, 1, 1, 1)
    MainFrame.Header.Name.Text:SetText("Name")

    MainFrame.Header.Class = CreateFrame("Frame", nil, MainFrame.Header, "BackdropTemplate")
    MainFrame.Header.Class:SetSize(75, 24)
    MainFrame.Header.Class:SetPoint("LEFT", MainFrame.Header.Name, "RIGHT", -4, 0)
    MainFrame.Header.Class:SetBackdrop({
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 10,
        insets = {left = 2, right = 2, top = 2, bottom = 2},
    })
    MainFrame.Header.Class:SetBackdropColor(1, 1, 1, 1)

    MainFrame.Header.Class.Text = MainFrame.Header.Class:CreateFontString("MainFrame.Header.Class.Text", "ARTWORK", "GameFontNormal")
    MainFrame.Header.Class.Text:SetSize(MainFrame.Header.Class:GetWidth(), MainFrame.Header.Class:GetHeight())
    MainFrame.Header.Class.Text:SetPoint("CENTER", 0, 0)
    MainFrame.Header.Class.Text:SetTextColor(1, 1, 1, 1)
    MainFrame.Header.Class.Text:SetText("Class")

    MainFrame.Header.Data = CreateFrame("Frame", nil, MainFrame.Header, "BackdropTemplate")
    MainFrame.Header.Data:SetSize(360, 24)
    MainFrame.Header.Data:SetPoint("BOTTOMLEFT", MainFrame.Header.Name, "BOTTOMRIGHT", -4, 0)
    MainFrame.Header.Data:SetBackdrop({
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 10,
        insets = {left = 2, right = 2, top = 2, bottom = 2},
    })
    MainFrame.Header.Data:SetBackdropColor(1, 1, 1, 1)

    MainFrame.Header.Data.Text = MainFrame.Header.Data:CreateFontString("MainFrame.Header.Data.Text", "ARTWORK", "GameFontNormal")
    MainFrame.Header.Data.Text:SetSize(MainFrame.Header.Data:GetWidth(), MainFrame.Header.Data:GetHeight())
    MainFrame.Header.Data.Text:SetPoint("CENTER", 0, 0)
    MainFrame.Header.Data.Text:SetTextColor(1, 1, 1, 1)
    MainFrame.Header.Data.Text:SetText("Data")

    local curFont, curSize, curFlags = MainFrame.Header.Name.Text:GetFont()
    MainFrame.Header.Name.Text:SetFont(curFont, curSize - 2, curFlags)
    MainFrame.Header.Class.Text:SetFont(curFont, curSize - 2, curFlags)
    MainFrame.Header.Data.Text:SetFont(curFont, curSize - 2, curFlags)

    MainFrame.CloseButton = CreateFrame("Button", nil, MainFrame, "UIPanelCloseButton, BackDropTemplate")
    MainFrame.CloseButton:SetSize(24, 24)
    MainFrame.CloseButton:SetPoint("TOPRIGHT", MainFrame, "TOPRIGHT", -3, -3)
    MainFrame.CloseButton:SetScript("OnClick", function() MainFrame:Hide() end)

    scrollFrame:SetScrollChild(ScrollPanel)
end

function SoftCouncil:FillScrollPanel()
    SoftCouncil:HideAllFrames()
    local allTempFrames = {}
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
        table.insert(allTempFrames, curDateListItem)
        if allDateItems.Expanded[allDates[curDate]] == true then
            local DateData = Data[allDates[curDate]]
            local allEncounters = DateData.Encounters
            for curEncounter = 1, #allEncounters do
                local curEncounterKey = string.format("%s:%d", allDates[curDate], allEncounters[curEncounter])
                local curEncounterListItem = allEncounterItems[curEncounterKey]
                if curEncounterListItem == nil then
                    curEncounterListItem = SoftCouncil:CreateEncounterListItem()
                    allEncounterItems[curEncounterKey] = curEncounterListItem
                end
                local EncounterInfo = SoftCouncil.InfoTable.Encounters[allEncounters[curEncounter]]
                curEncounterListItem.Label:SetText(string.format("%s (%d)", EncounterInfo.EncounterName, allEncounters[curEncounter]))
                curEncounterListItem.Key = curEncounterKey
                table.insert(allTempFrames, curEncounterListItem)
                if allEncounterItems.Expanded[curEncounterKey] == true then
                    local EncounterData = DateData[allEncounters[curEncounter]]
                    local allPulls = EncounterData.Pulls
                    for curPull = 1, #allPulls do
                        local curPullKey = string.format("%s:%d", curEncounterKey, allPulls[curPull])
                        local curPullListItem = allPullItems[curPullKey]
                        if curPullListItem == nil then
                            curPullListItem = SoftCouncil:CreatePullListItem()
                            allPullItems[curPullKey] = curPullListItem
                        end
                        curPullListItem.Label:SetText(string.format("Pull #%s", curPull))
                        curPullListItem.Key = curPullKey
                        table.insert(allTempFrames, curPullListItem)
                        if allPullItems.Expanded[curPullKey] == true then
                            local PullData = EncounterData[allPulls[curPull]]
                            local allPlayers = PullData.Players
                            for curPlayer = 1, #allPlayers do
                                local curPlayerKey = string.format("%s:%s", curPullKey, allPlayers[curPlayer])
                                local curPlayerListItem = allPlayerItems[curPlayerKey]
                                if curPlayerListItem == nil then
                                    curPlayerListItem = SoftCouncil:CreatePlayerListItem()
                                    allPlayerItems[curPlayerKey] = curPlayerListItem
                                end
                                local PlayerInfo = PullData[PullData.Players[curPlayer]]
                                curPlayerListItem.Name:SetText(PlayerInfo.Name)
                                curPlayerListItem.Class:SetText(PlayerInfo.Class)
                                curPlayerListItem.Key = curPlayerKey
                                table.insert(allTempFrames, curPlayerListItem)
                                if allPlayerItems.Expanded[curPlayerKey] == true then
                                    curPlayerListItem:SetHeight(75)
                                    SoftCouncil:AddDataToPlayerFrame(curPlayerListItem, PlayerInfo)
                                else
                                    SoftCouncil:HideDataFrames(curPlayerListItem)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    local lastFrame = ScrollPanel
    for i, frame in ipairs(allTempFrames) do
        if lastFrame == ScrollPanel then
            frame:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", 0, 0)
        else
            frame:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
        end
            frame:Show()
            lastFrame = frame
    end
end

function SoftCouncil:HideDataFrames(curPlayerListItem)
    curPlayerListItem:SetHeight(25)
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

function SoftCouncil:CreateStandardListItem()
    local curFrame = CreateFrame("Frame", nil, ScrollPanel, "BackDropTemplate")
    curFrame:SetSize(dataFrameWidth - 5, 25)
    curFrame:SetPoint("TOPRIGHT", 0, 0)
    curFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 8,
        insets = {left = 2, right = 2, top = 2, bottom = 2},
    })
    curFrame:SetBackdropColor(0.25, 0.25, 0.25, 1)

    return curFrame
end

function SoftCouncil:CreateDateListItem()
    local curFrame = SoftCouncil:CreateStandardListItem()

    curFrame:SetScript("OnMouseDown", function() allDateItems.Expanded[curFrame.Key] = not allDateItems.Expanded[curFrame.Key] SoftCouncil:FillScrollPanel() end)

    curFrame.Type = "Date"

    curFrame.Label = curFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    curFrame.Label:SetSize(100, 25)
    curFrame.Label:SetPoint("LEFT", 5, 0)
    curFrame.Label:SetJustifyH("LEFT")
    curFrame.Label:SetTextColor(1, 1, 1, 1)

    return curFrame
end

function SoftCouncil:CreateEncounterListItem()
    local curFrame = SoftCouncil:CreateStandardListItem()

    curFrame:SetScript("OnMouseDown", function() allEncounterItems.Expanded[curFrame.Key] = not allEncounterItems.Expanded[curFrame.Key] SoftCouncil:FillScrollPanel() end)

    curFrame.Type = "Encounter"

    curFrame.Label = curFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    curFrame.Label:SetSize(200, 25)
    curFrame.Label:SetPoint("LEFT", 30, 0)
    curFrame.Label:SetJustifyH("LEFT")
    curFrame.Label:SetTextColor(1, 1, 1, 1)

    return curFrame
end

function SoftCouncil:CreatePullListItem()
    local curFrame = SoftCouncil:CreateStandardListItem()

    curFrame:SetScript("OnMouseDown", function() allPullItems.Expanded[curFrame.Key] = not allPullItems.Expanded[curFrame.Key] SoftCouncil:FillScrollPanel() end)

    curFrame.Type = "Pull"

    curFrame.Label = curFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    curFrame.Label:SetSize(100, 25)
    curFrame.Label:SetPoint("LEFT", 55, 0)
    curFrame.Label:SetJustifyH("LEFT")
    curFrame.Label:SetTextColor(1, 1, 1, 1)

    return curFrame
end

function SoftCouncil:CreatePlayerListItem()
    local curFrame = SoftCouncil:CreateStandardListItem()

    curFrame:SetScript("OnMouseDown", function() allPlayerItems.Expanded[curFrame.Key] = not allPlayerItems.Expanded[curFrame.Key] SoftCouncil:FillScrollPanel() end)

    curFrame.Type = "Player"

    curFrame.Name = curFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    curFrame.Name:SetSize(MainFrame.Header.Name:GetWidth(), 25)
    curFrame.Name:SetPoint("TOPLEFT", 76, 0)
    curFrame.Name:SetTextColor(1, 1, 1, 1)

    curFrame.Class = curFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    curFrame.Class:SetSize(MainFrame.Header.Class:GetWidth(), 25)
    curFrame.Class:SetPoint("TOPLEFT", curFrame.Name, "TOPRIGHT", -4, 0)
    curFrame.Class:SetTextColor(1, 1, 1, 1)

    curFrame.Buffs = {}
    curFrame.Consumables = {}

    curFrame.BuffLabel = nil
    curFrame.ConsumableLabel = nil

    return curFrame
end

function SoftCouncil:AddDataToPlayerFrame(curFrame, playerInfo)
    if curFrame.BuffLabel == nil then
        curFrame.BuffLabel = curFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        curFrame.BuffLabel:SetSize(100, 25)
        curFrame.BuffLabel:SetPoint("TOPLEFT", curFrame.Class, "TOPRIGHT", -4, 0)
        curFrame.BuffLabel:SetTextColor(1, 1, 1, 1)
        curFrame.BuffLabel:SetText("Buffs:")
    end
    curFrame.BuffLabel:Show()

    if curFrame.ConsumableLabel == nil then
        curFrame.ConsumableLabel = curFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        curFrame.ConsumableLabel:SetSize(100, 25)
        curFrame.ConsumableLabel:SetPoint("TOP", curFrame.BuffLabel, "BOTTOM", 0, -25)
        curFrame.ConsumableLabel:SetTextColor(1, 1, 1, 1)
        curFrame.ConsumableLabel:SetText("Consumables:")
    end
    curFrame.ConsumableLabel:Show()

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
            curBuffFrame:SetPoint("TOPLEFT", curFrame.Class, "TOPRIGHT", 25 * i + 75, -3)
        elseif i >= 11 then
            curBuffFrame:SetPoint("TOPLEFT", curFrame.Class, "TOPRIGHT", 25 * (i - 10)  + 75, -28)
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
        local curConsumableItemID = SoftCouncil.InfoTable.Consumables[curConsumable][2][1]
        local _, _, _, _, _, _, _, _, _, curConsumableIcon = GetItemInfo(curConsumableItemID)
        --local _, _, curConsumableIcon = GetSpellInfo(curConsumable)
        curConsumableFrame.Texture:SetTexture(curConsumableIcon)
        if i <= 10 then
            curConsumableFrame:SetPoint("TOPLEFT", curFrame.Class, "TOPRIGHT", 25 * i + 75, -53)
        end
        curConsumableFrame:Show()
    end
end

function SoftCouncil:CreateDataListItem(curFrame)
    local curDataFrame = CreateFrame("Frame", nil, curFrame, "BackDropTemplate")
    curDataFrame:SetSize(20, 20)
    curDataFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 8,
        insets = {left = 2, right = 2, top = 2, bottom = 2},
    })
    curDataFrame:SetBackdropColor(0.25, 0.25, 0.25, 1)

    return curDataFrame
end

function SoftCouncil:FillScrollPanelOld()
    local allTempFrames = {}
    local Data = SoftCouncilDataTable
    local allDates = Data["Dates"]
    for datesAmount = 1, #allDates do
        local DateData = Data[allDates[datesAmount]]
        local allEncounters = DateData.Encounters
        for encountersAmount = 1, #allEncounters do
            local EncounterData = DateData[allEncounters[encountersAmount]]
            local allPulls = EncounterData.Pulls
            for pullAmount = 1, #allPulls do
                local PullData = EncounterData[allPulls[pullAmount]]
                local allPlayers = PullData.Players
                for playerAmount = 1, #allPlayers do
                    local PlayerData = PullData[allPlayers[playerAmount]]
                    local allBuffs = PlayerData.Buffs
                    local allConsumables = PlayerData.Consumables
                    local testFrame = CreateFrame("Frame", nil, ScrollPanel, "BackDropTemplate")
                    testFrame:SetSize(MainFrame:GetWidth() - 50, 25)
                    testFrame:SetPoint("TOPLEFT", 10, -10)
                    testFrame:SetBackdrop({
                        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                        edgeSize = 8,
                        insets = {left = 2, right = 2, top = 2, bottom = 2},
                    })
                    testFrame:SetBackdropColor(0.25, 0.25, 0.25, 1)

                    testFrame.Date = testFrame:CreateFontString("testFrame", "ARTWORK", "GameFontNormal")
                    testFrame.Date:SetSize(MainFrame.Header.Date:GetWidth(), 25)
                    testFrame.Date:SetPoint("LEFT", 0, 0)
                    testFrame.Date:SetTextColor(1, 1, 1, 1)
                    local year, month, date = string.sub(allDates[datesAmount], 1, 4), string.sub(allDates[datesAmount], 5, 6), string.sub(allDates[datesAmount], 7, 8)
                    testFrame.Date:SetText(string.format("%s/%s\n%s", date, month, year))

                    testFrame.Encounter = testFrame:CreateFontString("testFrame", "ARTWORK", "GameFontNormal")
                    testFrame.Encounter:SetSize(MainFrame.Header.Encounter:GetWidth(), 25)
                    testFrame.Encounter:SetPoint("LEFT", testFrame.Date, "RIGHT", -4, 0)
                    testFrame.Encounter:SetTextColor(1, 1, 1, 1)
                    testFrame.Encounter:SetText(SoftCouncil.InfoTable.Encounters[allEncounters[encountersAmount]].EncounterName)

                    testFrame.Pull = testFrame:CreateFontString("testFrame", "ARTWORK", "GameFontNormal")
                    testFrame.Pull:SetSize(MainFrame.Header.Pull:GetWidth(), 25)
                    testFrame.Pull:SetPoint("LEFT", testFrame.Encounter, "RIGHT", -4, 0)
                    testFrame.Pull:SetTextColor(1, 1, 1, 1)
                    testFrame.Pull:SetText(allPulls[pullAmount])

                    testFrame.Name = testFrame:CreateFontString("testFrame", "ARTWORK", "GameFontNormal")
                    testFrame.Name:SetSize(MainFrame.Header.Name:GetWidth(), 25)
                    testFrame.Name:SetPoint("LEFT", testFrame.Pull, "RIGHT", -4, 0)
                    testFrame.Name:SetTextColor(1, 1, 1, 1)
                    testFrame.Name:SetText(string.format("%s\n%s", PullData[allPlayers[playerAmount]].Name, PullData[allPlayers[playerAmount]].Class))

                    testFrame.Data = testFrame:CreateFontString("testFrame", "ARTWORK", "GameFontNormal")
                    testFrame.Data:SetSize(MainFrame.Header.Data:GetWidth(), 25)
                    testFrame.Data:SetPoint("LEFT", testFrame.Name, "RIGHT", -4, 0)
                    testFrame.Data:SetTextColor(1, 1, 1, 1)

                    local allBuffsText, allConsumablesText = nil, nil

                    if allBuffs[1] ~= nil then
                        allBuffsText = allBuffs[1]
                        for buffAmount = 2, #allBuffs do
                            allBuffsText = allBuffsText .. " - " .. allBuffs[buffAmount]
                        end
                    end

                    if allConsumables[1] ~= nil then
                        allConsumablesText = allConsumables[1]
                        for ConsumablesAmount = 2, #allConsumables do
                            allConsumablesText = allConsumablesText .. " - " .. allConsumables[ConsumablesAmount]
                        end
                    end

                    testFrame.Data:SetText(allBuffsText, "\n", allConsumablesText)

                    local curFont, curSize, curFlags = MainFrame.Header.Date.Text:GetFont()
                    testFrame.Date     :SetFont(curFont, curSize, curFlags)
                    testFrame.Encounter:SetFont(curFont, curSize, curFlags)
                    testFrame.Pull     :SetFont(curFont, curSize, curFlags)
                    testFrame.Name     :SetFont(curFont, curSize, curFlags)
                    testFrame.Data     :SetFont(curFont, curSize, curFlags)

                    allTempFrames[#allTempFrames + 1] = testFrame
                end
            end
        end
    end
    for i, frame in ipairs(allTempFrames) do
        frame:SetPoint("TOPLEFT", ScrollPanel, "TOPLEFT", 5, -24 * i + 25)
    end
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
    local DateTimeString = date()
    local year, month, date, day, time = nil, nil, nil, nil, nil
    if string.find(DateTimeString, "  ") then
        day, month, _, date, time, year = strsplit(" ", DateTimeString)
    else
        day, month, date, time, year = strsplit(" ", DateTimeString)
    end
    day = SoftCouncil:GetFullDayName(day)
    month = SoftCouncil:GetNumericMonth(month)
    date = tonumber(date)
    year = tonumber(year)
    return year, month, date
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

function SoftCouncil:AddConsumableToPull(curGUID, consID)

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

function SoftCouncil.events:EncounterStart(encounterID)
    activeEncounter = encounterID
    SoftCouncil:SaveEncounterPull(encounterID)
end

function SoftCouncil.events:EncounterEnd()
    activeEncounter = false
end

function SoftCouncil.events:CombatLogUnfiltered()
    if activeEncounter ~= nil then
        local year, month, date = SoftCouncil:GetDateTime()
        local dateString = year .. month .. date
        local v1, combatEvent, v3, UnitGUID, casterName, v6, v7, destGUID, destName, v10, v11, spellID, v13, v14, v15 = CombatLogGetCurrentEventInfo()
        if SoftCouncil.InfoTable.Consumables[spellID] ~= nil then
            for indexPlayers = 1, #SoftCouncilDataTable.Players do
                if SoftCouncilDataTable.Players[indexPlayers] == UnitGUID then
                    local pullNumber = #SoftCouncilDataTable[dateString][activeEncounter].Pulls
                    local curPlayer = SoftCouncilDataTable[dateString][activeEncounter][pullNumber][UnitGUID]
                    if curPlayer.Consumables == nil then curPlayer.Consumables = {} end
                    curPlayer.Consumables[#curPlayer.Consumables + 1] = 0
                end
            end
        end
    end
end

function SoftCouncil.events:AddonLoaded(...)
    if ... == "TBC-EPGP" then
        SoftCouncil.DataTable = SoftCouncilDataTable
    end
end

function SoftCouncil.events:VariablesLoaded(...)
    for _, data in pairs(SoftCouncil.InfoTable.Consumables) do
        GetItemInfo(data[2][1])
    end
    SoftCouncil:FillScrollPanel()
end

SoftCouncil:OnLoad()

SoftCouncil.SlashCommands["test"] = function(value)
    print("TestCommand Works!")
end