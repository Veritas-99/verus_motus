local doRoll = false
local degree = 0
local pitch = 0

net.Receive(
    "vmotus_vroll",
    function()
        doRoll = true
        deg = net.ReadInt(16)
        pitch = deg - 360
    end
)

hook.Add(
    "CalcView",
    "vmotus_cvroll",
    function(player, origin, angles, fov)
        if not doRoll then
            return
        end

        local view = GAMEMODE:CalcView(player, origin, angles, fov)
        pitch = math.Approach(pitch, degree, FrameTime() * 700)
        if pitch == degree then
            doRoll = false
        end
        view.angles.p = pitch
        return view
    end
)

hook.Add(
    "CalcViewModelView",
    "vmotus_cvmcroll",
    function(wep, vm, pos_, ang_, pos, ang)
        if not doRoll then
            return
        end
        
        ang.p = pitch;
        return pos, ang
    end
)
