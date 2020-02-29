require("convars")
util.AddNetworkString("vmotus_vroll")

function notifyClientToRoll(player)
    net.Start("vmotus_vroll")
    net.WriteInt(math.Round(player:EyeAngles().p), 16)
    net.Send(player)
end

local negateFallDamage = false
local reduceFallDamage = false

hook.Add(
    "OnPlayerHitGround",
    "vmotus_ophg",
    function(player, inWater, onFloater, speed)
        if vmotus_rdr() then
            if not player:HasGodMode() then
                if player:KeyDown(IN_DUCK) and not inWater then
                    if speed > 380 and speed < 800 then
                        notifyClientToRoll(player)
                        negateFallDamage = true
                    elseif speed > 800 then
                        notifyClientToRoll(player)
                        reduceFallDamage = true
                    end
                end

                timer.Simple(
                    0.1,
                    function()
                        reduceFallDamage = false
                        negateFallDamage = false
                    end
                )
            end
        end
    end
)

hook.Add(
    "GetFallDamage",
    "vmotus_gfd",
    function(player, speed)
        if negateFallDamage then
            player:EmitSound("physics/cardboard/cardboard_box_break1.wav", 100, 100)
            return 0
        end
        if vmotus_rfd() then
            local lSpeed = speed / vmotus_rfdNum()
            if reduceFallDamage and speed < 1000 then
                if vmotus_scream() then
                    player:EmitSound("vo/npc/" .. vmotus_vg(player) .. "/pain03.wav")
                end
                if speed < 900 then
                    return lSpeed / 2
                else
                    return lSpeed / 1.25
                end
            else
                if vmotus_scream() then
                    player:EmitSound("vo/npc/" .. vmotus_vg(player) .. "/pain03.wav")
                end
                return lSpeed
            end
        end
        if vmotus_scream() then
            player:EmitSound("vo/npc/" .. vmotus_vg(player) .. "/pain03.wav")
        end
        return 10
    end
)
