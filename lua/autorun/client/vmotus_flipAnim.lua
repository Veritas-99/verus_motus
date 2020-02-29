local doFlip = false
local yaw = 0
local ang = 0
local degree = 0

net.Receive(
    "vmotus_vflip",
    function()
        doFlip = true;
        ang = net.ReadAngle()
        yaw = ang.y
        local posNeg = {180, -180}
        degree = posNeg[math.random(#posNeg)]
    end
)

hook.Add(
    "CalcView",
    "vmotus_cvflip",
    function(player, origin, angles, fov)
        if not doFlip then
            return
        end

        local view = GAMEMODE:CalcView(player, origin, angles, fov)


        yaw = math.Approach(yaw, ang.y + degree, FrameTime() * 1000)
        player:ChatPrint(yaw)
        player:ChatPrint(ang.y)
        if yaw == ang.y + degree then
            doFlip = false
            return
        end
        
        local ea = player:EyeAngles()
        player:SetEyeAngles(Angle(ea.x,yaw,ea.z))
        return view
    end
)

hook.Add(
    "CalcViewModelView",
    "vmotus_cvmcflip",
    function(wep, vm, pos_, ang_, pos, ang)
        -- ang.p = pitch;
        -- return pos, ang
    end
)
