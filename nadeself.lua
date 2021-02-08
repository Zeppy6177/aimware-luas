local NadeReference = gui.Reference("MISC")
local NadeMenuTab = gui.Tab(NadeReference, "nademenu.tab", "Self Nade")
local NadeSelfGroupbox = gui.Groupbox(NadeMenuTab, "Nade Self", 15, 15, 200, 100)
local tickwait = globals.TickCount()
NadeSelfKey = gui.Keybox(NadeSelfGroupbox, "nadeself.key", "Key", 191)
nadeval = -1

callbacks.Register( "Draw", function()
    lPlayer = entities.GetLocalPlayer()
    if lPlayer == nil then return end
    lPlayerAlive = lPlayer:IsAlive()
    if entities.GetLocalPlayer() then
        local lPlayerWeaponID = lPlayer:GetWeaponID();
        if lPlayerWeaponID == 44 then
            if NadeSelfKey:GetValue() ~= 0 then
                if input.IsButtonPressed(NadeSelfKey:GetValue()) then
                        ang_x = engine.GetViewAngles()["pitch"]
                        ang_y = engine.GetViewAngles()["yaw"]
                        ang_z = engine.GetViewAngles()["roll"]
                        nadeval = 1
                        engine.SetViewAngles(EulerAngles(-89,ang_y,ang_z))
                        tickwait = globals.TickCount()
                    elseif globals.TickCount() - tickwait > 60 then
                        nadeval = -1
                    elseif globals.TickCount() - tickwait > 56 then
                        nadeval = 3
                    elseif globals.TickCount() - tickwait > 45 then
                        nadeval = 0
                    elseif globals.TickCount() - tickwait > 26 then
                        nadeval = 2
                end

                if nadeval == 1  then
                        client.Command("+attack", true)
                        client.Command("+attack2", true)
                    elseif nadeval == 2 then
                        client.Command("-attack", true)
                    elseif nadeval == 0 then
                        client.Command("-attack2", true)
                    elseif nadeval == 3 then
                        engine.SetViewAngles(EulerAngles(ang_x,ang_y,ang_z))
                    elseif nadeval == -1 then return
                end
            end
        end
    end
end)
