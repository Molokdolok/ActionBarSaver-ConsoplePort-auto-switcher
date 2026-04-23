local ABS = select(2, ...)
local L = ABS.locals

local UI = CreateFrame("Frame")
ABS.UI = UI

-- Default settings for the UI
local defaults = {
    minimapPos = 180,
    hide = false,
}

-- Initialize UI DB
function UI:InitDB()
    ActionBarSaverUIDB = ActionBarSaverUIDB or {}
    for k, v in pairs(defaults) do
        if ActionBarSaverUIDB[k] == nil then
            ActionBarSaverUIDB[k] = v
        end
    end
    self.db = ActionBarSaverUIDB
end

-- Minimap Button
local function UpdateMinimapButtonPos()
    local angle = ActionBarSaverUIDB.minimapPos or 180
    ActionBarSaverMinimapButton:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52 - (80 * cos(angle)), (80 * sin(angle)) - 52)
end

function UI:CreateMinimapButton()
    local btn = CreateFrame("Button", "ActionBarSaverMinimapButton", Minimap)
    btn:SetSize(31, 31)
    btn:SetFrameLevel(8)
    btn:SetToplevel(true)
    btn:SetMovable(true)
    btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    btn:RegisterForDrag("LeftButton")
    
    btn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    
    local overlay = btn:CreateTexture(nil, "OVERLAY")
    overlay:SetSize(53, 53)
    overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    overlay:SetPoint("TOPLEFT")
    
    local icon = btn:CreateTexture(nil, "BACKGROUND")
    icon:SetSize(20, 20)
    icon:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
    icon:SetPoint("TOPLEFT", 7, -5)
    
    UpdateMinimapButtonPos()
    
    btn:SetScript("OnDragStart", function(self)
        self:SetScript("OnUpdate", function(self)
            local xpos, ypos = GetCursorPosition()
            local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()
            xpos = xmin - xpos / Minimap:GetEffectiveScale() + 70
            ypos = ypos / Minimap:GetEffectiveScale() - ymin - 70
            ActionBarSaverUIDB.minimapPos = math.deg(math.atan2(ypos, xpos))
            UpdateMinimapButtonPos()
        end)
    end)
    
    btn:SetScript("OnDragStop", function(self)
        self:SetScript("OnUpdate", nil)
    end)
    
    btn:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            UI:ToggleMainFrame()
        end
    end)
    
    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("Action Bar Saver")
        GameTooltip:AddLine("|cff66bbffLeft-Click|r to open menu", 1, 1, 1)
        GameTooltip:AddLine("|cff66bbffDrag|r to move icon", 1, 1, 1)
        GameTooltip:Show()
    end)
    
    btn:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
end

-- Touch UI Frame Creation
local function CreateTouchButton(parent, text, onClick)
    local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    btn:SetSize(160, 40)
    btn:SetText(text)
    btn:SetScript("OnClick", onClick)
    local fontString = btn:GetFontString()
    fontString:SetFont(fontString:GetFont(), 14, "OUTLINE")
    return btn
end

function UI:CreateMainFrame()
    if self.MainFrame then return end
    
    local f = CreateFrame("Frame", "ActionBarSaverMainFrame", UIParent)
    f:SetSize(200, 300)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 8, right = 8, top = 8, bottom = 8 }
    })
    
    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -15)
    title:SetText("ActionBarSaver")
    
    f.container = CreateFrame("Frame", nil, f)
    f.container:SetAllPoints()
    
    self.MainFrame = f
    self:ShowMainMenu()
end

function UI:ClearContainer()
    if not self.MainFrame or not self.MainFrame.container then return end
    local c = self.MainFrame.container
    
    local children = { c:GetChildren() }
    for _, child in ipairs(children) do
        child:Hide()
        child:SetParent(nil)
    end
    
    local regions = { c:GetRegions() }
    for _, region in ipairs(regions) do
        if region.Hide then
            region:Hide()
        end
    end
end

function UI:ShowMainMenu()
    self:ClearContainer()
    local c = self.MainFrame.container
    
    local btnSave = CreateTouchButton(c, "SAVE LAYOUT", function()
        self:ShowSaveMenu()
    end)
    btnSave:SetPoint("TOP", 0, -60)
    
    local btnRestore = CreateTouchButton(c, "RESTORE", function()
        self:ShowProfileList("RESTORE")
    end)
    btnRestore:SetPoint("TOP", 0, -110)
    
    local btnDelete = CreateTouchButton(c, "DELETE", function()
        self:ShowProfileList("DELETE")
    end)
    btnDelete:SetPoint("TOP", 0, -160)

    local btnSettings = CreateTouchButton(c, "SETTINGS", function()
        self:ShowSettingsMenu()
    end)
    btnSettings:SetPoint("TOP", 0, -210)
    
    local btnClose = CreateTouchButton(c, "CLOSE", function()
        self.MainFrame:Hide()
    end)
    btnClose:SetPoint("BOTTOM", 0, 20)
