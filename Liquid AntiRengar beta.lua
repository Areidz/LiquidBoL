local version = "2.02"
_G.UseUpdater = true

--Champion: Skill, Range, Special Cast, Skillshot, Targeted, Speed, Delay, Width.
--Special Cast:
--		0: Shield or Self-Evasion-Dash (Garen, Fizz, Anivia W...)
--		1: Dash (Leblanc E, Gnar E...)
--		2: Combo (Katarina Ward-Jump, Jarvan E-Q...)
--		3: Form-Required check (Jayce E, Elise E...)
--		4: Buff Check (Annie Stun, Yasuo 3rd Q...)

local NORMAL_CAST, DIRECT_CAST, AIR_CAST = false, false, false
local SPECIAL_CAST, SKILLSHOT_CAST, TARGETED_CAST = true, true, true
local SHIELD, DASH, COMBO, FORMCHECK, BUFFCHECK = 0, 1, 2, 3, 4

local champions = {	
	Ahri = {_E, 975, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, 1500, 0.25, 100}, 
	Alistar = {_W, 650, NORMAL_CAST, DIRECT_CAST, TARGETED_CAST},
	Anivia = {_W, 1000, SPECIAL_CAST, SHIELD}, -- Wall (Difficult)
	Annie = {_Q, 500, SPECIAL_CAST, BUFFCHECK}, --if stun
	Ashe = {_R, 1000, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, 1600, 0.25, 120}, --true range 25000
	Azir = {_R, 250, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, 1400, 0.5, 700},
	Blitzcrank = {_Q, 1250, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, 1800, 0.25, 70},
	Braum = {_E, 250, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, math.huge, 0.25, 200},
	--Caitlyn = {_E, 500, true, true, false,...}
	--Cassio R
	Chogath {_Q, 950, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, math.huge, 0.625, 87.5},
	Diana = {_E, 500, NORMAL_CAST, DIRECT_CAST, AIR_CAST},
	Draven = {_E, 1050, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, 1400, 0.28, 90},
	Elise = {_E, 1075, SPECIAL_CAST, FORMCHECK, 1600, 0.25, 55},
	Evelynn = {_R, 650, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, math.huge, 0.25, 250},
	FiddleSticks = {_Q, 575, NORMAL_CAST, DIRECT_CAST, TARGETED_CAST},
	Fizz = {_E, 800, SPECIAL_CAST, SHIELD}, 
	Galio = {_R, 600, NORMAL_CAST, DIRECT_CAST, AIR_CAST},
	Garen = {_W, 250, SPECIAL_CAST, SHIELD},
	--Gragas R and E
	Janna = {_Q, 850, SPECIAL_CAST, COMBO, 900, 0.25, 120},
	Irelia = {_E, 425, NORMAL_CAST, DIRECT_CAST, TARGETED_CAST},
	Janna = {_R, 725, NORMAL_CAST, DIRECT_CAST, AIR_CAST},
	Jax = {_E, 187.5, NORMAL_CAST, DIRECT_CAST, AIR_CAST},
	Jayce = {_E, 240, SPECIAL_CAST, FORMCHECK},
	Jinx = {_E, 900, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, 1750, 1.2, 20}, --Jinx E on player position
	--Katarina wardjump?
	Kindred = {_R, 400, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, math.huge, 0.25, 500}, --Not tested
	Leblanc = {_E, 950, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, 1750, 0.25, 27.5}, --Also W for Dash? 
	LeeSin = {_R, 375, NORMAL_CAST, DIRECT_CAST, TARGETED_CAST},
	Lissandra = {_R, 550, NORMAL_CAST, DIRECT_CAST, TARGETED_CAST},
	Lulu = {_W, 650, NORMAL_CAST, DIRECT_CAST, TARGETED_CAST},
	Lux = {_Q, 1175, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, 1200, 0.25, 70},
	Malzahar = {_R, 700, NORMAL_CAST, DIRECT_CAST, TARGETED_CAST},
	Maokai = {_Q, 575, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, 1200, 0.5, 110},
	Monkeyking = {_W, 250, NORMAL_CAST, DIRECT_CAST, AIR_CAST},
	Nami = {_Q, 875, NORMAL_CAST, SKILLSHOT_CAST, DIRECT_CAST, math.huge, 0.925, 162}, --Thanks to S1mple.
	Pantheon = {_W, 600, NORMAL_CAST, DIRECT_CAST, TARGETED_CAST},
	Poppy = {_E, 525, NORMAL_CAST, DIRECT_CAST, TARGETED_CAST},
	Quinn = {_E, 700, NORMAL_CAST, DIRECT_CAST, TARGETED_CAST},
	Rammus = {_Q, 250, NORMAL_CAST, DIRECT_CAST, AIR_CAST}, --also W and E.
	Riven = {_W, 250, NORMAL_CAST, DIRECT_CAST, AIR_CAST}, 
	Ryze = {_W, 600, NORMAL_CAST, DIRECT_CAST, TARGETED_CAST},
	Sejuani = {_R, 1175, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, 1600, 0.25, 110},
	Shaco = {_R, 250, NORMAL_CAST, DIRECT_CAST, AIR_CAST},
	Shen = {_E, 500, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, 1600, 0.25, 150},
	Skarner = {_R, 350, NORMAL_CAST, DIRECT_CAST, TARGETED_CAST},
	Singed = {_E, 150, NORMAL_CAST, DIRECT_CAST, TARGETED_CAST},
	Soraka = {_E, 925, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, 2000, 0.5, 25}, --Thanks to CooLow.
	Syndra = {_E, 700, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, 2500, 0.25, 22.5},
	Teemo = {_Q, 580, NORMAL_CAST, DIRECT_CAST, TARGETED_CAST},
	Thresh = {_E, 400, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, 2000, 0.38, 180},
	Tristana = {_R, 550, NORMAL_CAST, DIRECT_CAST, TARGETED_CAST}, 
	Urgot = {_R, 550, NORMAL_CAST, DIRECT_CAST, TARGETED_CAST},
	Varus = {_R, 1100, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, 1950, 0.25, 120},
	Vayne = {_E, 550, NORMAL_CAST, DIRECT_CAST, TARGETED_CAST},
	Velkoz = {_E, 850, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, math.huge, 0.5, 70},
	Veigar = {_E, 700, SPECIAL_CAST, SHIELD},
	Vladimir = {_W, 250, NORMAL_CAST, DIRECT_CAST, AIR_CAST},
	Warwick = {_R, 700, NORMAL_CAST, DIRECT_CAST, TARGETED_CAST},
	Xerath = {_E, 1050, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, 2300, 0.25, 30},
	XinZhao = {_R, 187.5, NORMAL_CAST, DIRECT_CAST, AIR_CAST},
	Yasuo {_Q, 900, SPECIAL_CAST, BUFFCHECK},
	Zac = {_R, 300, NORMAL_CAST, DIRECT_CAST, AIR_CAST},
	Zyra = {_E, 1100, NORMAL_CAST, SKILLSHOT_CAST, AIR_CAST, 1400, 0.5, 70}
}

