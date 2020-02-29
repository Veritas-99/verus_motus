require("convars")
util.AddNetworkString("vmotus_vflip")

function notifyClientToFlip(player)
    net.Start("vmotus_vflip")
    net.WriteAngle(player:EyeAngles())
    net.Send(player)
end

local steps

local stepSounds = {
    "player/footsteps/concrete1.wav",
    "player/footsteps/concrete2.wav",
    "player/footsteps/concrete3.wav",
    "player/footsteps/concrete4.wav"
}

function wallRun(number, player, frontal)
    local v = player:GetVelocity()
    if v.z > (frontal and -450 or -100) then
        player:ViewPunch(Angle(-15, 0, 0))
        player:EmitSound(stepSounds[math.random(#stepSounds)])
        player:SetVelocity(
            Vector(
                0 - (frontal and v.x * 0.75 or 0),
                0 - (frontal and v.y * 0.75 or 0),
                (frontal and vmotus_wrsf() or vmotus_wrsf() * 0.9091) - v.z
            )
        )
        steps = steps - 1

        timer.Create(
            number .. "wrcooldown",
            0.3,
            1,
            function()
            end
        )
    end
end

function wallJump(number, player, frontal, left)
    local a = player:EyeAngles()
    local v = player:GetVelocity()
    if v.z > -450 then
        local pv
        if frontal then
            pv = -a:Forward()
            pv.z = 0
        else
            pv = v:GetNormalized()
            pv.z = 0
            if left then
                pv:Rotate(Angle(0, -90, 0))
            else
                pv:Rotate(Angle(0, 90, 0))
            end
            pv.x = pv.x - v:GetNormalized().x * 1.25
            pv.y = pv.y - v:GetNormalized().y * 1.25
        end

        local sv = (pv * (frontal and 250 or 150)) + Vector(0, 0, 250 - v.z)

        player:ViewPunch(Angle(-10, 0, 0))
        player:EmitSound(stepSounds[math.random(#stepSounds)])

        player:SetVelocity(sv)
        if frontal then
            notifyClientToFlip(player)
        end

        timer.Create(
            number .. "wjcooldown",
            0.25,
            1,
            function()
                steps = vmotus_wjs()
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
                steps = vmotus_wrs()
            end

            local forwarder = Vector(5, 0, 0)
            forwarder:Rotate(Angle(0, cPlayer:EyeAngles().yaw, 0))

            local collisionFront = util.QuickTrace(cPlayer:GetPos() + Vector(0, 0, 40), forwarder * 5, cPlayer)
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
                            steps < vmotus_wrs()
                     then
                        wallJump(i, cPlayer, true)
                    end
                end
                if
                    collisionLeft.Hit and cPlayer:KeyDown(IN_MOVELEFT) and cPlayer:KeyDown(IN_SPEED) and
                        ((v.x > 150 or v.x < -150) or (v.y > 150 or v.y < -150))
                 then
                    if not timer.Exists(i .. "wrcooldown") and steps > 0 then
                        wallRun(i, cPlayer, false)
                    end
                    if
                        not cPlayer:IsOnGround() and cPlayer:KeyDown(IN_JUMP) and not timer.Exists(i .. "wjcooldown") and
                            steps < vmotus_wrs()
                     then
                        wallJump(i, cPlayer, false, true)
                    end
                end
                if
                    collisionRight.Hit and cPlayer:KeyDown(IN_MOVERIGHT) and cPlayer:KeyDown(IN_SPEED) and
                        ((v.x > 150 or v.x < -150) or (v.y > 150 or v.y < -150))
                 then
                    if not timer.Exists(i .. "wrcooldown") and steps > 0 then
                        wallRun(i, cPlayer, false)
                    end
                    if
                        not cPlayer:IsOnGround() and cPlayer:KeyDown(IN_JUMP) and not timer.Exists(i .. "wjcooldown") and
                            steps < vmotus_wrs()
                     then
                        wallJump(i, cPlayer, false, false)
                    end
                end
            end
        end
    end
)
