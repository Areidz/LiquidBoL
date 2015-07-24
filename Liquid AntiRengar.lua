local version = "1.13"
_G.UseUpdater = true

local champions = {	Ahri = {_E, 975, true, 1500, 0.25, 100}, 
					Alistar = {_W, 650, false},
					--Anivia Wall (Difficult)
					Azir = {_R, 250, true, 2000, 0.25, 500}, --Not real values, just a test.
					Braum = {_E, 250, true, 2000, 0.25, 500}, --Not real values, just a test.
					Draven = {_E, 1050, true, 1400, 0.28, 90}, 
					FiddleSticks = {_Q, 575, false},
					--Janna Q : 1100, 900, 0.25, 120.
					Janna = {_R, 725, false},
					LeeSin = {_R, 375, false},
					Lulu = {_W, 650, false},
					Malzahar = {_R, 700, false},
					Maokai = {_Q, 575, true, 1200, 0.5, 110},
					Rammus = {_Q, 250, false},
					Syndra = {_E, 700, true, 2500, 0.25, 22.5},
					Tristana = {_R, 550, false}, 
					Vayne = {_E, 550, false},
					XinZhao = {_R, 187.5, false}
				}

if not champions[myHero.charName] then return end

--Liquid AntiRengar, a script to automatically stop rengar leaping you with some specific champions.
--Champion support: Have a look at the table below.
--Thanks to: Brown (Helping me testing and champion ideas)
--To-Do: 	Add some other dashes, like Leblanc or Gnar.
--			Add more champions and options.
--Version: 1.13

local REQUIRED_LIBS = {
	["VPrediction"] = "https://raw.githubusercontent.com/Hellsing/BoL/master/common/VPrediction.lua"
}

local DOWNLOADING_LIBS, DOWNLOAD_COUNT = false, 0

function AfterDownload()
	DOWNLOAD_COUNT = DOWNLOAD_COUNT - 1
	if DOWNLOAD_COUNT == 0 then
		DOWNLOADING_LIBS = false
		print("<b><font color=\"#6699FF\">Liquid AntiRengar:</font></b> <font color=\"#FFFFFF\">Required libraries downloaded successfully, please reload (double F9).</font>")
	end
end

for DOWNLOAD_LIB_NAME, DOWNLOAD_LIB_URL in pairs(REQUIRED_LIBS) do
	if FileExist(LIB_PATH .. DOWNLOAD_LIB_NAME .. ".lua") then
		if DOWNLOAD_LIB_NAME ~= "Prodiction" then require(DOWNLOAD_LIB_NAME) end
		--if DOWNLOAD_LIB_NAME == "Prodiction" and VIP_USER then require(DOWNLOAD_LIB_NAME) end
	else
		DOWNLOADING_LIBS = true
		DOWNLOAD_COUNT = DOWNLOAD_COUNT + 1
		DownloadFile(DOWNLOAD_LIB_URL, LIB_PATH .. DOWNLOAD_LIB_NAME..".lua", AfterDownload)
	end
end

if DOWNLOADING_LIBS then return end

local UPDATE_NAME = "Liquid AntiRengar"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/LiquidBoL/LiquidBoL/master/Liquid%20AntiRengar.lua" .. "?rand=" .. math.random(1, 10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "http://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<b><font color=\"#6699FF\">"..UPDATE_NAME..":</font></b> <font color=\"#FFFFFF\">"..msg..".</font>") end
if _G.UseUpdater then
	local ServerData = GetWebResult(UPDATE_HOST, UPDATE_PATH)
	if ServerData then
		local ServerVersion = string.match(ServerData, "local version = \"%d+.%d+\"")
		ServerVersion = string.match(ServerVersion and ServerVersion or "", "%d+.%d+")
		if ServerVersion then
			ServerVersion = tonumber(ServerVersion)
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("New version available "..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 2)	 
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end

require "VPrediction"

local skillReady = false
local skillRange, myChampion, antiRengar = nil, nil, nil

function OnLoad()
	VPred = VPrediction()
	Menu()
	print("Liquid AntiRengar v"..version.." loaded!")
	myChampion = champions[myHero.charName]
	skillRange = myChampion[2]
end

function OnTick()
	SkillCheck()
end

