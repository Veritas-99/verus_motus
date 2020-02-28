require("ConVars")

local steps

local stepSounds = {
    "player/footsteps/concrete1.wav",
    "player/footsteps/concrete2.wav",
    "player/footsteps/concrete3.wav",
    "player/footsteps/concrete4.wav"
}

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

            local collision = util.QuickTrace(cPlayer:GetPos() + Vector(0, 0, 60), forwarder * 8, cPlayer)
            if collision.Hit then
                if cPlayer:KeyDown(IN_FORWARD) and cPlayer:KeyDown(IN_SPEED) then
                    if steps > 0 then
                        if not timer.Exists(i .. "wrcooldown") then
                            local z = cPlayer:GetVelocity().z
                            cPlayer:EmitSound(stepSounds[math.random(#stepSounds)])
                            cPlayer:SetVelocity(Vector(0, 0, 300-(z > 100 and z or 0)))
                            steps = steps - 1

                            timer.Create(
                                i .. "wrcooldown",
                                0.5,
                                1,
                                function()
                                end
                            )
                        end
                    end
                end
            end
        end
    end
)
