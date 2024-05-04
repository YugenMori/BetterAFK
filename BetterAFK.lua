-- Author: Yugen
--
-- Supports any version of wow
--
-- A stylish and clean AFK mode for World of Warcraft
--------------------------------------------------------------
-- BetterAFK
--------------------------------------------------------------
-- Init - Tables - Saves
local addonName, addonTable = ...
local L = LibStub("AceLocale-3.0"):GetLocale("BetterAFK")
local GetWoWVersion = ((select(4, GetBuildInfo())))
--local texturepackCheck    = "1.0.1.7"
--local texturepackDate     = "26/11/20"
local f = CreateFrame("Frame", "BetterAFK_Config", UIParent)
f:SetSize(50, 50)
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, ...)
  character = UnitName("player").."-"..GetRealmName()
  -- Config/Panel
  if not BetterAFK_Config then
    local BetterAFK_Config = {}
  end
  -- Color Init
  if not COLOR_MY_UI then
      COLOR_MY_UI = {}
  end
  if not COLOR_MY_UI[character] then
      COLOR_MY_UI[character] = {}
  end
  if not COLOR_MY_UI[character].Color then
      COLOR_MY_UI[character].Color = { r = 1, g = 1, b = 1 }
  end
end)
local dialogFrameTexture 		= "Interface\\Addons\\BetterAFK\\textures\\extra\\dialogFrameTexture"
local dialogFrameTextureBorder 	= "Interface\\DialogFrame\\UI-DialogBox-Background"
-- Fontfication
local function AbyssUI_Fontification(globalFont, subFont, damageFont)
local locale = GetLocale()
local fontName, fontHeight, fontFlags = MinimapZoneText:GetFont()
local mediaFolder = "Interface\\AddOns\\AbyssUI\\textures\\font\\"
  if (locale == "zhCN") then
    globalFont  = mediaFolder.."zhCN-TW\\senty.ttf"
    subFont     = mediaFolder.."zhCN-TW\\senty.ttf"
    damageFont  = mediaFolder.."zhCN-TW\\senty.ttf"
  elseif (locale == "zhTW") then
    globalFont  = mediaFolder.."zhCN-TW\\senty.ttf"
    subFont     = mediaFolder.."zhCN-TW\\senty.ttf"
    damageFont  = mediaFolder.."zhCN-TW\\senty.ttf"
  elseif (locale == "ruRU") then
    globalFont  = mediaFolder.."ruRU\\dejavu.ttf"
    subFont     = mediaFolder.."ruRU\\dejavu.ttf"
    damageFont  = mediaFolder.."ruRU\\dejavu.ttf"
  elseif (locale == "koKR") then
    globalFont  = mediaFolder.."koKR\\dxlbab.ttf"
    subFont     = mediaFolder.."koKR\\dxlbab.ttf"
    damageFont  = mediaFolder.."koKR\\dxlbab.ttf"
  elseif (locale == "frFR" or locale == "deDE" or locale == "enGB" or locale == "enUS" or locale == "itIT" or
    locale == "esES" or locale == "esMX" or locale == "ptBR") then
    globalFont  = mediaFolder.."global.ttf"
    subFont     = mediaFolder.."npcfont.ttf"
    damageFont  = mediaFolder.."damagefont.ttf"
  else
    globalFont  = fontName
    subFont     = fontName
    damageFont  = fontName
  end
  return globalFont, subFont, damageFont
end
-- declarations
local globalFont, subFont, damageFont = AbyssUI_Fontification(globalFont, subFont, damageFont)