if not champions[myHero.charName] then return end

--Liquid AntiRengar, a script to automatically stop rengar leaping you with some specific champions.
--Champion support: Have a look at the table above.
--Thanks to: Brown (Helping me testing and champion ideas)
--To-Do: 	Add some other dashes, like Leblanc or Gnar.
--			Add more champions and options.
--			Add shields to autoshield on rengar's leap.
--Version: 2.02

local REQUIRED_LIBS = {
	["VPrediction"] = "https://raw.githubusercontent.com/Hellsing/BoL/master/common/VPrediction.lua"
}

local DOWNLOADING_LIBS, DOWNLOAD_COUNT = false, 0

function AfterDownload()
	DOWNLOAD_COUNT = DOWNLOAD_COUNT - 1
	if DOWNLOAD_COUNT == 0 then
		DOWNLOADING_LIBS = false
		print("<b><font color=\"#6699FF\">Liquid AntiRengar beta:</font></b> <font color=\"#FFFFFF\">Required libraries downloaded successfully, please reload (double F9).</font>")
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

local UPDATE_NAME = "Liquid AntiRengar"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/LiquidBoL/LiquidBoL/master/Liquid%20AntiRengar%20beta.lua" .. "?rand=" .. math.random(1, 10000)
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

local skillReady = false
local skillRange, myChampion, antiRengar = nil, nil, nil

