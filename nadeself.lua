local NadeReference = gui.Reference("MISC")
local NadeMenuTab = gui.Tab(NadeReference, "nademenu.tab", "Self Nade")
local NadeSelfGroupbox = gui.Groupbox(NadeMenuTab, "Nade Self", 15, 15, 200, 100)
local tickwait = globals.TickCount()
NadeSelfKey = gui.Keybox(NadeSelfGroupbox, "nadeself.key", "Key", 6)

local function NadeSelf()
    	local lPlayer = entities.GetLocalPlayer()
    	if gui.Reference("menu"):IsActive() then return end
    	if lPlayer == nil then return end
    	if entities.GetLocalPlayer() then
	   	local lPlayerWeaponID = lPlayer:GetWeaponID();
	   	if lPlayerWeaponID == 44 then
		  	if NadeSelfKey:GetValue() ~= 0 then
				if input.IsButtonPressed(NadeSelfKey:GetValue()) then
					local function nadeCmd(cmd)
						local ang_x = engine.GetViewAngles()["pitch"]
						local ang_y = engine.GetViewAngles()["yaw"]
						local ang_z = engine.GetViewAngles()["roll"]
						cmd.viewangles = EulerAngles(-89,ang_y,ang_z)
						if globals.TickCount() - tickwait > 56 then
							cmd.viewangles = EulerAngles(ang_x,ang_y,ang_z)
							return
						end
					end
					callbacks.Register("CreateMove", "nadeCmd", nadeCmd)
					client.Command("+attack", true)
					client.Command("+attack2", true)
					tickwait = globals.TickCount()
				elseif globals.TickCount() - tickwait > 60 then
					callbacks.Unregister("CreateMove", "nadeCmd")
				    	return
				elseif globals.TickCount() - tickwait > 45 then
				    	client.Command("-attack2", true)
				elseif globals.TickCount() - tickwait > 26 then
					client.Command("-attack", true)
				end
			end
		end
	end
end
callbacks.Register("Draw", "NadeSelf", NadeSelf)
