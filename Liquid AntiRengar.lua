--Liquid AntiRengar, a script to automatically stop rengar leaping you with some specific champions.
--Champion support: Have a look at the table below.
--Thanks to: Brown (Helping me testing and champion ideas)
--To-Do: 	Add some other dashes, like Leblanc or Gnar.
--			Add more champions and options.
--Version: 1.0.7

require "VPrediction"

local champions = {	Ahri = {_E, 975, true, 1500, 0.25, 100}, 
					Alistar = {_W, 650, false},
					--Anivia Wall (Difficult)
					--Azir R below life
					Draven = {_E, 1050, true, 1400, 0.28, 90}, 
					FiddleSticks = {_Q, 575, false},
					Maokai = {_Q, 575, true, 1200, 0,5, 110},
					Tristana = {_R, 550, false}, 
					Vayne = {_E, 550, false}
				}

if not champions[myHero.charName] then return end

local version = "1.0.7"
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
					if ally.team == myHero.team and skillReady and not ally.dead and GetDistanceSqr(ally, endPos) < 250*250 and GetDistanceSqr(myHero, endPos) < (skillRange)*(skillRange) then
						if myChampion[3] then
							if antiRengar.usePred then
								CastPrediction(unit)
							else
								CastSpell(myChampion[1], unit.x, unit.z)
							end
						else
							CastSpell(myChampion[1], unit)
						end
					end
				end
			elseif skillReady and GetDistanceSqr(myHero, endPos) < 250*250 then --Distance to be moving and still throw the ability
				if myChampion[3] then
					if antiRengar.usePred then
						CastPrediction(unit)
					else
						CastSpell(myChampion[1], unit.x, unit.z)
					end
				else
					CastSpell(myChampion[1], unit)
				end
			end
		end
	end
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