function OnLoad()
	VPred = VPrediction()
	myChampion = champions[myHero.charName]
	Menu()
	skillRange = myChampion[2]
	print("Liquid AntiRengar beta v"..version.." loaded!")
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
					if ally.team == myHero.team and not ally.dead and IsNotHealthy(ally) and GetDistanceSqr(ally, endPos) < 250*250 and GetDistanceSqr(myHero, endPos) < (skillRange)*(skillRange) then
						if not myChampion[3] and skillReady then
							if myChampion[4] then
								if antiRengar.usePred then
									DelayAction(function() CastPrediction(unit) end, antiRengar.delayTime*0.001)
								else
									DelayAction(function() CastSpell(myChampion[1], unit.x, unit.z) end, antiRengar.delayTime*0.001)
								end
							else
								DelayAction(function() CastSpell(myChampion[1], unit) end, antiRengar.delayTime*0.001)
							end
						else
							--Special cast part
							if myChampion[4] == SHIELD and skillReady then
								if myHero.charName == "Garen" then
									DelayAction(function() CastSpell(myChampion[1], myHero.x, myHero.z) end, antiRengar.delayTime*0.001)
								end
								if myHero.charName == "Anivia" then
									--Calculate vector from me to the enemy, and cast the wall near me facing the enemy.
									--If the ally helper is on, we would be have to calculate it from the ally to the enemy.
								end
								if myHero.charName == "Fizz" then
									DelayAction(function() CastSpell(myChampion[1], myHero.x, myHero.z) end, antiRengar.delayTime*0.001)
								end
							end
							if myChampion[4] == FORMCHECK and skillReady then  --Thanks to Nebelwolfi
								if myHero.charName == "Jayce" then
									if(myHero:GetSpellData(_E).name == "JayceThunderingBlow") then
										DelayAction(function() CastSpell(myChampion[1], unit) end, antiRengar.delayTime*0.001)
									end
								end
								if myHero.charName == "Elise" then
									if(myHero:GetSpellData(_E).name"EliseSpiderEInitial") then
										DelayAction(function() CastSpell(myChampion[1], unit.x, unit.z) end, antiRengar.delayTime*0.001)
									end
								end
							end
							if myChampion[4] == BUFFCHECK then
								if myHero.charName == "Annie" then
									--if stun buff ready
									--cast Q or W.
								end
								if myHero.charName == "Yasuo" and skillReady then
									--if 3rd Q ready
									--cast Q
								end
							end
						end
					end
				end
			elseif IsNotHealthy(myHero) and GetDistanceSqr(myHero, endPos) < 250*250 then --Distance to be moving and still throw the ability
				if not skillReady and myChampion[3] then
					if myChampion[4] then
						if antiRengar.usePred then
							DelayAction(function() CastPrediction(unit) end, antiRengar.delayTime*0.001)
						else
							DelayAction(function() CastSpell(myChampion[1], unit.x, unit.z) end, antiRengar.delayTime*0.001)
						end
					elseif not myChampion[5] then
						DelayAction(function() CastSpell(myChampion[1]) end, antiRengar.delayTime*0.001)
					else
						DelayAction(function() CastSpell(myChampion[1], unit) end, antiRengar.delayTime*0.001)
					end
				else
					--Special cast part
					if myChampion[4] == SHIELD and skillReady then
						if myHero.charName == "Garen" then
							DelayAction(function() CastSpell(myChampion[1], myHero.x, myHero.z) end, antiRengar.delayTime*0.001)
						end
						if myHero.charName == "Anivia" then
							--Calculate vector from me to the enemy, and cast the wall near me facing the enemy.
							--If the ally helper is on, we would be have to calculate it from the ally to the enemy.
						end
						if myHero.charName == "Fizz" then
							DelayAction(function() CastSpell(myChampion[1], myHero.x, myHero.z) end, antiRengar.delayTime*0.001)
						end
					end
					if myChampion[4] == FORMCHECK and skillReady then --Thanks to Nebelwolfi
						if myHero.charName == "Jayce" then
							if(myHero:GetSpellData(_E).name == "JayceThunderingBlow") then
								DelayAction(function() CastSpell(myChampion[1], unit) end, antiRengar.delayTime*0.001)
							end
						end
						if myHero.charName == "Elise" then
							if(myHero:GetSpellData(_E).name == "EliseHumanE") then
								DelayAction(function() CastSpell(myChampion[1], unit.x, unit.z) end, antiRengar.delayTime*0.001)
							elseif (myHero:GetSpellData(_E).name == "EliseSpiderEInitial") then
								DelayAction(function() CastSpell(myChampion[1], unit) end, antiRengar.delayTime*0.001)
							end
						end
					end
					if myChampion[4] == BUFFCHECK then
						if myHero.charName == "Annie" then
							--if stun buff ready
							--cast Q or W.
						end
						if myHero.charName == "Yasuo" and skillReady then
							--if 3rd Q ready
							--cast Q
						end
					end
				end
			end
		end
	end