end

function UI:ShowSaveMenu()
    self:ClearContainer()
    local c = self.MainFrame.container
    
    local btnNew = CreateTouchButton(c, "NEW PROFILE", function()
        StaticPopup_Show("ABS_SAVE_PROFILE")
        self.MainFrame:Hide()
    end)
    btnNew:SetPoint("TOP", 0, -60)
    
    local btnOverwrite = CreateTouchButton(c, "OVERWRITE", function()
        self:ShowProfileList("SAVE")
    end)
    btnOverwrite:SetPoint("TOP", 0, -110)
    
    local btnBack = CreateTouchButton(c, "BACK", function()
        self:ShowMainMenu()
    end)
    btnBack:SetPoint("BOTTOM", 0, 20)
end

function UI:ShowSettingsMenu()
    self:ClearContainer()
    local c = self.MainFrame.container
    
    local autoSwitchText = ActionBarSaverDB.autoSwitch and "AUTO-SWITCH: ON" or "AUTO-SWITCH: OFF"
    local btnAutoSwitch = CreateTouchButton(c, autoSwitchText, function(self_btn)
        ActionBarSaverDB.autoSwitch = not ActionBarSaverDB.autoSwitch
        local newText = ActionBarSaverDB.autoSwitch and "AUTO-SWITCH: ON" or "AUTO-SWITCH: OFF"
        self_btn:SetText(newText)
    end)
    btnAutoSwitch:SetPoint("TOP", 0, -60)
    
    local btnBack = CreateTouchButton(c, "BACK", function()
        self:ShowMainMenu()
    end)
    btnBack:SetPoint("BOTTOM", 0, 20)
end

function UI:ShowProfileList(mode)
    self:ClearContainer()
    local c = self.MainFrame.container
    local playerClass = select(2, UnitClass("player"))
    local sets = ABS.db.sets[playerClass]
    
    local titleText = "Select Profile"
    if mode == "RESTORE" then titleText = "Restore Profile"
    elseif mode == "DELETE" then titleText = "Delete Profile"
    elseif mode == "SAVE" then titleText = "Overwrite Profile" end
    
    local title = c:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("TOP", 0, -45)
    title:SetText(titleText)
    
    local scrollFrame = CreateFrame("ScrollFrame", "ABS_ScrollFrame", c, "UIPanelScrollFrameTemplate")
    scrollFrame:SetSize(170, 180)
    scrollFrame:SetPoint("TOPLEFT", 10, -70)
    
    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(160, 1)
    scrollFrame:SetScrollChild(content)
    
    local offset = 0
    local sortedSets = {}
    for name in pairs(sets) do table.insert(sortedSets, name) end
    table.sort(sortedSets)
    
    for _, setName in ipairs(sortedSets) do
        local btn = CreateTouchButton(content, setName, function()
            if mode == "RESTORE" then
                ABS:RestoreProfile(setName, playerClass)
                self.MainFrame:Hide()
            elseif mode == "SAVE" then
                ABS:SaveProfile(setName)
                self.MainFrame:Hide()
            else
                if ActionBarSaverDB.autoSwitch and (setName == "ConsolePortON" or setName == "ConsolePortOFF") then
                    ABS:Print(string.format("Cannot delete reserved profile \"%s\" while Auto-Switch is enabled.", setName))
                else
                    ABS.db.sets[playerClass][setName] = nil
                    ABS:Print(string.format(L["Deleted saved profile %s."], setName))
                    self:ShowProfileList("DELETE")
                end
            end
        end)
        btn:SetPoint("TOP", 0, -offset)
        offset = offset + 45
    end
    content:SetHeight(offset)
    
    local btnBack = CreateTouchButton(c, "BACK", function()
        if mode == "SAVE" then self:ShowSaveMenu() else self:ShowMainMenu() end
    end)
    btnBack:SetPoint("BOTTOM", 0, 20)
end

function UI:ToggleMainFrame()
    self:CreateMainFrame()
    if self.MainFrame:IsShown() then
        self.MainFrame:Hide()
    else
        self:ShowMainMenu()
        self.MainFrame:Show()
    end
end

-- Static Popups
StaticPopupDialogs["ABS_SAVE_PROFILE"] = {
    text = "Enter name for the new profile:",
    button1 = "Save",
    button2 = "Cancel",
    hasEditBox = 1,
    OnAccept = function(self)
        local name = self.editBox:GetText()
        if name and name ~= "" then
            ABS:SaveProfile(name)
        end
    end,
    EditBoxOnEnterPressed = function(self)
        local name = self:GetParent().editBox:GetText()
        if name and name ~= "" then
            ABS:SaveProfile(name)
        end
        self:GetParent():Hide()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
}

-- Registration
UI:RegisterEvent("ADDON_LOADED")
UI:SetScript("OnEvent", function(self, event, addon)
    if addon == "ActionBarSaver" then
        self:InitDB()
        self:CreateMinimapButton()
    end
end)
