local version = "1.01"
_G.UseUpdater = true

--First check for the map
if not (GetGame().map.shortName == "howlingAbyss" or 
		GetGame().map.shortName == "butchersBridge" or 
		GetGame().map.shortName == "unknown") then 
	return 
end

--Second check, for the summoner
function CheckSummoner(IGNName)
    if myHero:GetSpellData(SUMMONER_1).name:find(IGNName) then 
        return SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:find(IGNName) then 
        return SUMMONER_2
    end
    return nil
end

local summonerKey = CheckSummoner("snowball")
if summonerKey == nil then return end

--Autoupdater
local REQUIRED_LIBS = {
	["VPrediction"] = "https://raw.githubusercontent.com/Hellsing/BoL/master/common/VPrediction.lua"
}

local DOWNLOADING_LIBS, DOWNLOAD_COUNT = false, 0

function AfterDownload()
	DOWNLOAD_COUNT = DOWNLOAD_COUNT - 1
	if DOWNLOAD_COUNT == 0 then
		DOWNLOADING_LIBS = false
		print("<b><font color=\"#6699FF\">Liquid ARAMShooter:</font></b> <font color=\"#FFFFFF\">Required libraries downloaded successfully, please reload (double F9).</font>")
	end
end

for DOWNLOAD_LIB_NAME, DOWNLOAD_LIB_URL in pairs(REQUIRED_LIBS) do
	if FileExist(LIB_PATH .. DOWNLOAD_LIB_NAME .. ".lua") then
		require(DOWNLOAD_LIB_NAME)
	else
		DOWNLOADING_LIBS = true
		DOWNLOAD_COUNT = DOWNLOAD_COUNT + 1
		DownloadFile(DOWNLOAD_LIB_URL, LIB_PATH .. DOWNLOAD_LIB_NAME..".lua", AfterDownload)
	end
end

if DOWNLOADING_LIBS then return end

local UPDATE_NAME = "Liquid ARAMShooter"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/LiquidBoL/LiquidBoL/master/Liquid%20ARAMShooter.lua" .. "?rand=" .. math.random(1, 10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "http://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) 
	print("<b><font color=\"#6699FF\">"..UPDATE_NAME..":</font></b> <font color=\"#FFFFFF\">"..msg..".</font>") 
end

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

local spellShot = {1200, 1600, 50, 0.33} --range, speed, width, cast time.
local lastMessage = ""

function OnLoad()
	VPred = VPrediction()
	Menu()
	print("Liquid ARAMShooter v"..version.." loaded!")
end

function OnTick()
	local target = GetTarget()

	if aramShooter.notification and BallLanded() then
		SendMessageOnce("<b><font color=\"#6699FF\">SNOWBALL LANDED!!!</font></b>")
	end
	
	if (aramShooter.enabled or (aramShooter.pressEnable and aramShooter.enableKey)) and target ~= nil and (myHero:CanUseSpell(summonerKey) == READY) then
		CastPrediction(target)
	end
end

function Menu()
	aramShooter = scriptConfig("Liquid ARAMShooter", "aramShooter")
	aramShooter:addParam("enabled", "Always enabled", SCRIPT_PARAM_ONOFF, true)
	aramShooter:addParam("pressEnable", "Enable on Press", SCRIPT_PARAM_ONOFF, false)
	aramShooter:addParam("enableKey", "Enable Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	aramShooter:addParam("notification", "Notify when landed", SCRIPT_PARAM_ONOFF, false)
	aramShooter:addParam("hitChance", "VPrediction Hitchance", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
	--aramShooter:addParam("stealthed", "Throw when Stealthed", SCRIPT_PARAM_ONOFF, false)
end

function BallLanded()
	return myHero:GetSpellData(summonerKey).name:find("follow")
end

function SendMessageOnce(message)
	if message == lastMessage then return end
	print(message)
	lastMessage = message
end

function CastPrediction(target)
	local castPosition, hitChance, position = VPred:GetLineCastPosition(target, spellShot[4], spellShot[3], spellShot[1], spellShot[2], myHero, true)
	if hitChance >= aramShooter.hitChance then
		CastSpell(summonerKey, castPosition.x, castPosition.z)
	end
end

