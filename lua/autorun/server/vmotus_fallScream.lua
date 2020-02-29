require("convars")

function playSound(number, player, file, volume)
    if not timer.Exists(number .. "scooldown") then
        player:EmitSound(file, 50, 100, volume)
    end
    timer.Create(
        number .. "scooldown",
        1,
        1,
        function()
        end
    )
end

hook.Add(
    "Think",
    "vmotus_fsT",
    function()
        if vmotus_scream() then
            local Players = player:GetAll()
            for i = 1, player.GetCount() do
                local cPlayer = Players[i]

                local zSpeed = cPlayer:GetVelocity().z

                if zSpeed < -200 then
                    local trace = util.QuickTrace(cPlayer:GetPos(), Vector(0, 0, -10000))
                    local dist = cPlayer:GetPos():DistToSqr(trace.HitPos)
                    if dist > 605000 then
                        playSound(i, cPlayer, "vo/npc/" .. vmotus_vg(cPlayer) .. "/no02.wav", 0.75)
                    elseif dist > 250000 then
                        playSound(i, cPlayer, "vo/npc/" .. vmotus_vg(cPlayer) .. "/uhoh.wav", 0.5)
                    end
                end
            end
        end
    end
)
