local layoutName = "BlizzArenaModern"
local layout = {}
layout.name = "|cff00b4ffBlizz|r Arena Modern"

layout.defaultSettings = {
    posX = 300,
    posY = 100,
    scale = 1.4,
    classIconFontSize = 10,
    spacing = 20,
    growthDirection = 1,
    specIcon = {
        posX = 47,
        posY = -12,
        scale = 1,
    },
    trinket = {
        posX = -72,
        posY = -1,
        scale = 1,
        fontSize = 12,
    },
    racial = {
        posX = -98,
        posY = -1,
        scale = 1,
        fontSize = 12,
    },
    castBar = {
        posX = -156,
        posY = 0,
        scale = 1,
        width = 84,
    },
    dr = {
        posX = -74,
        posY = 24,
        size = 22,
        borderSize = 2.5,
        fontSize = 12,
        spacing = 6,
        growthDirection = 4,
    },

    -- custom layout settings
    mirrored = false,
    darktheme = false,
}

local function getSetting(info)
    return layout.db[info[#info]]
end

local function setSetting(info, val)
    layout.db[info[#info]] = val

    for i = 1, 3 do
        local frame = info.handler["arena" .. i]
        layout:UpdateOrientation(frame)
    end
end

local function setupOptionsTable(self)
    layout.optionsTable = self:GetLayoutOptionsTable(layoutName)

    layout.optionsTable.arenaFrames.args.positioning.args.mirrored = {
        order = 5,
        name = "Mirrored Frames",
        type = "toggle",
        width = "full",
        get = getSetting,
        set = setSetting,
    }

    layout.optionsTable.arenaFrames.args.theme.args = {
        darktheme = {
            order = 1,
            name = "Dark Theme",
            desc = "Make the Arena Frames and borders dark (only works with BlizzArena Modern Layout)",
            type = "toggle",
            width = "full",
            get = getSetting,
            set = setSetting,
        }
    }
end

function layout:Initialize(frame)
    self.db = frame.parent.db.profile.layoutSettings[layoutName]

    if (not self.optionsTable) then
        setupOptionsTable(frame.parent)
    end

    if (frame:GetID() == 3) then
        frame.parent:UpdateCastBarSettings(self.db.castBar)
        frame.parent:UpdateDRSettings(self.db.dr)
        frame.parent:UpdateFrameSettings(self.db)
        frame.parent:UpdateSpecIconSettings(self.db.specIcon)
        frame.parent:UpdateTrinketSettings(self.db.trinket)
        frame.parent:UpdateRacialSettings(self.db.racial)
    end

    frame.ClassIconCooldown:SetSwipeTexture([[Interface\CharacterFrame\TempPortraitAlphaMask]])
    frame.ClassIconCooldown:SetUseCircularEdge(true)

    frame:SetSize(120, 42)
    frame.SpecIcon:SetSize(14, 14)
    frame.SpecIcon.Texture:AddMaskTexture(frame.SpecIcon.Mask)
    frame.Trinket:SetSize(22, 22)
    frame.Trinket.Texture:AddMaskTexture(frame.Trinket.Mask)
    frame.Trinket.Cooldown:SetSwipeTexture([[Interface\CharacterFrame\TempPortraitAlphaMask]])
    frame.Racial:SetSize(22.5, 22)
    frame.Racial.Texture:AddMaskTexture(frame.Racial.Mask)
    frame.Racial.Cooldown:SetSwipeTexture([[Interface\CharacterFrame\TempPortraitAlphaMask]])

    local healthBar = frame.HealthBar
    healthBar:SetSize(80, 16)
    healthBar:SetStatusBarTexture([[Interface\AddOns\mArena\Textures\HealthBar-Default]])

    local powerBar = frame.PowerBar
    powerBar:SetSize(81, 9)
    powerBar:SetPoint("TOPLEFT", healthBar, "BOTTOMLEFT", 0, -1)
    powerBar:SetStatusBarTexture([[Interface\AddOns\mArena\Textures\ManaBar-Default]])

    local f = frame.ClassIcon
    f:SetSize(38, 38)
    f:Show()
    f:AddMaskTexture(frame.ClassIconMask)
    frame.ClassIconMask:SetAllPoints(f)

    frame.TrinketBorder = frame.TexturePool:Acquire()
    frame.TrinketBorder = frame.TexturePool:Acquire()
    frame.TrinketBorder:SetParent(frame.Trinket)
    frame.TrinketBorder:SetDrawLayer("OVERLAY", 3)
    frame.TrinketBorder:SetTexture([[Interface\AddOns\mArena\Textures\Border]])
    frame.TrinketBorder:SetScale(0.2)
    frame.TrinketBorder:SetPoint("TOPLEFT", frame.Trinket, "TOPLEFT", -5, 5)
    frame.TrinketBorder:SetPoint("BOTTOMRIGHT", frame.Trinket, "BOTTOMRIGHT", 5, -5)
    frame.TrinketBorder:Show()

    frame.RacialBorder = frame.TexturePool:Acquire()
    frame.RacialBorder:SetParent(frame.Racial)
    frame.RacialBorder:SetDrawLayer("OVERLAY", 3)
    frame.RacialBorder:SetTexture([[Interface\AddOns\mArena\Textures\Border]])
    frame.RacialBorder:SetScale(0.2)
    frame.RacialBorder:SetPoint("TOPLEFT", frame.Racial, "TOPLEFT", -5, 5)
    frame.RacialBorder:SetPoint("BOTTOMRIGHT", frame.Racial, "BOTTOMRIGHT", 5, -5)
    frame.RacialBorder:Show()

    frame.SpecBorder = frame.TexturePool:Acquire()
    frame.SpecBorder:SetParent(frame.SpecIcon)
    frame.SpecBorder:SetDrawLayer("ARTWORK", 3)
    frame.SpecBorder:SetTexture([[Interface\AddOns\mArena\Textures\Border]])
    frame.SpecBorder:SetScale(0.2)
    frame.SpecBorder:SetPoint("TOPLEFT", frame.SpecIcon, "TOPLEFT", -5, 5)
    frame.SpecBorder:SetPoint("BOTTOMRIGHT", frame.SpecIcon, "BOTTOMRIGHT", 5, -5)
    frame.SpecBorder:Show()

    f = frame.Name
    f:SetJustifyH("LEFT")
    f:SetPoint("BOTTOMLEFT", healthBar, "TOPLEFT", 2, 2)
    f:SetPoint("BOTTOMRIGHT", healthBar, "TOPRIGHT", -2, 2)
    f:SetHeight(12)

    f = frame.CastBar
    local typeInfoTexture = "Interface\\TargetingFrame\\UI-StatusBar";
    f:SetStatusBarTexture(typeInfoTexture)
    f.typeInfo = {
        applyingcrafting = { 
            filling = "ui-castingbar-filling-applyingcrafting",
            full = "ui-castingbar-full-applyingcrafting",
            glow = "ui-castingbar-full-glow-applyingcrafting",
            sparkFx = "CraftingGlow",
            finishAnim = "CraftingFinish",
        },
        applyingtalents = { 
            filling = "ui-castingbar-filling-standard",
            full = "ui-castingbar-full-standard",
            glow = "ui-castingbar-full-glow-standard",
            sparkFx = "StandardGlow",
        },
        standard = {
            filling = "ui-castingbar-filling-standard",
            full = "ui-castingbar-full-standard",
            glow = "ui-castingbar-full-glow-standard",
            sparkFx = "StandardGlow",
            finishAnim = "StandardFinish",
        },
        empowered = { 
            filling = "",
            full = "",
            glow = "",
        },
        channel = { 
            filling = "ui-castingbar-filling-channel",
            full = "ui-castingbar-full-channel",
            glow = "ui-castingbar-full-glow-channel",
            sparkFx = "ChannelShadow",
            finishAnim = "ChannelFinish",
        },
        uninterruptable = {
            filling = "ui-castingbar-uninterruptable",
            full = "ui-castingbar-uninterruptable",
            glow = "ui-castingbar-full-glow-standard",
        },
        interrupted = { 
            filling = "ui-castingbar-interrupted",
            full = "ui-castingbar-interrupted",
            glow = "ui-castingbar-full-glow-standard",
        },
    }

    f = frame.DeathIcon
    f:ClearAllPoints()
    f:SetPoint("CENTER", frame.HealthBar, "CENTER")
    f:SetSize(38, 38)

    frame.HealthText:SetPoint("CENTER", frame.HealthBar)
    frame.HealthText:SetShadowOffset(0, 0)

    frame.PowerText:SetPoint("CENTER", frame.PowerBar, 0, -0.5)
    frame.PowerText:SetShadowOffset(0, 0)

    local underlay = frame.TexturePool:Acquire()
    underlay:SetDrawLayer("BACKGROUND", 1)
    underlay:SetColorTexture(0, 0, 0, 0.5)
    underlay:SetPoint("TOPLEFT", healthBar)
    underlay:SetPoint("BOTTOMRIGHT", powerBar)
    underlay:Show()

    local id = frame:GetID()
    layout["frameTexture" .. id] = frame.TexturePool:Acquire()
    local frameTexture = layout["frameTexture" .. id]
    frameTexture:SetDrawLayer("ARTWORK", 2)
    frameTexture:SetAllPoints(frame)
    frameTexture:SetTexture([[Interface\AddOns\mArena\Textures\UnitFrame-Default]])
    frameTexture:Show()

    self:UpdateOrientation(frame)
end

function layout:UpdateOrientation(frame)
    local frameTexture = layout["frameTexture" .. frame:GetID()]
    local healthBar = frame.HealthBar
    local powerBar = frame.PowerBar
    local classIcon = frame.ClassIcon
    local specBorder = frame.SpecBorder
    local racialBorder = frame.RacialBorder
    local trinketBorder = frame.TrinketBorder

    healthBar:ClearAllPoints()
    classIcon:ClearAllPoints()

    if (self.db.mirrored) then
        frameTexture:SetTexture([[Interface\AddOns\mArena\Textures\UnitFrame-Default-Mirrored]])
        healthBar:SetPoint("TOPRIGHT", -3, -9)
        healthBar:SetStatusBarTexture([[Interface\AddOns\mArena\Textures\HealthBar-Default-Mirrored]])
        powerBar:SetStatusBarTexture([[Interface\AddOns\mArena\Textures\ManaBar-Default-Mirrored]])
        classIcon:SetPoint("TOPLEFT", 2, -2)
    else
        frameTexture:SetTexture([[Interface\AddOns\mArena\Textures\UnitFrame-Default]])
        healthBar:SetPoint("TOPLEFT", 3, -9)
        healthBar:SetStatusBarTexture([[Interface\AddOns\mArena\Textures\HealthBar-Default]])
        powerBar:SetStatusBarTexture([[Interface\AddOns\mArena\Textures\ManaBar-Default]])
        classIcon:SetPoint("TOPRIGHT", -2, -2)
    end

    if (self.db.darktheme) then
        frameTexture:SetDesaturated(true)
        frameTexture:SetVertexColor(0.15, 0.15, 0.15)

        racialBorder:SetDesaturated(true)
        racialBorder:SetVertexColor(0.15, 0.15, 0.15)

        trinketBorder:SetDesaturated(true)
        trinketBorder:SetVertexColor(0.15, 0.15, 0.15)

        specBorder:SetDesaturated(true)
        specBorder:SetVertexColor(0.15, 0.15, 0.15)
    else
        frameTexture:SetDesaturated(false)
        frameTexture:SetVertexColor(1, 1, 1)

        racialBorder:SetDesaturated(false)
        racialBorder:SetVertexColor(1, 1, 1)

        trinketBorder:SetDesaturated(false)
        trinketBorder:SetVertexColor(1, 1, 1)

        specBorder:SetDesaturated(false)
        specBorder:SetVertexColor(1, 1, 1)
    end
end

mArenaMixin.layouts[layoutName] = layout
mArenaMixin.defaultSettings.profile.layoutSettings[layoutName] = layout.defaultSettings