local function AFKCamInit()
	-- AbyssUI_AFKCameraFrame
	local AbyssUI_AFKCameraFrame = CreateFrame("Frame", "AbyssUI_AFKCameraFrame", WorldFrame)
	AbyssUI_AFKCameraFrame:SetFrameStrata("HIGH")
	AbyssUI_AFKCameraFrame:SetScale(UIParent:GetScale())
	AbyssUI_AFKCameraFrame:SetAllPoints(UIParent)
	AbyssUI_AFKCameraFrame:SetClampedToScreen(true)
	AbyssUI_AFKCameraFrame:Hide()
	----------------------------------------------------
	local AbyssUIBorder = AbyssUI_AFKCameraFrame:CreateTexture(nil, "BACKGROUND")
	AbyssUIBorder:SetTexture(dialogFrameTextureBorder)
	AbyssUIBorder:SetPoint("TOPLEFT", -3, 3)
	AbyssUIBorder:SetPoint("BOTTOMRIGHT", 3, -3)
	AbyssUIBorder:SetVertexColor(0.9, 0.9, 0.9, 0.9)
	----------------------------------------------------
	-- Text
	AbyssUI_AFKCameraFrame.text = AbyssUI_AFKCameraFrame.text or AbyssUI_AFKCameraFrame:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
	AbyssUI_AFKCameraFrame.text:SetScale(3)
	AbyssUI_AFKCameraFrame.text:SetAllPoints(true)
	AbyssUI_AFKCameraFrame.text:ClearAllPoints()
	AbyssUI_AFKCameraFrame.text:SetPoint("BOTTOM", 0, -200)
	AbyssUI_AFKCameraFrame.text:SetWidth(GetScreenWidth()/4)
	AbyssUI_AFKCameraFrame.text:SetHeight(GetScreenHeight()/2)
	AbyssUI_AFKCameraFrame.text:SetText(L["Move"])
	-- Texture
	local Texture = AbyssUI_AFKCameraFrame:CreateTexture(nil, "BACKGROUND")
	Texture:SetTexture(dialogFrameTextureBorder)
	Texture:SetAllPoints(AbyssUI_AFKCameraFrame)
	AbyssUI_AFKCameraFrame.texture = Texture
	----------------------------------------------------
	-- AFK Camera Function
	local AbyssUI_AFKCamera = CreateFrame("Frame", "$parentAbyssUI_AFKCamera", nil)
	AbyssUI_AFKCamera:RegisterEvent("PLAYER_FLAGS_CHANGED")
	AbyssUI_AFKCamera:RegisterEvent("PLAYER_ENTERING_WORLD")
	AbyssUI_AFKCamera:RegisterEvent("PLAYER_STARTED_MOVING")
	----------------------------------------------------
	-- ModelFrameAFKMode
	-- Model1
	local AbyssUI_ModelFrameAFKMode = CreateFrame("Frame", "$parentAbyssUI_ModelFrameAFKMode", AbyssUI_AFKCameraFrame)
	AbyssUI_ModelFrameAFKMode:SetPoint("BOTTOMRIGHT", 5, 5)
	if (GetWoWVersion <= 30500) then
		AbyssUI_ModelFrameAFKMode:SetWidth(CharacterModelFrame:GetWidth()*2)
		AbyssUI_ModelFrameAFKMode:SetHeight(CharacterModelFrame:GetHeight()*2)
	elseif (GetWoWVersion >= 40000) then
		AbyssUI_ModelFrameAFKMode:SetWidth(CharacterModelScene:GetWidth()*2)
		AbyssUI_ModelFrameAFKMode:SetHeight(CharacterModelScene:GetHeight()*2)
	end
	AbyssUI_ModelFrameAFKMode:SetAlpha(1)
	local ModelFrame_Model1 = CreateFrame("PlayerModel", "$parentModelFrame_Model1", AbyssUI_ModelFrameAFKMode)
	ModelFrame_Model1:SetUnit("player")
	ModelFrame_Model1:SetAlpha(1)
	ModelFrame_Model1:SetAllPoints(AbyssUI_ModelFrameAFKMode)
	ModelFrame_Model1:SetCustomCamera(1)
	----------------------------------------------------
	-- PlayerInfoAFKMode
	-- Name
	local PlayerInfo_Name1 = CreateFrame("Frame", "$parentPlayerInfo_Name1", AbyssUI_AFKCameraFrame)
	local playerName = UnitName("player")
	PlayerInfo_Name1:SetAllPoints(AbyssUI_AFKCameraFrame)
	PlayerInfo_Name1:SetScale(4)
	PlayerInfo_Name1.text = PlayerInfo_Name1.text or PlayerInfo_Name1:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
	PlayerInfo_Name1.text:SetPoint("TOP", 0, -1)
	PlayerInfo_Name1.text:SetText(playerName)
	-- Title
	local PlayerInfo_Title1 = CreateFrame("Frame", "$parentPlayerInfo_Title1", AbyssUI_AFKCameraFrame)
	if (GetWoWVersion > 12400) then
		local titleId = GetCurrentTitle() 
		local titleName = GetTitleName(titleId)
	end
	PlayerInfo_Title1:SetAllPoints(AbyssUI_AFKCameraFrame)
	PlayerInfo_Title1:SetScale(2)
	PlayerInfo_Title1.text = PlayerInfo_Title1.text or PlayerInfo_Title1:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
	PlayerInfo_Title1.text:SetPoint("TOP", 0, -21)
	PlayerInfo_Title1.text:SetText(titleName)
	-- Race
	local PlayerInfo_Race1 = CreateFrame("Frame", "$parentPlayerInfo_Race1", AbyssUI_AFKCameraFrame)
	local race, raceEn = UnitRace("player")
	PlayerInfo_Race1:SetAllPoints(AbyssUI_AFKCameraFrame)
	PlayerInfo_Race1:SetScale(3)
	PlayerInfo_Race1.text = PlayerInfo_Race1.text or PlayerInfo_Race1:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
	PlayerInfo_Race1.text:SetPoint("BOTTOMLEFT", 5, 100)
	PlayerInfo_Race1.text:SetText(raceEn)
	-- Class
	local PlayerInfo_Class1 = CreateFrame("Frame", "$parentPlayerInfo_Class1", AbyssUI_AFKCameraFrame)
	local playerClass, englishClass = UnitClass("player")
	PlayerInfo_Class1:SetAllPoints(AbyssUI_AFKCameraFrame)
	PlayerInfo_Class1:SetScale(3)
	PlayerInfo_Class1.text = PlayerInfo_Class1.text or PlayerInfo_Class1:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
	PlayerInfo_Class1.text:SetPoint("BOTTOMLEFT", 5, 90)
	PlayerInfo_Class1.text:SetText(playerClass)
	-- Current Specialization
	local PlayerInfo_CurrentSpec1 = CreateFrame("Frame", "$parentPlayerInfo_CurrentSpec1", AbyssUI_AFKCameraFrame)
	if (GetWoWVersion > 50600) then
		local currentSpec = GetSpecialization()
		local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or "None"
		PlayerInfo_CurrentSpec1:SetAllPoints(AbyssUI_AFKCameraFrame)
		PlayerInfo_CurrentSpec1:SetScale(3)
		PlayerInfo_CurrentSpec1.text = PlayerInfo_CurrentSpec1.text or PlayerInfo_CurrentSpec1:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
		PlayerInfo_CurrentSpec1.text:SetPoint("BOTTOMLEFT", 5, 80)
		PlayerInfo_CurrentSpec1.text:SetText(currentSpecName)
	end
	-- Level
	local PlayerInfo_Level1 = CreateFrame("Frame", "$parentPlayerInfo_Level1", AbyssUI_AFKCameraFrame)
	local level = UnitLevel("player")
	PlayerInfo_Level1:SetAllPoints(AbyssUI_AFKCameraFrame)
	PlayerInfo_Level1:SetScale(3)
	PlayerInfo_Level1.text = PlayerInfo_Level1.text or PlayerInfo_Level1:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
	if (GetWoWVersion > 50600) then 
		PlayerInfo_Level1.text:SetPoint("BOTTOMLEFT", 5, 70)
	else
		PlayerInfo_Level1.text:SetPoint("BOTTOMLEFT", 5, 80)
	end
	PlayerInfo_Level1.text:SetText(L["Level: "]..level)
	-- Honor Level
	local PlayerInfo_Honor1 = CreateFrame("Frame", "$parentPlayerInfo_Honor1", AbyssUI_AFKCameraFrame)
	PlayerInfo_Honor1:SetAllPoints(AbyssUI_AFKCameraFrame)
	PlayerInfo_Honor1:SetScale(3)
	PlayerInfo_Honor1.text = PlayerInfo_Honor1.text or PlayerInfo_Honor1:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
	if (GetWoWVersion > 50600) then
		PlayerInfo_Honor1.text:SetPoint("BOTTOMLEFT", 5, 60)
		local HonorLevel = UnitHonorLevel("player")
		PlayerInfo_Honor1.text:SetText(L["Honor: "]..HonorLevel)
	end
	-- Item Level
	local PlayerInfo_ILevel1 = CreateFrame("Frame", "$parentPlayerInfo_ILevel1", AbyssUI_AFKCameraFrame)
