--Liquid AntiRengar Script, a script to automatically stop rengar leaping you with some specific champions.
--Champion support: Vayne, Draven, Tristana, Ahri, Alistar
--Thanks to: Brown (Helping me testing and champion ideas)
--To-Do: 	Add more champions.
--			Add some other dashes, like Leblanc or Gnar.
--Version: 1.0.2

require "VPrediction"

local champions = {	Ahri = {_E, 975, true, 1500, 0.25, 100}, 
					Alistar = {_W, 650, false},
					Draven = {_E, 1050, true, 1400, 0.28, 90}, 
					Fiddlesticks = {_Q, 575, false},
					Maokai = {_Q, 575, true, 1200, 0,5, 110},
					Tristana = {_R, 550, false}, 
					Vayne = {_E, 550, false}
				}

if not champions[myHero.charName] then return end

local version = "1.0.2"
local skillReady = false
local skillRange = nil
local myChampion = nil
local AntiRengar = nil

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

function OnCreateObj(obj)
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

function CastPrediction(target)
	local castPosition, hitChance, position = VPred:GetLineCastPosition(target, myChampion[5], myChampion[6], myChampion[2], myChampion[4], myHero, true)
	if hitChance >= 2 and GetDistanceSqr(castPosition, myChampion[2]) then
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
	AntiRengar = scriptConfig("Liquid AntiRengar", "AntiRengar")
	AntiRengar:addParam("enabled", "Always enabled", SCRIPT_PARAM_ONOFF, true)
	AntiRengar:addParam("pressEnable", "Enable on Press", SCRIPT_PARAM_ONOFF, false)
	AntiRengar:addParam("enableKey", "Enable Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	AntiRengar:addParam("usePred", "Predict Skillshots (Slower)", SCRIPT_PARAM_ONOFF, false)
end
