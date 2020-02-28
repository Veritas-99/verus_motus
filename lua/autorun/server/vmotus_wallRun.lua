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

function wallJump(number, player, frontal)
    local a = player:EyeAngles()
    local v = player:GetVelocity()
    if v.z > -450 then
        local fa = (frontal and -a:Forward() or a:Forward())
        if fa.x > 0.5 then
            fa.x = 1
        elseif fa.x < -0.5 then
            fa.x = -1
        end
        if fa.y > 0.5 then
            fa.y = 1
        elseif fa.y < -0.5 then
            fa.y = -1
        end
        fa.z = 0
        print(fa)
        local sv = (fa * 250) + Vector(0, 0, 250 - v.z)

        player:ViewPunch(Angle(-15, 0, 0))
        player:EmitSound(stepSounds[math.random(#stepSounds)])
        player:SetVelocity(sv)

        timer.Create(
            number .. "wjcooldown",
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

            local collisionFront = util.QuickTrace(cPlayer:GetPos() + Vector(0, 0, 60), forwarder * 5, cPlayer)
            local collisionRight =
                util.QuickTrace(cPlayer:GetPos() + Vector(0, 0, 28), cPlayer:EyeAngles():Right() * 23, cPlayer)
            local collisionLeft =
                util.QuickTrace(cPlayer:GetPos() + Vector(0, 0, 28), -cPlayer:EyeAngles():Right() * 23, cPlayer)
            local collisionUp = util.QuickTrace(cPlayer:GetPos(), Vector(0, 0, 120), cPlayer)

            if not collisionUp.Hit and cPlayer:KeyDown(IN_FORWARD) then
                local v = cPlayer:GetVelocity()
                if collisionFront.Hit then
                    if not timer.Exists(i .. "wrcooldown") and cPlayer:KeyDown(IN_SPEED) and steps > 0 then
                        wallRun(i, cPlayer, true)
                    end
                    if
                        not cPlayer:IsOnGround() and cPlayer:KeyDown(IN_JUMP) and not timer.Exists(i .. "wjcooldown") and
                            steps < 3
                     then
                        wallJump(i, cPlayer, true)
                    end
                end
                if
                    collisionLeft.Hit and cPlayer:KeyDown(IN_MOVELEFT) and cPlayer:KeyDown(IN_SPEED) and
                        ((v.x > 200 or v.x < -200) or (v.y > 200 or v.y < -200))
                 then
                    if not timer.Exists(i .. "wrcooldown") and steps > 0 then
                        wallRun(i, cPlayer, false)
                    end
                    if
                        not cPlayer:IsOnGround() and cPlayer:KeyDown(IN_JUMP) and not timer.Exists(i .. "wjcooldown") and
                            steps < 3
                     then
                        -- wallJump(i, cPlayer, false)
                    end
                end
                if
                    collisionRight.Hit and cPlayer:KeyDown(IN_MOVERIGHT) and cPlayer:KeyDown(IN_SPEED) and
                        ((v.x > 200 or v.x < -200) or (v.y > 200 or v.y < -200))
                 then
                    if not timer.Exists(i .. "wrcooldown") and steps > 0 then
                        wallRun(i, cPlayer, false)
                    end
                    if
                        not cPlayer:IsOnGround() and cPlayer:KeyDown(IN_JUMP) and not timer.Exists(i .. "wjcooldown") and
                            steps < 3
                     then
                        -- wallJump(i, cPlayer, false)
                    end
                end
            end
        end
    end
)