if (GetWoWVersion > 30600) then
	local overall, equipped = GetAverageItemLevel()
	PlayerInfo_ILevel1:SetAllPoints(AbyssUI_AFKCameraFrame)
	PlayerInfo_ILevel1:SetScale(3)
	PlayerInfo_ILevel1.text = PlayerInfo_ILevel1.text or PlayerInfo_ILevel1:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
	if (GetWoWVersion > 50600) then
		PlayerInfo_ILevel1.text:SetPoint("BOTTOMLEFT", 5, 50)
	else
		PlayerInfo_ILevel1.text:SetPoint("BOTTOMLEFT", 5, 70)
	end
	PlayerInfo_ILevel1.text:SetText(L["Item Level: "]..floor(overall + 0.5))
	end
	-- Zone
	local PlayerInfo_CurrentZone1 = CreateFrame("Frame", "$parentPlayerInfo_CurrentZone1", AbyssUI_AFKCameraFrame)
	local zoneName = GetZoneText()
	PlayerInfo_CurrentZone1:SetAllPoints(AbyssUI_AFKCameraFrame)
	PlayerInfo_CurrentZone1:SetScale(3)
	PlayerInfo_CurrentZone1.text = PlayerInfo_CurrentZone1.text or PlayerInfo_CurrentZone1:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
	if (GetWoWVersion > 50600) then
		PlayerInfo_CurrentZone1.text:SetPoint("BOTTOMLEFT", 5, 40)
	else
		if (GetWoWVersion < 30000) then
			PlayerInfo_CurrentZone1.text:SetPoint("BOTTOMLEFT", 5, 70)
		else
			PlayerInfo_CurrentZone1.text:SetPoint("BOTTOMLEFT", 5, 60)
		end
	end
	PlayerInfo_CurrentZone1.text:SetText(zoneName)
	-- Guild Info
	local PlayerInfo_Guild1 = CreateFrame("Frame", "$parentPlayerInfo_Guild1", AbyssUI_AFKCameraFrame)
	local guildName, guildRankName, guildRankIndex = GetGuildInfo("player")
	PlayerInfo_Guild1:SetAllPoints(AbyssUI_AFKCameraFrame)
	PlayerInfo_Guild1:SetScale(3)
	PlayerInfo_Guild1.text = PlayerInfo_Guild1.text or PlayerInfo_Guild1:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
	if (GetWoWVersion > 50600) then
		PlayerInfo_Guild1.text:SetPoint("BOTTOMLEFT", 5, 30)
	else
		PlayerInfo_Guild1.text:SetPoint("BOTTOMLEFT", 5, 50)
	end
	PlayerInfo_Guild1.text:SetText(guildName)
	-- CLock
	local ExtraInfo_Clock1 = CreateFrame("Frame", "$parentExtraInfo_Clock1", AbyssUI_AFKCameraFrame)
	ExtraInfo_Clock1:SetAllPoints(AbyssUI_AFKCameraFrame)
	ExtraInfo_Clock1:SetScale(3)
	ExtraInfo_Clock1.text = ExtraInfo_Clock1.text or ExtraInfo_Clock1:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
	ExtraInfo_Clock1.text:SetPoint("TOPRIGHT", -5, -1)
	-- Faction
	local englishFaction, localizedFaction = UnitFactionGroup("player")
	local ExtraInfo_Faction1 = CreateFrame("Frame", "$parentExtraInfo_Faction1", AbyssUI_AFKCameraFrame)
	ExtraInfo_Faction1:SetWidth(64)
	ExtraInfo_Faction1:SetHeight(64)
	ExtraInfo_Faction1:SetPoint("TOPLEFT", 5, -5)
	ExtraInfo_Faction1:SetScale(3)
	if (GetWoWVersion ~= 30401) then
		local t = ExtraInfo_Faction1:CreateTexture(nil, "BACKGROUND")
			if (englishFaction == "Horde") then
				t:SetTexture("Interface\\AddOns\\AbyssUI\\textures\\extra\\Horde-Logo")
			else
				t:SetTexture("Interface\\AddOns\\AbyssUI\\textures\\extra\\Alliance-Logo")
			end
		t:SetAllPoints(ExtraInfo_Faction1)
	end
	-- Gold Amount
	local _G = _G
	local currency = _G["MONEY"]
	local PlayerInfo_GoldAmount1 = CreateFrame("Frame", "$parentPlayerInfo_GoldAmount1", AbyssUI_AFKCameraFrame)
	PlayerInfo_GoldAmount1:RegisterEvent("PLAYER_FLAGS_CHANGED")
	PlayerInfo_GoldAmount1:RegisterEvent("PLAYER_ENTERING_WORLD")
	local money = GetCoinTextureString(GetMoney())
	PlayerInfo_GoldAmount1:SetAllPoints(AbyssUI_AFKCameraFrame)
	PlayerInfo_GoldAmount1:SetScale(3)
	PlayerInfo_GoldAmount1.text = PlayerInfo_GoldAmount1.text or PlayerInfo_GoldAmount1:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
	PlayerInfo_GoldAmount1.text:SetPoint("BOTTOMLEFT", 5 , 1)
	PlayerInfo_GoldAmount1.text:SetText(currency.."|cfff2dc7f"..money.."|r")
	-- Class colorization (all player info)
	if (englishClass == "EVOKER") then
		for i, v in pairs({
			AbyssUI_AFKCameraFrame, 
			PlayerInfo_Name1,
			PlayerInfo_Title1, 
			PlayerInfo_Level1, 
			PlayerInfo_Race1, 
			PlayerInfo_Class1,
			PlayerInfo_ILevel1,
			PlayerInfo_CurrentZone1,
			PlayerInfo_Guild1,
			ExtraInfo_Clock1,
		PlayerInfo_GoldAmount1 }) do
			if (GetWoWVersion > 30600) then 
			v.text:SetVertexColor(51/255, 147/255, 127/255)
		end
		if (GetWoWVersion > 50600) then
			PlayerInfo_Honor1.text:SetVertexColor(51/255, 147/255, 127/255)
			PlayerInfo_CurrentSpec1.text:SetVertexColor(51/255, 147/255, 127/255)
		end
		end 
	elseif (englishClass == "DEATHKNIGHT") then
		for i, v in pairs({
			AbyssUI_AFKCameraFrame, 
			PlayerInfo_Name1,
			PlayerInfo_Title1, 
			PlayerInfo_Level1, 
			PlayerInfo_Race1, 
			PlayerInfo_Class1,
			PlayerInfo_ILevel1,
			PlayerInfo_CurrentZone1,
			PlayerInfo_Guild1,
			ExtraInfo_Clock1,
		PlayerInfo_GoldAmount1 }) do
		if (GetWoWVersion > 30600) then 
			v.text:SetVertexColor(196/255, 30/255, 59/255)
		end
		if (GetWoWVersion > 50600) then
			PlayerInfo_Honor1.text:SetVertexColor(196/255, 30/255, 59/255)
			PlayerInfo_CurrentSpec1.text:SetVertexColor(196/255, 30/255, 59/255)
		end
		end 
	elseif (englishClass == "DEMONHUNTER") then
		for i, v in pairs({ 
			AbyssUI_AFKCameraFrame, 
			PlayerInfo_Name1,
			PlayerInfo_Title1,
			PlayerInfo_Level1, 
			PlayerInfo_Race1, 
			PlayerInfo_Class1,
			PlayerInfo_ILevel1,
			PlayerInfo_CurrentZone1,
			PlayerInfo_Guild1,
			ExtraInfo_Clock1,
		PlayerInfo_GoldAmount1 }) do
			if (GetWoWVersion > 30600) then 
				v.text:SetVertexColor(163/255, 48/255, 201/255)
			end
			if (GetWoWVersion > 50600) then
				PlayerInfo_Honor1.text:SetVertexColor(163/255, 48/255, 201/255)
				PlayerInfo_CurrentSpec1.text:SetVertexColor(163/255, 48/255, 201/255)
			end
		end 
	elseif (englishClass == "DRUID") then
		for i, v in pairs({ 
			AbyssUI_AFKCameraFrame, 
			PlayerInfo_Name1,
			PlayerInfo_Title1,
			PlayerInfo_Level1, 
			PlayerInfo_Race1, 
			PlayerInfo_Class1,
			PlayerInfo_ILevel1,
			PlayerInfo_CurrentZone1,
			PlayerInfo_Guild1,
			ExtraInfo_Clock1,
		PlayerInfo_GoldAmount1 }) do
			if (GetWoWVersion > 30600) then 
				v.text:SetVertexColor(255/255, 125/255, 10/255)
			end
			if (GetWoWVersion > 50600) then
				PlayerInfo_Honor1.text:SetVertexColor(255/255, 125/255, 10/255)
				PlayerInfo_CurrentSpec1.text:SetVertexColor(255/255, 125/255, 10/255)
			end
		end 
	elseif (englishClass == "HUNTER") then
		for i, v in pairs({ 
			AbyssUI_AFKCameraFrame,
			PlayerInfo_Name1,
			PlayerInfo_Title1,
			PlayerInfo_Level1, 
			PlayerInfo_Race1, 
			PlayerInfo_Class1,
			PlayerInfo_Honor1,
			PlayerInfo_ILevel1,
			PlayerInfo_CurrentSpec1,
			PlayerInfo_CurrentZone1,
			PlayerInfo_Guild1,
			ExtraInfo_Clock1,
		PlayerInfo_GoldAmount1 }) do
			if (GetWoWVersion > 30600) then 
				v.text:SetVertexColor(171/255, 212/255, 115/255)
			end
			if (GetWoWVersion > 50600) then
				PlayerInfo_Honor1.text:SetVertexColor(171/255, 212/255, 115/255)
				PlayerInfo_CurrentSpec1.text:SetVertexColor(171/255, 212/255, 115/255)
			end
		end 
	elseif (englishClass == "MAGE") then
		for i, v in pairs({ 
			AbyssUI_AFKCameraFrame,
			PlayerInfo_Name1,
			PlayerInfo_Title1,
			PlayerInfo_Level1, 
			PlayerInfo_Race1, 
			PlayerInfo_Class1,
			PlayerInfo_Honor1,
			PlayerInfo_ILevel1,
			PlayerInfo_CurrentSpec1,
			PlayerInfo_CurrentZone1,
			PlayerInfo_Guild1,
			ExtraInfo_Clock1,
		PlayerInfo_GoldAmount1 }) do
			if (GetWoWVersion > 30600) then 
				v.text:SetVertexColor(105/255, 204/255, 240/255)
			end
			if (GetWoWVersion > 50600) then
				PlayerInfo_Honor1.text:SetVertexColor(105/255, 204/255, 240/255)
				PlayerInfo_CurrentSpec1.text:SetVertexColor(105/255, 204/255, 240/255)
			end
		end 
	elseif (englishClass == "MONK") then
		for i, v in pairs({ 
			AbyssUI_AFKCameraFrame,
			PlayerInfo_Name1,
			PlayerInfo_Title1, 
			PlayerInfo_Level1, 
			PlayerInfo_Race1, 
			PlayerInfo_Class1,
			PlayerInfo_Honor1,
			PlayerInfo_ILevel1,
			PlayerInfo_CurrentSpec1,
			PlayerInfo_CurrentZone1,
			PlayerInfo_Guild1,
			ExtraInfo_Clock1,
		PlayerInfo_GoldAmount1 }) do
			if (GetWoWVersion > 30600) then 
				v.text:SetVertexColor(0/255, 255/255, 150/255)
			end
			if (GetWoWVersion > 50600) then
				PlayerInfo_Honor1.text:SetVertexColor(0/255, 255/255, 150/255)
				PlayerInfo_CurrentSpec1.text:SetVertexColor(0/255, 255/255, 150/255)
			end
		end 
	elseif (englishClass == "PALADIN") then
		for i, v in pairs({ 
			AbyssUI_AFKCameraFrame,
			PlayerInfo_Name1,
			PlayerInfo_Title1, 
			PlayerInfo_Level1, 
			PlayerInfo_Race1, 
			PlayerInfo_Class1,
			PlayerInfo_Honor1,
			PlayerInfo_ILevel1,
			PlayerInfo_CurrentSpec1,
			PlayerInfo_CurrentZone1,
			PlayerInfo_Guild1,
			ExtraInfo_Clock1,
		PlayerInfo_GoldAmount1 }) do
			if (GetWoWVersion > 30600) then 
				v.text:SetVertexColor(245/255, 140/255, 186/255)
			end
			if (GetWoWVersion > 50600) then
				PlayerInfo_Honor1.text:SetVertexColor(245/255, 140/255, 186/255)
				PlayerInfo_CurrentSpec1.text:SetVertexColor(245/255, 140/255, 186/255)			
			end
		end 
	elseif (englishClass == "PRIEST") then
		for i, v in pairs({ 
			AbyssUI_AFKCameraFrame,
			PlayerInfo_Name1,
			PlayerInfo_Title1, 
			PlayerInfo_Level1, 
			PlayerInfo_Race1, 
			PlayerInfo_Class1,
			PlayerInfo_Honor1,
			PlayerInfo_ILevel1,
			PlayerInfo_CurrentSpec1,
			PlayerInfo_CurrentZone1,
			PlayerInfo_Guild1,
			ExtraInfo_Clock1,
		PlayerInfo_GoldAmount1 }) do
			if (GetWoWVersion > 30600) then 
				v.text:SetVertexColor(255/255, 255/255, 255/255)
			end
			if (GetWoWVersion > 50600) then
				PlayerInfo_Honor1.text:SetVertexColor(255/255, 255/255, 255/255)
				PlayerInfo_CurrentSpec1.text:SetVertexColor(255/255, 255/255, 255/255)			
			end
		end 
	elseif (englishClass == "ROGUE") then
		for i, v in pairs({
			AbyssUI_AFKCameraFrame,
			PlayerInfo_Name1,
			PlayerInfo_Title1, 
			PlayerInfo_Level1, 
			PlayerInfo_Race1, 
			PlayerInfo_Class1,
			PlayerInfo_Honor1,
			PlayerInfo_ILevel1,
			PlayerInfo_CurrentSpec1,
			PlayerInfo_CurrentZone1,
			PlayerInfo_Guild1,
			ExtraInfo_Clock1,
		PlayerInfo_GoldAmount1 }) do
			if (GetWoWVersion > 30600) then 
				v.text:SetVertexColor(255/255, 245/255, 105/255)
			end
			if (GetWoWVersion > 50600) then
				PlayerInfo_Honor1.text:SetVertexColor(255/255, 245/255, 105/255)
				PlayerInfo_CurrentSpec1.text:SetVertexColor(255/255, 245/255, 105/255)
			end
		end 
	elseif (englishClass == "SHAMAN") then
		for i, v in pairs({ 
			AbyssUI_AFKCameraFrame,
			PlayerInfo_Name1,
			PlayerInfo_Title1, 
			PlayerInfo_Level1, 
			PlayerInfo_Race1, 
			PlayerInfo_Class1,
			PlayerInfo_Honor1,
			PlayerInfo_ILevel1,
			PlayerInfo_CurrentSpec1,
			PlayerInfo_CurrentZone1,
			PlayerInfo_Guild1,
			ExtraInfo_Clock1,
		PlayerInfo_GoldAmount1 }) do
			if (GetWoWVersion > 30600) then 
				v.text:SetVertexColor(0/255, 112/255, 222/255)
			end
			if (GetWoWVersion > 50600) then
				PlayerInfo_Honor1.text:SetVertexColor(0/255, 112/255, 222/255)
				PlayerInfo_CurrentSpec1.text:SetVertexColor(0/255, 112/255, 222/255)
			end
		end 
	elseif (englishClass == "WARLOCK") then
		for i, v in pairs({ 
			AbyssUI_AFKCameraFrame,
			PlayerInfo_Name1,
			PlayerInfo_Title1,
			PlayerInfo_Level1, 
			PlayerInfo_Race1, 
			PlayerInfo_Class1,
			PlayerInfo_Honor1,
			PlayerInfo_ILevel1,
			PlayerInfo_CurrentSpec1,
			PlayerInfo_CurrentZone1,
			PlayerInfo_Guild1,
			ExtraInfo_Clock1,
		PlayerInfo_GoldAmount1 }) do
			if (GetWoWVersion > 30600) then 
				v.text:SetVertexColor(148/255, 130/255, 201/255)
			end
			if (GetWoWVersion > 50600) then
				PlayerInfo_Honor1.text:SetVertexColor(148/255, 130/255, 201/255)
				PlayerInfo_CurrentSpec1.text:SetVertexColor(148/255, 130/255, 201/255)			
			end
		end 
	elseif (englishClass == "WARRIOR") then
		for i, v in pairs({ 
			AbyssUI_AFKCameraFrame,
			PlayerInfo_Name1,
			PlayerInfo_Title1,
			PlayerInfo_Level1, 
			PlayerInfo_Race1, 
			PlayerInfo_Class1,
			PlayerInfo_Honor1,
			PlayerInfo_ILevel1,
			PlayerInfo_CurrentSpec1,
			PlayerInfo_CurrentZone1,
			PlayerInfo_Guild1,
			ExtraInfo_Clock1,
		PlayerInfo_GoldAmount1 }) do
			if (GetWoWVersion > 30600) then 
				v.text:SetVertexColor(199/255, 156/255, 110/255)
			end
			if (GetWoWVersion > 50600) then
				PlayerInfo_Honor1.text:SetVertexColor(199/255, 156/255, 110/255)
				PlayerInfo_CurrentSpec1.text:SetVertexColor(199/255, 156/255, 110/255)	
			end
		end 
	else
		return nil
	end
	-- nonMilitaryClock
	local function nonMilitaryClock(time)
		if (time == 13) then
			time = 1
		elseif (time == 14) then
			time = 2
		elseif (time == 15) then
			time = 3
		elseif (time == 16) then
			time = 4
		elseif (time == 17) then
			time = 5
		elseif (time == 18) then
			time = 6
		elseif (time == 19) then
			time = 7
		elseif (time == 20) then
			time = 8
		elseif (time == 21) then
			time = 9
		elseif (time == 22) then
			time = 10
		elseif (time == 23) then
			time = 11
		elseif (time == 00) then
			time = 12
		end
		return time
	end
	local function AbyssUI_UpdateAFKCameraData()
		-- Get
		playerName = UnitName("player")
		local nonMilitaryHour = date("%H")
		local nonMilitaryMinutes = date("%M |cffffcc00%m/%d/%y|r")
		if (GetWoWVersion > 12400) then
			titleId = GetCurrentTitle() 
			titleName = GetTitleName(titleId)
		end
		level = UnitLevel("player")
		race, raceEn = UnitRace("player")
		playerClass, englishClass = UnitClass("player")
		zoneName = GetZoneText()
		guildName, guildRankName, guildRankIndex = GetGuildInfo("player")
		if (AbyssUIAddonSettings.ExtraFunctionAmericanClock == true) then
			dataTime = date("%H:%M |cfff2dc7f%m/%d/%y|r ")
		else
			dataTime = date("%H:%M |cfff2dc7f%d/%m/%y|r ")
		end
		englishFaction, localizedFaction = UnitFactionGroup("player")
		money = GetCoinTextureString(GetMoney())
		-- Set
		PlayerInfo_Name1.text:SetText(playerName)
		PlayerInfo_Title1.text:SetText(titleName)
		PlayerInfo_Level1.text:SetText(L["Level: "]..level)
		PlayerInfo_Race1.text:SetText(race)
		PlayerInfo_Class1.text:SetText(playerClass)
		if (AbyssUIAddonSettings.ExtraFunctionAmericanClock == true) then
			ExtraInfo_Clock1.text:SetText(nonMilitaryClock(tonumber(nonMilitaryHour))..":"..nonMilitaryMinutes)
		else
			ExtraInfo_Clock1.text:SetText(dataTime)
		end
		if (GetWoWVersion > 50600) then
			local HonorLevel = UnitHonorLevel("player")
			local overall, equipped = GetAverageItemLevel()
			local currentSpec = GetSpecialization()
			local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or "None"
			PlayerInfo_Honor1.text:SetText(L["Honor: "]..HonorLevel)
			PlayerInfo_ILevel1.text:SetText(L["Item Level: "]..floor(overall + 0.5))
			PlayerInfo_CurrentSpec1.text:SetText(currentSpecName)
		end
		PlayerInfo_GoldAmount1.text:SetText(currency..": |cfff2dc7f"..money.."|r")
		PlayerInfo_CurrentZone1.text:SetText(zoneName)
		PlayerInfo_Guild1.text:SetText(guildName)
	end
	-- Clock Update
	local timer = ExtraInfo_Clock1:CreateAnimationGroup()
	local timerAnim = timer:CreateAnimation()
	timerAnim:SetDuration(5) -- how often you want it to finish
	timer:SetScript("OnFinished", function(self, requested)
		-- requested = true if you used timer:Stop(), false if it finished naturally
		AbyssUI_UpdateAFKCameraData()
		self:Play() -- start it over again
	end)
	timer:Play()
	local function PlayerModelRandomAnimation()
		local idRandAnimation = { 
	    4,   -- walk
	    5,   -- run
	    40,  -- falling
	    42,  -- swimming
	    62,  -- mining
	    69,  -- dance
	    94,  -- iddle(normal)
	    96,  -- siting
	    102, -- knell
	    103, -- knell2
	    115, -- headdown
	    193, -- levitating
	    234, -- state_work_chopwood
		}
		local randAnimation = #idRandAnimation 
		if (GetWoWVersion > 12400) then
			ModelFrame_Model1:SetAnimation(idRandAnimation[random(1, randAnimation)])
		end
	end
