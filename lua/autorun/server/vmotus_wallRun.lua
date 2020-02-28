require("ConVars")

local steps

local stepSounds = {
    "player/footsteps/concrete1.wav",
    "player/footsteps/concrete2.wav",
    "player/footsteps/concrete3.wav",
    "player/footsteps/concrete4.wav"
}

function wallRun(number, player, frontal)
    local v = player:GetVelocity()
    if v.z > -450 then
        player:ViewPunch(Angle(-15, 0, 0))
        player:EmitSound(stepSounds[math.random(#stepSounds)])
        player:SetVelocity(Vector(0 - (frontal and v.x * 0.75 or 0), 0 - (frontal and v.y * 0.75 or 0), 300 - v.z))
        steps = steps - 1

        timer.Create(
            number .. "wrcooldown",
            0.25,
            1,
            function()
            end
        )
    end
end

hook.Add(
    "Think",
    "vmotus_wrT",
    function()
        local Players = player:GetAll()
        for i = 1, player.GetCount() do
            local cPlayer = Players[i]

            if cPlayer:IsOnGround() then
                steps = 3
            end

            local forwarder = Vector(5, 0, 0)
            forwarder:Rotate(Angle(0, cPlayer:EyeAngles().yaw, 0))

            local collisionFront = util.QuickTrace(cPlayer:GetPos() + Vector(0, 0, 60), forwarder * 4, cPlayer)
            local collisionRight =
                util.QuickTrace(cPlayer:GetPos() + Vector(0, 0, 28), cPlayer:EyeAngles():Right() * 19, cPlayer)
            local collisionLeft =
                util.QuickTrace(cPlayer:GetPos() + Vector(0, 0, 28), -cPlayer:EyeAngles():Right() * 19, cPlayer)
            local collisionUp = util.QuickTrace(cPlayer:GetPos(), Vector(0, 0, 120), cPlayer)

            if
                not collisionUp.Hit and cPlayer:KeyDown(IN_FORWARD) and cPlayer:KeyDown(IN_SPEED) and steps > 0 and
                    not timer.Exists(i .. "wrcooldown")
             then
                if collisionFront.Hit then
                    wallRun(i, cPlayer, true)
                end
                if collisionLeft.Hit and cPlayer:KeyDown(IN_MOVELEFT) then
                    wallRun(i, cPlayer, false)
                end
                if collisionRight.Hit and cPlayer:KeyDown(IN_MOVERIGHT) then
                    wallRun(i, cPlayer, false)
                end
            end
        end
    end
)
