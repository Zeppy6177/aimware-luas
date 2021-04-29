local teamDamageArray = {}

local function gameEvents(event)

	if event:GetName() == "weapon_fire" then
		lPlayer = entities.GetLocalPlayer()
		lPlayerTeam = lPlayer:GetTeamNumber()
	end

	if event:GetName() == "player_hurt" or event:GetName() == "player_death" then
		local attacker = event:GetInt("attacker")
		local victim = event:GetInt("userid")
		local dmgdone = event:GetInt("dmg_health")
		local attackerIndex = client.GetPlayerIndexByUserID(attacker)
		local victimIndex = client.GetPlayerIndexByUserID(victim)
		local attackerName = client.GetPlayerNameByUserID(attacker)
		local attackerUID = entities.GetByUserID(attacker)
		local victimUID = entities.GetByUserID(victim)
		local attackerTeam = attackerUID:GetTeamNumber()
		local victimTeam = victimUID:GetTeamNumber()
		local attackerPlayerInfo = client.GetPlayerInfo(attackerIndex)
		local victimPlayerInfo = client.GetPlayerInfo(victimIndex)
		local attackerSteamID = attackerPlayerInfo["SteamID"]
		local victimSteamID = victimPlayerInfo["SteamID"]

		if event:GetName() == "player_hurt" then
			local lPlayerTeam = lPlayer:GetTeamNumber()
			if victimTeam == lPlayerTeam and attackerTeam == lPlayerTeam and victimIndex ~= attackerIndex then
				if teamDamageArray[attackerSteamID] == nil then
					teamDamageArray[attackerSteamID] = {0, 0, attackerName}
				end
				teamDamageArray[attackerSteamID][1] = teamDamageArray[attackerSteamID][1] + dmgdone
			end
		elseif event:GetName() == "player_death" then
			local lPlayerTeam = lPlayer:GetTeamNumber()
			if victimTeam == lPlayerTeam and attackerTeam == lPlayerTeam and victimIndex ~= attackerIndex then
				teamDamageArray[attackerSteamID][2] = teamDamageArray[attackerSteamID][2] + 1
			end
		end
	end
end

client.AllowListener("player_death")
client.AllowListener("player_hurt")
client.AllowListener("weapon_fire")
callbacks.Register("FireGameEvent", "gameEvents", gameEvents)

screenSize = {0, 0}
local function draw_Func()
	screenSize = {draw.GetScreenSize()}
	local playerCount = 0
	for i, v in pairs(teamDamageArray) do

		if input.IsButtonDown(9) or gui.Reference("menu"):IsActive() then

			if playerCount % 2 == 0 then
				draw.Color(50, 50, 50, 255)
			else
				draw.Color(20, 20, 20, 255)
			end

			if v[3]:len() > 15 then
				v[3] = v[3]:sub(1, 15).."..."
			end

			draw.FilledRect(screenSize[1] - select(1, draw.GetTextSize("Damage: 300")) - 53, screenSize[2] * 0.187 + (screenSize[2] * 0.027 * playerCount), screenSize[1], screenSize[2] * 0.214 + (screenSize[2] * 0.027 * playerCount))
			--Draw Kills
			if v[2] == 0 then
				draw.Color(245, 245, 245, 255)
			elseif v[2] == 1 then
				draw.Color(245, 245, 0, 255)
			elseif v[2] == 2 then
				draw.Color(245, 150, 0, 255)
			elseif v[2] >= 3 then
				draw.Color(245, 0, 0, 255)				
			end
			draw.TextShadow(screenSize[1] - select(1, draw.GetTextSize("Kills: 0")) - 5, screenSize[2] * 0.2 + (screenSize[2] * 0.027 * playerCount), "Kills: "..v[2])	

			--Draw Damage
			if v[1] < 100 then
				draw.Color(245, 245, 0, 255)
			elseif v[1] > 99 and v[1] < 199 then
				draw.Color(245, 150, 0, 255)
			elseif v[1] > 200 then
				draw.Color(245, 0, 0, 255)
			end
			draw.TextShadow(screenSize[1] - select(1, draw.GetTextSize("Damage: 300")) - 50, screenSize[2] * 0.2 + (screenSize[2] * 0.027 * playerCount), "Damage: "..v[1])

			--Draw Name
			draw.Color(255, 255, 255, 255)
			draw.TextShadow(screenSize[1] - select(1, draw.GetTextSize("Damage: 300")) - 50, screenSize[2] * 0.189 + (screenSize[2] * 0.027 * playerCount), v[3])
			--Draw Background

			playerCount = playerCount + 1
		end
	end
end
callbacks.Register("Draw", "draw_Func", draw_Func)