----------------------------------------------------
-- AbyssUI_AFKCamera SetScript
	AbyssUI_AFKCamera:SetScript("OnEvent", function(self, event, ...)
		local inInstance, instanceType = IsInInstance()
		if (AbyssUIAddonSettings.AFKCammeraFrame ~= true) then 
			if (event == "PLAYER_FLAGS_CHANGED" or event == "PLAYER_ENTERING_WORLD") then
				PlayerModelRandomAnimation()
				local isAFK = UnitIsAFK("player")
				if isAFK == true and inInstance ~= true then
					UIParent:SetAlpha(0)
					if AbyssUIAddonSettings.HideMinimap ~= true then
						MinimapCluster:Hide()
					end
					AbyssUI_UpdateAFKCameraData()
					UIFrameFadeIn(AbyssUI_AFKCameraFrame, 3, 0, 1)
				elseif isAFK == false and inInstance ~= true then
					AbyssUI_AFKCameraFrame:Hide()
					UIParent:SetAlpha(1)
					if AbyssUIAddonSettings.HideMinimap ~= true then
						MinimapCluster:Show()
					end
				elseif isAFK == true and inInstance == true then
					AbyssUI_AFKCameraFrame:Hide()
					UIParent:SetAlpha(1)
					if AbyssUIAddonSettings.HideMinimap ~= true then
						MinimapCluster:Show()
					end
				elseif isAFK == false and inInstance == true then
					AbyssUI_AFKCameraFrame:Hide()
					UIParent:SetAlpha(1)
					if AbyssUIAddonSettings.HideMinimap ~= true then
						if (not MinimapCluster:IsShown()) then
							MinimapCluster:Show()
						end
					end
				else
					AbyssUI_AFKCameraFrame:Hide()
				end
			end
			-- OnClick
			if (AbyssUI_AFKCameraFrame:IsShown()) then
				AbyssUI_AFKCameraFrame:SetScript("OnMouseDown", function (self, button)
				    if (button == 'LeftButton') then 
				    	AbyssUI_AFKCameraFrame:Hide()
							UIParent:SetAlpha(1)
							if AbyssUIAddonSettings.HideMinimap ~= true then
								MinimapCluster:Show()
							end
							if UnitIsAFK("player") then
        				SendChatMessage("", "AFK")
        			end
				    end
				end)
			end
		end
	end)
end
local f = CreateFrame("Frame")
f:SetSize(50, 50)
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, ...)
  character = UnitName("player").."-"..GetRealmName()
  if not AbyssUIAddonSettings then
    AbyssUIAddonSettings = {}
  end
  if not AbyssUIAddonSettings[character] then
    AbyssUIAddonSettings[character] = {}
  end
  AFKCamInit()
end)
--------------------------------------------