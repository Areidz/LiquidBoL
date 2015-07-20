--Liquid AntiRengar Assembly, a script to automatically stop rengar leaping you with some specific champions.
--Champion support: Vayne, Draven, Tristana, Ahri, Alistar
--Thanks to: Brown (Helping me testing and champion ideas)
--To-Do: 	Add more champions.
--			Add some other dashes, like Leblanc or Gnar.
--			Improve skillshot accuracy.
--Version: 1.0

local champions = {	Vayne = {_E, 550, false}, 
					Tristana = {_R, 550, false}, 
					Draven = {_E, 1050, true}, 
					Ahri = {_E, 975, true}, 
					Alistar = {_W, 650, false}
				}

if not champions[myHero.charName] then return end

local version = "1.0"
local skillReady = false
local skillRange = nil
local myChampion = nil

function OnLoad()
	Menu()
	print("Liquid AntiRengar v"..version.." loaded!")
	myChampion = champions[myHero.charName]
	skillRange = myChampion[2]
end

function OnTick()
	SkillCheck()
end

function OnCreateObj(obj)
	if AntiRengar.enabled then
		if obj.name:lower():find("leapsound") then
			for i = 1, heroManager.iCount do
				local enemy = heroManager:getHero(i)
				if ValidTarget(enemy, skillRange) and enemy.charName == "Rengar" then
					if myChampion[3] then
						CastSpell(myChampion[1], enemy.x, enemy.z)
					else
						CastSpell(myChampion[1], enemy)
					end
				end
			end
		end
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
	local AntiRengar = scriptConfig("Liquid AntiRengar", "AntiRengar")
	AntiRengar:addParam("enabled", "Enabled", SCRIPT_PARAM_ONOFF, true)
end