function OnNewPath(unit, startPos, endPos, isDash, dashSpeed, dashGravity, dashDistance)
	if antiRengar.enabled or (antiRengar.pressEnable and antiRengar.enableKey) then
		if unit.charName == "Rengar" and isDash then
			if antiRengar.allyHelp then
				for i = 1, heroManager.iCount do
					local ally = heroManager:getHero(i)
					if ally.team == myHero.team and skillReady and not ally.dead and IsNotHealthy(ally) and GetDistanceSqr(ally, endPos) < 250*250 and GetDistanceSqr(myHero, endPos) < (skillRange)*(skillRange) then
						if myChampion[3] then
							if antiRengar.usePred then
								DelayAction(function() CastPrediction(unit) end, antiRengar.delayTime*0.001)
							else
								DelayAction(function() CastSpell(myChampion[1], unit.x, unit.z) end, antiRengar.delayTime*0.001)
							end
						else
							DelayAction(function() CastSpell(myChampion[1], unit) end, antiRengar.delayTime*0.001)
						end
					end
				end
			elseif skillReady and IsNotHealthy(myHero) and GetDistanceSqr(myHero, endPos) < 250*250 then --Distance to be moving and still throw the ability
				if myChampion[3] then
					if antiRengar.usePred then
						DelayAction(function() CastPrediction(unit) end, antiRengar.delayTime*0.001)
					else
						DelayAction(function() CastSpell(myChampion[1], unit.x, unit.z) end, antiRengar.delayTime*0.001)
					end
				elseif myHero.charName == "Janna" or myHero.charName == "XinZhao" or myHero.charName == "Rammus" then
					DelayAction(function() CastSpell(myChampion[1]) end, antiRengar.delayTime*0.001)
				else
					DelayAction(function() CastSpell(myChampion[1], unit) end, antiRengar.delayTime*0.001)
				end
			end
		end
	end
end

function IsNotHealthy(unit)
	return (((unit.health/unit.maxHealth)*100) <= antiRengar.currentLife)
end

function CastPrediction(target)
	local castPosition, hitChance, position = VPred:GetLineCastPosition(target, myChampion[5], myChampion[6], skillRange, myChampion[4], myHero, true)
	if hitChance >= 2 then
		CastSpell(myChampion[1], castPosition.x, castPosition.z)
	end
end

function GetTristanaRange()
	return 550+7*myHero.level
end

function SkillCheck()
	skillReady = myHero:CanUseSpell(myChampion[1])
	if myHero.charName == "Tristana" then
		skillRange = GetTristanaRange()
	end
end

function Menu()
	antiRengar = scriptConfig("Liquid AntiRengar", "AntiRengar")
	antiRengar:addParam("enabled", "Always enabled", SCRIPT_PARAM_ONOFF, true)
	antiRengar:addParam("pressEnable", "Enable on Press", SCRIPT_PARAM_ONOFF, false)
	antiRengar:addParam("enableKey", "Enable Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	antiRengar:addParam("usePred", "Predict Skillshots (Slower)", SCRIPT_PARAM_ONOFF, false)
	antiRengar:addParam("allyHelp", "Help allies", SCRIPT_PARAM_ONOFF, false)
	--antiRengar:addParam("delayEnable", "Delay Skills", SCRIPT_PARAM_ONOFF, false)
	antiRengar:addParam("delayTime", "Delay time (ms)", SCRIPT_PARAM_SLICE, 80, 0, 130, -1)
	antiRengar:addParam("currentLife", "Current life to use (%)", SCRIPT_PARAM_SLICE, 50, 0, 100, -1)
end


--Deprecated function.
--[[function OnCreateObj(obj)
	if AntiRengar.enabled or (AntiRengar.pressEnable and AntiRengar.enableKey) then
		if obj.name:lower():find("leapsound") then
			for i = 1, heroManager.iCount do
				local enemy = heroManager:getHero(i)
				if ValidTarget(enemy, skillRange) and enemy.charName == "Rengar" and skillReady then
					if myChampion[3] then
						if AntiRengar.usePred then
							CastPrediction(enemy)
						else
							CastSpell(myChampion[1], enemy.x, enemy.z)
						end
					else
						CastSpell(myChampion[1], enemy)
					end
				end
			end
		end
	end
end
]]--