end

function IsNotHealthy(unit)
	return (((unit.health/unit.maxHealth)*100) <= antiRengar.currentLife)
end

function CastPrediction(target)
	local castPosition, hitChance, position = VPred:GetLineCastPosition(target, myChampion[7], myChampion[8], skillRange, myChampion[6], myHero, true)
	if hitChance >= 2 then
		CastSpell(myChampion[1], castPosition.x, castPosition.z)
	end
end

function GetTristanaRange()
	return 550+7*myHero.level
end

function GetUrgotRange()
	return 400+(myHero:GetSpellData(_R).level*150)
end

function SkillCheck()
	skillReady = myHero:CanUseSpell(myChampion[1])
	if myHero.charName == "Tristana" then
		skillRange = GetTristanaRange()
	end
	if myHero.charName == "Urgot" then
		skillRange = GetUrgotRange()
	end
end

function Menu()
	antiRengar = scriptConfig("Liquid AntiRengar", "AntiRengarFix")
	antiRengar:addParam("info", "---- Your Skill is "..GetCorrectSkill(myChampion[1]).." ----", SCRIPT_PARAM_INFO, "")
	antiRengar:addParam("enabled", "Always enabled", SCRIPT_PARAM_ONOFF, true)
	antiRengar:addParam("pressEnable", "Enable on Press", SCRIPT_PARAM_ONOFF, false)
	antiRengar:addParam("enableKey", "Enable Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	antiRengar:addParam("usePred", "Predict Skillshots (Slower)", SCRIPT_PARAM_ONOFF, false)
	antiRengar:addParam("allyHelp", "Help allies", SCRIPT_PARAM_ONOFF, false)
	antiRengar:addParam("delayTime", "Delay time (ms)", SCRIPT_PARAM_SLICE, 80, 0, 130, 0)
	antiRengar:addParam("currentLife", "Current life to use (%)", SCRIPT_PARAM_SLICE, 65, 0, 100, 0)
end

function GetCorrectSkill(keyNumber)
	local skills = {"Q", "W", "E", "R"}
	return skills[keyNumber+1]
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
